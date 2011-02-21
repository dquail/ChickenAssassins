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
	SoundClipPool *finishHimClips;
	
	double lastSlapTime;
	
	BOOL slapping;
	BOOL shouldPlayFinishHim;
	
	UIImage *targetImage;
	
	NSMutableString *slapHistory;
	
	int slapCount;
	
	UIProgressView *progressView;
	UIImageView *targetImageView;
	UILabel *statusLabel;
	
}
@property (nonatomic, assign) AssassinsAppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIImageView *targetImageView;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

- (id) initWithTargetImage:(UIImage *)image;

- (IBAction)slapButton;
	
// Resets the hitcount, combination etc.
- (void) resetUsingImage:(UIImage *) image;

@end

