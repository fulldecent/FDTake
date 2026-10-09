import Testing
@testable import FDTake

@MainActor
struct FDTakeTests {
    @Test func localizationOverrides() {
        let fdTake = FDTakeController()
        fdTake.cancelText = "bob"
        #expect(fdTake.cancelText == "bob")
        fdTake.chooseFromLibraryText = "bob"
        #expect(fdTake.chooseFromLibraryText == "bob")
        fdTake.chooseFromPhotoRollText = "bob"
        #expect(fdTake.chooseFromPhotoRollText == "bob")
        fdTake.noSourcesText = "bob"
        #expect(fdTake.noSourcesText == "bob")
        fdTake.takePhotoText = "bob"
        #expect(fdTake.takePhotoText == "bob")
        fdTake.takeVideoText = "bob"
        #expect(fdTake.takeVideoText == "bob")
    }

    @Test func configurationDefaultsCanBeTurnedOff() {
        let fdTake = FDTakeController()

        fdTake.allowsPhoto = false
        #expect(fdTake.allowsPhoto == false)

        fdTake.allowsVideo = false
        #expect(fdTake.allowsVideo == false)

        fdTake.allowsTake = false
        #expect(fdTake.allowsTake == false)

        fdTake.allowsSelectFromLibrary = false
        #expect(fdTake.allowsSelectFromLibrary == false)

        fdTake.allowsEditing = false
        #expect(fdTake.allowsEditing == false)

        fdTake.iPadUsesFullScreenCamera = false
        #expect(fdTake.iPadUsesFullScreenCamera == false)

        fdTake.defaultsToFrontCamera = false
        #expect(fdTake.defaultsToFrontCamera == false)

        fdTake.presentingBarButtonItem = nil
        #expect(fdTake.presentingBarButtonItem == nil)

        fdTake.presentingView = nil
        #expect(fdTake.presentingView == nil)

        fdTake.presentingRect = nil
        #expect(fdTake.presentingRect == nil)

        fdTake.presentingTabBar = nil
        #expect(fdTake.presentingTabBar == nil)
    }
}
