//
//  ControlsViewController.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/2/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "ControlsViewController.h"
#import "OrbModel.h"
#import "OrbManager.h"
#import "UIColor+ColorAdditions.h"
#import "myFunction.h"
#import "Theme.h"

@interface ControlsViewController () <SequencerViewDelegate, EffectsViewDelegate>
@end

@implementation ControlsViewController

- (void)loadView {
     CGRect bounds = [UIScreen mainScreen].bounds;
     bounds.size.height /= [Theme sharedTheme].relativeDivisorForHeightOfControlsView;
     self.view = [[UIView alloc] initWithFrame:bounds];
}


- (void)viewDidLoad {
     [super viewDidLoad];
     
     self.controlsView = [[ControlsView alloc] initWithFrame:self.view.bounds];
     self.controlsView.sequencerView.delegate = self;
     self.controlsView.effectsView.delegate = self;
     self.view = self.controlsView;
}

- (void)toggle:(BOOL)expanded {
     [self.mainViewController toggleControls:expanded];
}
- (void)setEffectForOrbWithID:(int)orbID effectTag:(int)effectTag selected:(BOOL)selected {

     OrbModel *orbModel = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     switch (effectTag) {
          case 1:
               orbModel.hasRev = selected;
               break;
          case 2:
               orbModel.hasHP = selected;
               break;
          case 3:
               orbModel.hasLP = selected;
               break;
          case 4:
               orbModel.hasDL = selected;
               break;
          default:
               break;
     }
}



#pragma mark -- handle controls & sequencer

//- (void)loadOrbWithTag:(NSInteger)tag {
//     OrbModel *orb = [[OrbManager sharedOrbManager]getOrbWithID:(int)tag];
//     [self.controlsView.sequencerView loadOrb:orb];
//}

- (void)toggleExpand:(BOOL)toggle {
     [self.mainViewController toggleControls:toggle];
}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum-1 withObject:[NSNumber numberWithBool:selected]];
}


@end
