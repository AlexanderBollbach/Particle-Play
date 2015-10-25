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

@interface ControlsViewController () <SequencerViewDelegate, TransportViewDelegate>
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
     self.controlsView.transportView.delegate = self;
     
     self.view = self.controlsView;
     
     // load initial orb as Kick
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:0];
//     [self.controlsView.sequencerView setupSequencerViews];
     [self.controlsView.sequencerView loadOrb:someOrb];
    // [self.view addSubview:self.controlsView];
}


- (void)loadOrbWithTag:(NSInteger)tag {
     [self.controlsView.sequencerView loadOrb:[[OrbManager sharedOrbManager]getOrbWithID:(int)tag]];
}



#pragma mark -- handle controls & sequencer

- (void)toggleExpand:(BOOL)toggle {
     [self.mainViewController toggleControls:toggle];
}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum withObject:[NSNumber numberWithBool:selected]];
}

//-(void)loadOrbWithTag:(NSInteger)tag {
//     NSInteger orbID = tag;
//     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:(int)orbID];
//     [self.controlsView.sequencerView loadOrb:someOrb];
//}

-(void)sliderChangedWithValue:(int)value {
     float interpolated = interpolate(0, 200, 1, -0.5, value, 1);
     
          float forPhaseShift = interpolate(0, 200, 0, 5, value, 1);
     
     self.mainViewController.mainView.phaseShift = forPhaseShift;
     
     [Sequencer sharedSequencer].tempoNew = interpolated;
}

- (void)playedPaused:(BOOL)play_pause {
     if (play_pause) {
          [self.mainViewController.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:10] forKey:@"emitterCells.particle.birthrate"];
          self.mainViewController.mainView.isPlaying = YES;
          
          [[Sequencer sharedSequencer] startSequencer];
     } else {
          [self.mainViewController.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:0] forKey:@"emitterCells.particle.birthrate"];
          self.mainViewController.mainView.isPlaying = NO;
          [[Sequencer sharedSequencer] stopSequencer];
     }
}

@end
