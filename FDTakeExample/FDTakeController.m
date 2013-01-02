//
//  FDTakeController.m
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import "FDTakeController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kPhotosActionSheetTag 1
#define kVideosActionSheetTag 2
#define kVideosOrPhotosActionSheetTag 3

@interface FDTakeController() <UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSMutableArray *sources;
@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popover;

// Returns either optional view controll for presenting or main window.
- (UIViewController*)presentingViewController;

// encapsulation of actionsheet creation 
- (void)_setUpActionSheet;

// we need to reset actionsheet items each time since we share sources and button titles
// we could have a set of sources and titles for each actionsheet to prevent this
- (void)_resetUI;

@end

@implementation FDTakeController
@synthesize sources = _sources;
@synthesize buttonTitles = _buttonTitles;
@synthesize actionSheet = _actionSheet;
@synthesize imagePicker = _imagePicker;
@synthesize popover = _popover;
@synthesize viewControllerForPresenting = _viewControllerForPresenting;
@synthesize popOverPresentRect = _popOverPresentRect;

- (id)init
{
    self = [super init];
    if (self) {
        self.sources = [[NSMutableArray alloc] init];
        self.buttonTitles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        
        // when using iPad, didFinishPickingMediaWithInfo doesn't returns the image (UIImagePickerControllerOriginalImage).
        // apparently, this is a bug from Apple, and for the time being, following is a workaround to this problem
        // see: http://stackoverflow.com/questions/3196349/iphone-4-0-simulator-didfinishpickingmediawithinfo-is-missing-uiimagepickercont
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

- (UIPopoverController *)popover
{
    if (!_popover) _popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
    return _popover;
}

- (void)takePhotoOrChooseFromLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:NSLocalizedStringFromTable(@"takePhoto", @"FDTake", @"Option to take photo using camera")];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.buttonTitles addObject:NSLocalizedStringFromTable(@"chooseFromLibrary", @"FDTake", @"Option to select photo from library")];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [self.buttonTitles addObject:NSLocalizedStringFromTable(@"chooseFromPhotoRoll", @"FDTake", @"Option to select photo from photo roll")];
    }
    
    [self _setUpActionSheet];
    
    [self.actionSheet setTag:kPhotosActionSheetTag];
}

- (void)takeVideoOrChooseFromLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:NSLocalizedStringFromTable(@"takeVideo", @"FDTake", @"Option to take photo using video")];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.buttonTitles addObject:NSLocalizedStringFromTable(@"chooseFromLibrary", @"FDTake", @"Option to select photo from library")];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [self.buttonTitles addObject:NSLocalizedStringFromTable(@"chooseFromPhotoRoll", @"FDTake", @"Option to select photo from photo roll")];
    }
    
    [self _setUpActionSheet];
    
    [self.actionSheet setTag:kVideosActionSheetTag];
}

- (void)takePhotoOrVideoOrChooseFromLibrary
{
#warning TODO
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == self.actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(takeController:didCancelAfterAttempting:)])
            [self.delegate takeController:self didCancelAfterAttempting:NO];
    } else {
        self.imagePicker.sourceType = [[self.sources objectAtIndex:buttonIndex] integerValue];
        
        // set the media type: photo or video
        if (actionSheet.tag == kPhotosActionSheetTag) {
            self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        } else if (actionSheet.tag == kVideosActionSheetTag) {
            self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        }
        
        // On iPad use pop-overs.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.popover presentPopoverFromRect:self.popOverPresentRect
                                          inView:[self presentingViewController].view
                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                        animated:YES];
        }
        else {
            // On iPhone use full screen presentation.
            
            [[self presentingViewController] presentViewController:self.imagePicker animated:YES completion:nil];
        }        
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(takeController:didCancelAfterAttempting:)])
        [self.delegate takeController:self didCancelAfterAttempting:NO];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        BOOL errorHappened = NO;
        if (editedImage) {
            imageToSave = editedImage;
        } else if (originalImage) {
            imageToSave = originalImage;
        } else {
            // no image found, an unknown error happened
            errorHappened = YES;
        }
        
        if (errorHappened) {
            if ([self.delegate respondsToSelector:@selector(takeController:didFailAfterAttempting:)]) {
                [self.delegate takeController:self didFailAfterAttempting:YES];
                return;
            }
        } else {
            [self.delegate takeController:self gotPhoto:imageToSave withInfo:info];
        }
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        [self.delegate takeController:self gotVideo:[info objectForKey:UIImagePickerControllerMediaURL] withInfo:info];
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    
    [self _resetUI];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(takeController:didCancelAfterAttempting:)])
        [self.delegate takeController:self didCancelAfterAttempting:YES];
    
    [self _resetUI];
}

#pragma mark - Private methods

- (UIViewController*)presentingViewController
{
    // Use optional view controller for presenting the image picker if set
    UIViewController *presentingViewController = nil;
    if (self.viewControllerForPresenting!=nil) {
        presentingViewController = self.viewControllerForPresenting;
    }
    else {
        // Otherwise do this stuff (like in original source code)
        presentingViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    return presentingViewController;
}

- (void)_resetUI
{
    self.sources = [[NSMutableArray alloc] init];
    self.buttonTitles = [[NSMutableArray alloc] init];
}

- (void)_setUpActionSheet
{
    if ([self.sources count]) {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        for (NSString *title in self.buttonTitles)
            [self.actionSheet addButtonWithTitle:title];
        [self.actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"cancel", @"FDTake", @"Decline to proceed with operation")];
        self.actionSheet.cancelButtonIndex = self.sources.count;
        
        // If on iPad use the present rect and pop over style.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self.actionSheet showFromRect:self.popOverPresentRect inView:[self presentingViewController].view animated:YES];
        }
        else {
            // Otherwise use iPhone style action sheet presentation.
            [self.actionSheet showInView:[self presentingViewController].view];
        }
    } else {
        NSString *str = NSLocalizedStringFromTable(@"noSources", @"FDTake", @"There are no sources available to select a photo");
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:str
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:nil] show];
    }
}


@end
