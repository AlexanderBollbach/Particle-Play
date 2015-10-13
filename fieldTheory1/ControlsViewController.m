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

@interface ControlsViewController () <SequencerViewDelegate, UIScrollViewDelegate>
@property (nonatomic,strong) SequencerView *sequencerView;
@end

@implementation ControlsViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     

}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     
     
     CGFloat sequencerViewOriginY = self.view.frame.size.height/5;
     
     
     
     self.sequencerView = [[SequencerView alloc] initWithFrame:CGRectMake(0,
                                                                                    sequencerViewOriginY,
                                                                                    self.view.frame.size.width,
                                                                                    CGRectGetHeight(self.view.bounds) - sequencerViewOriginY)];
     
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               CGRectGetWidth(self.view.bounds),
                                                                               sequencerViewOriginY)];
     
     scrollView.backgroundColor = [UIColor greenColor];
     
     
     
     UILabel *labeView1 = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    CGRectGetWidth(scrollView.frame),
                                                                    CGRectGetHeight(scrollView.frame))];
     
     UILabel *labeView2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(scrollView.frame),
                                                                    0,
                                                                    CGRectGetWidth(scrollView.frame),
                                                                    CGRectGetHeight(scrollView.frame))];
     
     UILabel *labeView3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(scrollView.frame)*2,
                                                                    0,
                                                                    CGRectGetWidth(scrollView.frame),
                                                                    CGRectGetHeight(scrollView.frame))];
     
     UILabel *labeView4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(scrollView.frame)*3,
                                                                    0,
                                                                    CGRectGetWidth(scrollView.frame),
                                                                    CGRectGetHeight(scrollView.frame))];

     
     
     scrollView.pagingEnabled = YES;
     scrollView.delegate = self;
     scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.frame)*4,
                                         CGRectGetHeight(scrollView.frame));
     
     
     labeView1.text = @"one";
     labeView2.text = @"two";
     labeView3.text = @"three";
     labeView4.text = @"four";

     
     labeView1.textAlignment = NSTextAlignmentCenter;
     labeView2.textAlignment = NSTextAlignmentCenter;
     labeView3.textAlignment = NSTextAlignmentCenter;
     labeView4.textAlignment = NSTextAlignmentCenter;

     [scrollView addSubview:labeView1];
     [scrollView addSubview:labeView2];
     [scrollView addSubview:labeView3];
     [scrollView addSubview:labeView4];

     
     [self.view addSubview:self.sequencerView];
     [self.view addSubview:scrollView];
     
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:0];
     [self.sequencerView loadOrb:someOrb];
     self.view.backgroundColor = [UIColor redColor];
     
     self.sequencerView.delegate = self;

}

- (void)seqTickedWithOrbID:(int)orbID andGridNum:(int)gridNum selected:(BOOL)selected {
     OrbModel *someOrb = [[OrbManager sharedOrbManager] getOrbWithID:orbID];
     [someOrb.sequence replaceObjectAtIndex:(int)gridNum withObject:[NSNumber numberWithBool:selected]];
     
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


@end
