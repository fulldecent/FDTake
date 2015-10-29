//
//  FDAppDelegate.h
//  FDTakeExample
//
//  Created by Will Entriken on 8/9/12.
//  Copyright (c) 2012 William Entriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"

@interface FDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FDTakeController *fdTake;

@end
