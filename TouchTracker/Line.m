//
//  Line.m
//  TouchTracker
//
//  Created by Josh Braun on 2/10/13.
//  Copyright (c) 2013 Josh Braun. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize begin, end;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGPoint: begin forKey: @"begin"];
    [aCoder encodeCGPoint: end forKey: @"end"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setBegin: [aDecoder decodeCGPointForKey: @"begin"]];
        [self setEnd: [aDecoder decodeCGPointForKey: @"end"]];
    }
    return self;
}

@end
