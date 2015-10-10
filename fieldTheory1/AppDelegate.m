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

+ (AppDelegate *)sharedDelegate {
     return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

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
     OrbModel *kick = [[OrbModel alloc] init];
     kick.name = @"Kick";
     kick.idNum = 0;
     kick.sizeValue = 0.5;
     kick.midiNote = 36;
     kick.center = CGPointMake(10.0f, 50.0f);
     kick.sequence = [@[@true,@false,@false,@false,
                         @false,@false,@false,@false,
                         @true,@false,@false,@false,
                         @false,@false,@false,@false] mutableCopy];
     [presetsOne addObject:kick];
     
     OrbModel* snare = [[OrbModel alloc] init];
     snare.name = @"Snare";
     snare.idNum = 1;
     snare.sizeValue = 0.5;
     snare.midiNote = 37;
     snare.center = CGPointMake(150.0f, 75.0f);
     snare.sequence = [@[@true,@false,@false,@false,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false]mutableCopy];
     [presetsOne addObject:snare];
     
     OrbModel* hihat = [[OrbModel alloc] init];
     hihat.name = @"Hi-Hat";
     hihat.sizeValue = 0.5;
     hihat.idNum = 2;
     hihat.midiNote = 38;
     hihat.center = CGPointMake(200.0f, 100.0f);
     hihat.sequence = [@[@true,@true,@true,@true,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     [presetsOne addObject:hihat];
     
     OrbModel* openHihat = [[OrbModel alloc] init];
     openHihat.name = @"openHihat";
     openHihat.idNum = 3;
     openHihat.sizeValue = 0.5;
     openHihat.midiNote = 39;
     openHihat.center = CGPointMake(200.0f, 120.0f);
     openHihat.sequence = [@[@true,@true,@true,@true,
                              @false,@false,@false,@false,
                              @true,@false,@false,@false,
                              @false,@false,@false,@false] mutableCopy];
     [presetsOne addObject:openHihat];
     
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
     kick = [[OrbModel alloc]init];
     kick.name = @"Kick";
     kick.idNum = 0;
     kick.sizeValue = 0.5;
     kick.midiNote = 36;
     kick.center = CGPointMake(10.0f, 100.0f);
     kick.sequence = [@[@true,@true,@false,@true,
                         @false,@false,@false,@false,
                         @true,@false,@false,@false,
                         @false,@false,@false,@false]mutableCopy];
     [presetsTwo addObject:kick];
     
     snare = [[OrbModel alloc] init];
     snare.name = @"Snare";
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
     hihat.name = @"Hi-Hat";
     hihat.sizeValue = 0.5;
     hihat.idNum = 2;
     hihat.midiNote = 38;
     hihat.center = CGPointMake(200.0f, 150.0f);
     hihat.sequence = [@[@true,@true,@true,@true,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     [presetsTwo addObject:hihat];
     
     openHihat = [[OrbModel alloc] init];
     openHihat.name = @"Open Hihat";
     openHihat.idNum = 3;
     openHihat.sizeValue = 0.5;
     openHihat.midiNote = 39;
     openHihat.center = CGPointMake(200.0f, 200.0f);
     openHihat.sequence = [@[@true,@true,@false,@true,
                              @false,@false,@false,@false,
                              @true,@false,@false,@false,
                              @true,@false,@true,@false] mutableCopy];
     [presetsTwo addObject:openHihat];
     
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

@end




