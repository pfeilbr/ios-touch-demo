//
//  TouchDemoView.h
//  TouchDemo
//
//  Created by Brian Pfeil on 4/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface TouchDemoView : UIView {
    NSMutableArray *_touches;
    NSMutableArray *_views;
    SystemSoundID ssid;
    UIImage *_image;
}

@end
