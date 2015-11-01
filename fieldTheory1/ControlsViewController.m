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
     [self.controlsView.sequencerView loadOrb:someOrb];
     
      [self.mainViewController.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:0] forKeyPath:@"emitterCells.test.birthRate"];
//     [self.mainViewController.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:100] forKeyPath:@"emitterCells.test.velocity"];
}






#pragma mark -- handle controls & sequencer

- (void)loadOrbWithTag:(NSInteger)tag {
     OrbModel *orb = [[OrbManager sharedOrbManager]getOrbWithID:(int)tag];
     [self.controlsView.sequencerView loadOrb:orb];
}

- (void)toggleExpand:(BOOL)toggle {
     [self.mainViewController toggleControls:toggle];
}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum-1 withObject:[NSNumber numberWithBool:selected]];
}

-(void)sliderChangedWithValue:(int)value {
     float forPhaseShift = interpolate(0, 800, 0, 5, value, 1);
     self.mainViewController.mainView.phaseShift = forPhaseShift;
     float interpolated = interpolate(0, 100, 9, 2, value, 1);
     [[Sequencer sharedSequencer] setTempoWithInterval:interpolated];
     uint64_t interval = [[Sequencer sharedSequencer].superTimer getIntervalSamples];
     self.mainViewController.tempoLabel.text = [NSString stringWithFormat:@"tempo: %i", (int)interval];


}

- (void)playedPaused:(BOOL)play_pause {
     self.mainViewController.mainView.isPlaying = play_pause;
     [Sequencer sharedSequencer].playing = play_pause;
     [self.mainViewController.mainView setNeedsDisplay];

    NSString *someValue = [self.mainViewController.mainView.spaceView.emitterLayer valueForKeyPath:@"emitterCells.test.birthRate"];
     if (!play_pause) {
                  [self.mainViewController.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:0] forKeyPath:@"emitterCells.test.birthRate"];
     } else {
                  [self.mainViewController.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:200] forKeyPath:@"emitterCells.test.birthRate"];
     }

}

@end
