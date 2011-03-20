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

@interface AttackViewController ()
- (void) finishKill;
- (void) slap;
- (void) pulseRed;
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
			curve:(int)curve x:(CGFloat)x y:(CGFloat)y;
@end

@implementation AttackViewController

@synthesize progressView, targetImageView, chickenImageView, redOverlay;

#define MAX_PAST_ACCELERATION_EVENTS 2

#define NONSHAKE_DELTA 0.4
#define SHAKE_DELTA 2.0
#define HITS_TO_KILL 45
#define HITS_TO_FINISH_HIM 38
#define HITS_FOR_RESPONSE 4  //Only occasionally will responses be played

- (IBAction)slapButton {
	//slapCount = HITS_TO_KILL -1;
	[self shake:16];
}

- (IBAction) onCancelAttack{
    AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showHud];
}
- (void) completeInitialization {
	shakeEventSource = [[ShakeEventSource alloc] init];	
	[shakeEventSource addDelegate: self];

	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.attackInfo.hitCombo setString:@""];

	/*
	 * Create slap clips
	 */
	slapClips = [[SoundClipPool alloc] init];
	slapClips.delegate = self;
	
	NSString *slapURLs[] = {
		@"s1.caf",
		@"s2.caf",
		@"s3.caf",
		@"s4.caf",
		@"s5.caf",
		@"s6.caf",
		@"s7.caf",
		@"s8.caf",		
	};
	
	for (int i = 0; i < (sizeof(slapURLs) / sizeof(slapURLs[0])); i++) {
		NSURL *slapURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: slapURLs[i]];
		AVAudioPlayer *slapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: slapURL error: NULL];
		[slapClips addSoundClip: slapSound];
	}

	/*
	 * Create jab clips
	 */
	jabClips = [[SoundClipPool alloc] init];
	jabClips.delegate = self;
	
	NSString *jabURLs[] = {
		@"j1.caf",
	};
	
	for (int i = 0; i < (sizeof(jabURLs) / sizeof(jabURLs[0])); i++) {
		NSURL *slapURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: jabURLs[i]];
		AVAudioPlayer *slapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: slapURL error: NULL];
		[jabClips addSoundClip: slapSound];
	}
	
	/*
	 * Create bonk clips
	 */
	bonkClips = [[SoundClipPool alloc] init];
	bonkClips.delegate = self;
	
	NSString *bonkURLS[] = {
		@"b1.caf",
		@"b2.caf",
		@"b3.caf",		
	};
	
	for (int i = 0; i < (sizeof(bonkURLS) / sizeof(bonkURLS[0])); i++) {
		NSURL *slapURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: bonkURLS[i]];
		AVAudioPlayer *slapSound = [[AVAudioPlayer alloc] initWithContentsOfURL: slapURL error: NULL];
		[bonkClips addSoundClip: slapSound];
	}
	
	lastSlapTime = CACurrentMediaTime();
	
	responseClips = [[SoundClipPool alloc] init];
	/*
	 * Create response clips
	 */
	NSString *responseURLs[] = {
		@"c1.caf",
		@"c2.caf",
		@"r1.caf",
		@"r2.caf",
		@"r3.caf",
		@"r4.caf",
		@"r5.caf",
		@"r6.caf",
		@"r7.caf",
		@"r8.caf",
		@"r9.caf",
		@"r10.caf",
		@"r11.caf",
		@"r12.caf",
		@"r13.caf",		
	};
	
	for (int i = 0; i < (sizeof(responseURLs) / sizeof(responseURLs[0])); i++) {
		NSURL *url = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: responseURLs[i]];
		
		AVAudioPlayer *clip = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
		[responseClips addSoundClip: clip];
	}
	
	/*
	 * Create Finish him clips
	 */
	finishHimClips = [[SoundClipPool alloc] init];	
	NSString *finishURLs[] = {
		@"c1.caf",
		@"c2.caf",
	};
	
	for (int i = 0; i < (sizeof(finishURLs) / sizeof(finishURLs[0])); i++) {
		NSURL *url = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent: finishURLs[i]];
		
		AVAudioPlayer *clip = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: NULL];
		[finishHimClips addSoundClip: clip];
	}
	
	timer = [[NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(checkIfStillSlapping) userInfo: nil repeats: YES] retain];	
}

- (void) resetUsingImage:(UIImage *) image{
	if (targetImage!=image){
		AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];		
		appDelegate.attackInfo = [[AttackInfo alloc] init];
		[appDelegate.attackInfo.hitCombo setString:@""];		
		[targetImage release];
		targetImage = [image retain];
		self.targetImageView.image = targetImage;
		[self.progressView setProgress:1.0f];
		[appDelegate.attackInfo.hitCombo setString:@""];		
		slapCount = 0;
	}
}

- (id) initWithTargetImage:(UIImage *)image{	
	if (self = [self initWithNibName:nil bundle:nil]) {
		targetImage = [image retain];
	}
	
	return self;
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
	responseClips.delegate = nil;
	[responseClips release];
	[slapClips release];
	[bonkClips release];
	[jabClips release];
	[finishHimClips release];
	
	[shakeEventSource removeDelegate: self];
	[shakeEventSource release];
	
	[progressView release];
	[targetImageView release];
	[targetImage release];
	
    [super dealloc];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) finishKill{
	[timer invalidate];
	[timer release];
	
	// Move the image
	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	appDelegate.attackInfo.targetImage = targetImage;
	[appDelegate targetKilled:targetImage];
}

- (void) slap {
	++slapCount;
	
	self.progressView.progress = 1.0f - (float) slapCount / (float)HITS_TO_KILL;
	shouldPlayFinishHim = NO;
	if (slapCount == HITS_TO_KILL){
		[finishHimClips playRandomClip];	
		[self finishKill];	
	}
	else if (slapCount == HITS_TO_FINISH_HIM){
		//[finishHimClips playRandomClip];
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
			
			//[slapClips playRandomClip];
			
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
	
	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (slapCount > HITS_TO_KILL)
		return;
	
	BOOL playClip;
	
	double currentTime = CACurrentMediaTime();
	if ((currentTime - lastSlapTime) >= 0.15) {
		playClip = YES;
	}
	else {
		playClip = NO;
	}

	[self pulseRed];
	if (direction & AccelerometerShakeDirectionLeft) {
		NSLog(@"AccelerofmeterShakeDirectionLeft");
		[appDelegate.attackInfo.hitCombo appendString:@"L"];
		if (playClip)
		{
			[slapClips playRandomClip];
		}
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionRight) {
		NSLog(@"AccelerometerShakeDirectionRight");
		[appDelegate.attackInfo.hitCombo appendString:@"R"];
		if (playClip)
		{
			[slapClips playRandomClip];
		}		
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionUp) {
		NSLog(@"AccelerometerShakeDirectionUp");
		[appDelegate.attackInfo.hitCombo appendString:@"U"];
		if (playClip)
		{
			[slapClips playRandomClip];
		}
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionDown) {
		NSLog(@"AccelerometerShakeDirectionDown");
		[appDelegate.attackInfo.hitCombo appendString:@"D"];		
		if (playClip)
		{
			[bonkClips playRandomClip];
		}		
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionPush) {
		NSLog(@"AccelerometerShakeDirectionPush");		
		[appDelegate.attackInfo.hitCombo appendString:@"F"];	
		if (playClip)
		{
			[jabClips playRandomClip];
		}	
		[self slap];
	}
	
	if (direction & AccelerometerShakeDirectionPull) {
		/*Don't want to capture pulls
		[self.appData.attackInfo.hitCombo appendString:@"B"];		*/
		NSLog(@"AccelerometerShakeDirectionPull - not sending slap though");
	}
	NSLog(@"Slap history: %@",appDelegate.attackInfo.hitCombo);
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
	if (!slapping){
		[NSTimer scheduledTimerWithTimeInterval: delay target: self selector: @selector(playNextResponse) userInfo: nil repeats: NO];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];	
    [super viewDidLoad];
	appDelegate = (AssassinsAppDelegate *)[UIApplication sharedApplication].delegate;
	self.targetImageView.image = targetImage;
	
	//Round the image view
	self.targetImageView.layer.cornerRadius = 5.0;
	self.targetImageView.layer.masksToBounds = YES;
	
	//Add a border
	self.targetImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.targetImageView.layer.borderWidth = 1.0;
	
	[self.progressView setProgress:1.0f];
}

- (void)viewDidAppear:(BOOL)animated{
	
	// Move the image
	[self moveImage:self.chickenImageView duration:1.15 
			  curve:UIViewAnimationCurveEaseInOut x:0.0 y:-270.0];	

	[finishHimClips playRandomClip];
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
	self.progressView = nil;
	self.targetImageView = nil;
}

- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
			curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
	// Setup the animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationCurve:curve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	// The transform matrix
	CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
	image.transform = transform;
	
	// Commit the changes
	[UIView commitAnimations];
	
}

- (void) pulseRed{	
	// Setup the animation
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];	
	
	self.redOverlay.alpha = 0.6;
	[UIView commitAnimations];

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	self.redOverlay.alpha = 0.0;
	[UIView commitAnimations];	
}
@end
