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
#import "SequencerView.h"
#import "myFunction.h"
#import "ControlsView.h"

@interface ControlsViewController () <SequencerViewDelegate, ControlsViewDelegate, HotCuesViewDelegate>
@property (nonatomic,strong) SequencerView *sequencerView;
@end

@implementation ControlsViewController

-(void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [UIColor flatSTLightBlueColor];
}

-(void)toggleExpand:(BOOL)toggle {
     [self.mainViewController toggleControls:toggle];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     CGRect row1 = self.view.bounds;
     row1.size.height /= 2;
     
     CGRect row2 = row1;
     row2.origin.y = row2.size.height;

     self.controlsView = [[ControlsView alloc] initWithFrame:row1];
     self.controlsView.delegate = self;
     

     
     self.sequencerView = [[SequencerView alloc] initWithFrame:row2];
     self.sequencerView.delegate = self;

     [self.view addSubview:self.controlsView];
     [self.view addSubview:self.sequencerView];

     self.controlsView.hotCuesView.delegate = self;

     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:0];
     [self.sequencerView setupSequencerViews];
     [self.sequencerView loadOrb:someOrb];
}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum withObject:[NSNumber numberWithBool:selected]];
}

-(void)loadOrbWithTag:(NSInteger)tag {
     NSInteger orbID = tag;
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:(int)orbID];
     [self.sequencerView loadOrb:someOrb];
}

-(void)didClickWithTag:(int)tag {
     switch (tag) {
          case 0:
               [Sequencer sharedSequencer].sequencerCounter = 0;
               break;
          case 1:
               [Sequencer sharedSequencer].sequencerCounter = 4;
               break;
          case 2:
               [Sequencer sharedSequencer].sequencerCounter = 8;
               break;
          case 3:
               [Sequencer sharedSequencer].sequencerCounter = 12;
               break;
          default:
               break;
     }
}

-(void)doSomethingWithTag:(NSInteger)tag {
     [Sequencer sharedSequencer].sequencerCounter = tag;
}

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
