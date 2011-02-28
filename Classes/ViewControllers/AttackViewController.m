//
//  AttackViewController.m
//  Accelerometer
//
//  Created by David Quail on 01/11/11.
//  Copyright 2011 Invisible Software Inc. All rights reserved.
//

#import "AttackViewController.h"
#import "AttackCompletedViewController.h"
#import "AssassinsAppDelegate.h"

@interface AttackViewController (Private)
- (void) finishKill;
@end

@implementation AttackViewController

@synthesize appDelegate, progressView, targetImageView, statusLabel;

#define MAX_PAST_ACCELERATION_EVENTS 2

#define NONSHAKE_DELTA 0.4
#define SHAKE_DELTA 2.0
#define HITS_TO_KILL 5
#define HITS_TO_FINISH_HIM 5
#define HITS_FOR_RESPONSE 4  //Only occasionally will responses be played

- (IBAction)slapButton {
	[self slap];
}

- (void) completeInitialization {
	shakeEventSource = [[ShakeEventSource alloc] init];	
	[shakeEventSource addDelegate: self];

	[self.appDelegate.attackInfo.hitCombo setString:@""];
	/*
	 * Create slap clips
	 */
	slapClips = [[SoundClipPool alloc] init];
	slapClips.delegate = self;
	
	NSString *slapURLs[] = {
		@"slap_splat_3.caf",
		@"slap_bonk.caf",
		@"slap_hard_1.caf",
//		@"slap_hard_2.caf",
//		@"slap_light_1.caf",
		@"slap_light_2.caf",
//		@"slap_ow.caf",
//		@"slap_splat_1.caf",
//		@"slap_splat_4.caf",
		@"slap_squeak.caf",
//		@"slap01.caf",
//		@"slap02.caf",
//		@"slap03.caf",
//		@"slap04.caf",
//		@"slap05.caf",
		@"slap06.caf",
//		@"slap07.caf",
		@"slap08.caf",
		@"slap.caf",
//		@"slap2.caf",
		@"slap3.caf",
//		@"slap4.caf",
//		@"slap5.caf",
//		@"slap6.caf",
//		@"slap7.caf",
	};
	
	for (int i = 0; i < (sizeof(slapURLs) / sizeof(slapURLs[0])); i++) {
		NSURL *slapURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: slapURLs[i]];
		AVAudioPlayer *slapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: slapURL error: NULL];
		[slapClips addSoundClip: slapSound];
	}
	
	lastSlapTime = CACurrentMediaTime();
	
	responseClips = [[SoundClipPool alloc] init];
	//responseClips.delegate = self;
	
	/*
	 * Create response clips
	 */
	NSString *responseURLs[] = {
//		@"ah.caf",
//		@"dude.caf",
		//@"excellent.caf",
//		@"hey.caf",
//		@"stopit.caf",
//		@"whatthehell.caf",
//		@"isthatachicken.caf",
//		@"oof.caf",
//		@"ow.caf",
//		@"thathurts.caf",
//		@"threat.caf",
//		@"ah2.caf",
		@"chicken_squawk1.caf",
		@"chicken_squawk2.caf",
//		@"dude2.caf",
		@"dude3.caf",
		@"hesgotarubberchicken.caf",
//		@"hey_ow.caf",
//		@"hey2.caf",
//		@"hey3.caf",
		@"isthatarubberchicken.caf",
//		@"oomf1.caf",
//		@"ow_whine.caf",
		@"ow2.caf",
//		@"ow3.caf",
//		@"ow4.caf",
		@"stopit2.caf",
//		@"uhh2.caf",
//		@"uhh3.caf",
//		@"uhh4.caf",
		@"umm_ouch.caf",
//		@"what_the1.caf",
//		@"what_the2.caf",
//		@"what_the3.caf",
//		@"uhh.caf",
		@"whatthehell.caf",
		//@"godlike.caf",
		//@"firstblood.caf",
		//@"holyshit.caf",
		//@"ludicrouskill.caf",
		//@"pathetic.caf",
		//@"prepare.caf",
		//@"rampage.caf",
		//@"wickedsick.caf",
	};
	
	for (int i = 0; i < (sizeof(responseURLs) / sizeof(responseURLs[0])); i++) {
		NSURL *url = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: responseURLs[i]];
		
		AVAudioPlayer *clip = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
		[responseClips addSoundClip: clip];
	}
	
	[NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(checkIfStillSlapping) userInfo: nil repeats: YES];
	
	/*
	 * Create Finish him clips
	 */
	finishHimClips = [[SoundClipPool alloc] init];	
	NSString *finishURLs[] = {
		@"finishhim.caf",
		@"punishhim.caf",
	};
	
	for (int i = 0; i < (sizeof(finishURLs) / sizeof(finishURLs[0])); i++) {
		NSURL *url = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: finishURLs[i]];
		
		AVAudioPlayer *clip = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
		[finishHimClips addSoundClip: clip];
	}
	
	
}

- (void) resetUsingImage:(UIImage *) image{
	if (targetImage!=image){
		self.appDelegate.attackInfo = [[AttackInfo alloc] init];
		[targetImage release];
		targetImage = [image retain];
		self.targetImageView.image = targetImage;
		self.statusLabel.text = @"Attack using your chicken!";
		[self.progressView setProgress:1.0f];
		[self.appDelegate.attackInfo.hitCombo setString:@""];		
		slapCount = 0;
	}
}

- (id) initWithTargetImage:(UIImage *)image{	
	targetImage = [image retain];
	return [self initWithNibName:nil bundle:nil];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self completeInitialization];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
		[self completeInitialization];
    }
	
    return self;
}

- (void)dealloc {
	[NSTimer cancelPreviousPerformRequestsWithTarget: self];
	
	responseClips.delegate = nil;
	[responseClips release];
	
	[finishHimClips release];
	
	[shakeEventSource removeDelegate: self];
	[shakeEventSource release];
	
	[targetImage release];
	
    [super dealloc];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) finishKill{
	self.appDelegate.attackInfo.targetImage = targetImage;
	[self.appDelegate targetKilled:targetImage];
}

- (void) slap {
	NSLog(@"Slapping %d", slapCount);
	++slapCount;
	[self.appDelegate.attackInfo.hitCombo appendString:@"L"];
	NSLog(@"progress value before: %f", self.progressView.progress);
	
	self.progressView.progress = 1.0f - (float) slapCount / (float)HITS_TO_KILL;
	NSLog(@"progress value after: %f", self.progressView.progress);
	shouldPlayFinishHim = NO;
	if (slapCount == HITS_TO_KILL){
		[self finishKill];
	}
	else if (slapCount == HITS_TO_FINISH_HIM){
		self.statusLabel.text = @"Finish him!!!";
		[finishHimClips playRandomClip];
	}
	else if (slapCount > HITS_TO_KILL)
	{
		NSLog(@"Something went wrong.  sholdn't be slapping after a kill");
		return;
	}
	else{
		double currentTime = CACurrentMediaTime();
		if ((currentTime - lastSlapTime) >= 0.15) {
			lastSlapTime = currentTime;
			
			[slapClips playRandomClip];
			
			if (!slapping) {
				slapping = YES;
			}
		}
	}
}

- (void) checkIfStillSlapping {
	double currentTime = CACurrentMediaTime();
	
	if ((currentTime - lastSlapTime) >= 0.5) {
		//NSLog(@"%lf %lf", currentTime, lastSlapTime);
		slapping = NO;
	}
}

- (void) shake: (int) direction {
	//Stoo sending slap events after kill
	if (slapCount > HITS_TO_KILL)
		return;
	
	if (direction & AccelerometerShakeDirectionLeft) {
		NSLog(@"AccelerofmeterShakeDirectionLeft");
		[self.appDelegate.attackInfo.hitCombo appendString:@"L"];
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionRight) {
		NSLog(@"AccelerometerShakeDirectionRight");
		[self.appDelegate.attackInfo.hitCombo appendString:@"R"];
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionUp) {
		NSLog(@"AccelerometerShakeDirectionUp");
		[self.appDelegate.attackInfo.hitCombo appendString:@"U"];
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionDown) {
		NSLog(@"AccelerometerShakeDirectionDown");
		[self.appDelegate.attackInfo.hitCombo appendString:@"D"];		
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionPush) {
		[self slap];
		[self.appDelegate.attackInfo.hitCombo appendString:@"F"];		
		NSLog(@"AccelerometerShakeDirectionPush");
	}
	
	if (direction & AccelerometerShakeDirectionPull) {
		/*Don't want to capture pulls
		[self.appData.attackInfo.hitCombo appendString:@"B"];		*/
		NSLog(@"AccelerometerShakeDirectionPull - not sending slap though");
	}
	NSLog(@"Slap history: %@",self.appDelegate.attackInfo.hitCombo);
}

- (void) playNextResponse {
	if (arc4random() % HITS_FOR_RESPONSE == 1) {
		//We don't always want to play response clips.  More of an easter egg
		[responseClips playRandomClip];
	}
}

- (void) soundClipPoolDidFinishPlaying: (SoundClipPool *) pool {
	// 0.5 - 1.5 second delay
	double delay = 1.5 + (double) (arc4random() % 10) / 10.0;
	
	[NSTimer scheduledTimerWithTimeInterval: delay target: self selector: @selector(playNextResponse) userInfo: nil repeats: NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.appDelegate = (AssassinsAppDelegate *)[UIApplication sharedApplication].delegate;
	self.targetImageView.image = targetImage;
	[self.progressView setProgress:1.0f];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


@end
