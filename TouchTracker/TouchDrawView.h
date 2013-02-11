//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Josh Braun on 2/10/13.
//  Copyright (c) 2013 Josh Braun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView
{
    NSMutableDictionary *linesInProcess;
    NSMutableArray *completeLines;
}

-(void)clearAll;
-(void)endTouches:(NSSet *)touches;
-(BOOL)saveChanges;

@end
