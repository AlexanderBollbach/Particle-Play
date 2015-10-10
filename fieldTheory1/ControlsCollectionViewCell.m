//
//  ContolsCollectionViewCell.m
//  Particle Play
//
//  Created by alexanderbollbach on 10/3/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "ControlsCollectionViewCell.h"
#import "UIColor+ColorAdditions.h"

@interface SequencerSection : UIButton
@property (nonatomic, assign) NSUInteger column;
@end

@interface ControlsCollectionViewCell()

@property (nonatomic, strong) UIView *infoHolderView;
@property (nonatomic, strong) UIView *seqHolderView;

@end

@implementation SequencerSection
@end

@implementation ControlsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
     if (self = [super initWithFrame:frame]) {

          _infoHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/4)];
          [self.contentView addSubview:_infoHolderView];
          
          _seqHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)/4, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/4*3)];
          [self.contentView addSubview:_seqHolderView];
          
          self.orbName = [[UILabel alloc] init];
          self.orbName.text = @"test";
          self.orbName.textColor = [UIColor whiteColor];
          self.orbName.font = [UIFont systemFontOfSize:24.0f];
          [self.orbName sizeToFit];
          self.orbName.center = CGPointMake(CGRectGetMidX(_infoHolderView.bounds), CGRectGetMidY(_infoHolderView.bounds));
          self.orbName.frame = CGRectIntegral(self.orbName.frame);
          [_infoHolderView addSubview:self.orbName];


          
          self.backgroundColor = [UIColor flatSTTripleColor];
     }
     return self;
}

-(void)layoutSeqWithSeq:(NSArray *)seq {

     float heightRelative = _seqHolderView.bounds.size.height / 4.0;
     float xVal = 0;
     int yVal = 0;
     int counter = 1;
     for (int column = 0; column < 16; column++) {
          BOOL selected = [seq[column] boolValue];
          CGRect gridRect = CGRectMake(xVal,
                                       (heightRelative * yVal) + 1,
                                       _seqHolderView.bounds.size.width / 4.0 - 1,
                                       heightRelative - 2);
          SequencerSection* oneGridView = [[SequencerSection alloc] initWithFrame:gridRect];
          [oneGridView addTarget:self action:@selector(sectionWasSelected:) forControlEvents:UIControlEventTouchUpInside];
          [oneGridView setBackgroundImage:[self imageWithColor:[UIColor flatSTWhiteColor]] forState:UIControlStateNormal];
          [oneGridView setBackgroundImage:[self imageWithColor:[UIColor flatSTEmeraldColor]] forState:UIControlStateSelected];
          oneGridView.selected = [[seq objectAtIndex:column] boolValue] ? YES : NO;
          oneGridView.column = column;
          oneGridView.selected = selected;
          [_seqHolderView addSubview:oneGridView];
          
          xVal += self.bounds.size.width / 4.0;
          
          if (counter % 4 == 0) {
               yVal++;
               xVal = 0;
          }
          counter++;
     }
}

-(void)sectionWasSelected:(SequencerSection *)sender {
     sender.selected = !sender.selected;
     if (self.delegate) {
          [self.delegate seqTickedWithColumn:(int)sender.column
                                       orbId:self.orbID
                                    selected:sender.selected];
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

- (void)layoutSubviews {
     [super layoutSubviews];
     
     [self.orbName sizeToFit];
     self.orbName.center = CGPointMake(CGRectGetMidX(_infoHolderView.bounds), CGRectGetMidY(_infoHolderView.bounds));
     self.orbName.frame = CGRectIntegral(self.orbName.frame);
}


@end
