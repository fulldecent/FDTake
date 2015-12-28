# FDTake

[![CI Status](http://img.shields.io/travis/fulldecent/FDTake.svg?style=flat)](https://travis-ci.org/William Entriken/FDTake)
[![Version](https://img.shields.io/cocoapods/v/FDTake.svg?style=flat)](http://cocoapods.org/pods/FDTake)
[![License](https://img.shields.io/cocoapods/l/FDTake.svg?style=flat)](http://cocoapods.org/pods/FDTake)
[![Platform](https://img.shields.io/cocoapods/p/FDTake.svg?style=flat)](http://cocoapods.org/pods/FDTake)


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use it in your project, add an `FDTakeController` to your view controller and implement:

    fdTakeController.gotPhoto = {
        ...
    }

then call:

    fdTakeController.present()

Other available options are documented at <a href="http://cocoadocs.org/docsets/FDTake/">CocoaDocs for FDTake</a>.


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
   - Please help translate <a href="https://github.com/fulldecent/FDTake/blob/master/FDTakeExample/en.lproj/FDTake.strings">`FDTake.strings`</a> to more languages
 * Pure Swift support and iOS 8+ required
 * Compile testing running on Travis CI
 * In progress: functional test cases ([please help](https://github.com/fulldecent/FDTake/issues/72))
 * In progress: UI test cases ([please help](https://github.com/fulldecent/FDTake/issues/72))
 * In progress: select last photo used ([please help](https://github.com/fulldecent/FDTake/issues/22))


## Installation

FDTake is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FDTake"
```


## Author

William Entriken, github.com@phor.net


## License

FDTake is available under the MIT license. See the LICENSE file for more info.
