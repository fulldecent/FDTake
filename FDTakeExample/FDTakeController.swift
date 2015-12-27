//
//  FDTakeController.swift
//  FDTakeExample
//
//  Copyright © 2015 William Entriken. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

public class FDTakeController: NSObject /* , UIImagePickerControllerDelegate, UINavigationControllerDelegate*/ {
    
    // MARK: - Initializers
    
    public override init() {
        super.init()
    }
    
    public convenience init(getPhotoWithCallback callback: (photo: UIImage, info: [NSObject : AnyObject]) -> Void) {
        self.init()
        self.allowVideo = false
        self.didGetPhoto = callback
    }
    
    public convenience init(getVideoWithCallback callback: (video: NSURL, info: [NSObject : AnyObject]) -> Void) {
        self.init()
        self.allowPhoto  = false
        self.didGetVideo = callback
    }
    
    
    // MARK: - Configuration options
    
    public var allowPhoto = true
    
    public var allowVideo = true
    
    public var allowTake = true
    
    public var allowSelectFromLibrary = true
    
    public var allowEditing = false
    
    public var defaultToFrontCamera = false
    
    public var presentingView: UIView? = nil
    
    public var presentingRect: CGRect? = nil
    
    public var presentingTabBar: UITabBar? = nil
    
    public lazy var presentingViewController: UIViewController = {
        return UIApplication.sharedApplication().keyWindow!.rootViewController!
    }()
    
    
    // MARK: - Callbacks
    
    /// A photo was selected
    public var didGetPhoto: ((photo: UIImage, info: [NSObject : AnyObject]) -> Void)?
    
    /// A video was selected
    public var didGetVideo: ((video: NSURL, info: [NSObject : AnyObject]) -> Void)?
    
    /// The user selected did not attempt to select a photo
    public var didDeny: (() -> Void)?
    
    /// The user started selecting a photo or took a photo and then hit cancel
    public var didCancel: (() -> Void)?
    
    /// A photo or video was selected but the ImagePicker had NIL for EditedImage and OriginalImage
    public var didFail: (() -> Void)?
    
    
    // MARK: - Localization overrides
    
    /// Custom UI text (skips localization)
    public var takePhotoText: String? = nil
    
    /// Custom UI text (skips localization)
    public var takeVideoText: String? = nil
    
    /// Custom UI text (skips localization)
    public var chooseFromLibraryText: String? = nil
    
    /// Custom UI text (skips localization)
    public var chooseFromPhotoRollText: String? = nil
    
    /// Custom UI text (skips localization)
    public var cancelText: String? = nil
    
    /// Custom UI text (skips localization)
    public var noSourcesText: String? = nil
    
    
    // MARK: - String constants
    
    private let kTakePhotoKey: String = "takePhoto"
    
    private let kTakeVideoKey: String = "takeVideo"
    
    private let kChooseFromLibraryKey: String = "chooseFromLibrary"
    
    private let kChooseFromPhotoRollKey: String = "chooseFromPhotoRoll"
    
    private let kCancelKey: String = "cancel"
    
    private let kNoSourcesKey: String = "noSources"
    
    private let kStringsTableName: String = "FDTake"
    
    
    // MARK: - Private
    
    private var sources = [UIImagePickerControllerSourceType]()
    
    private var buttonTitles = [String]()
    
    private lazy var imagePicker: UIImagePickerController = {
        [unowned self] in
        let retval = UIImagePickerController()
        let selfDelegate = self as! protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
        retval.delegate = selfDelegate
        retval.allowsEditing = true
        return retval
    }()
    
    private lazy var popover: UIPopoverController = {
        [unowned self] in
        return UIPopoverController(contentViewController: self.imagePicker)
    }()
    
    private var actionSheet: UIActionSheet? = nil
    
    // This is a hack required on iPad if you want to select a photo and you already have a popup on the screen
    // see: http://stackoverflow.com/a/34392409/300224
    private func topViewController(rootViewController: UIViewController) -> UIViewController {
        var rootViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        repeat {
            if rootViewController.presentingViewController == nil {
                return rootViewController
            }
            if let navigationController = rootViewController.presentedViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.last!
            }
            rootViewController = rootViewController.presentedViewController!
        } while true
    }
    
    // MARK: - Localization
    
    private lazy var frameworkBundle : NSBundle = {
        let mainBundleURL = NSBundle(forClass: self as! AnyClass).resourceURL!
        let frameworkBundleURL = mainBundleURL.URLByAppendingPathComponent("FDTakeResources.bundle")
        let frameworkBundle = NSBundle(URL: frameworkBundleURL)
        return frameworkBundle ?? NSBundle.mainBundle()
    }()
    
    private func localize(key: String, comment: String) -> String {
        return NSLocalizedString(key, tableName: kStringsTableName, bundle: self.frameworkBundle, value: key, comment: comment)
    }
    
    private func textForButtonWithTitle(title: String) -> String {
        switch title {
        case kTakePhotoKey:
            return self.takePhotoText ?? localize(kTakePhotoKey, comment: "Option to take photo using camera")
        case kTakeVideoKey:
            return self.takeVideoText ?? localize(kTakeVideoKey, comment: "Option to take video using camera")
        case kChooseFromLibraryKey:
            return self.chooseFromLibraryText ?? localize(kChooseFromLibraryKey, comment: "Option to select photo/video from library")
        case kChooseFromPhotoRollKey:
            return self.chooseFromPhotoRollText ?? localize(kChooseFromPhotoRollKey, comment: "Option to select photo from photo roll")
        case kCancelKey:
            return self.cancelText ?? localize(kCancelKey, comment: "Decline to proceed with operation")
        case kNoSourcesKey:
            return self.noSourcesText ?? localize(kNoSourcesKey, comment: "There are no sources available to select a photo")
        default:
            NSLog("Invalid title passed to textForButtonWithTitle:")
            return "ERROR"
        }
    }
    
    /**
     *  Presents the user with an option to take a photo or choose a photo from the library
     */
    public func present() {
        self.sources = []
        self.buttonTitles = []
        
        if self.allowTake && UIImagePickerController.isSourceTypeAvailable(.Camera) {
            if self.allowPhoto {
                self.sources.append(.Camera)
                self.buttonTitles.append(self.textForButtonWithTitle(kTakePhotoKey))
            }
            if self.allowVideo {
                self.sources.append(.Camera)
                self.buttonTitles.append(self.textForButtonWithTitle(kTakeVideoKey))
            }
        }
        if self.allowSelectFromLibrary {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                self.sources.append(.PhotoLibrary)
                self.buttonTitles.append(self.textForButtonWithTitle(kChooseFromLibraryKey))
            } else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
                self.sources.append(.SavedPhotosAlbum)
                self.buttonTitles.append(self.textForButtonWithTitle(kChooseFromPhotoRollKey))
            }
        }
        
        guard self.sources.count > 0 else {
            var str: String = self.textForButtonWithTitle(kNoSourcesKey)
            UIAlertView(title: nil, message: str, delegate: nil, cancelButtonTitle: nil).show()
            return
        }
        
        let sender = self.presentingView
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        for title in self.buttonTitles {
            actionSheet.addButtonWithTitle(title)
        }
        actionSheet.addButtonWithTitle(self.textForButtonWithTitle(kCancelKey))
        actionSheet.cancelButtonIndex = self.sources.count
        
        var popOverPresentRect : CGRect = self.presentingRect ?? CGRectMake(0, 0, 1, 1)
        if popOverPresentRect.size.height == 0 || popOverPresentRect.size.width == 0 {
            popOverPresentRect = CGRectMake(0, 0, 1, 1)
        }
        
        self.actionSheet = actionSheet
        // If on iPad use the present rect and pop over style.
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            if let barButtonItem = sender as? UIBarButtonItem {
                actionSheet.showFromBarButtonItem(barButtonItem, animated: true)
            } else {
                actionSheet.showFromRect(popOverPresentRect, inView: topViewController(presentingViewController).view!, animated: true)
            }
        }
        else if let tabBar = self.presentingTabBar {
            actionSheet.showFromTabBar(tabBar)
        }
        else {
            // Otherwise use iPhone style action sheet presentation.
            // UIWindow hack: http://stackoverflow.com/a/28902549/300224
            let window = (UIApplication.sharedApplication().delegate!.window ?? nil)! as UIWindow
            let topVC = topViewController(presentingViewController)
            if window.subviews.contains(topVC.view!) {
                actionSheet.showInView(topVC.view)
            }
            else {
                actionSheet.showInView(window)
            }
        }
    }
    
    /**
     *  Dismisses the displayed view (actionsheet or imagepicker).
     *  Especially handy if the sheet is displayed while suspending the app,
     *  and you want to go back to a default state of the UI.
     */
    public func dismiss() {
        if let actionSheet = self.actionSheet {
            actionSheet.dismissWithClickedButtonIndex(sources.count, animated: false)
        } else {
            imagePicker.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}

extension FDTakeController : UIActionSheetDelegate {
    public func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        let aViewController: UIViewController = self.topViewController(self.presentingViewController)
        if buttonIndex == actionSheet.cancelButtonIndex {
            self.didDeny?()
        } else {
            self.imagePicker.sourceType = self.sources[buttonIndex]
            if (self.imagePicker.sourceType == .Camera) || (self.imagePicker.sourceType == .Camera) {
                if self.defaultToFrontCamera && UIImagePickerController.isCameraDeviceAvailable(.Front) {
                    self.imagePicker.cameraDevice = .Front
                }
            }
            // set the media type: photo or video
            self.imagePicker.allowsEditing = self.allowEditing
            self.imagePicker.mediaTypes = []
            if self.allowPhoto {
                self.imagePicker.mediaTypes.append(String(kUTTypeImage))
            }
            if self.allowVideo {
                self.imagePicker.mediaTypes.append(String(kUTTypeMovie))
            }
            if self.allowPhoto && self.allowVideo && self.sources.count > 1 {
                if buttonIndex == 0 {
                    self.imagePicker.mediaTypes = [String(kUTTypeImage)]
                }
                else if buttonIndex == 1 {
                    self.imagePicker.mediaTypes = [String(kUTTypeMovie)]
                }
                else if buttonIndex == 2 {
                    self.imagePicker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
                }
            }
            
            var popOverPresentRect: CGRect = self.presentingRect ?? CGRectMake(0, 0, 1, 1)
            if popOverPresentRect.size.height == 0 || popOverPresentRect.size.width == 0 {
                popOverPresentRect = CGRectMake(0, 0, 1, 1)
            }
            // On iPad use pop-overs.
            if UI_USER_INTERFACE_IDIOM() == .Pad {
                self.popover.presentPopoverFromRect(popOverPresentRect, inView: aViewController.view!, permittedArrowDirections: .Any, animated: true)
            }
            else {
                // On iPhone use full screen presentation.
                let topVC = topViewController(self.presentingViewController)
                topVC.presentViewController(self.imagePicker, animated: true, completion: { _ in })
            }
        }
        self.actionSheet = nil
    }
}

extension FDTakeController : UIImagePickerControllerDelegate {
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        UIApplication.sharedApplication().statusBarHidden = true
        let mediaType: String = info[UIImagePickerControllerMediaType] as! String
        var imageToSave: UIImage
        // Handle a still image capture
        if mediaType == kUTTypeImage as String {
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageToSave = originalImage
            } else {
                self.didCancel?()
                return
            }
            self.didGetPhoto?(photo: imageToSave, info: info)
            if UI_USER_INTERFACE_IDIOM() == .Pad {
                self.popover.dismissPopoverAnimated(true)
            }
        } else if mediaType == kUTTypeMovie as String {
            self.didGetVideo?(video: info[UIImagePickerControllerMediaURL] as! NSURL, info: info)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        UIApplication.sharedApplication().statusBarHidden = true
        picker.dismissViewControllerAnimated(true, completion: { _ in })
        self.didCancel?()
    }
}

extension FDTakeController : UIAlertViewDelegate {
    public func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.didDeny?()
    }
}
