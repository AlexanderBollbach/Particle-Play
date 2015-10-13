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

@end

@implementation SequencerView


-(void)loadOrb:(OrbModel*)orb {
     self.orbID = orb.idNum;
     [self layoutSeqWithSeq:orb.sequence];
}


-(void)layoutSeqWithSeq:(NSArray *)seq {
     
     float heightRelative = self.bounds.size.height / 4.0;
     float xVal = 0;
     int yVal = 0;
     int counter = 1;
     for (int gridNum = 0; gridNum < 16; gridNum++) {
          BOOL selected = [seq[gridNum] boolValue];
          CGRect gridRect = CGRectMake(xVal,
                                       (heightRelative * yVal) + 1,
                                       self.bounds.size.width / 4.0 - 1,
                                       heightRelative - 2);
          SequencerSection *oneGridView = [[SequencerSection alloc] initWithFrame:gridRect];
          [oneGridView addTarget:self action:@selector(sectionWasSelected:) forControlEvents:UIControlEventTouchUpInside];
          [oneGridView setBackgroundImage:[self imageWithColor:[UIColor flatSTWhiteColor]] forState:UIControlStateNormal];
          [oneGridView setBackgroundImage:[self imageWithColor:[UIColor flatSTEmeraldColor]] forState:UIControlStateSelected];
          oneGridView.selected = [[seq objectAtIndex:gridNum] boolValue] ? YES : NO;
          oneGridView.seqGridNum = gridNum;
          oneGridView.selected = selected;
          [self addSubview:oneGridView];
          
          xVal += self.bounds.size.width / 4.0;
          
          if (counter % 4 == 0) {
               yVal++;
               xVal = 0;
          }
          counter++;
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


-(void)sectionWasSelected:(SequencerSection *)sender {
     sender.selected = !sender.selected;
     if (self.delegate) {
          [self.delegate seqTickedWithOrbID:(int)self.orbID andGridNum:(int)sender.seqGridNum selected:sender.selected];
     }
}


-(void)animateWithCount:(int)count {
     SequencerSection *someSection;
     for (SequencerSection *section in self.subviews) {
          if (section.seqGridNum == count) {
               someSection = section;
          }
     }
     CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
     strokeAnim.fromValue         = (id) [UIColor blackColor].CGColor;
     strokeAnim.toValue           = (id) [UIColor purpleColor].CGColor;
     strokeAnim.duration          = 0.2;
     [someSection.layer addAnimation:strokeAnim forKey:nil];
}

@end
