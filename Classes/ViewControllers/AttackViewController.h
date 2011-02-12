//
//  AttackViewController.h
//  Accelerometer
//
//  Created by David Quail on 01/11/11.
//  Copyright 2011 Invisible Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "ShakeEventSource.h"
#import "SoundClipPool.h"

@class AssassinsAppDelegate;

@interface AttackViewController : UIViewController <ShakeDelegate, SoundClipPoolDelegate> {
	AssassinsAppDelegate *appDelegate;
	ShakeEventSource *shakeEventSource;

	SoundClipPool *slapClips;
	SoundClipPool *responseClips;
	double lastSlapTime;
	
	BOOL slapping;
	
	UIImage *targetImage;
	
	int slapCount;
}
@property (nonatomic, retain) AssassinsAppDelegate *appDelegate;

- (id) initWithTargetImage:(UIImage *)image;
	
@end

