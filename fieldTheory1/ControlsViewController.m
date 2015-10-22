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

@interface ControlsViewController () <SequencerViewDelegate, CockPitViewDelegate>
@end

@implementation ControlsViewController

-(void)loadView {
     CGRect bounds = [UIScreen mainScreen].bounds;
     bounds.size.height /= 1.25;
     self.view = [[UIView alloc] initWithFrame:bounds];
}

-(void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [Theme sharedTheme].controlsViewBackground;
     self.controlsView = [[ControlsView alloc] initWithFrame:self.view.bounds];
     [self.view addSubview:self.controlsView];
}





- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];

     self.controlsView.sequencerView.delegate = self;
     self.controlsView.cockPitView.delegate = self;

     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:0];
     [self.controlsView.sequencerView setupSequencerViews];
     [self.controlsView.sequencerView loadOrb:someOrb];

}


#pragma mark -- handle controls & sequencer

- (void)toggleExpand:(BOOL)toggle {
     [self.mainViewController toggleControls:toggle];
}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum withObject:[NSNumber numberWithBool:selected]];
}

-(void)loadOrbWithTag:(NSInteger)tag {
     NSInteger orbID = tag;
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:(int)orbID];
     [self.controlsView.sequencerView loadOrb:someOrb];
}

// hot cues TODO

//
//-(void)didClickWithTag:(int)tag {
//     switch (tag) {
//          case 0:
//               [Sequencer sharedSequencer].sequencerCounter = 0;
//               break;
//          case 1:
//               [Sequencer sharedSequencer].sequencerCounter = 4;
//               break;
//          case 2:
//               [Sequencer sharedSequencer].sequencerCounter = 8;
//               break;
//          case 3:
//               [Sequencer sharedSequencer].sequencerCounter = 12;
//               break;
//          default:
//               break;
//     }
//}


-(void)sliderChangedWithValue:(int)value {
     float interpolated = interpolate(0, 200, 1, -0.5, value, 1);
     [Sequencer sharedSequencer].tempoNew = interpolated;
}

- (void)playedPaused:(BOOL)play_pause {
     if (play_pause) {
          [[Sequencer sharedSequencer] stopSequencer];
     } else {
          [[Sequencer sharedSequencer] startSequencer];
     }
}

@end
