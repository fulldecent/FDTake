//
//  FDTakeExampleTests.m
//  FDTakeExampleTests
//
//  Created by William Entriken on 5/3/14.
//  Copyright (c) 2014 William Entriken. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FDTakeController.h"

@interface FDTakeExampleTests : XCTestCase
@property (nonatomic) FDTakeController *controller;
@end

@implementation FDTakeExampleTests

- (void)setUp
{
    [super setUp];
    self.controller = [[FDTakeController alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    self.controller = nil;
}

- (void)testInheritsFromNSObject
{
    XCTAssert([self.controller isKindOfClass:[NSObject class]], @"Must inherit from NSObject");
}

- (void)testDelegateSetGet
{
    id <FDTakeDelegate> class = nil;
    self.controller.delegate = class;
    XCTAssertEqual(self.controller.delegate, class, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testViewControllerForPresentingImagePickerControllerSetGet
{
    UIViewController *controller = [[UIViewController alloc] init];
    self.controller.viewControllerForPresentingImagePickerController = controller;
    XCTAssertEqual(self.controller.viewControllerForPresentingImagePickerController, controller, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testPopOverPresentRectSetGet
{
    CGRect rect = CGRectMake(0,0,5,5);
    self.controller.popOverPresentRect = rect;
    XCTAssert(CGRectEqualToRect(self.controller.popOverPresentRect, rect), @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testTabBarSetGet
{
    UITabBar *tabBar = [[UITabBar alloc] init];
    self.controller.tabBar = tabBar;
    XCTAssertEqual(self.controller.tabBar, tabBar, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testAllowsEditingPhotoSetGet
{
    BOOL b = true;
    self.controller.allowsEditingPhoto = b;
    XCTAssertEqual(self.controller.allowsEditingPhoto, b, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testAllowsEditingVideoSetGet
{
    BOOL b = true;
    self.controller.allowsEditingVideo = b;
    XCTAssertEqual(self.controller.allowsEditingVideo, b, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testDefaultToFrontCameraSetGet
{
    BOOL b = true;
    self.controller.defaultToFrontCamera = b;
    XCTAssertEqual(self.controller.defaultToFrontCamera, b, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testTakePhotoTextSetGet
{
    NSString *text = @"a";
    self.controller.takePhotoText = text;
    XCTAssertEqualObjects(self.controller.takePhotoText, text, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testTakeVideoTextSetGet
{
    NSString *text = @"a";
    self.controller.takeVideoText = text;
    XCTAssertEqualObjects(self.controller.takeVideoText, text, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testChooseFromLibraryTextSetGet
{
    NSString *text = @"a";
    self.controller.chooseFromLibraryText = text;
    XCTAssertEqualObjects(self.controller.chooseFromLibraryText, text, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testChooseFromPhotoRollTextSetGet
{
    NSString *text = @"a";
    self.controller.chooseFromPhotoRollText = text;
    XCTAssertEqualObjects(self.controller.chooseFromPhotoRollText, text, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testCancelTextSetGet
{
    NSString *text = @"a";
    self.controller.cancelText = text;
    XCTAssertEqualObjects(self.controller.cancelText, text, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

- (void)testNoSourcesSetGet
{
    NSString *text = @"a";
    self.controller.noSourcesText = text;
    XCTAssertEqualObjects(self.controller.noSourcesText, text, @"Must have same value as set for %s", __PRETTY_FUNCTION__);
}

@end