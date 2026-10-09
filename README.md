# FDTake

[![CI](https://github.com/fulldecent/FDTake/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/fulldecent/FDTake/actions/workflows/ci.yml)

Easily take a photo or video or choose from library

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
   - Swedish (thanks Paul Peelen)
   - Portuguese (thanks Natan Rolnik)
   - Greek (thanks Konstantinos)
   - Italian (thanks Giuseppe Filograno)
   - Hungarian (thanks Andras Kadar)
   - Please help translate [`Localizable.strings`](Resources/Resources/en.lproj/Localizable.strings) to more languages
 * Pure Swift, deployment target iOS 15 (see [Package.swift](Package.swift))
 * Compile testing running on GitHub Actions
 * In progress: functional test cases ([please help](https://github.com/fulldecent/FDTake/issues/72))
 * In progress: UI test cases ([please help](https://github.com/fulldecent/FDTake/issues/72))


## Installation

Add this package with Swift Package Manager. In Xcode that is File > Add Package Dependencies...

## Author

William Entriken, github.com@phor.net

## Project scope

This is a mature project and we do not expect to add new features unless something has already become state-of-the-art in other applications. Please be prepared to cite screenshots of other apps before making a feature request.

We support targets for the latest released versions of Xcode and Swift Package Manager. If there are incompatibilities, we will only support the latest released versions/combinations that are supported. If you would like to support pre-release versions of these packages, please open a pull request, not an issue.

## License

FDTake is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Development

### Testing

Run the test suite on an iPhone simulator:

```sh
xcodebuild test -scheme FDTake -destination 'platform=iOS Simulator,name=iPhone 17,OS=27.0'
```

`xcrun swift test`, the command in the Swift 6 module template, builds the package for macOS. This package imports UIKit, so that command does not compile here.

### Releases

Use `fix:`, `feat:` or `BREAKING CHANGE:` in your commit messages. This triggers our bot to make a release draft pull request. Merging that pull request triggers a new tag and GitHub Release.

The [release workflow](.github/workflows/release.yml) uses [Release Please](https://github.com/googleapis/release-please) with the `simple` release type, as [swift6-module-template v16.5.0](https://github.com/fulldecent/swift6-module-template/releases/tag/v16.5.0) does. [`.release-please-manifest.json`](.release-please-manifest.json) is the last released version, `3.1.0`. Release Please writes [CHANGELOG.md](CHANGELOG.md) on the release pull request. Commit messages follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

[Build and test](.github/workflows/build-test.yml) tests the package, builds the example, builds `libFDTake.a` for the iOS simulator, then attests and uploads it. The template's copy of that workflow builds a Linux library with `swift build -c release` on `ubuntu-latest`. Swift Package Manager uses the git tag.

> [!NOTE]
> In your GitHub repository settings, under Actions, General, Workflow permissions, select read and write permissions and check "Allow GitHub Actions to create and approve pull requests". Under General, Releases, enable release immutability. Attestations are available for public repositories; private repositories require GitHub Enterprise Cloud.

## Maintenance and dependency updates

Do this every quarter or so and please send a pull request if you see updates available:

1. Identify external Actions in [.github/workflows](.github/workflows) and look for available new versions. Review and then update to the new version if it is safe. GitHub-supported Actions (under the `actions/` organization) may require only cursory review.
1. Review the Xcode pin and the iPhone destination in [.github/workflows/ci.yml](.github/workflows/ci.yml) against the [xcode-27 runner image](https://github.com/actions/runner-images/blob/main/images/macos/xcode-27-arm64-Readme.md). The [recipe](https://github.com/fulldecent/swift6-module-template/blob/main/TEMPLATE/Recipe.md) records the Xcode version it was written against. When that version changes, confirm this package still builds with the version asserted there.

## References

1. We use title case for titles and proper nouns; not for headings and things.
1. FDTake is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
1. Swift ignore rules are inlined from [Swift.gitignore](https://github.com/github/gitignore/blob/main/Swift.gitignore), the same snapshot vendored by [swift6-module-template](https://github.com/fulldecent/swift6-module-template/blob/main/.gitignore). The `.DS_Store` rule above that block comes from [macOS.gitignore](https://github.com/github/gitignore/blob/main/Global/macOS.gitignore).
1. This project is built based on [best practices documented in Swift 6 Module Template](https://github.com/fulldecent/swift6-module-template), release [v16.5.0](https://github.com/fulldecent/swift6-module-template/releases/tag/v16.5.0). `Package.swift` uses `// swift-tools-version: 6.4` and `ApproachableConcurrency`, as that release does. FDTake keeps these choices:
   - [Package.swift](Package.swift) declares `.iOS(.v15)` because the library presents `UIImagePickerController`.
   - [.github/workflows/build-test.yml](.github/workflows/build-test.yml) runs on the GitHub-hosted `xcode-27` runner and builds `arm64-apple-ios15.0-simulator`. The template's [build-test.yml](https://github.com/fulldecent/swift6-module-template/blob/v16.5.0/.github/workflows/build-test.yml) runs `swift build` and `swift test` on `ubuntu-latest`.
   - The template's [swiftlang workflow](https://github.com/fulldecent/swift6-module-template/blob/v16.5.0/.github/workflows/swiftlang-workflows.yml) calls [`swift_package_test.yml`](https://github.com/swiftlang/github-workflows/blob/main/.github/workflows/swift_package_test.yml) and runs `xcrun swift test` on `xcode-27`. FDTake's [.github/workflows/ci.yml](.github/workflows/ci.yml) runs `xcodebuild test` on iPhone 17, iOS 27.0.
   - The example stays at `iOS Example/iOS Example.xcodeproj` and uses storyboards. The recipe allows that in place of its SwiftUI example.
1. This project is built based on [best practices documented in project-template](https://github.com/fulldecent/project-template), release 1.0.0.
1. Releases follow the [project-template release workflow](https://github.com/fulldecent/project-template/blob/v1.3.0/.github/workflows/release.yml), release 1.3.0, through the copy in [swift6-module-template v16.5.0](https://github.com/fulldecent/swift6-module-template/blob/v16.5.0/.github/workflows/release.yml). The published file is `libFDTake.a` from `swift build -c release --triple arm64-apple-ios15.0-simulator`. The template publishes its Linux static library. project-template publishes `README.md` there, and [rust-template](https://github.com/fulldecent/rust-template) publishes its command-line binary.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). This project's layout is based on [swift6-module-template](https://github.com/fulldecent/swift6-module-template). If you would like to change the layout, please change that project FIRST. That project has a recipe: you explain why you are doing things. As a maintainer this makes my job MUCH simpler. In a similar respect, if you are introducing non-minor changes, please reference another project (like Alamofire) that has seen and discussed the types of design challenges you are touching.
