//
//  AppDelegate.m
//  fieldTheory1
//
//  Created by alexanderbollbach on 8/14/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "OrbManager.h"
#import "OrbModel.h"
#import "Sequencer.h"

NSString * const ABUserDefaultsPresetsKey = @"ABUserDefaultsPresetsKey";
NSString * const ABUserDefaultsPresetsStockKey = @"ABUserDefaultsPresetsStockKey";
NSString * const ABUserDefaultsPresetsCustomKey = @"ABUserDefaultsPresetsCustomKey";

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

     
  //   sleep(55);
     application.statusBarHidden = true;

     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.rootViewController = [[MainViewController alloc] init];
     [self.window makeKeyAndVisible];
     
     return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
     [[Sequencer sharedSequencer] pauseSequencer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [[Sequencer sharedSequencer] startSequencer];
}

+ (AppDelegate *)sharedDelegate {
     return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end




