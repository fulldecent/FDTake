//
//  FDViewController.h
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"

@interface FDViewController : UIViewController

@property FDTakeController *takeController;
- (IBAction)takePhotoOrChooseFromLibrary;
- (IBAction)takeVideoOrChooseFromLibrary;
- (IBAction)takePhotoOrVideoOrChooseFromLibrary;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)editingSwitchToggled:(id)sender;

@end
