//
//  CockPitView.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "CockPitView.h"

@implementation CockPitView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          
          CGRect row1 = self.bounds;
          row1.size.height /= 4;
          
          CGFloat transportConstant = 5.5;
          
          CGRect col1_A = row1;
          col1_A.size.width /= transportConstant;
          
          CGRect col1_B = row1;
          col1_B.size.width /= transportConstant;
          col1_B.origin.x += col1_A.size.width;
          
          CGRect col1_C = row1;
          col1_C.size.width /= transportConstant;
          col1_C.origin.x = col1_B.origin.x + col1_B.size.width;
          
          CGRect col1_D = row1;
          CGFloat finalWidth = col1_A.size.width * 3;
          col1_D.size.width = row1.size.width - finalWidth;
          col1_D.origin.x = finalWidth;
          
          UIButton *play = [[UIButton alloc] initWithFrame:CGRectInset(col1_A, 5, 5)];
          [play addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          play.selected = YES;
          [play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
          [self addSubview:play];
          
          UIButton *stop = [[UIButton alloc] initWithFrame:CGRectInset(col1_B, 5, 5)];
          [stop addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          stop.selected = YES;
          [stop setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
          [self addSubview:stop];
          
          UIButton *pause = [[UIButton alloc] initWithFrame:CGRectInset(col1_C, 5, 5)];
          [pause addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          pause.selected = YES;
          [pause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
          [self addSubview:pause];

          self.tempoSlider = [[CustomSlider alloc] initWithFrame:CGRectInset(col1_D, 5, 5)];
          [self.tempoSlider addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventValueChanged];
          [self addSubview:self.tempoSlider];
          
          CGRect expandFrame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bounds)/12,
                                          0 - (CGRectGetHeight(self.bounds)/12),
                                          CGRectGetWidth(self.bounds)/12,
                                          CGRectGetHeight(self.bounds)/12);
          self.expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self.expandButton.frame = expandFrame;
          self.expandButton.tag = 3;
          [self.expandButton setImage:[UIImage imageNamed:@"carrot"] forState:UIControlStateNormal];
          [self.expandButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          self.expandButton.backgroundColor = [UIColor whiteColor];
          self.expandButton.tintColor = [UIColor whiteColor];
          [self addSubview:self.expandButton];

     }
     return self;
}




-(void)handleEvent:(id)sender {
     if ([sender isKindOfClass:[CustomSlider class]]) {
          CustomSlider *theSlider = sender;
          theSlider.selected = !theSlider.selected;
          if (self.delegate) {
               [self.delegate sliderChangedWithValue:(int)theSlider.amount];
          }
     }
     if (((UIButton*)sender).tag == 3) {
          UIButton *senderExpand = sender;
          senderExpand.selected = !senderExpand.selected;
          [self.delegate toggleExpand:senderExpand.selected];
     }
     if ([sender isKindOfClass:[PlayPauseButton class]]) {
          PlayPauseButton *theButton = sender;
          theButton.selected = !theButton.selected;
          if (theButton.selected) {
               [theButton animateTriToSquare];
          } else {
               [theButton animateSquareToTri];
          }
          if (self.delegate) {
               [self.delegate playedPaused:theButton.selected];
          }
     }
     
}

@end
