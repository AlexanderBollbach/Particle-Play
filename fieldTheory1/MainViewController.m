     //
//  MainViewController.m
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "MainViewController.h"
#import "OrbView.h"
#import "AppDelegate.h"
#import "OrbModel.h"
#import "myFunction.h"
#import "ControlsViewController.h"
#import "PresetsViewController.h"
#import "UIColor+ColorAdditions.h"
#import "Sampler.h"
#import "Sequencer.h"
#import "ControlsViewController.h"
#import "Theme.h"
#import "OrbTrackView.h"

#define MAINVIEWTRANSFORM 0.58
#define EFFECTDIST 300

@interface MainViewController()<SequencerDelegate,OrbViewDelegate,UICollisionBehaviorDelegate,TopTransportViewDelegate>

@property (nonatomic, strong) ControlsViewController *controlsViewController;
@property (nonatomic, strong) PresetsViewController *presetsViewController;
@property (nonatomic,strong)  NSMutableArray *currentPreset;
@property (strong) SuperTimer *superTimer;
@property (nonatomic,assign) BOOL wasBeat;
@property (nonatomic,strong) UILabel *cryptoLabel;
@property (nonatomic,strong) UILabel *beatLabel;
@property (nonatomic,strong) UIDynamicAnimator *ani;
@property (nonatomic,strong) TopTransportView *topTransportView;
@property (nonatomic,assign) CGFloat heightOfTransportView;
@property (nonatomic,assign) CGFloat sizeOfControlsBar;
@property (nonatomic,assign) CGRect mainViewBoundsExpanded;


@end

@implementation MainViewController {
     CGFloat controlsClosedPos;
     CGFloat controlsOpenPos;
     CGFloat maxOrbDist;
     CGFloat minOrbDist;
}




-(instancetype)init {
     if (self = [super init]) {

          // start Seq
          
          //update mainView DrawRect
          CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
          [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
          
          // sequencer control
          [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(didTick:)
                                                       name:@"didTick"
                                                     object:nil];
          // KVO
//          [[Theme sharedTheme] addObserver:self forKeyPath:@"mainViewBackgroundColor"
//                                   options:NSKeyValueObservingOptionNew
//                                   context:nil];
//          [[Theme sharedTheme] addObserver:self
//                                forKeyPath:@"borderWidth"
//                                   options:NSKeyValueObservingOptionNew
//                                   context:nil];
//          [[Theme sharedTheme] addObserver:self
//                                forKeyPath:@"bordersColor"
//                                   options:NSKeyValueObservingOptionNew
//                                   context:nil];
//          [[Theme sharedTheme] addObserver:self
//                                forKeyPath:@"controlsViewBackgroundColor"
//                                   options:NSKeyValueObservingOptionNew
//                                   context:nil];
     }
     return self;
}

- (void)viewDidLoad {
     [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     CGFloat topTransportHeight =  [[UIScreen mainScreen] bounds].size.height/8;
     CGFloat mainWidth = CGRectGetWidth(self.view.bounds);
     CGFloat mainHeight = CGRectGetHeight(self.view.bounds);
     
     CGFloat ttViewXPos = CGRectGetWidth(self.view.bounds)/8;
     CGFloat ttHeightConstraint = CGRectGetHeight(self.view.bounds)/18;
     
     self.topTransportView = [[TopTransportView alloc] initWithFrame:CGRectMake(ttViewXPos,
                                                                                0,
                                                                                mainWidth - ttViewXPos,
                                                                                topTransportHeight - ttHeightConstraint)];// changed......
     self.topTransportView.delegate = self;
     [self.view addSubview:self.topTransportView];
     
     // MainView
     self.mainViewBoundsExpanded = CGRectMake(0,
                                              topTransportHeight,
                                              mainWidth,
                                              mainHeight - topTransportHeight*2 -25);
     self.mainView = [[MainView alloc] initWithFrame:self.mainViewBoundsExpanded];
     self.mainView.autoresizesSubviews = YES;
     [self.view addSubview:self.mainView];
     self.mainView.backgroundColor = [Theme sharedTheme].mainViewBackgroundColor;
     
     // orbs
     [self loadStockPreset:[self createPreset]];
     
     // controls view setup
     self.controlsViewController = [[ControlsViewController alloc] init];
     self.controlsViewController.mainViewController = self;
     [self.view addSubview:self.controlsViewController.view];
     
     // toggle controls layout
     self.heightOfTransportView = self.controlsViewController.controlsView.effectsView.bounds.size.height;
     controlsClosedPos = CGRectGetHeight(self.view.bounds) - self.heightOfTransportView;
     controlsOpenPos = CGRectGetHeight(self.view.bounds) - self.controlsViewController.view.frame.size.height;
     CGRect setControlsVCFrame = self.controlsViewController.view.frame;
     setControlsVCFrame.origin.y = controlsClosedPos;
     self.controlsViewController.view.frame = setControlsVCFrame;
     
     self.sizeOfControlsBar = CGRectGetHeight(self.mainView.bounds) - controlsClosedPos;
     
     [self orbTappedWithID:0];
}
#pragma mark seq stuff

- (void)didTick:(NSNotification*)notification {
     int count = [notification.userInfo[@"count"] intValue];
     [self didTickWithCount:count];
     [self didTickOnMainThread:count];
}

- (void)didTickWithCount:(int)count {
     
     for (OrbView* orb in self.mainView.orbs) {
               if ([[orb.orbModelRef.sequence objectAtIndex:count] boolValue]) {
         
                    
                    UIView *mainWid = [UIApplication sharedApplication].keyWindow;
                    CGPoint orb1Con = [orb.superview
                                       convertPoint:orb.center
                                       toCoordinateSpace:mainWid];
                    CGPoint orb2Con = [self.mainView.effectsOrb.superview
                                       convertPoint:self.mainView.effectsOrb.center
                                       toCoordinateSpace:mainWid];

                    CGFloat dist = [self distanceFromPoint:orb1Con toOrb:orb2Con];
                  
                    orb.effectAmount = interpolate(minOrbDist,maxOrbDist, 1, 0, dist, 1);
                    
                    
                    NSLog(@"max %f min %f effectAmount %f distToeffect %f", maxOrbDist, minOrbDist, orb.effectAmount,dist);

                    
                    [orb.sampler setLowPassCutoff:orb.orbModelRef.hasLP ? orb.effectAmount : 0];
                    [orb.sampler setHighPassCutoff:orb.orbModelRef.hasHP ? orb.effectAmount : 0];
                    [orb.sampler setReverbCutoff:orb.orbModelRef.hasRev ? orb.effectAmount : 0];
                    [orb.sampler setDelayAmount:orb.orbModelRef.hasDL ? orb.effectAmount : 0];

                    [orb.sampler sendNoteOnEvent:orb.orbModelRef.midiNote velocity:127];
               }
          }
}





- (CGFloat)distanceFromPoint:(CGPoint)point1 toOrb:(CGPoint)point2 {

     double side1 = point2.x - point1.x;
     double side2 = point2.y - point1.y;
     
     return hypot(side1, side2);
}

- (void)didTickOnMainThread:(int)count {
     
     dispatch_async(dispatch_get_main_queue(), ^{
               
               // switch case is better option if there is too many else if
               static int theBeat = 1;
               if (count == 0) {
                    theBeat = 1;
               } else if (count == 4) {
                    theBeat = 2;
               } else if (count == 8) {
                    theBeat = 3;
               } else if (count == 12) {
                    theBeat = 4;
               }
               self.beatLabel.text = [NSString stringWithFormat:@"beat: %i", theBeat];
               for (OrbView* orb in self.mainView.orbs) {
                    if ([[orb.orbModelRef.sequence objectAtIndex:count] boolValue]) {
                         [orb performAnimation];

                    [UIView animateWithDuration:0.08 animations:^{
                         self.mainView.spaceView.alpha = 0.4;
                    } completion:^(BOOL finished) {
                         self.mainView.spaceView.alpha = 0.1;
                    }];
                    }
               }
               //cryptoMode
               if ([Theme sharedTheme].cryptoMode) {
                    if (self.wasBeat) {
                         [UIView animateWithDuration:0.005 delay:0 options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                               self.mainView.alpha = 0.25;
                                          }
                                          completion:^(BOOL finished) {
                                               self.mainView.alpha = 1;
                                          }
                          ];
                    }
               }
          });
}




// called from CADisplayLink
- (void)tick {
     [self.mainView setNeedsDisplay];
}



#pragma mark transport 


-(void)sliderChangedWithValue:(int)value {
     float forPhaseShift = interpolate(0, 800, 0, 5, value, 1);
     self.mainView.phaseShift = forPhaseShift;
     float interpolated = interpolate(0, 100, 9, 2, value, 1);
     [[Sequencer sharedSequencer] setTempoWithInterval:interpolated];
     uint64_t interval = [[Sequencer sharedSequencer].superTimer getIntervalSamples];
     self.tempoLabel.text = [NSString stringWithFormat:@"tempo: %i", (int)interval];
}

- (void)playedPaused:(BOOL)play_pause {
     self.mainView.isPlaying = play_pause;
     [Sequencer sharedSequencer].playing = play_pause;
     [self.mainView setNeedsDisplay];

     if (!play_pause) {
          [self.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:10] forKeyPath:@"emitterCells.test.birthRate"];
          [self.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:50] forKeyPath:@"emitterCells.test.velocity"];
          self.mainView.spaceView.alpha = 0.4;
     } else {
          [self.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:200] forKeyPath:@"emitterCells.test.birthRate"];
          [self.mainView.spaceView.emitterLayer setValue:[NSNumber numberWithFloat:500] forKeyPath:@"emitterCells.test.velocity"];
          self.mainView.spaceView.alpha = 0.2;
     }
     
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//     NSLog(@"object %@", object);
//     NSLog(@"change %@", change);
//     NSLog(@"keypath %@", keyPath);
//     NSLog(@"context %@", context);
     
//     if ([keyPath isEqualToString:@"mainViewBackgroundColor"]) {
//          UIColor *color = change[@"new"];
//          self.mainView.backgroundColor = color;
//     } else if ([keyPath isEqualToString:@"orbColor"]) {
//          UIColor *color = change[@"new"];
//          for (OrbView *orb in self.mainView.orbs) {
//               orb.backgroundColor = color;
//          }
//     } else if ([keyPath isEqualToString:@"effectsOrbColor"]) {
//          UIColor *color = change[@"new"];
//          self.mainView.effectsOrb.backgroundColor = color;
//     } else if ([keyPath isEqualToString:@"borderWidth"]) {
//          CGFloat lineWidth = [change[@"new"] floatValue];
//          self.controlsViewController.controlsView.transportView.playPauseButton.playPauseLayer.borderWidth = lineWidth;
//          for (UIView *view in self.controlsViewController.controlsView.sequencerView.gridView.subviews) {
//               view.layer.borderWidth = lineWidth;
//          }
//          self.controlsViewController.controlsView.transportView.tempoSlider.layer.borderWidth = lineWidth;
//     } else if ([keyPath isEqualToString:@"bordersColor"]) {
//          UIColor *color = change[@"new"];
//          self.controlsViewController.controlsView.transportView.playPauseButton.playPauseLayer.borderColor = color.CGColor;
//     } else if ([keyPath isEqualToString:@"controlsViewBackgroundColor"]) {
//          UIColor *color = change[@"new"];
//          self.controlsViewController.controlsView.backgroundColor = color;
//     }

}


#pragma mark orb stuff


-(void)loadStockPreset:(NSArray*)preset {
     
     
     // only needed for true preset loading
     //     [[[OrbManager sharedOrbManager] orbModels] removeAllObjects];
     //     self.mainView.reverbOrb = nil;
     //     [self.mainView.orbs removeAllObjects];
     //
     //     for (UIView *subview in self.mainView.subviews) {
     //          if ([subview isKindOfClass:[OrbView class]]) {
     //               [subview removeObserver:self forKeyPath:@"center"];
     //               [subview removeFromSuperview];
     //          }
     //     }
     
     
     
     for (OrbModel *model in preset) {
          const CGFloat orbSize = model.isEffect ? [[UIScreen mainScreen] bounds].size.width/5 : [[UIScreen mainScreen] bounds].size.width/6;
          CGRect bounds = CGRectMake(0.0f, 0.0f, orbSize, orbSize);
          OrbView *orb = [[OrbView alloc] initWithFrame:bounds];
          orb.center = CGPointMake(model.center.x, model.center.y);
          orb.orbModelRef = model;
          orb.isEffect = model.isEffect;
          orb.delegate = self;
          [[[OrbManager sharedOrbManager] orbModels] addObject:model];
    
          if ([model.name isEqualToString:@"effects"]) {
               self.mainView.effectsOrb = orb;
               orb.center = CGPointMake(self.mainView.bounds.size.width/2, self.mainView.bounds.size.height/2);

               orb.backgroundColor = [Theme sharedTheme].effectsOrbColor;
               [self.mainView addSubview:orb];
  
          } else {
               orb.backgroundColor = [Theme sharedTheme].orbColor;
               [orb loadSampler];
               [orb setIcon];
               [self.mainView.orbs addObject:orb];
               
               CGFloat midX = CGRectGetWidth(self.mainView.bounds)/2;
               CGFloat midY = CGRectGetHeight(self.mainView.bounds)/2;
               CGFloat orbYPosOffset = self.mainView.bounds.size.height/8;
               CGFloat insetVal = orbYPosOffset / 1;
               
              
               
               if ([model.name isEqualToString:@"bass"]) {
                    
                    OrbTrackView *trackView = [[OrbTrackView alloc]
                                               initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        midX,
                                                                        midY)
                                               andHandleView:orb];
                    trackView.backgroundColor = [UIColor clearColor];

                    CGPoint fromPoint = CGPointMake(0 + insetVal,0 + insetVal);
                    CGPoint toPoint = CGPointMake(trackView.bounds.size.width - insetVal,
                                                  trackView.bounds.size.height - insetVal);
                    [trackView createPathFromPoint:fromPoint
                                           toPoint:toPoint];
                    
                    
                    
                    
                    
                    // set dynamic max min here.... not ideal?
                    
                    
                    
                    UIView *mainWindow = [UIApplication sharedApplication].keyWindow;
                    CGRect r = [[UIScreen mainScreen] bounds];
                 //   mainWindow = [UIScreen mainScreen] ;
                    
                    CGPoint farPos = [orb
                                            convertPoint:fromPoint
                                            toCoordinateSpace:mainWindow];
                    CGPoint nearPos = [orb
                                             convertPoint:toPoint
                                             toCoordinateSpace:mainWindow];
                    CGPoint effectsPos = [self.mainView.effectsOrb
                                          convertPoint:self.mainView.effectsOrb.center
                                          fromCoordinateSpace:mainWindow];
                    
                    maxOrbDist = [self distanceFromPoint:farPos toOrb:effectsPos];
                    minOrbDist = [self distanceFromPoint:nearPos toOrb:effectsPos];
                    
                    
                    NSLog(@"max %f, min %f", maxOrbDist,minOrbDist);
                    
                    NSLog(@"win width %f, height %f", r.size.width,r.size.height);

                    
                    float temp = minOrbDist;
                    minOrbDist = maxOrbDist;
                    maxOrbDist = temp;
                    
                    
                    
                    
                    
                    [self.mainView addSubview:trackView];
                  
               } else if ([model.name isEqualToString:@"snare"]) {
                    
                    OrbTrackView *trackView = [[OrbTrackView alloc]
                                               initWithFrame:CGRectMake(midX,
                                                                        0,
                                                                        midX,
                                                                        midY)
                                               andHandleView:orb];
                    trackView.backgroundColor = [UIColor clearColor];
                    [trackView createPathFromPoint:CGPointMake(trackView.bounds.size.width - insetVal,
                                                               0 + insetVal)
                                           toPoint:CGPointMake(0 +  insetVal,
                                                               trackView.bounds.size.height - insetVal)];
                    [self.mainView addSubview:trackView];
               
               } else if ([model.name isEqualToString:@"hihat"]) {
                    
                    
                    OrbTrackView *trackView = [[OrbTrackView alloc]
                                               initWithFrame:CGRectMake(0,
                                                                        midY,
                                                                        midX,
                                                                        midY)
                                               andHandleView:orb];
                    trackView.backgroundColor = [UIColor clearColor];
                    [trackView createPathFromPoint:CGPointMake(0 + insetVal,
                                                               trackView.bounds.size.height - insetVal)
                                           toPoint:CGPointMake(trackView.bounds.size.width - insetVal,
                                                               0 + insetVal)];
                    [self.mainView addSubview:trackView];
                    
                    
               } else if ([model.name isEqualToString:@"openHihat"]) {
                    
                    OrbTrackView *trackView = [[OrbTrackView alloc]
                                               initWithFrame:CGRectMake(midX,
                                                                        midY,
                                                                        midX,
                                                                        midY)
                                               andHandleView:orb];
                    trackView.backgroundColor = [UIColor clearColor];
                    [trackView createPathFromPoint:CGPointMake(trackView.bounds.size.width -insetVal,
                                                               trackView.bounds.size.height - insetVal)
                                           toPoint:CGPointMake(0 + insetVal,
                                                               0 + insetVal)];
                    [self.mainView addSubview:trackView];
               }
          }
     }
}

- (BOOL)isPointTooCloseToOrbs:(CGPoint)point theOrb:(OrbView *)orb {
     
     //     for (OrbView *anOrb in self.mainView.orbs) {
     //          if (![anOrb.orbModelRef.name isEqualToString:orb.orbModelRef.name]) {
     //
     //               float distToOrb = sqrt(
     //                                      fabs(
     //                                           pow                   // Distance
     //                                           (anOrb.center.x       // I
     //                                            -                    // S
     //                                            point.x, 2)          // T
     //                                           +                     // A
     //                                           fabs(                 // N
     //                                                pow              // C
     //                                                (anOrb.center.y  // Equation
     //                                                 -               //
     //                                                 point.y, 2)     // To
     //                                                )                // halt
     //                                           )                     //orb
     //                                      );                         // TODO:
     //               CGFloat orbDimeter = CGRectGetWidth(orb.bounds);  // use UIKIT Dynamics
     //               if (distToOrb < orbDimeter) {
     //                    return false;
     //               }
     //          }
     //     }
     return true;
}


- (NSMutableArray*)createPreset {
     self.currentPreset = [NSMutableArray new];
     
     
     OrbModel *bass = [[OrbModel alloc] init];
     bass.name = @"bass";
     bass.idNum = 0;
     bass.sizeValue = 0.5;
     bass.midiNote = 36;
     bass.center = CGPointMake(50, 150.0f);
     bass.sequence = [@[@false,@false,@false,@false,
                         @false,@false,@false,@false,
                         @false,@false,@false,@false,
                         @false,@false,@false,@false] mutableCopy];
     [self.currentPreset addObject:bass];
     bass.hasDL = NO;
          bass.hasRev = NO;
          bass.hasHP = NO;
          bass.hasLP = NO;
     
     OrbModel *snare = [[OrbModel alloc] init];
     snare.name = @"snare";
     snare.idNum = 1;
     snare.sizeValue = 0.5;
     snare.midiNote = 37;
     snare.center = CGPointMake(100, 150);
     snare.sequence = [@[@false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false]mutableCopy];
     snare.hasDL = NO;
     snare.hasRev = NO;
     snare.hasHP = NO;
     snare.hasLP = NO;
     [self.currentPreset addObject:snare];
     
     OrbModel *hihat = [[OrbModel alloc] init];
     hihat.name = @"hihat";
     hihat.sizeValue = 0.5;
     hihat.idNum = 2;
     hihat.midiNote = 38;
     hihat.center = CGPointMake(270, 150);
     hihat.sequence = [@[@false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     hihat.hasDL = NO;
     hihat.hasRev = NO;
     hihat.hasHP = NO;
     hihat.hasLP = NO;
     [self.currentPreset addObject:hihat];
//
     
     OrbModel *Ohihat = [[OrbModel alloc] init];
     Ohihat.name = @"openHihat";
     Ohihat.sizeValue = 0.6;
     Ohihat.idNum = 3;
     Ohihat.midiNote = 39;
     Ohihat.center = CGPointMake(290, 150);
     Ohihat.sequence = [@[@false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     Ohihat.hasDL = NO;
     Ohihat.hasRev = NO;
     Ohihat.hasHP = NO;
     Ohihat.hasLP = NO;
//
     [self.currentPreset addObject:Ohihat];
//
     OrbModel* effectsOrb = [[OrbModel alloc]init];
     effectsOrb.name = @"effects";
     effectsOrb.sizeValue = 1;
     effectsOrb.isEffect = YES;
     effectsOrb.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]),
                                     CGRectGetMidY([[UIScreen mainScreen] bounds]));
     effectsOrb.sequence = [@[@false,@false,@false,@false,
                               @false,@false,@false,@false,
                               @false,@false,@false,@false,
                               @false,@false,@false,@false]mutableCopy];
     effectsOrb.hasDL = NO;
     effectsOrb.hasRev = NO;
     effectsOrb.hasHP = NO;
     effectsOrb.hasLP = NO;
     [self.currentPreset addObject:effectsOrb];

     
     return self.currentPreset;

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
     if (motion == UIEventSubtypeMotionShake)
     {
          for (OrbModel *orb in [OrbManager sharedOrbManager].orbModels) {
               orb.sequence = [@[@false,@false,@false,@false,
                                  @false,@false,@false,@false,
                                  @false,@false,@false,@false,
                                  @false,@false,@false,@false]mutableCopy];
          }
     }
}





- (void)orbTappedWithID:(int)ID {
     
     OrbModel *orb = [[OrbManager sharedOrbManager] getOrbWithID:ID];
     for (OrbView *anOrb in self.mainView.orbs) {
          if (![anOrb.orbModelRef.name isEqualToString:orb.name]) {
               anOrb.layer.borderWidth = 0;
          } else {
               self.selectedOrb = anOrb;
          }
     }
     [self.controlsViewController.controlsView.sequencerView loadOrbWithID:orb.idNum
                                                               andSequence:orb.sequence];
     [self.controlsViewController.controlsView.effectsView loadOrbWithID:orb.idNum
                                                                  andRev:self.selectedOrb.orbModelRef.hasRev
                                                                      hp:self.selectedOrb.orbModelRef.hasHP
                                                                      lp:self.selectedOrb.orbModelRef.hasLP
                                                                    dist:self.selectedOrb.orbModelRef.hasDL
                                                                 orbName:self.selectedOrb.orbModelRef.name];
      self.selectedOrb.layer.borderWidth = [Theme sharedTheme].borderWidth + 2;
}





-(void)toggleControls:(BOOL)toggle {
     [self.view bringSubviewToFront:self.controlsViewController.view];

     [UIView animateWithDuration:0.15 animations:^{
          CGRect controlsViewFrame = self.controlsViewController.view.frame;
          if (toggle) {
               self.controlsViewController.controlsView.effectsView.expandButton.pivot = 1.5;
               self.controlsViewController.controlsView.effectsView.expandButton.wings = 0.3;

               self.controlsViewController.controlsView.effectsView.expandButton.selected = YES;
               controlsViewFrame.origin.y = controlsOpenPos;
          } else {
               self.controlsViewController.controlsView.effectsView.expandButton.pivot = 0.3;
               self.controlsViewController.controlsView.effectsView.expandButton.wings = 1.5;

               self.controlsViewController.controlsView.effectsView.expandButton.selected = NO;
               controlsViewFrame.origin.y = controlsClosedPos;
          }
          self.controlsViewController.view.frame = controlsViewFrame;
     }];
}


//- (void)cryptoMode:(UILongPressGestureRecognizer*)lp {
//     if (lp.state == UIGestureRecognizerStateBegan) {
//          [[Theme sharedTheme] cycleTheme];
//     }
//     
//     if ([Theme sharedTheme].cryptoMode) {
//          self.cryptoLabel.hidden = NO;
//     } else {
//          self.cryptoLabel.hidden = YES;
//     }
//}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p;
{
     // todo
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2;
{
     // todo
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     //   [self toggleControls:NO];
}


@end