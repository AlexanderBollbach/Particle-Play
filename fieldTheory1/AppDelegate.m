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

NSString * const ABUserDefaultsPresetsKey = @"ABUserDefaultsPresetsKey";
NSString * const ABUserDefaultsPresetsStockKey = @"ABUserDefaultsPresetsStockKey";
NSString * const ABUserDefaultsPresetsCustomKey = @"ABUserDefaultsPresetsCustomKey";

@interface AppDelegate ()
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
     application.statusBarHidden = true;
     
//     [self _initalizeGlobalPersistantData];

     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.rootViewController = [[MainViewController alloc] init];
     [self.window makeKeyAndVisible];
     
     return YES;
}

//- (void)loadPreset:(NSArray *)preset {
//     MainViewController *viewController = (MainViewController *)self.window.rootViewController;
//     [viewController loadStockPreset:preset];
//}

- (void)_initalizeGlobalPersistantData {
     
     if ([[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey]) {
          return;
     }
     NSMutableArray *presetOne = [NSMutableArray new];
     
     OrbModel *bass = [[OrbModel alloc] init];
     bass.name = @"bass";
     bass.idNum = 0;
     bass.sizeValue = 0.5;
     bass.midiNote = 36;
     bass.center = CGPointMake(10.0f, 50.0f);
     bass.sequence = [@[@true,@false,@false,@false,
                         @false,@false,@false,@false,
                         @true,@false,@false,@false,
                         @false,@false,@false,@false] mutableCopy];
     [presetOne addObject:bass];
     
     OrbModel *snare = [[OrbModel alloc] init];
     snare.name = @"snare";
     snare.idNum = 1;
     snare.sizeValue = 0.5;
     snare.midiNote = 37;
     snare.center = CGPointMake(150.0f, 75.0f);
     snare.sequence = [@[@true,@false,@false,@false,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false]mutableCopy];
     [presetOne addObject:snare];
     
     OrbModel *hihat = [[OrbModel alloc] init];
     hihat.name = @"hihat";
     hihat.sizeValue = 0.5;
     hihat.idNum = 2;
     hihat.midiNote = 38;
     hihat.center = CGPointMake(200.0f, 100.0f);
     hihat.sequence = [@[@true,@true,@true,@true,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     [presetOne addObject:hihat];
 
     OrbModel* reverb = [[OrbModel alloc]init];
     reverb.name = @"reverb";
     reverb.sizeValue = 1;
     reverb.isEffect = YES;
     reverb.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]),
                                 CGRectGetMidY([[UIScreen mainScreen] bounds]));
     reverb.sequence = [@[@false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @true,@true,@true,@false]mutableCopy];
     [presetOne addObject:reverb];
     
     OrbModel* hp = [[OrbModel alloc]init];
     hp.name = @"hp";
     hp.sizeValue = 1;
     hp.isEffect = YES;
     hp.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]),
                                CGRectGetMidY([[UIScreen mainScreen] bounds]));
     hp.sequence = [@[@false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @true,@true,@true,@false]mutableCopy];
     [presetOne addObject:hp];
   
     NSMutableDictionary *stockDict = [NSMutableDictionary dictionary];
     NSMutableDictionary *customDict = [NSMutableDictionary dictionary];
     NSMutableDictionary *masterDict = [NSMutableDictionary dictionary];
     
     [stockDict setObject:presetOne forKey:@"Preset1"];
     [masterDict setObject:stockDict forKey:ABUserDefaultsPresetsStockKey];
     [masterDict setObject:customDict forKey:ABUserDefaultsPresetsCustomKey];
     
     [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:masterDict]
                                               forKey:ABUserDefaultsPresetsKey];
}
+ (AppDelegate *)sharedDelegate {
     return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end




