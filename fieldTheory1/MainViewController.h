//
//  MainViewController.h
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OrbManager.h"
#import "MainView.h"
#import "TopTransportView.h"

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,strong) OrbManager* orbModelMaster;
@property (nonatomic,strong) MainView *mainView;
@property (nonatomic,strong) UILabel *tempoLabel;
@property (nonatomic,strong) OrbView *selectedOrb;

-(void)loadStockPreset:(NSArray*)preset;
-(void)toggleControls:(BOOL)toggle;

@end

