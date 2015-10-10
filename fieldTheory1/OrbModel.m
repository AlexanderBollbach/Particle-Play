//
//  OrbModel.m
//  fieldTheory1
//
//  Created by alexanderbollbach on 9/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import "OrbModel.h"

@implementation OrbModel

-(instancetype)init {
     if (self = [super init]) {
     }
     return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
     [aCoder encodeObject:[NSNumber numberWithInt:self.midiNote] forKey:@"midiNote"];
     [aCoder encodeObject:self.name forKey:@"name"];
     [aCoder encodeObject:self.sequence forKey:@"sequence"];
     [aCoder encodeObject:[NSValue valueWithCGPoint:self.center] forKey:@"center"];
     [aCoder encodeObject:[NSNumber numberWithFloat:self.sizeValue] forKey:@"sizeValue"];
     [aCoder encodeObject:[NSNumber numberWithBool:self.isMaster] forKey:@"isMaster"];

     [aCoder encodeObject:[NSNumber numberWithInt:self.idNum] forKey:@"idNum"];

}


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
     if (self = [super init]) {
          self.name = [aDecoder decodeObjectForKey:@"name"];
          self.sequence = [aDecoder decodeObjectForKey:@"sequence"];
          self.midiNote = [[aDecoder decodeObjectForKey:@"midiNote"] intValue];
          self.center = [[aDecoder decodeObjectForKey:@"center"] CGPointValue];
          self.sizeValue = [[aDecoder decodeObjectForKey:@"sizeValue"] floatValue];
          self.isMaster = [[aDecoder decodeObjectForKey:@"isMaster"] boolValue];
          self.idNum = [[aDecoder decodeObjectForKey:@"idNum"] intValue];

     }
     return self;
}


@end
