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
    
    // MARK: - Initializers & Class Convenience Methods
    
    public override init() {
        super.init()
    }
    
    public class func getPhotoWithCallback(getPhotoWithCallback callback: (photo: UIImage, info: [NSObject : AnyObject]) -> Void) {
        let fdTake = FDTakeController()
        fdTake.allowsVideo = false
        fdTake.didGetPhoto = callback
        fdTake.present()
    }
    
    public class func getVideoWithCallback(getVideoWithCallback callback: (video: NSURL, info: [NSObject : AnyObject]) -> Void) {
        let fdTake = FDTakeController()
        fdTake.allowsPhoto = false
        fdTake.didGetVideo = callback
        fdTake.present()
    }

    
    // MARK: - Configuration options
    
    public var allowsPhoto = true
    
    public var allowsVideo = true
    
    public var allowsTake = true
    
    public var allowsSelectFromLibrary = true
    
    public var allowsEditing = false
    
    public var iPadUsesFullScreenCamera = false
    
    public var defaultsToFrontCamera = false
    
    //WARNING: THESE WILL DISAPPEAR AND YOU WILL GET NEW PRESENT FUNCTIONS! MAYBE!!
    public var presentingBarButtonItem: UIBarButtonItem? = nil
    
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
        
    
    // MARK: - Private
    
    private lazy var imagePicker: UIImagePickerController = {
        [unowned self] in
        let retval = UIImagePickerController()
        retval.delegate = self
        retval.allowsEditing = true
        return retval
        }()
    
    private lazy var popover: UIPopoverController = {
        [unowned self] in
        return UIPopoverController(contentViewController: self.imagePicker)
        }()
    
    private var alertController: UIAlertController? = nil
    
    // This is a hack required on iPad if you want to select a photo and you already have a popup on the screen
    // see: http://stackoverflow.com/a/34392409/300224
    private func topViewController(rootViewController: UIViewController) -> UIViewController {
        var rootViewController = UIApplication.sharedApplication().keyWindow!.rootViewController!
        repeat {
            guard let presentedViewController = rootViewController.presentedViewController else {
                return rootViewController
            }
            
            if let navigationController = rootViewController.presentedViewController as? UINavigationController {
                rootViewController = navigationController.topViewController ?? navigationController
                
            } else {
                rootViewController = presentedViewController
            }
        } while true
    }
    
    // MARK: - Localization
    
    private func localize(key: String, comment: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: NSBundle(URL: NSBundle(forClass: self.dynamicType).resourceURL!.URLByAppendingPathComponent("FDTake.bundle"))!, value: key, comment: comment)
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
        //TODO: maybe encapsulate source selection?
        var titleToSource = [(buttonTitle: String, source: UIImagePickerControllerSourceType)]()
        
        if self.allowsTake && UIImagePickerController.isSourceTypeAvailable(.Camera) {
            if self.allowsPhoto {
                titleToSource.append((buttonTitle: kTakePhotoKey, source: .Camera))
            }
            if self.allowsVideo {
                titleToSource.append((buttonTitle: kTakeVideoKey, source: .Camera))
            }
        }
        if self.allowsSelectFromLibrary {
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                titleToSource.append((buttonTitle: kChooseFromLibraryKey, source: .PhotoLibrary))
            } else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
                titleToSource.append((buttonTitle: kChooseFromPhotoRollKey, source: .SavedPhotosAlbum))
            }
        }
        
        guard titleToSource.count > 0 else {
            let str: String = self.textForButtonWithTitle(kNoSourcesKey)

            //TODO: Encapsulate this
            //TODO: These has got to be a better way to do this
            let alert = UIAlertController(title: nil, message: str, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: textForButtonWithTitle(kCancelKey), style: .Default, handler: nil))
            
            // http://stackoverflow.com/a/34487871/300224
            let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var popOverPresentRect : CGRect = self.presentingRect ?? CGRectMake(0, 0, 1, 1)
        if popOverPresentRect.size.height == 0 || popOverPresentRect.size.width == 0 {
            popOverPresentRect = CGRectMake(0, 0, 1, 1)
        }
        
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        for (title, source) in titleToSource {
            let action = UIAlertAction(title: textForButtonWithTitle(title), style: .Default) {
                (UIAlertAction) -> Void in
                self.imagePicker.sourceType = source
                if source == .Camera && self.defaultsToFrontCamera && UIImagePickerController.isCameraDeviceAvailable(.Front) {
                    self.imagePicker.cameraDevice = .Front
                }
                // set the media type: photo or video
                self.imagePicker.allowsEditing = self.allowsEditing
                var mediaTypes = [String]()
                if self.allowsPhoto {
                    mediaTypes.append(String(kUTTypeImage))
                }
                if self.allowsVideo {
                    mediaTypes.append(String(kUTTypeMovie))
                }
                self.imagePicker.mediaTypes = mediaTypes

                //TODO: Need to encapsulate popover code
                var popOverPresentRect: CGRect = self.presentingRect ?? CGRectMake(0, 0, 1, 1)
                if popOverPresentRect.size.height == 0 || popOverPresentRect.size.width == 0 {
                    popOverPresentRect = CGRectMake(0, 0, 1, 1)
                }
                let topVC = self.topViewController(self.presentingViewController)
                
                // 
                if UI_USER_INTERFACE_IDIOM() == .Phone || (source == .Camera && self.iPadUsesFullScreenCamera) {
                    topVC.presentViewController(self.imagePicker, animated: true, completion: { _ in })
                } else {
                    // On iPad use pop-overs.
                    self.popover.presentPopoverFromRect(popOverPresentRect, inView: topVC.view!, permittedArrowDirections: .Any, animated: true)
                }
                
                NSLog("DID SELECT!")
            }
            alertController!.addAction(action)
        }
        let cancelAction = UIAlertAction(title: textForButtonWithTitle(kCancelKey), style: .Cancel) {
            (UIAlertAction) -> Void in
            self.didCancel?()
        }
        alertController!.addAction(cancelAction)
        
        let topVC = topViewController(presentingViewController)
  
        alertController?.modalPresentationStyle = .Popover
        if let presenter = alertController!.popoverPresentationController {
            presenter.sourceView = presentingView;
            if let presentingRect = self.presentingRect {
                presenter.sourceRect = presentingRect
            }
            //WARNING: on ipad this fails if no SOURCEVIEW AND SOURCE RECT is provided
        }
        topVC.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    /**
     *  Dismisses the displayed view (actionsheet or imagepicker).
     *  Especially handy if the sheet is displayed while suspending the app,
     *  and you want to go back to a default state of the UI.
     */
    public func dismiss() {
        alertController?.dismissViewControllerAnimated(true, completion: nil)
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension FDTakeController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        self.didDeny?()
    }
}
