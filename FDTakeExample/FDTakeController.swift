//
//  FDTakeController.swift
//  FDTakeExample
//
//  Copyright © 2015 William Entriken. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

public protocol FDTakeDelegate: NSObject {
    /// Delegate method after the user has started a take operation but cancelled it
    optional func takeController(controller: FDTakeController, didCancelAfterAttempting madeAttempt: Bool)

    /// Delegate method after the user has started a take operation but it failed
    optional func takeController(controller: FDTakeController, didFailAfterAttempting madeAttempt: Bool)

    /// Delegate method after the user has successfully taken or selected a photo
    optional func takeController(controller: FDTakeController, gotPhoto photo: UIImage, withInfo info: [NSObject : AnyObject])

    /// Delegate method after the user has successfully taken or selected a video
    optional func takeController(controller: FDTakeController, gotVideo video: NSURL, withInfo info: [NSObject : AnyObject])
}

public class FDTakeController: NSObject /*, UIImagePickerControllerDelegate, UINavigationControllerDelegate */ {

    // MARK: - Properties
    
    /// The delegate to receive updates from FDTake
    public weak var delegate: FDTakeDelegate? = nil
    
    public var allowPhoto = true
    
    public var allowVideo = true
    
    public var allowTake = true
    
    public var allowSelectFromLibrary = true
    
    public var allowEditing = true
    
    public var defaultToFrontCamera = false
    
    public var presentingView: UIView? = nil
    
    public var presentingRect: CGRect? = nil
    
    public var presentingTabBar: UITabBar? = nil
    
    public var presentingViewController: UIViewController? = nil

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

    private let kTakePhotoKey: String = "takePhoto"
    
    private let kTakeVideoKey: String = "takeVideo"
    
    private let kChooseFromLibraryKey: String = "chooseFromLibrary"
    
    private let kChooseFromPhotoRollKey: String = "chooseFromPhotoRoll"
    
    private let kCancelKey: String = "cancel"
    
    private let kNoSourcesKey: String = "noSources"
    
    private let kStringsTableName: String = "FDTake"

    private var sources = [UIImagePickerControllerSourceType]()
    
    private var buttonTitles = [String]()
    
    private lazy var imagePicker = {
        [unowned self] in
        let retval = UIImagePickerController()
        retval.delegate = self
        retval.allowsEditing = true
        return retval
    }()
    
    private lazy var popover = {
        return UIPopoverController(initWithContentViewController: self.imagePicker)
    }()
    
    private var actionSheet: UIActionSheet? = nil
    
    private func calculatedViewController() -> UIViewController {
        if let presentingViewController = self.presentingViewController {
            return presentingViewController
        }
        return self.topViewController()
    }
    
    // This is a hack required on iPad if you want to select a photo and you already have a popup on the screen
    // see: http://stackoverflow.com/a/34392409/300224
    private func topViewController() -> UIViewController {
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
    
    private let frameworkBundle : NSBundle = {
        let mainBundleURL = NSBundle(forClass: self).resourceURL
        let frameworkBundleURL = mainBundleURL.URLByAppendingPathComponent("FDTakeResources.bundle")
        let frameworkBundle = NSBundle(path: frameworkBundleURL)
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
                actionSheet.showFromRect(popOverPresentRect, inView: self.calculatedViewController().view!, animated: true)
            }
        }
        else if let tabBar = self.presentingTabBar {
            actionSheet.showFromTabBar(tabBar)
        }
        else {
            // Otherwise use iPhone style action sheet presentation.
            let window = UIApplication.sharedApplication().delegate!.window!
            if window.subviews.containsObject(self.calculatedViewController().view!) {
                actionSheet.showInView(self.calculatedViewController().view!)
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
        }
        else if imagePicker != nil {
            imagePicker.dismissViewControllerAnimated(false, completion: nil)
        }
        else {
            NSLog("Other view")
        }
    }
}

extension FDTakeController : UIActionSheetDelegate {
    public func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        var aViewController: UIViewController = self.topViewController()
        if buttonIndex == actionSheet.cancelButtonIndex {
            self.delegate?.takeController(self, didCancelAfterAttempting: false)
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
                self.calculatedViewController().presentViewController(self.imagePicker, animated: true, completion: { _ in })
            }
        }
        self.actionSheet = nil
    }
}

extension FDTakeController : UIImagePickerControllerDelegate {
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        UIApplication.sharedApplication().statusBarHidden = true
        var mediaType: String = info[UIImagePickerControllerMediaType]
        var imageToSave: UIImage
        // Handle a still image capture
        if mediaType == kUTTypeImage as String {
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageToSave = originalImage
            } else {
                self.delegate?.takeController(self, didFailAfterAttempting: true)
                return
            }
            self.delegate?.takeController(self, gotPhoto: imageToSave, withInfo: info)
            if UI_USER_INTERFACE_IDIOM() == .Pad {
                self.popover.dismissPopoverAnimated(true)
            }
        } else if mediaType == kUTTypeMovie as String {
            self.delegate?.takeController(self, gotVideo: info[UIImagePickerControllerMediaURL], withInfo: info)
        }

        picker.dismissViewControllerAnimated(true, completion: nil)
        self.imagePicker = nil
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        UIApplication.sharedApplication().statusBarHidden = true
        picker.dismissViewControllerAnimated(true, completion: { _ in })
        self.imagePicker = nil
        self.delegate?.takeController(self, didCancelAfterAttempting: true)
    }
}


extension FDTakeController : UIAlertViewDelegate {
    public func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.delegate?.takeController(self, didCancelAfterAttempting: false)
    }
}
