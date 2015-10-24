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


@protocol seqDelegate <NSObject>
- (void)animatePlayheadWithIndex:(NSInteger)index;
@end

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,strong) OrbManager* orbModelMaster;
@property (nonatomic,weak) id <seqDelegate> seqDelegate;
@property (nonatomic,strong) MainView *mainView;

-(void)loadStockPreset:(NSArray*)preset;
-(void)toggleControls:(BOOL)toggle;

@end

