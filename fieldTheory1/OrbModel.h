//
//  OrbModel.h
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "OrbView.h"



@interface OrbModel : NSObject <NSCoding>

@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSMutableArray* sequence;
@property(nonatomic,assign) float sizeValue;
@property(nonatomic,assign)CGPoint center;
@property(nonatomic,assign)int midiNote;
@property(nonatomic,assign)int idNum;

@property(nonatomic,assign) BOOL isMaster;

@end
