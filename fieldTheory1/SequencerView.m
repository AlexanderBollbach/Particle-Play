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
@property (nonatomic,strong) UIView *selectSampleView;
@end

@implementation SequencerView

-(void)loadOrb:(OrbModel*)orb {
     self.orbID = orb.idNum;
     [self layoutSeqWithSeq:orb.sequence];
}

-(void)handleSampleButton:(UIButton*)sender {
     
     for (UIView *view in self.selectSampleView.subviews) {
          view.tintColor = [UIColor whiteColor];
     }
     sender.tintColor = [UIColor orangeColor];
     [self.delegate loadOrbWithTag:sender.tag];
}

-(void)setupSequencerViews {
     
     self.clipsToBounds = YES;
     
     // row = choose sample View
     CGRect row1 = self.bounds;
     row1.size.height /= 4;

     self.selectSampleView = [[UIView alloc] initWithFrame:row1];
     self.selectSampleView.backgroundColor = [UIColor clearColor];
     [self addSubview:self.selectSampleView];
     
     // choose sample button
     CGRect col1 = self.selectSampleView.bounds;
     col1.size.width /= 3;
     
     CGRect col2 = col1;
     col2.origin.x += col2.size.width;
     
     CGRect col3 = col2;
     col3.origin.x += col3.size.width;
     
     UIButton *kickButton = [UIButton buttonWithType:UIButtonTypeSystem];
     kickButton.tag = 0;
     kickButton.tintColor = [UIColor whiteColor];
     [kickButton setImage:[UIImage imageNamed:@"bass"] forState:UIControlStateNormal];
     kickButton.frame = col1;
     [self.selectSampleView addSubview:kickButton];
     [kickButton addTarget:self action:@selector(handleSampleButton:) forControlEvents:UIControlEventTouchUpInside];
     kickButton.tintColor = [UIColor orangeColor];
     
     UIButton *snareButton = [UIButton buttonWithType:UIButtonTypeSystem];
          snareButton.tintColor = [UIColor whiteColor];
     snareButton.tag = 1;
     [snareButton setImage:[UIImage imageNamed:@"snare"] forState:UIControlStateNormal];
     snareButton.frame = col2;
     [self.selectSampleView addSubview:snareButton];
     [snareButton addTarget:self action:@selector(handleSampleButton:) forControlEvents:UIControlEventTouchUpInside];

     UIButton *hihatButton = [UIButton buttonWithType:UIButtonTypeSystem];
          hihatButton.tintColor = [UIColor whiteColor];
     hihatButton.tag = 2;
     [hihatButton setImage:[UIImage imageNamed:@"hihat"] forState:UIControlStateNormal];
     hihatButton.frame = col3;
     [self.selectSampleView addSubview:hihatButton];
     [hihatButton addTarget:self action:@selector(handleSampleButton:) forControlEvents:UIControlEventTouchUpInside];
     
     // row 2 = sequencer Grid
     CGRect row2 = row1;
     row2.origin.y = row1.size.height;
     row2.size.height = self.bounds.size.height - row1.size.height;
     
     self.seqContainerView = [[UIView alloc] initWithFrame:row2];
     self.seqBGContainerView = [[UIView alloc] initWithFrame:self.seqContainerView.bounds];
     self.seqBGOrderedList = [NSMutableArray array];

     float heightRelative = self.seqBGContainerView.bounds.size.height / 4.0;
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
     
     [self.seqContainerView addSubview:self.seqBGContainerView];
     [self addSubview:self.seqContainerView];
     self.seqContainerView.backgroundColor = [UIColor clearColor];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(didTick:)
                                                  name:@"didTick"
                                                object:nil];
     
}

- (void)layoutSeqWithSeq:(NSArray *)seq {
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
          [self.delegate seqTickedWithOrbID:(int)self.orbID
                                 andGridNum:(int)sender.seqGridNum
                                   selected:sender.selected];
     }
}


-(void)animateWithCount:(int)count {
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
