//
//  CockPitView.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "TransportView.h"
#import "SampleSelectButton.h"

@interface TransportView()
@property (nonatomic,strong) UIView *sampleHolderView;
@end

@implementation TransportView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {

          CGRect row1 = self.bounds;
          
          CGFloat transportConstant = 5;
          
          CGRect col1_A = row1;
          col1_A.size.width /= transportConstant;
          
          CGRect col1_B = row1;
          col1_B.size.width = (col1_B.size.width / transportConstant) * 3;
          col1_B.origin.x += col1_A.size.width ;

          PlayPauseButton *play = [[PlayPauseButton alloc] initWithFrame:CGRectInset(col1_A, 5, 5)];
          [play addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          play.selected = YES;
          play.tag = 6;
          play.selected = NO;
          [play animatePauseToPlay];
          [self addSubview:play];

          self.tempoSlider = [[CustomSlider alloc] initWithFrame:CGRectInset(col1_B, 5, 5)];
          [self.tempoSlider addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventValueChanged];
          [self addSubview:self.tempoSlider];
          
          CGFloat width = CGRectGetWidth(self.bounds);
          CGFloat height = CGRectGetHeight(self.bounds);
          CGRect expandFrame = CGRectMake(width - (width / 12), 0,width / 12,height / 3);
          self.expandButton = [ExpandButton buttonWithType:UIButtonTypeCustom];
          self.expandButton.frame = CGRectInset(expandFrame, 5, 5);
          self.expandButton.tag = 3;
          [self.expandButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          [self.expandButton setNeedsDisplay];
          [self addSubview:self.expandButton];
     }

     return self;
}

//- (void)handleSampleButtons:(UIButton*)sender {
//     for (SampleSelectButton *button in self.sampleHolderView.subviews) {
//          button.selected = NO;
//     }
//     sender.selected = !sender.selected;
//     [self.delegate loadOrbWithTag:sender.tag];
//}

-(void)handleEvent:(id)sender {
     if ([sender isKindOfClass:[CustomSlider class]]) {
          CustomSlider *theSlider = sender;
          theSlider.selected = !theSlider.selected;
          if (self.delegate) {
               [self.delegate sliderChangedWithValue:(int)theSlider.value];
          }
     }
     if ([sender isKindOfClass:[ExpandButton class]]) {
          ExpandButton *expand = sender;
          expand.selected = !expand.selected;
          if (self.delegate) {
               [self.delegate toggleExpand:expand.selected];
          }
     }
     if ([sender isKindOfClass:[PlayPauseButton class]]) {
      
          PlayPauseButton *play = sender;
          play.selected = !play.selected;

          if (play.selected) {
               [play animatePlayToPause];
               [self.delegate playedPaused:YES];
          } else {
               [play animatePauseToPlay];
               [self.delegate playedPaused:NO];
          }
     }
}

@end
