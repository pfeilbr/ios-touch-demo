//
//  TouchDemoView.m
//  TouchDemo
//
//  Created by Brian Pfeil on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchDemoView.h"

@implementation TouchDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = YES;
        _touches = [[NSMutableArray alloc] init];
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
        CFURLRef soundURL = (CFURLRef)[[NSURL alloc]
                                       initFileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID(soundURL, &ssid);

        _views = [[NSMutableArray alloc] init];
        CGFloat width = 60;
        CGFloat height = 60;        
        for (int i = 0; i < 11; i++) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            v.backgroundColor = [UIColor redColor];
            v.alpha = 0.0;
            [self addSubview:v];
            [_views addObject:v];
        }
        
        _image = [UIImage imageNamed:@"round_delete"];
    }
    return self;
}

- (UIView*)getNextView {
    UIView *v = [_views objectAtIndex:0];
    [_views removeObjectAtIndex:0];
    v.alpha = 0.5;
    return v;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInView:self];
        
        UIView *v = [self getNextView];
        v.center = p;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:touch forKey:@"touch"];
        [dict setValue:v forKey:@"view"];
        [_touches addObject:dict];
    }
    
	// play sound
    AudioServicesPlaySystemSound(ssid);
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInView:self];
        for (NSMutableDictionary *dict in _touches) {
            UITouch *t = (UITouch*)[dict  valueForKey:@"touch"];            
            UIView *v = (UIView*)[dict valueForKey:@"view"];
            if (t == touch) {
                v.center = p;                
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded");
    __block NSMutableArray *dictsToRemove = [[NSMutableArray alloc] init];
    //[UIView animateWithDuration:0.01 animations:^{
        for (UITouch *touch in touches) {
            for (NSMutableDictionary *dict in _touches) {
                UITouch *t = (UITouch*)[dict  valueForKey:@"touch"];            
                UIView *v = (UIView*)[dict valueForKey:@"view"];
                if (t == touch) {
                    v.alpha = 0.0;
                    [dictsToRemove addObject:dict];
                }
            }
        }
    //} completion:^(BOOL finished) {
        for (NSMutableDictionary *dict in dictsToRemove) {
            UIView *v = (UIView*)[dict valueForKey:@"view"];
            [_views addObject:v];
        }
        [_touches removeObjectsInArray:dictsToRemove];
        [dictsToRemove release];        
    //}];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    //CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSMutableDictionary *dict in _touches) {
        UITouch *t = (UITouch*)[dict  valueForKey:@"touch"];            
        CGPoint tp = [t locationInView:self];
        CGPoint p = CGPointMake( (tp.x - (_image.size.width/2)), (tp.y - (_image.size.height/2)) );
        [_image drawAtPoint:p];
    }
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end
