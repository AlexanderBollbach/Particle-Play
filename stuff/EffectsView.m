//
//  CockPitView.m
//  Particle Player
//
//  Created by alexanderbollbach on 10/21/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "EffectsView.h"
#import "SampleSelectButton.h"
#import "Theme.h"

@interface EffectsView()

@property (nonatomic,strong) UIImage *orbIm;
@property (nonatomic,strong) UIImageView *orbImView;
@property (nonatomic,assign) int orbID;
@property (nonatomic,strong) UIButton *revButton;
@property (nonatomic,strong) UIButton *hpButton;
@property (nonatomic,strong) UIButton *lpButton;
@property (nonatomic,strong) UIButton *dlButton;

@end

@implementation EffectsView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {

          CGRect row1 = self.bounds;


          CGFloat transportConstant = 6;
          
          CGRect col1_A = row1;
          col1_A.size.width /= transportConstant;
          
          CGRect col1_B = col1_A;
          col1_B.size.width = col1_A.size.width;
          col1_B.origin.x += col1_A.size.width ;

          CGRect col1_C = col1_B;
          col1_C.size.width = col1_A.size.width;
          col1_C.origin.x += col1_A.size.width ;

          CGRect col1_D = col1_C;
          col1_D.size.width = col1_A.size.width;
          col1_D.origin.x += col1_A.size.width ;
          
          CGRect col1_E = col1_D;
          col1_E.size.width = col1_A.size.width;
          col1_E.origin.x += col1_A.size.width ;
          
          CGRect col1_F = col1_E;
          col1_F.size.width = col1_A.size.width;
          col1_F.origin.x += col1_A.size.width ;

          CGFloat inset = col1_A.size.width / 10;
         
          self.lpButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self.dlButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self.hpButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self.expandButton = [ExpandButton buttonWithType:UIButtonTypeCustom];
         // self.expandButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
          self.revButton = [UIButton buttonWithType:UIButtonTypeCustom];
          self.orbImView = [[UIImageView alloc] initWithFrame:CGRectInset(col1_A, 10, 10)];

          self.revButton.tag = 1;
          self.hpButton.tag = 2;
          self.lpButton.tag = 3;
          self.expandButton.tag = 5;
          self.dlButton.tag = 4;
          
          self.revButton.frame = CGRectInset(col1_B, inset, inset);
          self.hpButton.frame =  CGRectInset(col1_C, inset, inset);
          self.lpButton.frame =  CGRectInset(col1_D, inset, inset);
          self.dlButton.frame =  CGRectInset(col1_E, inset, inset);
          self.expandButton.frame = CGRectInset(col1_F, inset, inset);
          
          [self.lpButton addTarget:self
                            action:@selector(handleEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
          [self.dlButton addTarget:self
                            action:@selector(handleEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
          [self.hpButton addTarget:self
                            action:@selector(handleEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
          [self.revButton addTarget:self
                             action:@selector(handleEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
          [self.expandButton addTarget:self
                                action:@selector(handleEvent:)
                      forControlEvents:UIControlEventTouchUpInside];
          
          self.revButton.backgroundColor = [Theme sharedTheme].mainFillColor;
          self.hpButton.backgroundColor = [Theme sharedTheme].mainFillColor;
          self.dlButton.backgroundColor = [Theme sharedTheme].mainFillColor;
          self.lpButton.backgroundColor = [Theme sharedTheme].mainFillColor;
          self.orbImView.backgroundColor = [UIColor clearColor];
          self.expandButton.backgroundColor = [UIColor clearColor];

          [self.dlButton setTitle:@"Delay"
                           forState:UIControlStateNormal];
          [self.hpButton setTitle:@"HP"
                         forState:UIControlStateNormal];
          [self.revButton setTitle:@"Rev"
                          forState:UIControlStateNormal];
          [self.lpButton setTitle:@"LP"
                         forState:UIControlStateNormal];

          self.dlButton.titleLabel.font = [UIFont systemFontOfSize:10];
          self.revButton.titleLabel.font = [UIFont systemFontOfSize:10];
          self.lpButton.titleLabel.font = [UIFont systemFontOfSize:10];
          self.hpButton.titleLabel.font = [UIFont systemFontOfSize:10];

          
          self.dlButton.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
          self.revButton.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
          self.hpButton.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
          self.lpButton.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;

          self.hpButton.layer.borderWidth = 0;
          self.dlButton.layer.borderWidth = 0;
          self.lpButton.layer.borderWidth = 0;
          self.revButton.layer.borderWidth = 0;
          

          [self addSubview:self.hpButton];
          [self addSubview:self.revButton];
          [self addSubview:self.dlButton];
          [self addSubview:self.orbImView];
          [self addSubview:self.lpButton];
          [self addSubview:self.expandButton];

          [self.expandButton setNeedsDisplay];
     }
     return self;
}


-(void)loadOrbWithID:(int)orbID andRev:(BOOL)rev hp:(BOOL)hp lp:(BOOL)lp dist:(BOOL)dist
             orbName:(NSString*)orbName {

     self.orbID = orbID;
     self.orbImView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_white",orbName]];

     self.revButton.selected = rev;
     self.revButton.layer.borderWidth =  rev ? 5 : 0;

     self.hpButton.selected = hp;
     self.hpButton.layer.borderWidth =  hp ? 5 : 0;

     self.lpButton.selected = lp;
     self.lpButton.layer.borderWidth =  lp ? 5 : 0;

     self.dlButton.selected = dist;
     self.dlButton.layer.borderWidth =  dist ? 5 : 0;

}



-(void)handleEvent:(id)sender {

     if ([sender isKindOfClass:[ExpandButton class]]) {
          ExpandButton *expand = sender;

          expand.selected = !expand.selected;
          if (self.delegate) {
               [self.delegate toggle:expand.selected];
          }
     } else {
          UIButton *but = sender;
          but.selected = !but.selected;
          but.layer.borderWidth = but.selected ? 5 : 0;
          
          [self.delegate setEffectForOrbWithID:self.orbID effectTag:(int)but.tag selected:but.selected];
     }
}

@end
