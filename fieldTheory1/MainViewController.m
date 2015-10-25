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
#import "AUSamplePlayer2.h"
#import "Sequencer.h"
#import "ControlsViewController.h"
#import "Theme.h"
#import "SpaceView.h"

#define MAINVIEWTRANSFORM 0.58

@interface MainViewController() <sequencerDelegate>
@property (nonatomic, assign) BOOL isPresetsPopoverOpen;
@property (nonatomic, strong) ControlsViewController *controlsViewController;
@property (nonatomic, strong) PresetsViewController *presetsViewController;
@end

@implementation MainViewController {
     CGFloat controlsClosedPos;
     CGFloat controlsOpenPos;
}

-(instancetype)init {
     if (self = [super init]) {
          _isPresetsPopoverOpen = YES;
          [[Sequencer sharedSequencer] stopSequencer];
          [Sequencer sharedSequencer].delegate = self;
     }
     return self;
}


- (void)viewDidLoad {
     
     [super viewDidLoad];
     
     self.view.backgroundColor = [UIColor orangeColor];
     
     self.mainView = [[MainView alloc] initWithFrame:self.view.bounds];
     self.mainView.autoresizesSubviews = YES;
     [self.view addSubview:self.mainView];
     self.mainView.backgroundColor = [Theme sharedTheme].mainViewBackgroundColor;
     
     // load initial preset
     NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ABUserDefaultsPresetsKey];
     NSMutableDictionary *masterDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     NSDictionary *presets = [masterDict objectForKey:ABUserDefaultsPresetsStockKey];
     NSArray *preset = [presets objectForKey:@"Preset2"];
     [self loadStockPreset:preset];

     self.controlsViewController = [ControlsViewController new];
     self.controlsViewController.mainViewController = self;
     
    // [self addChildViewController:self.controlsViewController];
     [self.view addSubview:self.controlsViewController.view];
    // [self.view addSubview:self.controlsViewController.view];
     //  [self.controlsViewController didMoveToParentViewController:self];
     
     
     
     // get controls closed position
     CGFloat heightOfTransportView = self.controlsViewController.controlsView.transportView.bounds.size.height;
     NSLog(@"height of controlsView %f", heightOfTransportView);
     controlsClosedPos = CGRectGetHeight(self.view.bounds) - heightOfTransportView;
     controlsOpenPos = CGRectGetHeight(self.view.bounds) - self.controlsViewController.view.frame.size.height;
     
     
     NSLog(@"height of mainview %f || closedpos %f || openpos %f",CGRectGetHeight(self.view.bounds), controlsClosedPos, controlsOpenPos);
     
     CGRect setControlsVCFrame = self.controlsViewController.view.frame;
     setControlsVCFrame.origin.y = controlsClosedPos; 
     self.controlsViewController.view.frame = setControlsVCFrame;
     
     // Resize MainView relative to ControlsView
     CGRect mainViewFrame = self.view.bounds;
     mainViewFrame.size.height = CGRectGetHeight(self.view.bounds) - heightOfTransportView;
     self.mainView.frame = mainViewFrame;
     
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
     
     
     // Controls Gesture
     UIPanGestureRecognizer *controlsPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleControlsPan:)];
     [self.controlsViewController.controlsView addGestureRecognizer:controlsPan];
     controlsPan.delegate = self;
     
     
     
     

     
     
     
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
     if ([gestureRecognizer.view isKindOfClass:[CustomSlider class]]) {
          return NO;
     }
     return YES;
}

-(void)handleControlsPan:(UIPanGestureRecognizer*)pan {
     
    // NSLog(@"%@", pan.view);
     
     if ([pan.view isKindOfClass:[ControlsView class]]) {

     CGPoint translation = [pan translationInView:self.view];
     CGFloat direction = [pan velocityInView:self.view].y;
     
     BOOL isMovingUp;
     if (direction < 0) {
          isMovingUp = YES;
     } else {
          isMovingUp = NO;
     }
     
     
     switch (pan.state) {
          case UIGestureRecognizerStateBegan:
               break;
          case UIGestureRecognizerStateChanged:
          {
               CGFloat pannedPosition = self.controlsViewController.controlsView.frame.origin.y + translation.y;
               
               if (isMovingUp && pannedPosition < controlsOpenPos + 50) {
                //    [self toggleControls:YES];
               }
               
               if (!isMovingUp && pannedPosition > controlsClosedPos - 50) {
               //     [self toggleControls:NO];
               }
               
               if (pannedPosition >= controlsOpenPos  && pannedPosition <= controlsClosedPos) {
                    
                    self.controlsViewController.controlsView.center = CGPointMake(self.controlsViewController.controlsView.center.x,
                                                                                  self.controlsViewController.controlsView.center.y + translation.y);
                    float currentPoint = self.controlsViewController.controlsView.frame.origin.y;
                    float originalMin = controlsClosedPos;
                    float originalMax = controlsOpenPos;
          //          float amountOfPie = interpolate(originalMax,originalMin, 2, 1, currentPoint, 1);
                    float amountOfTransformForMainView = interpolate(originalMax,originalMin, MAINVIEWTRANSFORM, 1, currentPoint, 1);
                    
                    float amountOfTransformForMainViewSubViews = interpolate(originalMax,originalMin, 1, MAINVIEWTRANSFORM, currentPoint, 1);

                    
                    CGFloat pivotScaled = interpolate(originalMax, originalMin, 1, 0, currentPoint, 1);
                    CGFloat wingsScaled = interpolate(originalMax, originalMin, 0, 1, currentPoint, 1);

                    self.controlsViewController.controlsView.transportView.expandButton.pivot = pivotScaled;
                    self.controlsViewController.controlsView.transportView.expandButton.wings = wingsScaled;

                    [self.controlsViewController.controlsView.transportView.expandButton setNeedsDisplay];
                //    self.controlsViewController.controlsView.transportView.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI*amountOfPie);
                    self.mainView.transform = CGAffineTransformMakeScale(1, amountOfTransformForMainView);
                    
                    [self.mainView.orbs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         OrbView *orb = obj;
                         orb.transform = CGAffineTransformMakeScale(1, amountOfTransformForMainViewSubViews);
                    }];
                    
                    self.mainView.anchorOrb.transform = CGAffineTransformMakeScale(1, amountOfTransformForMainViewSubViews);
                    
                    CGRect mainFrame = self.mainView.frame;
                    mainFrame.origin = CGPointMake(0, 0);
                    self.mainView.frame = mainFrame;

                    [pan setTranslation:CGPointZero inView:self.controlsViewController.controlsView];
               }
          }
               break;
               
          case UIGestureRecognizerStateEnded:
          {
               
               CGFloat yOrigin = self.controlsViewController.controlsView.frame.origin.y;
               CGFloat dist1 = fabs(yOrigin - controlsClosedPos);
               CGFloat dist2 = fabs(yOrigin - controlsOpenPos);
               
               if (dist1 < dist2) {
                    [self toggleControls:NO];
               } else {
                    [self toggleControls:YES];
               }
          }
               break;
               
          default:
               break;
     }
     }
}

-(void)toggleControls:(BOOL)toggle {
     
     [UIView animateWithDuration:0.15 animations:^{
          [self.view bringSubviewToFront:self.controlsViewController.view];
          CGRect frameControls = self.controlsViewController.view.frame;
          if (toggle) {
               self.mainView.transform = CGAffineTransformMakeScale(1, MAINVIEWTRANSFORM);
               self.controlsViewController.controlsView.transportView.expandButton.pivot = 1;
               self.controlsViewController.controlsView.transportView.expandButton.wings = 0;
               self.controlsViewController.controlsView.transportView.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
               frameControls.origin.y = controlsOpenPos;
               
               CGRect frameReset = self.mainView.frame;
               frameReset.origin = CGPointMake(0, 0);
               self.mainView.frame = frameReset;
          } else {
               self.mainView.transform = CGAffineTransformMakeScale(1, 1);
               self.controlsViewController.controlsView.transportView.expandButton.pivot = 0;
               self.controlsViewController.controlsView.transportView.expandButton.wings = 1;
               CGRect frameReset = self.mainView.frame;
               frameReset.origin = CGPointMake(0, 0);
               self.mainView.frame = frameReset;
               self.controlsViewController.controlsView.transportView.expandButton.imageView.transform = CGAffineTransformMakeRotation(2*M_PI);
               frameControls.origin.y = controlsClosedPos;
          }
          self.controlsViewController.view.frame = frameControls;
     }];
}


-(void)loadStockPreset:(NSArray*)preset {
     
     [[[OrbManager sharedOrbManager] orbModels] removeAllObjects];

     self.mainView.anchorOrb = nil;
     [self.mainView.orbs removeAllObjects];
     
     for (UIView *subview in self.mainView.subviews) {
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
         // orb.autoresizingMask =  UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewContentModeTopLeft;
          [orb setIcon];
          orb.isMaster = model.isMaster;
          orb.backgroundColor = model.isMaster ? [Theme sharedTheme].orbMasterColor :  [Theme sharedTheme].orbColor;
          [orb addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
          [self.mainView addSubview:orb];
          
          [[[OrbManager sharedOrbManager] orbModels] addObject:model];
          if (model.isMaster) {
               self.mainView.anchorOrb = orb;
          } else {
               [self.mainView.orbs addObject:orb];
          }
     }
}

- (CGFloat)_anchorOrbDistanceToOrb:(OrbView *)orb {
     const CGPoint anchorPoint = self.mainView.anchorOrb.center;
     const CGPoint orbPoint = orb.center;
     const CGFloat dx = (anchorPoint.x - orbPoint.x);
     const CGFloat dy = (anchorPoint.y - orbPoint.y);
     float dist = interpolate(0.0f, 500.0f, 0.0f, 100.0f, sqrt(dx*dx + dy*dy), -1.0f);
  //   float dashDist = interpolate(0.0f, 500.0f, 2.0f, 15.0f, sqrt(dx*dx + dy*dy), 0);
     //self.mainView.dashConstant = dashDist;
     return dist;
}



#pragma mark --- presets gestures

- (void)handlePresetsPan:(UIPanGestureRecognizer*)gesture {
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

- (void)didTickWithCount:(int)count {
     for (OrbView* orb in self.mainView.orbs) {
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
     [self.mainView setNeedsDisplay];
}


@end