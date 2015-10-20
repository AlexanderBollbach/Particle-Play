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
#import "MainView.h"
#import "ControlsViewController.h"
#import "PresetsViewController.h"
#import "UIColor+ColorAdditions.h"
#import "AUSamplePlayer2.h"
#import "ControlsView.h"
#import "Sequencer.h"
#import "ControlsViewController.h"


@interface MainViewController() <sequencerDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isControlsPopoverOpen;
@property (nonatomic, assign) BOOL isPresetsPopoverOpen;
@property (nonatomic, strong) ControlsViewController *controlsViewController;
@property (nonatomic, strong) PresetsViewController *presetsViewController;
@end

@implementation MainViewController {
     __weak MainView *_weakMainView;
     UIVisualEffectView *_blur;
     CGFloat controlsClosedPos;
     CGFloat controlsOpenPos;

}

-(instancetype)init {
     if (self = [super init]) {
          _isControlsPopoverOpen = YES;
          _isPresetsPopoverOpen = YES;
          [[Sequencer sharedSequencer] stopSequencer];
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

     
     // initialize controls View Controller
     CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds),
                              CGRectGetHeight(self.view.bounds) - 150.0);
     CGRect mybounds = CGRectMake(0,
                                  0,
                                  size.width,
                                  size.height);
     self.controlsViewController = [ControlsViewController new];
     self.controlsViewController.view.frame = mybounds;
     self.controlsViewController.mainViewController = self;
     //  add VC
     [self addChildViewController:self.controlsViewController];
     [self.view addSubview:self.controlsViewController.view];
     [self.controlsViewController didMoveToParentViewController:self];
     
     
     
     
     
     // get controls closed position
     controlsClosedPos = self.controlsViewController.view.bounds.size.height / 8;
     controlsClosedPos = self.view.bounds.size.height - controlsClosedPos;
     controlsOpenPos = self.view.bounds.size.height - self.controlsViewController.view.frame.size.height;
     
     CGRect setControlsVCFrame = self.controlsViewController.view.frame;
     setControlsVCFrame.origin.y = controlsClosedPos;
     self.controlsViewController.view.frame = setControlsVCFrame;
     
     
     
     
     
     // initialize Presets View Controller
     CGSize sizePresets = CGSizeMake(CGRectGetWidth(self.view.bounds)/2.5,
                              CGRectGetHeight(self.view.bounds));
     CGRect myboundsPresets = CGRectMake(CGRectGetWidth(self.view.bounds),
                                  0,
                                  sizePresets.width,
                                  sizePresets.height);
     self.presetsViewController = [PresetsViewController new];
     self.presetsViewController.view.frame = myboundsPresets;
     
     // add VC
     [self addChildViewController:self.presetsViewController];
     [self.view addSubview:self.presetsViewController.view];
     [self.presetsViewController setupViews];
     [self.presetsViewController didMoveToParentViewController:self];
    
     
     // Open presets gesture
     UIScreenEdgePanGestureRecognizer *rightEdge = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdge:)];
     rightEdge.edges = UIRectEdgeRight;
     rightEdge.delegate = self;
     [self.view addGestureRecognizer:rightEdge];
     
     // close presets Gesture
     UIPanGestureRecognizer *closePresets = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePresetsPan:)];
     [self.presetsViewController.view addGestureRecognizer:closePresets];
     closePresets.delegate = self;
}

-(void)toggleControls:(BOOL)toggle {
     [UIView animateWithDuration:0.5 animations:^{
          [self.view bringSubviewToFront:self.controlsViewController.view];
          CGRect frame = self.controlsViewController.view.frame;
          if (toggle) {
               self.controlsViewController.controlsView.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
               frame.origin.y = controlsOpenPos;
        
          } else {
               self.controlsViewController.controlsView.expandButton.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
               frame.origin.y = controlsClosedPos;
          }
          self.controlsViewController.view.frame = frame;
     }];
}

#pragma mark --- presets gestures

-(void)handlePresetsPan:(UIPanGestureRecognizer*)gesture {
     CGPoint translation = [gesture translationInView:self.view];
     CGFloat presetsMidPoint = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.presetsViewController.view.bounds)/2;
     CGFloat presetsPosition = self.presetsViewController.view.frame.origin.x;
     switch (gesture.state) {
          case UIGestureRecognizerStateBegan:
               break;
          case UIGestureRecognizerStateChanged:
               if (presetsPosition < presetsMidPoint) {
                    self.presetsViewController.view.center = CGPointMake(self.presetsViewController.view.center.x + translation.x,
                                                                         self.presetsViewController.view.center.y);
                    [gesture setTranslation:CGPointZero inView:self.presetsViewController.view];
                    
               } else {
                    [self dismissPresetsViewController];
               }
               break;
          case UIGestureRecognizerStateEnded:
               if (presetsPosition < presetsMidPoint) {
                    [self presentPresetsViewController];
               } else {
                    [self dismissPresetsViewController];
               }
               break;
               
          default:
               break;
     }
     
}

- (void)handleRightEdge:(UIScreenEdgePanGestureRecognizer *)gesture {
     CGPoint translation = [gesture translationInView:self.view];
     CGFloat presetsMidPoint = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.presetsViewController.view.bounds)/2;
     CGFloat presetsPosition = self.presetsViewController.view.frame.origin.x;
     switch (gesture.state) {
          case UIGestureRecognizerStateBegan:
               break;
          case UIGestureRecognizerStateChanged:
               if (presetsPosition > presetsMidPoint) {
                    self.presetsViewController.view.center = CGPointMake(self.presetsViewController.view.center.x + translation.x, self.presetsViewController.view.center.y);
                    [gesture setTranslation:CGPointZero inView:self.view];

               } else {

                    [self presentPresetsViewController];
               }
               break;
          case UIGestureRecognizerStateEnded:
               if (presetsPosition < presetsMidPoint) {
                    [self presentPresetsViewController];
               } else {
                    [self dismissPresetsViewController];
               }
               break;
          default:
               break;
     }
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

- (void)dismissPresetsViewController {
     [UIView animateWithDuration:.200 animations:^{
          CGRect frame = self.presetsViewController.view.frame;
          frame.origin.x = self.view.frame.size.width;
          self.presetsViewController.view.frame = frame;
     }];
}

- (void)presentPresetsViewController {
     
     [UIView animateWithDuration:.200 animations:^{
          CGRect frame = self.presetsViewController.view.frame;
          frame.origin.x = CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.view.bounds)/2.5;
          self.presetsViewController.view.frame = frame;
     }];
     
}

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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
     [self.view setNeedsDisplay];
}

- (CGFloat)_anchorOrbDistanceToOrb:(OrbView *)orb {
     const CGPoint anchorPoint = _weakMainView.anchorOrb.center;
     const CGPoint orbPoint = orb.center;
     const CGFloat dx = (anchorPoint.x - orbPoint.x);
     const CGFloat dy = (anchorPoint.y - orbPoint.y);
     float dist = interpolate(0.0f, 500.0f, 0.0f, 100.0f, sqrt(dx*dx + dy*dy), -1.0f);
     float dashDist = interpolate(0.0f, 500.0f, 2.0f, 15.0f, sqrt(dx*dx + dy*dy), 0);

     _weakMainView.dashConstant = dashDist;
     return dist;
     
     
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
          [orb setIcon];
          orb.isMaster = model.isMaster;
          orb.backgroundColor = model.isMaster ? [UIColor flatSTLightBlueColor] : [UIColor flatSTEmeraldColor];
          //   [orb addTarget:self action:@selector(toggleControlsPopover:) forControlEvents:UIControlEventTouchUpInside];
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

@end