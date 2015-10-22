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
     
     [self _initalizeGlobalPersistantData];

     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.rootViewController = [[MainViewController alloc] init];
     [self.window makeKeyAndVisible];
     
     return YES;
}

- (void)loadPreset:(NSArray *)preset {
     MainViewController *viewController = (MainViewController *)self.window.rootViewController;
     [viewController loadStockPreset:preset];
}

- (void)_initalizeGlobalPersistantData {
     
     if ([[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey]) {
          return;
     }
     
     NSMutableArray *presetsOne = [NSMutableArray new];
     NSMutableArray *presetsTwo = [NSMutableArray new];
     
     //Preset number one
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
     [presetsOne addObject:bass];
     
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
     [presetsOne addObject:snare];
     
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
     [presetsOne addObject:hihat];
     
    
     
     OrbModel* master = [[OrbModel alloc]init];
     master.name = @"Master";
     master.sizeValue = 1;
     master.isMaster = YES;
     master.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), CGRectGetMidY([[UIScreen mainScreen] bounds]));
     master.sequence = [@[@false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @true,@true,@true,@false]mutableCopy];
     [presetsOne addObject:master];
     
     //Preset number two
     bass = [[OrbModel alloc]init];
     bass.name = @"bass";
     bass.idNum = 0;
     bass.sizeValue = 0.5;
     bass.midiNote = 36;
     bass.center = CGPointMake(10.0f, 100.0f);
     bass.sequence = [@[@true,@true,@false,@true,
                         @false,@false,@false,@false,
                         @true,@false,@false,@false,
                         @false,@false,@false,@false]mutableCopy];
     [presetsTwo addObject:bass];
     
     snare = [[OrbModel alloc] init];
     snare.name = @"snare";
     snare.idNum = 1;
     snare.sizeValue = 0.5;
     snare.midiNote = 37;
     snare.center = CGPointMake(150.0f, 150.0f);
     snare.sequence = [@[@true,@false,@false,@false,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     [presetsTwo addObject:snare];
     
     hihat = [[OrbModel alloc] init];
     hihat.name = @"hihat";
     hihat.sizeValue = 0.5;
     hihat.idNum = 2;
     hihat.midiNote = 38;
     hihat.center = CGPointMake(200.0f, 150.0f);
     hihat.sequence = [@[@true,@true,@true,@true,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     [presetsTwo addObject:hihat];
     
     
     master = [[OrbModel alloc] init];
     master.name = @"Master";
     master.sizeValue = 1;
     master.isMaster = YES;
     master.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]), CGRectGetMidY([[UIScreen mainScreen] bounds]));
     master.sequence = [@[@false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @true,@true,@true,@false] mutableCopy];
     [presetsTwo addObject:master];
     
     NSMutableDictionary *stockDict = [NSMutableDictionary dictionary];
     NSMutableDictionary *customDict = [NSMutableDictionary dictionary];
     NSMutableDictionary *masterDict = [NSMutableDictionary dictionary];
     
     [stockDict setObject:presetsOne forKey:@"Preset1"];
     [stockDict setObject:presetsTwo forKey:@"Preset2"];
     
     
     [masterDict setObject:stockDict forKey:ABUserDefaultsPresetsStockKey];
     [masterDict setObject:customDict forKey:ABUserDefaultsPresetsCustomKey];
     
     [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:masterDict]
                                               forKey:ABUserDefaultsPresetsKey];
}
+ (AppDelegate *)sharedDelegate {
     return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end




