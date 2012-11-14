//
//  FDTakeController.h
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FDTakeController;

@protocol FDTakeDelegate <NSObject>

@optional
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt;
- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info;
- (void)takeController:(FDTakeController *)controller gotVideo:(NSURL *)video withInfo:(NSDictionary *)info;

@end

@interface FDTakeController : NSObject <UIImagePickerControllerDelegate>

- (void)takePhotoOrChooseFromLibrary;
- (void)takeVideoOrChooseFromLibrary;
- (void)takePhotoOrVideoOrChooseFromLibrary;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic, unsafe_unretained) id <FDTakeDelegate> delegate;

// Optional view controller used for presenting the image picker controller
@property (unsafe_unretained, nonatomic) UIViewController *viewControllerForPresenting;
// Rect used in presentPopoverFromRect on iPads
@property (nonatomic, readwrite) CGRect popOverPresentRect;

@end
