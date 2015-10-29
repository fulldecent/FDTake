//
//  FDViewController.m
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import "FDViewController.h"
#import "FDAppDelegate.h"

@interface FDViewController () <FDTakeDelegate>

@end

@implementation FDViewController
@synthesize imageView;

- (IBAction)takePhotoOrChooseFromLibrary
{
    [self.takeController takePhotoOrChooseFromLibrary];
}

- (IBAction)takeVideoOrChooseFromLibrary
{
    [self.takeController takeVideoOrChooseFromLibrary];
}

- (IBAction)takePhotoOrVideoOrChooseFromLibrary
{
    [self.takeController takePhotoOrVideoOrChooseFromLibrary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
	// You can optionally override action sheet titles
//	self.takeController.takePhotoText = @"Take Photo";
//	self.takeController.takeVideoText = @"Take Video";
//	self.takeController.chooseFromPhotoRollText = @"Choose Existing";
//	self.takeController.chooseFromLibraryText = @"Choose Existing";
//	self.takeController.cancelText = @"Cancel";
//	self.takeController.noSourcesText = @"No Photos Available";
    
    NSBundle* myBundle = [NSBundle bundleWithIdentifier:@"FDTakeTranslations"];
    NSLog(@"%@", myBundle);
    NSString *str = NSLocalizedStringFromTableInBundle(@"noSources",
                                                       nil,
                                                       [NSBundle bundleWithIdentifier:@"FDTakeTranslations"],
                                                       @"There are no sources available to select a photo");
    NSLog(@"%@", str);
    [(FDAppDelegate*)[[UIApplication sharedApplication] delegate] setFdTake:_takeController];
    
}

- (IBAction)editingSwitchToggled:(id)sender
{
    self.takeController.allowsEditingPhoto = [(UISwitch *)sender isOn];
    self.takeController.allowsEditingVideo = [(UISwitch *)sender isOn];
}


#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
    if (madeAttempt) {
        NSLog(@"The take was cancelled after selecting media");
    } else {
        NSLog(@"The take was cancelled without selecting media");
    }
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info
{
    [self.imageView setImage:photo];
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
