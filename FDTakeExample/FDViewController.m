//
//  FDViewController.m
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import "FDViewController.h"

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
    
    
    NSBundle* myBundle = [NSBundle bundleWithIdentifier:@"FDTakeTranslations"];
    NSLog(@"%@", myBundle);
    NSString *str = NSLocalizedStringFromTableInBundle(@"noSources",
                                                       nil,
                                                       [NSBundle bundleWithIdentifier:@"FDTakeTranslations"],
                                                       @"There are no sources available to select a photo");
    NSLog(@"%@", str);
    
}

- (IBAction)editingSwitchToggled:(id)sender
{
    self.takeController.allowsEditingPhoto = [(UISwitch *)sender isOn];
    self.takeController.allowsEditingVideo = [(UISwitch *)sender isOn];
}


#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
    UIAlertView *alertView;
    if (madeAttempt)
        alertView = [[UIAlertView alloc] initWithTitle:@"Example app" message:@"The take was cancelled after selecting media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else
        alertView = [[UIAlertView alloc] initWithTitle:@"Example app" message:@"The take was cancelled without selecting media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
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
