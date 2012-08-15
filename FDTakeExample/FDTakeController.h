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

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info;
- (void)takeController:(FDTakeController *)controller gotVideo:(NSURL *)video withInfo:(NSDictionary *)info;
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt;

@end

@interface FDTakeController : NSObject

- (void)takePhotoOrChooseFromLibrary;
- (void)takeVideoOrChooseFromLibrary;
- (void)takePhotoOrVideoOrChooseFromLibrary;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) id <FDTakeDelegate> delegate;

@end
