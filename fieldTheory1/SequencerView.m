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
#import "SequencerGridButton.h"


@interface SequencerView()
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
          self.gridArray = [NSMutableArray array];
          self.backgroundColor = [UIColor clearColor];
          
          CGRect row1 = self.bounds; // row 2 = sequencer Grid
    
          self.gridView = [[UIView alloc] initWithFrame:row1];
          [self addSubview:self.gridView];
          self.gridView.backgroundColor = [UIColor clearColor];
     }
     return self;
}




- (void)didTick:(NSNotification*)notification {
     int count = [notification.userInfo[@"count"] intValue];
     [self animateWithCount:count];
}



- (void)displayOrbInSequencerWith:(NSArray *)sequence {
     
     float incrementingHeight = self.gridView.bounds.size.height / 4.0;
     float xVal = 0;
     int yVal = 0;
     int counter = 1;
     
     for (int gridNum = 0; gridNum < 16; gridNum++) {
          CGRect gridRect = CGRectMake(xVal,
                                       (incrementingHeight * yVal),
                                       CGRectGetWidth(self.gridView.bounds) / 4.0,
                                       incrementingHeight);
          
          SequencerGridButton *oneGridView = [[SequencerGridButton alloc] initWithFrame:CGRectInset(gridRect, 2, 2)];
          [oneGridView addTarget:self action:@selector(sectionWasSelected:) forControlEvents:UIControlEventTouchUpInside];
          oneGridView.selected = [[sequence objectAtIndex:counter-1] boolValue] ? YES : NO;
          oneGridView.seqGridNum = counter;
          oneGridView.tag = gridNum + 1; // not 0 indexed, grids are 1-16
          oneGridView.layer.borderColor = [Theme sharedTheme].bordersColor.CGColor;
          oneGridView.layer.borderWidth = [Theme sharedTheme].borderWidth;
          
          [self.gridView addSubview:oneGridView];
          [self.gridArray addObject:oneGridView];
          
          // proceed grid layout coordinates
          xVal += CGRectGetWidth(self.bounds) / 4.0;
          if (counter % 4 == 0) {  // next line od grid
               yVal++;
               xVal = 0;
          }
          counter++;
     }
}

-(void)animateWithCount:(int)count {
     
     [UIView animateWithDuration:0.4 animations:^{
          UIView *someGrid = [self.gridArray objectAtIndex:count];
          someGrid.layer.borderWidth  = 5;
     } completion:^(BOOL finished) {
          UIView *someGrid = [self.gridArray objectAtIndex:count];
          someGrid.layer.borderWidth = [Theme sharedTheme].borderWidth;
     }];
}

-(void)loadOrb:(OrbModel*)orb {
     self.orbID = orb.idNum;
     [self displayOrbInSequencerWith:orb.sequence];
}

- (void)sectionWasSelected:(SequencerGridButton *)sender {
     //    sender.selected = !sender.selected;
     if (self.delegate) {
          [self.delegate seqTickedWithOrbID:(int)self.orbID
                                 andGridNum:(int)sender.seqGridNum
                                   selected:sender.selected];
     }
}

@end
