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

#define MAINVIEWTRANSFORM 0.58
#define EFFECTDIST 300

@interface MainViewController() <SequencerDelegate, OrbViewDelegate, UICollisionBehaviorDelegate>
@property (nonatomic, strong) ControlsViewController *controlsViewController;
@property (nonatomic, strong) PresetsViewController *presetsViewController;
@property (nonatomic,strong)  NSMutableArray *currentPreset;
@property (strong) SuperTimer *superTimer;
@property (nonatomic,assign) BOOL wasBeat;
@property (nonatomic,strong) UILabel *cryptoLabel;
@property (nonatomic,strong) UILabel *beatLabel;
@property (nonatomic,strong) UIDynamicAnimator *ani;

@end

@implementation MainViewController {
     CGFloat controlsClosedPos;
     CGFloat controlsOpenPos;
}




-(instancetype)init {
     if (self = [super init]) {

          // start Seq
          [Sequencer sharedSequencer];
          
          //update mainView DrawRect
          CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
          [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
          
          // sequencer control
          [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(didTick:)
                                                       name:@"didTick"
                                                     object:nil];
          // KVO
          [[Theme sharedTheme] addObserver:self forKeyPath:@"mainViewBackgroundColor"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
          [[Theme sharedTheme] addObserver:self
                                forKeyPath:@"borderWidth"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
          [[Theme sharedTheme] addObserver:self
                                forKeyPath:@"bordersColor"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
          [[Theme sharedTheme] addObserver:self
                                forKeyPath:@"controlsViewBackgroundColor"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
     }
     return self;
}

- (void)viewDidLoad {
     [super viewDidLoad];
  
     self.mainView = [[MainView alloc] initWithFrame:self.view.bounds];
     self.mainView.autoresizesSubviews = YES;
     [self.view addSubview:self.mainView];
     self.mainView.backgroundColor = [Theme sharedTheme].mainViewBackgroundColor;

     CGFloat width = self.mainView.frame.size.width;
     CGFloat height = self.mainView.frame.size.height;
     
     self.beatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + width/30,
                                                                0,
                                                                width/5,
                                                                height/18)];
     self.beatLabel.textColor = [UIColor redColor];
     self.beatLabel.backgroundColor = [UIColor clearColor];
     self.beatLabel.text = @"beat: 1";
     [self.mainView addSubview:self.beatLabel];
     
     self.tempoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 + width/30 + (width/30)*5,
                                                                0,
                                                                width/3,
                                                                height/18)];
     self.tempoLabel.textColor = [UIColor redColor];
     self.tempoLabel.backgroundColor = [UIColor clearColor];
     self.tempoLabel.text = @"tempo: 1";
     [self.mainView addSubview:self.tempoLabel];
     
     self.cryptoLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - width/3.5,
                                                                  0,
                                                                  height/3,
                                                                  height/9)];
     self.cryptoLabel.text = @"Cryptomodo";
     self.cryptoLabel.textColor = [UIColor redColor];
     [self.mainView addSubview:self.cryptoLabel];
     self.cryptoLabel.hidden = YES;
     
     // hidden cryptomode access ciew
     UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, 50)];
     view.backgroundColor = [UIColor clearColor];
     [self.mainView addSubview:view];
     UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cryptoMode:)];
     lp.minimumPressDuration = 1;
     [view addGestureRecognizer:lp];
     
     // orbs
     [self createPreset];
     [self loadStockPreset:self.currentPreset];
     


     // controls view setup
     self.controlsViewController = [[ControlsViewController alloc] init];
     self.controlsViewController.mainViewController = self;
     [self.view addSubview:self.controlsViewController.view];
     
     // toggle controls layout
     CGFloat heightOfTransportView = self.controlsViewController.controlsView.transportView.bounds.size.height;
     controlsClosedPos = CGRectGetHeight(self.view.bounds) - heightOfTransportView;
     controlsOpenPos = CGRectGetHeight(self.view.bounds) - self.controlsViewController.view.frame.size.height;
     CGRect setControlsVCFrame = self.controlsViewController.view.frame;
     setControlsVCFrame.origin.y = controlsClosedPos; 
     self.controlsViewController.view.frame = setControlsVCFrame;
     
     
     
     // TODO UIKIT DYNAMICS to prevent overlapping orbs
//     self.ani = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//     UICollisionBehavior *col = [[UICollisionBehavior alloc] initWithItems:self.mainView.orbs];
//     [self.ani addBehavior:col];
//     [col setCollisionMode:UICollisionBehaviorModeEverything];
//     [col setCollisionDelegate:self];
}



-(void)loadStockPreset:(NSArray*)preset {
     
     [[[OrbManager sharedOrbManager] orbModels] removeAllObjects];
     self.mainView.reverbOrb = nil;
     [self.mainView.orbs removeAllObjects];
     
     for (UIView *subview in self.mainView.subviews) {
          if ([subview isKindOfClass:[OrbView class]]) {
               [subview removeObserver:self forKeyPath:@"center"];
               [subview removeFromSuperview];
          }
     }
     for (OrbModel *model in preset) {
          const CGFloat orbSize = model.isEffect ? 100.0f : 80.0f;
          CGRect bounds = CGRectMake(0.0f, 0.0f, orbSize, orbSize);
          OrbView *orb = [[OrbView alloc] initWithFrame:bounds];
          orb.center = CGPointMake(model.center.x, model.center.y);
          orb.orbModelRef = model;
          [orb setIcon];
          orb.isEffect = model.isEffect;
          orb.delegate = self;
          [orb addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
          [[[OrbManager sharedOrbManager] orbModels] addObject:model];
          if ([model.name isEqualToString:@"reverb"]) {
               self.mainView.reverbOrb = orb;
               orb.backgroundColor = [Theme sharedTheme].orbReverbColor;
          } else if ([model.name isEqualToString:@"hp"]) {
               self.mainView.hpOrb = orb;
               orb.backgroundColor = [Theme sharedTheme].orbHPColor;
          } else {
               
               orb.backgroundColor = [Theme sharedTheme].orbColor;
               [orb loadSampler];
               [self.mainView.orbs addObject:orb];
               
          }
          [self.mainView addSubview:orb];
     }
     [[Theme sharedTheme] addObserver:self forKeyPath:@"orbColor" options:NSKeyValueObservingOptionNew context:nil];
     [[Theme sharedTheme] addObserver:self forKeyPath:@"orbHPColor" options:NSKeyValueObservingOptionNew context:nil];
     [[Theme sharedTheme] addObserver:self forKeyPath:@"orbReverbColor" options:NSKeyValueObservingOptionNew context:nil];


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



#pragma mark seq stuff

- (void)didTickWithCount:(int)count {
     
     for (OrbView* orb in self.mainView.orbs) {
               if ([[orb.orbModelRef.sequence objectAtIndex:count] boolValue]) {
                    
                    self.wasBeat = YES;
                    
                    float hpAmount = interpolate(0, 100, 0, 17000, orb.hpCutoff, 0);
                    
                    if ([orb.orbModelRef.name isEqualToString:@"bass"]) {
                         hpAmount *= 0.05;
                    }
                    
                    [orb.sampler sendNoteOnEvent:orb.orbModelRef.midiNote velocity:127];
                    [orb.sampler sendReverbWetDry:orb.revAmount];
                    [orb.sampler setHighPassFreqCutoff:hpAmount];
               } else {
                    self.wasBeat = NO;
               }
          }
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

- (void)didTick:(NSNotification*)notification {
     int count = [notification.userInfo[@"count"] intValue];
     [self didTickWithCount:count];
     [self didTickOnMainThread:count];
}

// called from CADisplayLink
- (void)tick {
    // [self.mainView setNeedsDisplay];

          if (self.mainView.isPlaying) {
               for (OrbView *orb in self.mainView.orbs) {
                    
                    CGPoint currentOrb = orb.center;
                    CGPoint reverb = self.mainView.reverbOrb.center;
                    CGPoint hp = self.mainView.hpOrb.center;
                    
                    float distToRev = sqrt(fabs(pow(reverb.x - currentOrb.x, 2)+fabs(pow(reverb.y - currentOrb.y, 2))));
                    float distToHP = sqrt(fabs(pow(hp.x - currentOrb.x, 2)+fabs(pow(hp.y - currentOrb.y, 2))));
                    
                    float revAmount = interpolate(0, 300, 1, 0, distToRev, 1);
                    float delAmount = interpolate(0, 300, 1, 0, distToHP, 1);
                    
                    orb.revAmount = revAmount * 100;
                    orb.hpCutoff = delAmount * 100;
                    
                    if (distToRev < EFFECTDIST) {
                         orb.hasReverb = YES;
                    } else {
                         orb.hasReverb = NO;
                         orb.revAmount = 0;
                    }
                    if (distToHP < EFFECTDIST) {
                         orb.hasHP = YES;
                    } else {
                         orb.hasHP = NO;
                         orb.hpCutoff = NO;
                    }
               }
          }
     
     
     }



#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//     NSLog(@"object %@", object);
//     NSLog(@"change %@", change);
//     NSLog(@"keypath %@", keyPath);
//     NSLog(@"context %@", context);
     
     if ([keyPath isEqualToString:@"mainViewBackgroundColor"]) {
          UIColor *color = change[@"new"];
          self.mainView.backgroundColor = color;
     } else if ([keyPath isEqualToString:@"orbColor"]) {
          UIColor *color = change[@"new"];
          for (OrbView *orb in self.mainView.orbs) {
               orb.backgroundColor = color;
          }
     } else if ([keyPath isEqualToString:@"orbHPColor"]) {
          UIColor *color = change[@"new"];
          self.mainView.hpOrb.backgroundColor = color;
     } else if ([keyPath isEqualToString:@"orbReverbColor"]) {
          UIColor *color = change[@"new"];
          self.mainView.reverbOrb.backgroundColor = color;
     } else if ([keyPath isEqualToString:@"borderWidth"]) {
          CGFloat lineWidth = [change[@"new"] floatValue];
          self.controlsViewController.controlsView.transportView.playPauseButton.playPauseLayer.borderWidth = lineWidth;
          for (UIView *view in self.controlsViewController.controlsView.sequencerView.gridView.subviews) {
               view.layer.borderWidth = lineWidth;
          }
          self.controlsViewController.controlsView.transportView.tempoSlider.layer.borderWidth = lineWidth;
     } else if ([keyPath isEqualToString:@"bordersColor"]) {
          UIColor *color = change[@"new"];
          self.controlsViewController.controlsView.transportView.playPauseButton.playPauseLayer.borderColor = color.CGColor;
     } else if ([keyPath isEqualToString:@"controlsViewBackgroundColor"]) {
          UIColor *color = change[@"new"];
          self.controlsViewController.controlsView.backgroundColor = color;
     }

}


#pragma mark geature handlers

- (void)createPreset {
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
     
     OrbModel *snare = [[OrbModel alloc] init];
     snare.name = @"snare";
     snare.idNum = 1;
     snare.sizeValue = 0.5;
     snare.midiNote = 37;
     snare.center = CGPointMake(100, 150);
     snare.sequence = [@[@true,@false,@false,@false,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false]mutableCopy];
     [self.currentPreset addObject:snare];
     
     OrbModel *hihat = [[OrbModel alloc] init];
     hihat.name = @"hihat";
     hihat.sizeValue = 0.5;
     hihat.idNum = 2;
     hihat.midiNote = 38;
     hihat.center = CGPointMake(270, 150);
     hihat.sequence = [@[@true,@true,@true,@true,
                          @false,@false,@false,@false,
                          @true,@false,@false,@false,
                          @false,@false,@false,@false] mutableCopy];
     [self.currentPreset addObject:hihat];
     
     OrbModel* reverb = [[OrbModel alloc]init];
     reverb.name = @"reverb";
     reverb.sizeValue = 1;
     reverb.isEffect = YES;
     reverb.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]),
                                 CGRectGetMidY([[UIScreen mainScreen] bounds]));
     reverb.sequence = [@[@false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @false,@false,@false,@false,
                           @false,@false,@false,@false]mutableCopy];
     [self.currentPreset addObject:reverb];
     
     OrbModel* hp = [[OrbModel alloc]init];
     hp.name = @"hp";
     hp.sizeValue = 1;
     hp.isEffect = YES;
     hp.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] bounds]) + 50,
                                CGRectGetMidY([[UIScreen mainScreen] bounds]));
     hp.sequence = [@[@false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false,
                          @false,@false,@false,@false]mutableCopy];
     [self.currentPreset addObject:hp];
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
     [self.controlsViewController.controlsView.sequencerView loadOrb:orb];
     [self toggleControls:YES];
     OrbView *orbView;
     
     for (OrbView *anOrb in self.mainView.orbs) {
          if (![anOrb.orbModelRef.name isEqualToString:orb.name]) {
               anOrb.layer.borderWidth = 0;
          } else {
               orbView = anOrb;
          }
     }
     orbView.layer.borderWidth = [Theme sharedTheme].borderWidth + 2;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     [self toggleControls:NO];
}


-(void)toggleControls:(BOOL)toggle {
     
     [UIView animateWithDuration:0.15 animations:^{
          [self.view bringSubviewToFront:self.controlsViewController.view];
          CGRect frameControls = self.controlsViewController.view.frame;
          if (toggle) {
               self.mainView.transform = CGAffineTransformMakeScale(1, MAINVIEWTRANSFORM);
               for (OrbView *orb in self.mainView.orbs) {
                    orb.transform = CGAffineTransformMakeScale(1, 2 - MAINVIEWTRANSFORM+0.2);
               }
               self.controlsViewController.controlsView.transportView.expandButton.pivot = 1;
               self.controlsViewController.controlsView.transportView.expandButton.wings = 0;
               self.controlsViewController.controlsView.transportView.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
               frameControls.origin.y = controlsOpenPos;
               
               CGRect frameReset = self.mainView.frame;
               frameReset.origin = CGPointMake(0, 0);
               self.mainView.frame = frameReset;
               self.controlsViewController.controlsView.transportView.expandButton.selected = YES;
               
          } else {
               self.mainView.transform = CGAffineTransformMakeScale(1, 1);
               for (OrbView *orb in self.mainView.orbs) {
                    orb.transform = CGAffineTransformMakeScale(1,1);
               }
               self.controlsViewController.controlsView.transportView.expandButton.pivot = 0;
               self.controlsViewController.controlsView.transportView.expandButton.wings = 1;
               CGRect frameReset = self.mainView.frame;
               frameReset.origin = CGPointMake(0, 0);
               self.mainView.frame = frameReset;
               self.controlsViewController.controlsView.transportView.expandButton.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
               frameControls.origin.y = controlsClosedPos;
               self.controlsViewController.controlsView.transportView.expandButton.selected = NO;
               
          }
          self.controlsViewController.view.frame = frameControls;
     }];
}


- (void)cryptoMode:(UILongPressGestureRecognizer*)lp {
     if (lp.state == UIGestureRecognizerStateBegan) {
          [[Theme sharedTheme] cycleTheme];
     }
     
     if ([Theme sharedTheme].cryptoMode) {
          self.cryptoLabel.hidden = NO;
     } else {
          self.cryptoLabel.hidden = YES;
     }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p;
{
     // todo
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2;
{
     // todo
}

@end