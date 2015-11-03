//
//  UIBezierPath+forEachElement.h
//  PathTest
//
//  Created by alexanderbollbach on 11/1/15.
//  Copyright © 2015 alexanderbollbach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (forEachElement)

- (void)forEachElement:(void (^)(CGPathElement const *element))block;

@end
