# FDTake

[![CI Status](https://github.com/fulldecent/FDTake/workflows/CI/badge.svg)](https://github.com/fulldecent/FDTake/actions)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=fulldecent/FDTake)](http://clayallsopp.github.io/readme-score?url=fulldecent/FDTake)

Easily take a photo or video or choose from library

**:beer: Author's tip jar: https://amazon.com/hz/wishlist/ls/EE78A23EEGQB**

## Usage

To run the example project, clone the repo and open `iOS Example/iOS Example.xcodeproj`.

To use it in your project, add an `FDTakeController` to your view controller and implement:

    fdTakeController.didGetPhoto = {
        (_ photo: UIImage, _ info: [AnyHashable : Any]) in
    }

then call:

    fdTakeController.present()

The full API is:

```swift
/// Public initializer
public override init()

/// Convenience method for getting a photo
open class func getPhotoWithCallback(getPhotoWithCallback callback: @escaping (_ photo: UIImage, _ info: [AnyHashable : Any]) -> Void) -> <<error type>>

/// Convenience method for getting a video
open class func getVideoWithCallback(getVideoWithCallback callback: @escaping (_ video: URL, _ info: [AnyHashable : Any]) -> Void)

/// Whether to allow selecting a photo
open var allowsPhoto: Bool

/// Whether to allow selecting a video
open var allowsVideo: Bool

/// Whether to allow capturing a photo/video with the camera
open var allowsTake: Bool

/// Whether to allow selecting existing media
open var allowsSelectFromLibrary: Bool

/// Whether to allow editing the media after capturing/selection
open var allowsEditing: Bool

/// Whether to use full screen camera preview on the iPad
open var iPadUsesFullScreenCamera: Bool

/// Enable selfie mode by default
open var defaultsToFrontCamera: Bool

/// The UIBarButtonItem to present from (may be replaced by overloaded methods)
open var presentingBarButtonItem: UIBarButtonItem?

/// The UIView to present from (may be replaced by overloaded methods)
open var presentingView: UIView?

/// The UIRect to present from (may be replaced by overloaded methods)
open var presentingRect: CGRect?

/// The UITabBar to present from (may be replaced by overloaded methods)
open var presentingTabBar: UITabBar?

/// The UIViewController to present from (may be replaced by overloaded methods)
open lazy var presentingViewController: UIViewController { get set }

/// A photo was selected
open var didGetPhoto: ((_ photo: UIImage, _ info: [AnyHashable : Any]) -> Void)?

/// A video was selected
open var didGetVideo: ((_ video: URL, _ info: [AnyHashable : Any]) -> Void)?

/// The user did not attempt to select a photo
open var didDeny: (() -> Void)?

/// The user started selecting a photo or took a photo and then hit cancel
open var didCancel: (() -> Void)?

/// A photo or video was selected but the ImagePicker had NIL for EditedImage and OriginalImage
open var didFail: (() -> Void)?

/// Custom UI text (skips localization)
open var cancelText: String?

/// Custom UI text (skips localization)
open var chooseFromLibraryText: String?

/// Custom UI text (skips localization)
open var chooseFromPhotoRollText: String?

/// Custom UI text (skips localization)
open var noSourcesText: String?

/// Custom UI text (skips localization)
open var takePhotoText: String?

/// Custom UI text (skips localization)
open var takeVideoText: String?

/// Presents the user with an option to take a photo or choose a photo from the library
open func present()

/// Dismisses the displayed view. Especially handy if the sheet is displayed while suspending the app,
open func dismiss()
```

## How it works

 1. See if device has camera
 2. Create action sheet with appropriate options ("Take Photo" or "Choose from Library"), as available
 3. Localize "Take Photo" and "Choose from Library" into user's language
 4. Wait for response
 5. Bring up image picker with selected image picking method
 6. Default to selfie mode if so configured
 7. Get response, extract image from a dictionary
 8. Dismiss picker, send image to delegate


## Support

 * Supports iPhones, iPods, iPads and tvOS (but not tested)
 * Supported languages:
   - English
   - Chinese Simplified
   - Turkish (thanks Suleyman Melikoglu)
   - French (thanks Guillaume Algis)
   - Dutch (thanks Mathijs Kadijk)
   - Chinese Traditional (thanks Qing Ao)
   - German (thanks Lars Häuser)
   - Russian (thanks Alexander Zubkov)
   - Norwegian (thanks Sindre Sorhus)
   - Arabic (thanks HadiIOS)
   - Polish (thanks Jacek Kwiecień)
   - Spanish (thanks David Jorge)
   - Hebrew (thanks Asaf Siman-Tov)
   - Danish (thanks kaspernissen)
   - Sweedish (thanks Paul Peelen)
   - Portugese (thanks Natan Rolnik)
   - Greek (thanks Konstantinos)
   - Italian (thanks Giuseppe Filograno)
   - Hungarian (thanks Andras Kadar)
   - Please help translate <a href="https://github.com/fulldecent/FDTake/blob/master/FDTakeExample/en.lproj/FDTake.strings">`FDTake.strings`</a> to more languages
 * Pure Swift support and iOS 8+ required
 * Compile testing running on GitHub Actions
 * In progress: functional test cases ([please help](https://github.com/fulldecent/FDTake/issues/72))
 * In progress: UI test cases ([please help](https://github.com/fulldecent/FDTake/issues/72))


## Installation

Add this to your project using Swift Package Manager. In Xcode that is simply: File > Swift Packages > Add Package Dependency... and you're done.

## Author

William Entriken, github.com@phor.net

## Project scope

This is a mature project and we do not expect to add new features unless something has already become state-of-the-art in other applications. Please be prepared to cite screenshots of other apps before making a feature request.

We support targets for the latest released versions of Xcode and Swift Package Manager. If there are incompatibilities, we will only support the latest released versions/combinations that are supported. If you would like to support pre-release versions of these packages, please open a pull request, not an issue.

## License

FDTake is available under the MIT license. See the LICENSE file for more info.

## Contributing

This project's layout is based on https://github.com/fulldecent/swift4-module-template If you would like to change the layout, please change that project FIRST. Also you may appreciate that project has "recipes" -- you don't just change the code, you explain why you are doing things. As a maintainer this makes my job MUCH simpler. In a similar respect, if you are introducing non-minor changes, it will be VERY helpful if you could please reference to another project (like AlamoFire) that has seen and discussed the types of design challenges you are touching.) Thanks again and we all really do appreciate your contributions.
