//
//  OrbModelMaster.h
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrbManager : NSObject
@property(nonatomic,strong)NSMutableArray* orbModels;
+ (OrbManager*)sharedOrbManager;
@end
