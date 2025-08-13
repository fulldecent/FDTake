# Change Log
All notable changes to this project will be documented in this file.
`FDTake` adheres to [Semantic Versioning](http://semver.org/).

---

## [Master](https://github.com/fulldecent/FDBarGuage/compare/3.0.0...master)

#### Updated

- Now targeting iOS 10.3.3 or later
- Migrated from Travis CI to GitHub Actions for continuous integration
- Updated build environment from Xcode 11.2 to Xcode 15.4
- Updated iOS testing targets from iOS 13.2.2 to iOS 17.5, 16.4, and 14.5
- Updated Swift Package Manager tools version from 5.1 to 5.7
- **BREAKING:** Removed CocoaPods and Carthage support - use Swift Package Manager instead
- **BREAKING:** Removed Xcode workspace - use the project file directly
- Fixed MobileCoreServices import issue by migrating to UniformTypeIdentifiers framework
- Updated CI to use Xcode project instead of workspace

#### KNOWN ISSUES

- Localization is broken, discuss at https://github.com/fulldecent/FDTake/pull/99

---

## [3.0.0](https://github.com/fulldecent/FDBarGuage/compare/3.0.0)

#### Updated

- Switched to target Swift 5.

---

## [2.0.3](https://github.com/fulldecent/FDBarGuage/compare/2.0.3)

#### Fixed

- Fixed resources including the Podspec 
  - Added by [JoelGerboreLaser](https://github.com/JoelGerboreLaser) in regards to issue
  [#115](https://github.com/fulldecent/FDTake/pull/115).

---

## [2.0.2](https://github.com/fulldecent/FDBarGuage/compare/2.0.2)

#### Updated

- Updated to Swift 4 visibility inference

---

## [2.0.1](https://github.com/fulldecent/FDBarGuage/compare/2.0.1)
#### Updated

- Refactored to remove deprecated popover controller
- Updated to Xcode recommended settings
- Updated application strings to follow Apple HIG

------

## [2.0.0](https://github.com/fulldecent/FDBarGuage/compare/2.0.0)

#### Updated

- Updated for Swift 4

------

## [1.0.0](https://github.com/fulldecent/FDBarGuage/releases/tag/1.0.0)

Released on 2016-09-28.

Release 1.0 because this is already used in a lot of places. It's time.

---

## [0.4.2](https://github.com/fulldecent/FDBarGuage/releases/tag/0.4.2)
Released on 2016-09-17.

Version bump to trigger CocoaPods quality check

---

## [0.4.1](https://github.com/fulldecent/FDBarGuage/releases/tag/0.4.1)
Released on 2016-09-17.

#### Added
- Support for Swift Package Manager
  - Added by [William Entriken](https://github.com/fulldecent) in regards to issue
  [#87](https://github.com/fulldecent/FDBarGuage/issues/87).
- Test cases
  - Added by [William Entriken](https://github.com/fulldecent) in regards to issue
  [#72](https://github.com/fulldecent/FDBarGuage/issues/72).

#### KNOWN ISSUES
- Localization is broken, discuss at https://github.com/fulldecent/FDTake/pull/99

---

## [0.4.0](https://github.com/fulldecent/FDBarGuage/releases/tag/0.4.0)
Released on 2016-09-17.

#### Added
- Automated CocoaPods Quality Indexes testing
  - Added by [Hayden Holligan](https://github.com/haydenholligan) in regards to issue
  [#95](https://github.com/fulldecent/FDTake/issues/95).

#### Changed
- Updated to Swift 3
  - Added by [Anthony Miller](https://github.com/AnthonyMDev) and [William Entriken](https://github.com/fulldecent) in regards to issue
  [#98](https://github.com/fulldecent/FDTake/issues/98).

#### KNOWN ISSUES
- Localization is broken, discuss at https://github.com/fulldecent/FDTake/pull/99

---

## [0.3.3](https://github.com/fulldecent/FDBarGuage/releases/tag/0.3.3)
Released on 2016-06-27.

#### Added
- Change Log
  - Added by [William Entriken](https://github.com/fulldecent) in regards to issue
  [#90](https://github.com/fulldecent/FDBarGuage/issues/90).
- Tracking README score
  - Added by [William Entriken](https://github.com/fulldecent)
- Full API documentation with headerdoc
  - Added by [William Entriken](https://github.com/fulldecent)
- Contributing guidelines and release process documentation
  - Added by [William Entriken](https://github.com/fulldecent) in regards to issue
  [#93](https://github.com/fulldecent/FDBarGuage/issues/93).

#### Fixed
- Crash of the iPad example when present window is tapped
  - Added by [Lily](https://github.com/Lily418) in regards to issue
  [#84](https://github.com/fulldecent/FDTake/issues/84)

---

## [0.3.2](https://github.com/fulldecent/FDBarGuage/releases/tag/0.3.2)
Released on 2016-02-04.

#### Fixed
- Public API method visibility
  -  by [William Entriken](https://github.com/fulldecent)

---

## [0.3.1](https://github.com/fulldecent/FDBarGuage/releases/tag/0.3.1)
Released on 2016-02-03.

#### Added
- Support for tvOS (not tested)
  - Added by [William Entriken](https://github.com/fulldecent)

#### Updated
- Delegate method names
  - Added by [William Entriken](https://github.com/fulldecent)
- iOS supports version 8+
  - Added by [William Entriken](https://github.com/fulldecent)

---

## [0.3.0](https://github.com/fulldecent/FDBarGuage/releases/tag/0.3.0)
Released on 2015-12-28.

#### Fixed
- Example of a project storyboard
  - Added by [William Entriken](https://github.com/fulldecent)
