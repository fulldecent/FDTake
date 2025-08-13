# Contributing

All contributors are welcome. Please use issues and pull requests to contribute to the project. And update [CHANGELOG.md](CHANGELOG.md) when committing.

## Making a Change

When you commit a change, please add a note to [CHANGELOG.md](CHANGELOG.md).

## Release Process

1. Confirm the build is [passing in GitHub Actions](https://github.com/fulldecent/FDTake/actions)
   1. This automatically checks that the Podfile is building
2. Push a release commit
   1. Create a new Master section at the top
   2. Rename the old Master section like:
          ## [1.0.5](https://github.com/fulldecent/FDTake/releases/tag/1.0.5)
          Released on 2016-02-14.
   3. Update the Podspec version number
3. Create a GitHub release
   1. Tag the release (like `1.0.5`)
   2. Paste notes from [CHANGELOG.md](CHANGELOG.md)
3. Push the Podspec to CocoaPods
   1. `pod trunk push`
4. Create Carthage binaries
   1. `carthage build --no-skip-current`
   2. `carthage archive FDTake`
   3. Add to the GitHub release
