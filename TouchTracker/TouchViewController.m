//
//  TouchViewController.m
//  TouchTracker
//
//  Created by Josh Braun on 2/10/13.
//  Copyright (c) 2013 Josh Braun. All rights reserved.
//

#import "TouchViewController.h"
#import "TouchDrawView.h"

@implementation TouchViewController

-(void)loadView
{
    [self setView:[[TouchDrawView alloc] initWithFrame: CGRectZero]];
}

@end
