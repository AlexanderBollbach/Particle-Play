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
#import "CustomSlider.h"
#import "myFunction.h"
#import "MainView.h"
#import "ControlsViewController.h"
#import "PresetsViewController.h"
#import "UIColor+ColorAdditions.h"
#import "AUSamplePlayer2.h"
#import "TopPanelView.h"
#import "Sequencer.h"



@interface MainViewController() <sequencerDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isControlPopoverOpen;
@property (nonatomic, assign) BOOL isPresetsPopoverOpen;
@property (nonatomic, strong) CustomSlider *customSlider;
@property (nonatomic, strong) ControlsViewController *controlViewController;
@property (nonatomic, strong) PresetsViewController *presetsViewController;
@property (nonatomic, strong) TopPanelView *topPanelView;
@end

@implementation MainViewController {

     __weak MainView *_weakMainView;
     UIVisualEffectView *_blur;
}

-(instancetype)init {
     if (self = [super init]) {
          
          _isControlPopoverOpen = YES;
          _isPresetsPopoverOpen = YES;
          
          [[Sequencer sharedSequencer] startSequencer];
          
          [Sequencer sharedSequencer].delegate = self;
          
     }
     return self;
}

- (void)loadView {
     self.view = [[MainView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     _weakMainView = (MainView*)self.view;
     _weakMainView.backgroundColor = [UIColor flatSTDarkBlueColor];
}

- (void)viewDidLoad {
     [super viewDidLoad];
     
     
     // load initial preset
     NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey];
     NSMutableDictionary *masterDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     NSDictionary *presets = [masterDict objectForKey:ABUserDefaultsPresetsStockKey];
     NSArray *preset = [presets objectForKey:@"Preset2"];
     [self loadStockPreset:preset];

     // top UI
     self.topPanelView = [[TopPanelView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        CGRectGetWidth(self.view.bounds),
                                                                        CGRectGetHeight(self.view.bounds)/10)];
     self.topPanelView.backgroundColor = [UIColor flatSTLightBlueColor];
     [self.topPanelView.tempoSlider addTarget:self action:@selector(handleSlider:) forControlEvents:UIControlEventValueChanged];
     [self.topPanelView.resetButton addTarget:self action:@selector(resetButton:) forControlEvents:UIControlEventTouchUpInside];
     [self.topPanelView.playPauseButton addTarget:self action:@selector(playPauseButton:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:self.topPanelView];

     
     // start "seq"
    // [self _startTimer];
}

-(void)resetButton:(PlayPauseButton*)sender {
     sender.selected = !sender.selected;
// TODO: time jump
}

-(void)playPauseButton:(PlayPauseButton*)sender {
     sender.selected = !sender.selected;
     if (sender.selected) {
          [self.timer invalidate];
          [self.topPanelView.playPauseButton animateTriToSquare];
     } else {
          [self.topPanelView.playPauseButton animateSquareToTri];
          //[self _startTimer];
     }
}

-(void)handleSlider:(CustomSlider*)sender {
    // change SEQ tempo
     
     // tempoTransformNew = interpolate(0, 100, 2, 0, sender.amount, 1);
     
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
     [self.view setNeedsDisplay];
}

- (CGFloat)_anchorOrbDistanceToOrb:(OrbView *)orb {
     const CGPoint anchorPoint = _weakMainView.anchorOrb.center;
     const CGPoint orbPoint = orb.center;
     const CGFloat dx = (anchorPoint.x - orbPoint.x);
     const CGFloat dy = (anchorPoint.y - orbPoint.y);
     return interpolate(0.0f, 500.0f, 0.0f, 100.0f, sqrt(dx*dx + dy*dy), -1.0f);
}




-(void)didTickWithCount:(int)count {
     for (OrbView* orb in _weakMainView.orbs) {
          if ([[orb.orbModelRef.sequence objectAtIndex:count] boolValue]) {
               [orb.sampler sendNoteOnEvent:orb.orbModelRef.midiNote velocity:127];
               [orb.sampler sendReverbWetDry:[self _anchorOrbDistanceToOrb:orb]];
               [orb.sampler sendDelayWetDry:0];
               [orb performAnimation];
          } else {
               [orb.sampler sendNoteOffEvent:orb.orbModelRef.midiNote velocity:127];
          }
     }
}


-(void)loadStockPreset:(NSArray*)preset {
     
     [[[OrbManager sharedOrbManager] orbModels] removeAllObjects];

     _weakMainView.anchorOrb = nil;
     [_weakMainView.orbs removeAllObjects];
     
     for (UIView *subview in _weakMainView.subviews) {
          if ([subview isKindOfClass:[OrbView class]]) {
               [subview removeObserver:self forKeyPath:@"center"];
               [subview removeFromSuperview];
          }
     }
     [self.view setNeedsDisplay];
     
     for (OrbModel *model in preset) {
          const CGFloat orbSize = model.isMaster ? 100.0f : 80.0f;
          CGRect bounds = CGRectMake(0.0f, 0.0f, orbSize, orbSize);
          OrbView *orb = [[OrbView alloc] initWithFrame:bounds];
          orb.center = CGPointMake(model.center.x, model.center.y);
          orb.orbModelRef = model;
          orb.isMaster = model.isMaster;
          orb.backgroundColor = model.isMaster ? [UIColor flatSTLightBlueColor] : [UIColor flatSTEmeraldColor];
          [orb addTarget:self action:@selector(toggleControlsPopover:) forControlEvents:UIControlEventTouchUpInside];
          [orb addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
          [self.view addSubview:orb];
          
          [[[OrbManager sharedOrbManager] orbModels] addObject:model];
          if (model.isMaster) {
               _weakMainView.anchorOrb = orb;
          } else {
               [_weakMainView.orbs addObject:orb];
          }
     }
}

- (void)toggleControlsPopover:(OrbView*)sender {
     if (sender.isMaster) {
          self.isPresetsPopoverOpen = !self.isPresetsPopoverOpen;
     } else {
          self.isControlPopoverOpen = !self.isControlPopoverOpen;
     }
}

- (void)setIsControlPopoverOpen:(BOOL)isControlPopoverOpen {
     
     if (_isControlPopoverOpen == isControlPopoverOpen) {
          return;
     }
     _isControlPopoverOpen = isControlPopoverOpen;
     if (_isControlPopoverOpen) {
          [self dismissControlsViewController];
     } else {
          [self presentControlsViewController];
     }
}

- (void)setIsPresetsPopoverOpen:(BOOL)isPresetsPopoverOpen {
     
     if (_isPresetsPopoverOpen == isPresetsPopoverOpen) {
          return;
     }
     _isPresetsPopoverOpen = isPresetsPopoverOpen;
     if (_isPresetsPopoverOpen) {
          [self dismissPresetsViewController];
     } else {
          [self presentPresetsViewController];
     }
}

- (void)presentControlsViewController {
     
     CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds),  CGRectGetWidth(self.view.bounds) - 100.0);
     CGRect mybounds = CGRectMake(0.0, CGRectGetHeight(self.view.bounds), size.width, size.height);
     _controlViewController = [ControlsViewController new];
     _controlViewController.view.frame = mybounds;

     [self addChildViewController:_controlViewController];
     [self.view addSubview:_controlViewController.view];
     [_controlViewController didMoveToParentViewController:self];
     
  //   NSLog(@"%@",NSStringFromCGRect(_controlViewController.view.bounds));
     [UIView animateWithDuration:0.2 animations:^{
          CGRect frame = _controlViewController.view.frame;
          frame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_controlViewController.view.bounds);
          _controlViewController.view.frame = frame;
     }];
}

- (void)presentPresetsViewController {
     
     CGSize size = CGSizeMake(
                              CGRectGetWidth(self.view.bounds)/2.5,
                              CGRectGetHeight(self.view.bounds));
     CGRect mybounds = CGRectMake(
                                  CGRectGetWidth(self.view.bounds),
                                  0,
                                  size.width,
                                  size.height);
     _presetsViewController = [PresetsViewController new];
     _presetsViewController.view.frame = mybounds;
     
     [self addChildViewController:_presetsViewController];
     [self.view addSubview:_presetsViewController.view];
     [_presetsViewController setupViews];
     [_presetsViewController didMoveToParentViewController:self];
     
     [UIView animateWithDuration:.200 animations:^{
          CGRect frame = _presetsViewController.view.frame;
          frame.origin.x = CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.view.bounds)/2.5;
          _presetsViewController.view.frame = frame;
     }];
     
}

- (void)dismissControlsViewController {

     [UIView animateWithDuration:.200 animations:^{
          CGRect frame = _controlViewController.view.frame;
          frame.origin.y = self.view.frame.size.height + CGRectGetHeight(self.view.bounds)/2.5;
          _controlViewController.view.frame = frame;
        } completion:^(BOOL finished) {
             [_controlViewController.view removeFromSuperview];
             [_controlViewController removeFromParentViewController];
        }];
}

- (void)dismissPresetsViewController {
    
     [UIView animateWithDuration:.200 animations:^{
          CGRect frame = _presetsViewController.view.frame;
          frame.origin.x = self.view.frame.size.width;
          _presetsViewController.view.frame = frame;
     } completion:^(BOOL finished) {
          [_presetsViewController.view removeFromSuperview];
          [_presetsViewController removeFromParentViewController];
     }];
}

#pragma mark - UIResponder

//-(void)_startTimer {
//     
//     if (self.timer) {
//          [self.timer invalidate];
//          self.timer = nil;
//     }
//     self.timer = [NSTimer scheduledTimerWithTimeInterval:(0.08 * tempoTransformNew)
//                                                   target:self
//                                                 selector:@selector(sequencer:)
//                                                 userInfo:nil
//                                                  repeats:YES];
//     [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
////     NSLog(@"%@", self.timer);
//
//}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
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
@end