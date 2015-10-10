//
//  OrbModelMaster.m
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "OrbManager.h"

@implementation OrbManager
+ (OrbManager*)sharedOrbManager {
     static OrbManager *orbModelMaster = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
          orbModelMaster = [[self alloc] init];
     });
     return orbModelMaster;
}

-(instancetype)init {
     if (self = [super init]) {
          self.orbModels = [[NSMutableArray alloc] init];
     }
     return self;
}

@end
