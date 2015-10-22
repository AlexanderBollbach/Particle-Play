//
//  SequencerView.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "SequencerView.h"
#import "UIColor+ColorAdditions.h"
#import "Theme.h"
#import "SampleSelectButton.h"

@interface SequencerSection : UIButton
@property (nonatomic, assign) NSUInteger seqGridNum;
@end

@implementation SequencerSection
@end

@interface SequencerView()
//@property (nonatomic,strong) UIView *seqBGContainerView;
@property (nonatomic,strong) NSMutableArray *gridArray;
@property (nonatomic,strong) UIView *selectSampleView;
@end

@implementation SequencerView

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {
          // get ticks from sequencer to drive animating of grids
          [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(didTick:)
                                                       name:@"didTick"
                                                     object:nil];
     }
     return self;
}


-(void)setupSequencerViews {

     // row = choose sample View
     CGRect row1 = self.bounds;
     row1.size.height /= 4;
     
     // row 2 = sequencer Grid
     CGRect row2 = row1;
     row2.origin.y = row1.size.height;
     row2.size.height = self.bounds.size.height - row1.size.height;

     [self sampleButtonsWithRect:row1];
     [self layoutGridViewWithFrame:row2];
}

- (void)layoutSeqWithSeq:(NSArray *)seq {
     NSInteger counter = 0;

     
     for (UIView *view in self.gridArray) {
          
          [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               [obj removeFromSuperview];
          }];
          
          CGRect frame =  CGRectInset(view.bounds, 3, 3);
          SequencerSection *oneGridView = [[SequencerSection alloc] initWithFrame:frame];
          
          [oneGridView addTarget:self action:@selector(sectionWasSelected:) forControlEvents:UIControlEventTouchUpInside];

          [oneGridView setBackgroundImage:nil forState:UIControlStateNormal];
          oneGridView.backgroundColor = [UIColor clearColor];
          
          [oneGridView setBackgroundImage:[self imageWithColor:[Theme sharedTheme].gridSelectedColor] forState:UIControlStateSelected];
          oneGridView.selected = [[seq objectAtIndex:counter] boolValue] ? YES : NO;
          oneGridView.seqGridNum = counter;

          oneGridView.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor; // set color as you want.
          oneGridView.layer.borderWidth = [Theme sharedTheme].borderWidth; // set as you want.
          
          [view addSubview:oneGridView];
          counter++;
     }
}

-(void)animateWithCount:(int)count {
    
     [UIView animateWithDuration:0.1 animations:^{
         ((SequencerSection*)[self.gridArray objectAtIndex:count]).backgroundColor = [UIColor redColor];
     } completion:^(BOOL finished) {
          ((SequencerSection*)[self.gridArray objectAtIndex:count]).backgroundColor = [UIColor clearColor];
     }];
}

-(void)layoutGridViewWithFrame:(CGRect)frame {
     
     self.gridView = [[UIView alloc] initWithFrame:frame];
     self.gridView.backgroundColor = [UIColor clearColor];
     [self addSubview:self.gridView];
     self.gridArray = [NSMutableArray array]; // to hold background grids in sorted sequence to find late
     
     float incrementingHeight = self.gridView.bounds.size.height / 4.0;
     float xVal = 0;
     int yVal = 0;
     int counter = 1;
     
     for (int gridNum = 0; gridNum < 16; gridNum++) {
          CGRect gridRect = CGRectMake(xVal,
                                       (incrementingHeight * yVal),
                                       CGRectGetWidth(self.bounds) / 4.0,
                                       incrementingHeight);
          UIView *oneGridView = [[UIView alloc] initWithFrame:gridRect];
          oneGridView.tag = gridNum + 1; // not 0 indexed, grids are 1-16
          oneGridView.backgroundColor = [UIColor clearColor];
          xVal += CGRectGetWidth(self.bounds) / 4.0;
          if (counter % 4 == 0) {  // next line od grid
               yVal++;
               xVal = 0;
          }
          counter++;
          [self.gridView addSubview:oneGridView];
          [self.gridArray addObject:oneGridView];
     }

}


- (UIImage *)imageWithColor:(UIColor *)color {
     
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0, 1.0), true, [[UIScreen mainScreen] scale]);
     [color setFill];
     UIRectFill(CGRectMake(0.0, 0.0, 1.0, 1.0));
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return image;
}


- (void)didTick:(NSNotification*)notification {
     int count = [notification.userInfo[@"count"] intValue];
     [self animateWithCount:count];
}

- (void)handleSampleButton:(UIButton*)sender {
     
//     for (UIView *view in self.selectSampleView.subviews) {
//          if ([view isKindOfClass:[UIButton class]]) {
//               UIButton *button = (UIButton*)view;
//               button.selected = NO;
//               button.tintColor = [UIColor clearColor];
//          }
//
//     }
//     sender.selected = !sender.selected;
//     sender.tintColor = [UIColor orangeColor];
     [self.delegate loadOrbWithTag:sender.tag];
}



-(void)loadOrb:(OrbModel*)orb {
     self.orbID = orb.idNum;
     [self layoutSeqWithSeq:orb.sequence];
}

- (void)sectionWasSelected:(SequencerSection *)sender {
     sender.selected = !sender.selected;
     if (self.delegate) {
          [self.delegate seqTickedWithOrbID:(int)self.orbID
                                 andGridNum:(int)sender.seqGridNum
                                   selected:sender.selected];
     }
}


-(void)sampleButtonsWithRect:(CGRect)rect {
   
     self.selectSampleView = [[UIView alloc] initWithFrame:rect];
     self.selectSampleView.backgroundColor = [UIColor clearColor];
     [self addSubview:self.selectSampleView];
     
     CGRect col1 = self.selectSampleView.bounds;
     col1.size.width /= 3;
     
     CGRect col2 = col1;
     col2.origin.x += col2.size.width;
     
     CGRect col3 = col2;
     col3.origin.x += col3.size.width;
     
     UIButton *kickButton = [SampleSelectButton buttonWithType:UIButtonTypeCustom];
     kickButton.tag = 0;
     [kickButton setImage:[UIImage imageNamed:@"bass"] forState:UIControlStateNormal];
     kickButton.frame = CGRectInset(col1, 5, 5);
     [self.selectSampleView addSubview:kickButton];
     [kickButton addTarget:self action:@selector(handleSampleButton:) forControlEvents:UIControlEventTouchUpInside];
     
     UIButton *snareButton = [SampleSelectButton buttonWithType:UIButtonTypeCustom];
     snareButton.tag = 1;
     [snareButton setImage:[UIImage imageNamed:@"snare"] forState:UIControlStateNormal];
     snareButton.frame = CGRectInset(col2, 5, 5);
     [self.selectSampleView addSubview:snareButton];
     [snareButton addTarget:self action:@selector(handleSampleButton:) forControlEvents:UIControlEventTouchUpInside];
     
     UIButton *hihatButton = [SampleSelectButton buttonWithType:UIButtonTypeCustom];
     hihatButton.tag = 2;
     [hihatButton setImage:[UIImage imageNamed:@"hihat"] forState:UIControlStateNormal];
     hihatButton.frame = CGRectInset(col3, 5, 5);
     [self.selectSampleView addSubview:hihatButton];
     [hihatButton addTarget:self action:@selector(handleSampleButton:) forControlEvents:UIControlEventTouchUpInside];
}

@end
