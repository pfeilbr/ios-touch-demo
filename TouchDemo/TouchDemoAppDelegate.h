//
//  TouchDemoAppDelegate.h
//  TouchDemo
//
//  Created by Brian Pfeil on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchDemoView.h"

@interface TouchDemoAppDelegate : NSObject <UIApplicationDelegate> {
    TouchDemoView *_touchDemoView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end
