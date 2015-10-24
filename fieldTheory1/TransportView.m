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
          col1_B.size.width /= transportConstant;
          col1_B.origin.x += col1_A.size.width;
          
          self.sampleHolderView = [[UIView alloc] initWithFrame:col1_B];
          self.sampleHolderView.backgroundColor = [UIColor clearColor];
          [self addSubview:self.sampleHolderView];
          
          CGRect sampleViewFrame = self.sampleHolderView.bounds;

          CGRect sampleViewCol1 = sampleViewFrame;
          sampleViewCol1.size.width /= 2;
          
          CGRect sampleViewCol2 = self.sampleHolderView.bounds;
          sampleViewCol2.size.width /= 2;
          sampleViewCol2.origin.x += sampleViewCol2.size.width;
          
          CGRect sampleViewGridTL = sampleViewCol1;
          sampleViewGridTL.size.height /= 2;
          
          CGRect sampleViewGridTR = sampleViewCol2;
          sampleViewGridTR.size.height /= 2;
          
          CGRect sampleViewGridBL = sampleViewCol1;
          sampleViewGridBL.size.height /= 2;
          sampleViewGridBL.origin.y += sampleViewGridBL.size.height;
          
          SampleSelectButton *kickButton = [SampleSelectButton buttonWithType:UIButtonTypeCustom];
          kickButton.frame = CGRectInset(sampleViewGridTL, 3, 3);
          kickButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
          [kickButton setImage:[UIImage imageNamed:@"bass"] forState:UIControlStateNormal];
          [kickButton addTarget:self action:@selector(handleSampleButtons:) forControlEvents:UIControlEventTouchUpInside];
          [self.sampleHolderView addSubview:kickButton];
          
          SampleSelectButton *snareButton = [SampleSelectButton buttonWithType:UIButtonTypeCustom];
          snareButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
          snareButton.frame = CGRectInset(sampleViewGridTR, 3, 3);
          [snareButton addTarget:self action:@selector(handleSampleButtons:) forControlEvents:UIControlEventTouchUpInside];
          [snareButton setImage:[UIImage imageNamed:@"snare"] forState:UIControlStateNormal];
          [self.sampleHolderView addSubview:snareButton];
          
          SampleSelectButton *hihatButton = [SampleSelectButton buttonWithType:UIButtonTypeCustom];
          hihatButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
          [hihatButton addTarget:self action:@selector(handleSampleButtons:) forControlEvents:UIControlEventTouchUpInside];
          [hihatButton setImage:[UIImage imageNamed:@"hihat"] forState:UIControlStateNormal];
          hihatButton.frame = CGRectInset(sampleViewGridBL, 3, 3);
          [self.sampleHolderView addSubview:hihatButton];
          
//          CGRect col1_C = row1;
//          col1_C.size.width /= transportConstant;
//          col1_C.origin.x = col1_B.origin.x + col1_B.size.width;
          
          CGRect col1_D = row1;
          CGFloat finalWidth = col1_A.size.width * 2;
          col1_D.size.width = row1.size.width - (finalWidth * 1.25);
          col1_D.origin.x = finalWidth;
          
          PlayPauseButton *play = [[PlayPauseButton alloc] initWithFrame:CGRectInset(col1_A, 5, 5)];
          [play addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          play.selected = YES;
          play.tag = 6;
          play.selected = NO;
          [play animatePauseToPlay];
          [self addSubview:play];

          self.tempoSlider = [[CustomSlider alloc] initWithFrame:CGRectInset(col1_D, 5, 5)];
          [self.tempoSlider addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventValueChanged];
          [self addSubview:self.tempoSlider];
          
          CGRect expandFrame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bounds)/12,
                                          0,
                                          CGRectGetWidth(self.bounds)/12,
                                          CGRectGetHeight(self.bounds)/3);
          self.expandButton = [ExpandButton buttonWithType:UIButtonTypeCustom];
          self.expandButton.frame = CGRectInset(expandFrame, 5, 5);
          self.expandButton.tag = 3;

          [self.expandButton addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
          [self.expandButton setNeedsDisplay];
          [self addSubview:self.expandButton];
     }

     return self;
}

- (void)handleSampleButtons:(UIButton*)sender {
     for (SampleSelectButton *button in self.sampleHolderView.subviews) {
          button.selected = NO;
     }
     sender.selected = !sender.selected;
     [self.delegate loadOrbWithTag:sender.tag];
}


-(void)handleEvent:(id)sender {
     if ([sender isKindOfClass:[CustomSlider class]]) {
          CustomSlider *theSlider = sender;
          theSlider.selected = !theSlider.selected;
          if (self.delegate) {
               [self.delegate sliderChangedWithValue:(int)theSlider.value];
          }
     }
     if ([sender isKindOfClass:[PlayPauseButton class]]) {
          PlayPauseButton *play = sender;
          
          play.selected = !play.selected;
          
          NSLog(@"%i", play.selected);
          
          if (play.selected) {

               [play animatePlayToPause];
               [self.delegate playedPaused:YES];
          } else {
               [self.delegate playedPaused:NO];
               [play animatePauseToPlay];
          }
     }
}

@end
