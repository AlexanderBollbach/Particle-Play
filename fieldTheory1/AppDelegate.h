//
//  AppDelegate.h
//  fieldTheory1
//
//  Created by alexanderbollbach on 8/14/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ABUserDefaultsPresetsKey;
extern NSString * const ABUserDefaultsPresetsStockKey;
extern NSString * const ABUserDefaultsPresetsCustomKey;

@class MainViewController;
@class PresetsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)sharedDelegate;
- (void)loadPreset:(NSArray *)preset;
@end

