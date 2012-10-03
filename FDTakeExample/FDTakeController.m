//
//  FDTakeController.m
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import "FDTakeController.h"

@interface FDTakeController() <UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSMutableArray *sources;
@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation FDTakeController
@synthesize sources = _sources;
@synthesize buttonTitles = _buttonTitles;
@synthesize actionSheet = _actionSheet;
@synthesize imagePicker = _imagePicker;

- (FDTakeController *)init
{
    if (self = [super init]) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
    }
    return self;
}

- (void)takePhotoOrChooseFromLibrary
{
    self.sources = [[NSMutableArray alloc] init];
    self.buttonTitles = [[NSMutableArray alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeCamera]];
        [self.buttonTitles addObject:@"Take Photo"];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypePhotoLibrary]];
        [self.buttonTitles addObject:@"Choose from Library"];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [self.sources addObject:[NSNumber numberWithInteger:UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
        [self.buttonTitles addObject:@"Choose from Photo Roll"];
    }
    
    if ([self.sources count]) {
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        for (NSString *title in self.buttonTitles)
            [self.actionSheet addButtonWithTitle:title];
        [self.actionSheet addButtonWithTitle:@"Cancel"];
        self.actionSheet.cancelButtonIndex = self.sources.count;
        [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"There are no sources available to select a photo"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
        [alertView show];
    }        
}

- (void)takeVideoOrChooseFromLibrary
{
#warning INCOMPLETE
}

- (void)takePhotoOrVideoOrChooseFromLibrary
{
#warning INCOMPLETE
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == self.actionSheet.cancelButtonIndex)
        [self.delegate takeController:self didCancelAfterAttempting:NO];
    else {
        self.imagePicker.sourceType = [[self.sources objectAtIndex:buttonIndex] integerValue];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.delegate takeController:self didCancelAfterAttempting:NO];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.delegate takeController:self gotPhoto:[info objectForKey:@"UIImagePickerControllerOriginalImage"] withInfo:info];
    [picker dismissModalViewControllerAnimated:YES];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    [self.delegate takeController:self didCancelAfterAttempting:YES];
}

@end
