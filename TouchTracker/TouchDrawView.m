//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Josh Braun on 2/10/13.
//  Copyright (c) 2013 Josh Braun. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    
    if (self) {
        linesInProcess = [[NSMutableDictionary alloc] init];
        
        NSArray *docsDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [docsDirs objectAtIndex: 0];
        
        docsDir = [docsDir stringByAppendingPathComponent:@"lines.archive"];
        
        completeLines = [NSKeyedUnarchiver unarchiveObjectWithFile: docsDir];
        if (!completeLines)
            completeLines = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor: [UIColor whiteColor]];
        
        [self setMultipleTouchEnabled: YES];
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    [[UIColor blackColor] set];
    for (Line *line in completeLines) {
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
    // Draw lines in process in red (Don't copy and paste the previous loop:
    // this one is way different)
    [[UIColor redColor] set];
    for (NSValue *v in linesInProcess) {
        Line *line = [linesInProcess objectForKey: v];
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
}

-(void)clearAll
{
    // Clear the collections
    [linesInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redraw
    [self setNeedsDisplay];
}

// Touch Events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        // Is this a double tap?
        if ([t tapCount] > 1) {
            [self clearAll];
            return;
        }
        
        // Use the touch object (packed in an NSValue) as the key
        NSValue *key = [NSValue valueWithNonretainedObject: t];
        
        // Create a line for the value
        CGPoint loc = [t locationInView: self];
        Line *newLine = [[Line alloc] init];
        [newLine setBegin: loc];
        [newLine setEnd: loc];
        
        // Put pair in dictionary
        [linesInProcess setObject: newLine forKey: key];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Update linesInProcess with moved touches
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject: t];
        
        // Find the line for this touch
        Line *line = [linesInProcess objectForKey: key];
        
        // Update the line
        CGPoint loc = [t locationInView: self];
        [line setEnd: loc];
    }
    // Redraw
    [self setNeedsDisplay];
}

-(void)endTouches:(NSSet *)touches
{
    // Remove ending touches from dictionary
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject: t];
        Line *line = [linesInProcess objectForKey: key];
        
        // If this is a double tap. 'line' will be nil.
        // so make sure not to add it to the array
        if (line) {
            [completeLines addObject: line];
            [linesInProcess removeObjectForKey: key];
        }
    }
    // Redraw
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches: touches];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches: touches];
}

-(BOOL)saveChanges
{
    NSArray *docsDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [docsDirs objectAtIndex: 0];
    
    docsDir = [docsDir stringByAppendingPathComponent:@"lines.archive"];
    
    if ([NSKeyedArchiver archiveRootObject: completeLines toFile: docsDir])
        return YES;
    else
        return NO;
}

@end
