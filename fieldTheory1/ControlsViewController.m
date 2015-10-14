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

@interface ControlsViewController () <SequencerViewDelegate, UIScrollViewDelegate, ControlsViewDelegate>
@property (nonatomic,strong) SequencerView *sequencerView;
@property (nonatomic,strong) ControlsView *controlsView;
@end

@implementation ControlsViewController

-(void)viewDidLoad {
     [super viewDidLoad];
     self.view.backgroundColor = [UIColor flatSTLightBlueColor];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     CGFloat OriginY = 0;
     CGFloat controlsViewHeight = CGRectGetHeight(self.view.bounds)/4;
     CGFloat scrollViewOriginY = controlsViewHeight;
     CGFloat scrollViewHeight = CGRectGetHeight(self.view.bounds)/6;
     CGFloat sequencerViewOriginY = controlsViewHeight + scrollViewHeight;
     CGFloat sequencerViewHeight = CGRectGetHeight(self.view.bounds) - controlsViewHeight - scrollViewHeight;
     
     self.controlsView = [[ControlsView alloc] initWithFrame:CGRectMake(0,
                                                                        OriginY,
                                                                        CGRectGetWidth(self.view.bounds),
                                                                        controlsViewHeight)];
     self.controlsView.delegate = self;
     [self.view addSubview:self.controlsView];
     
     
     self.sequencerView = [[SequencerView alloc] initWithFrame:CGRectMake(0,
                                                                          sequencerViewOriginY,
                                                                          CGRectGetWidth(self.view.bounds),
                                                                          sequencerViewHeight)];
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                               scrollViewOriginY,
                                                                               CGRectGetWidth(self.view.bounds),
                                                                               scrollViewHeight)];
     for (int x = 0; x < 3; x++) {
          UIView *someView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(scrollView.frame)*x,
                                                                      0,
                                                                      CGRectGetWidth(scrollView.bounds),
                                                                      CGRectGetHeight(scrollView.bounds))];
          UIImageView *someImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
          someImageView.center = CGPointMake(CGRectGetMidX(someView.bounds), CGRectGetMidY(someView.bounds));
          someImageView.image = [self imageForIndex:x];
          someImageView.backgroundColor = [UIColor clearColor];
          [someView addSubview:someImageView];
          [scrollView addSubview:someView];
     }
     
     scrollView.showsHorizontalScrollIndicator = NO;
     scrollView.pagingEnabled = YES;
     scrollView.delegate = self;
     scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame)*3,
                                         CGRectGetHeight(scrollView.frame));
     [self.view addSubview:scrollView];
     [self.view addSubview:self.sequencerView];
     
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:0];
     self.sequencerView.delegate = self;
     [self.sequencerView initSequencerBG];
     [self.sequencerView loadOrb:someOrb];

}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum withObject:[NSNumber numberWithBool:selected]];
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


-(void)sliderChangedWithValue:(int)value {
[Sequencer sharedSequencer].tempoNew = interpolate(0, 100, 2, 0, value, 1);
     NSLog(@"%f", interpolate(0, 100, 2, 0, value, 1));

}


-(void)resetButton:(PlayPauseButton*)sender {
     sender.selected = !sender.selected;
     // TODO: time jump
}

-(void)playPauseButton:(PlayPauseButton*)sender {
     sender.selected = !sender.selected;
     if (sender.selected) {
         // [self.timer invalidate];
         // [self.topPanelView.playPauseButton animateTriToSquare];
     } else {
        //  [self.topPanelView.playPauseButton animateSquareToTri];
          //[self _startTimer];
     }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     
     CGFloat pageWidth = scrollView.frame.size.width;
     int fractionalPage = scrollView.contentOffset.x / pageWidth;
     OrbModel *thisOrb;
     switch (fractionalPage) {
          case 0:
             thisOrb = [[OrbManager sharedOrbManager] getOrbWithID:0];
               break;
          case 1:
               thisOrb = [[OrbManager sharedOrbManager] getOrbWithID:1];
               break;
          case 2:
               thisOrb = [[OrbManager sharedOrbManager] getOrbWithID:2];
               break;
          case 3:
               thisOrb = [[OrbManager sharedOrbManager] getOrbWithID:3];
               break;
          default:
               break;
     }
     [self.sequencerView loadOrb:thisOrb];
}

- (UIImage*)imageForIndex:(int)index {
     NSArray *image = @[[UIImage imageNamed:@"bass"],
                        [UIImage imageNamed:@"snare"],
                        [UIImage imageNamed:@"hihat"]];
     return image[index];
}


@end
