//
//  ControlsViewController.h
//  Particle Play
//
//  Created by alexanderbollbach on 10/2/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
//#import "ControlsView.h"
@class ControlsView;

@interface ControlsViewController : UIViewController
@property (nonatomic,strong) MainViewController *mainViewController;
@property (nonatomic,strong) ControlsView *controlsView;

@end
