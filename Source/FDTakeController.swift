//
//  FDTakeController.swift
//  FDTakeExample
//
//  Copyright © 2015 William Entriken. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

/// User interface strings
fileprivate enum FDTakeControllerLocalizableStrings: String {
    /// Decline to proceed with operation
    case cancel = "cancel"
    
    /// Option to select photo from library
    case chooseFromLibrary = "chooseFromLibrary"
    
    /// Option to select photo from photo roll
    case chooseFromPhotoRoll = "chooseFromPhotoRoll"
    
    /// There are no sources available to select a photo
    case noSources = "noSources"
    
    /// Option to take photo using camera
    case takePhoto = "takePhoto"
    
    /// Option to take video using camera
    case takeVideo = "takeVideo"
    
    public func comment() -> String {
        switch self {
        case .cancel:
            return "Decline to proceed with operation"
        case .chooseFromLibrary:
            return "Option to select photo/video from library"
        case .chooseFromPhotoRoll:
            return "Option to select photo from photo roll"
        case .noSources:
            return "There are no sources available to select a photo"
        case .takePhoto:
            return "Option to take photo using camera"
        case .takeVideo:
            return "Option to take video using camera"
        }
    }
}

/// A class for select and taking photos
open class FDTakeController: NSObject /* , UIImagePickerControllerDelegate, UINavigationControllerDelegate*/ {

    // MARK: - Initializers & Class Convenience Methods

    /// Convenience method for getting a photo
    open class func getPhotoWithCallback(getPhotoWithCallback callback: @escaping (_ photo: UIImage, _ info: [AnyHashable: Any]?) -> Void) {
        let fdTake = FDTakeController()
        fdTake.allowsVideo = false
        fdTake.didGetPhoto = callback
        fdTake.present()
    }

    /// Convenience method for getting a video
    open class func getVideoWithCallback(getVideoWithCallback callback: @escaping (_ video: URL, _ info: [AnyHashable: Any]) -> Void) {
        let fdTake = FDTakeController()
        fdTake.allowsPhoto = false
        fdTake.didGetVideo = callback
        fdTake.present()
    }


    // MARK: - Configuration options

    /// Whether to allow selecting a photo
    open var allowsPhoto = true

    /// Whether to allow selecting a video
    open var allowsVideo = true

    /// Whether to allow capturing a photo/video with the camera
    open var allowsTake = true

    /// Whether to allow selecting existing media
    open var allowsSelectFromLibrary = true

    /// Whether to allow editing the media after capturing/selection
    open var allowsEditing = false

    /// Whether to use full screen camera preview on the iPad
    open var iPadUsesFullScreenCamera = false

    /// Enable selfie mode by default
    open var defaultsToFrontCamera = false

    /// The UIBarButtonItem to present from (may be replaced by a overloaded methods)
    open var presentingBarButtonItem: UIBarButtonItem? = nil

    /// The UIView to present from (may be replaced by a overloaded methods)
    open var presentingView: UIView? = nil

    /// The UIRect to present from (may be replaced by a overloaded methods)
    open var presentingRect: CGRect? = nil

    /// The UITabBar to present from (may be replaced by a overloaded methods)
    open var presentingTabBar: UITabBar? = nil

    /// The UIViewController to present from (may be replaced by a overloaded methods)
    open lazy var presentingViewController: UIViewController = {
        return UIApplication.shared.keyWindow!.rootViewController!
    }()

    open var aspectRatio: CGFloat = 4/3

    // MARK: - Callbacks

    /// A photo was selected
    open var didGetPhoto: ((_ photo: UIImage, _ info: [AnyHashable: Any]?) -> Void)?

    /// A video was selected
    open var didGetVideo: ((_ video: URL, _ info: [AnyHashable: Any]) -> Void)?

    /// The user did not attempt to select a photo
    open var didDeny: (() -> Void)?

    /// The user started selecting a photo or took a photo and then hit cancel
    open var didCancel: (() -> Void)?

    /// A photo or video was selected but the ImagePicker had NIL for EditedImage and OriginalImage
    open var didFail: (() -> Void)?


    // MARK: - Localization overrides
    
    /// Custom UI text (skips localization)
    open var cancelText: String? = nil
    
    /// Custom UI text (skips localization)
    open var chooseFromLibraryText: String? = nil
    
    /// Custom UI text (skips localization)
    open var chooseFromPhotoRollText: String? = nil
    
    /// Custom UI text (skips localization)
    open var noSourcesText: String? = nil

    /// Custom UI text (skips localization)
    open var takePhotoText: String? = nil

    /// Custom UI text (skips localization)
    open var takeVideoText: String? = nil


    internal var info: [AnyHashable: Any]?
    
    internal lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        return picker
    }()

    // MARK: - Private

    private var alertController: UIAlertController? = nil

    // This is a hack required on iPad if you want to select a photo and you already have a popup on the screen
    // see: https://stackoverflow.com/a/35209728/300224
    private func topViewController(rootViewController: UIViewController) -> UIViewController {
        var rootViewController = UIApplication.shared.keyWindow!.rootViewController!
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

    private func localizeString(_ string:FDTakeControllerLocalizableStrings) -> String {
        let bundle = Bundle(for: type(of: self))
        //let stringsURL = bundle.resourceURL!.appendingPathComponent("Localizable.strings")
        let bundleLocalization = bundle.localizedString(forKey: string.rawValue, value: nil, table: nil)
        //let a = NSLocal
        //let bundleLocalization = NSLocalizedString(string.rawValue, tableName: nil, bundle: bundle, value: string.rawValue, comment: string.comment())
        
        
        switch string {
        case .cancel:
            return self.cancelText ?? bundleLocalization
        case .chooseFromLibrary:
            return self.chooseFromLibraryText ?? bundleLocalization
        case .chooseFromPhotoRoll:
            return self.chooseFromPhotoRollText ?? bundleLocalization
        case .noSources:
            return self.noSourcesText ?? bundleLocalization
        case .takePhoto:
            return self.takePhotoText ?? bundleLocalization
        case .takeVideo:
            return self.takeVideoText ?? bundleLocalization
        }
    }

    fileprivate func startImagePicker(_ title: FDTakeControllerLocalizableStrings, _ source: UIImagePickerController.SourceType) {
        
        
        self.imagePicker.sourceType = source
        if source == .camera && self.defaultsToFrontCamera && UIImagePickerController.isCameraDeviceAvailable(.front) {
            self.imagePicker.cameraDevice = .front
        }
        // set the media type: photo or video
        self.imagePicker.allowsEditing = false
        var mediaTypes = [String]()
        if self.allowsPhoto {
            mediaTypes.append(String(kUTTypeImage))
        }
        if self.allowsVideo {
            mediaTypes.append(String(kUTTypeMovie))
        }
        self.imagePicker.mediaTypes = mediaTypes
        
        //TODO: Need to encapsulate popover code
        var popOverPresentRect: CGRect = self.presentingRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        if popOverPresentRect.size.height == 0 || popOverPresentRect.size.width == 0 {
            popOverPresentRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        }
        
        if !(UI_USER_INTERFACE_IDIOM() == .phone || (source == .camera && self.iPadUsesFullScreenCamera)) {
            // On iPad use pop-overs.
            self.imagePicker.modalPresentationStyle = .popover
            self.imagePicker.popoverPresentationController?.sourceRect = popOverPresentRect
        }
        
    }
    
    /// Presents the user with an option to take a photo or choose a photo from the library
    open func present() {
        //TODO: maybe encapsulate source selection?
        var titleToSource = [(buttonTitle: FDTakeControllerLocalizableStrings, source: UIImagePickerController.SourceType)]()

        if self.allowsTake && UIImagePickerController.isSourceTypeAvailable(.camera) {
            if self.allowsPhoto {
                titleToSource.append((buttonTitle: .takePhoto, source: .camera))
            }
            if self.allowsVideo {
                titleToSource.append((buttonTitle: .takeVideo, source: .camera))
            }
        }
        if self.allowsSelectFromLibrary {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                titleToSource.append((buttonTitle: .chooseFromLibrary, source: .photoLibrary))
            } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                titleToSource.append((buttonTitle: .chooseFromPhotoRoll, source: .savedPhotosAlbum))
            }
        }

        guard titleToSource.count > 0 else {
            let str = localizeString(.noSources)

            //TODO: Encapsulate this
            //TODO: These has got to be a better way to do this
            let alert = UIAlertController(title: nil, message: str, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: localizeString(.cancel), style: .default, handler: nil))

            // http://stackoverflow.com/a/34487871/300224
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindow.Level.alert + 1
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
            return
        }

        var popOverPresentRect : CGRect = self.presentingRect ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        if popOverPresentRect.size.height == 0 || popOverPresentRect.size.width == 0 {
            popOverPresentRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        }

        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (title, source) in titleToSource {
            let action = UIAlertAction(title: localizeString(title), style: .default) {
                (UIAlertAction) -> Void in
                self.startImagePicker(title,source)
                let topVC = self.topViewController(rootViewController: self.presentingViewController)
                topVC.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController!.addAction(action)
        }
        let cancelAction = UIAlertAction(title: localizeString(.cancel), style: .cancel) {
            (UIAlertAction) -> Void in
            self.didCancel?()
        }
        alertController!.addAction(cancelAction)

        let topVC = topViewController(rootViewController: presentingViewController)

        alertController?.modalPresentationStyle = .popover
        if let presenter = alertController!.popoverPresentationController {
            presenter.sourceView = presentingView;
            if let presentingRect = self.presentingRect {
                presenter.sourceRect = presentingRect
            }
            //WARNING: on ipad this fails if no SOURCEVIEW AND SOURCE RECT is provided
        }
        topVC.present(alertController!, animated: true, completion: nil)
    }

    /// Dismisses the displayed view. Especially handy if the sheet is displayed while suspending the app,
    open func dismiss() {
        alertController?.dismiss(animated: true, completion: nil)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension FDTakeController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// Conformance for ImagePicker delegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        UIApplication.shared.isStatusBarHidden = true
        let mediaType: String = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        var imageToSave: UIImage
        // Handle a still image capture
        if mediaType == kUTTypeImage as String {
            if let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                imageToSave = originalImage
            } else {
                self.didCancel?()
                return
            }
            
            
            
            if self.allowsEditing {
                let cropper = UIImageCropper(cropRatio: self.aspectRatio)
                cropper.cropButtonText = "Crop" // button labes can be localised/changed
                cropper.cancelButtonText = "Cancel"
                
                cropper.image = imageToSave.fixOrientation()
                cropper.delegate = self
                
                
                picker.present(cropper, animated: true, completion: nil)
                
                
                self.info = info
            } else {
                self.didGetPhoto?(imageToSave, info)
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.imagePicker.dismiss(animated: true)
                }
                
                picker.dismiss(animated: true, completion: nil)
            }
            
            
        } else if mediaType == kUTTypeMovie as String {
            self.didGetVideo?(info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as! URL, info)
        }

    }

    /// Conformance for image picker delegate
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UIApplication.shared.isStatusBarHidden = true
        picker.dismiss(animated: true, completion: nil)
        self.didDeny?()
    }
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
}

extension FDTakeController: UIImageCropperProtocol {
    public func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        
        if let image = croppedImage {
            self.didGetPhoto?(image, self.info)
        } else {
            self.didFail?()
        }
        self.dismiss()
    }

}

