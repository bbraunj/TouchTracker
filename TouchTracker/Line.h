//
//  Line.h
//  TouchTracker
//
//  Created by Josh Braun on 2/10/13.
//  Copyright (c) 2013 Josh Braun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject <NSCoding>

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
