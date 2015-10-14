//
//  SequencerView.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/12/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "SequencerView.h"
#import "UIColor+ColorAdditions.h"

@interface SequencerSection : UIButton
@property (nonatomic, assign) NSUInteger seqGridNum;
@end

@implementation SequencerSection
@end

@interface SequencerView()
@property (nonatomic,strong) UIView *seqBGContainerView;
@property (nonatomic,strong) NSMutableArray *seqBGOrderedList;
@end

@implementation SequencerView

-(void)loadOrb:(OrbModel*)orb {
     self.orbID = orb.idNum;
     [self layoutSeqWithSeq:orb.sequence];
}

-(void)initSequencerBG {
     
     self.seqBGContainerView = [[UIView alloc] initWithFrame:self.bounds];
     self.seqBGOrderedList = [NSMutableArray array];
     float heightRelative = self.bounds.size.height / 4.0;
     float xVal = 0;
     int yVal = 0;
     int counter = 1;
     for (int gridNum = 0; gridNum < 16; gridNum++) {
          CGRect gridRect = CGRectMake(xVal,
                                       (heightRelative * yVal),
                                       self.bounds.size.width / 4.0,
                                       heightRelative );
          UIView *oneGridView = [[UIView alloc] initWithFrame:gridRect];
          oneGridView.tag = gridNum + 1;
          oneGridView.backgroundColor = [UIColor clearColor];
                  xVal += self.bounds.size.width / 4.0;
          if (counter % 4 == 0) {
               yVal++;
               xVal = 0;
          }
          counter++;
          [self.seqBGContainerView addSubview:oneGridView];
          [self.seqBGOrderedList addObject:oneGridView];
     }
     [self addSubview:self.seqBGContainerView];
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(didTick:)
                                                  name:@"didTick"
                                                object:nil];
     
}

-(void)layoutSeqWithSeq:(NSArray *)seq {
     
     NSInteger counter = 0;
     for (UIView *view in self.seqBGOrderedList) {
          CGRect frame =  CGRectInset(view.bounds, 3, 3);
          SequencerSection *oneGridView = [[SequencerSection alloc] initWithFrame:frame];
          [oneGridView addTarget:self action:@selector(sectionWasSelected:) forControlEvents:UIControlEventTouchUpInside];
          [oneGridView setBackgroundImage:[self imageWithColor:[UIColor flatSTWhiteColor]] forState:UIControlStateNormal];
          [oneGridView setBackgroundImage:[self imageWithColor:[UIColor flatSTEmeraldColor]] forState:UIControlStateSelected];
          oneGridView.selected = [[seq objectAtIndex:counter] boolValue] ? YES : NO;
          oneGridView.seqGridNum = counter;
          [view addSubview:oneGridView];
          counter++;
     }
}



-(void)sectionWasSelected:(SequencerSection *)sender {
     sender.selected = !sender.selected;
     if (self.delegate) {
          [self.delegate seqTickedWithOrbID:(int)self.orbID andGridNum:(int)sender.seqGridNum selected:sender.selected];
     }
}


-(void)animateWithCount:(int)count {
 //    NSLog(@"%i", count);
     SequencerSection *someSection;
     for (SequencerSection *section in self.seqBGContainerView.subviews) {
          if (section.tag - 1 == count) {
               someSection = section;
          }
          
     }
     [UIView animateWithDuration:0.1 animations:^{
          someSection.backgroundColor = [UIColor blackColor];
     } completion:^(BOOL finished) {
          someSection.backgroundColor = [UIColor clearColor];
     }];
}



- (UIImage *)imageWithColor:(UIColor *)color {
     
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0, 1.0), true, [[UIScreen mainScreen] scale]);
     [color setFill];
     UIRectFill(CGRectMake(0.0, 0.0, 1.0, 1.0));
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return image;
}


-(void)didTick:(NSNotification*)notification {
     int count = [notification.userInfo[@"count"] intValue];
     [self animateWithCount:count];
}

@end
