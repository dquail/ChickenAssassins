//
//  SoundClipPool.m
//  Accelerometer
//
//  Created by David Quail on 01/11/11.
//  Copyright 2011 Invisible Software Inc. All rights reserved.
//

#import "SoundClipPool.h"


@implementation SoundClipPool

@synthesize delegate;

- (id) init {
	if (self = [super init]) {
		availableClips = [[NSMutableArray alloc] init];
		activeClips = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	for (int i = 0; i < [activeClips count]; i++) {
		AVAudioPlayer *clip = [activeClips objectAtIndex: i];
		[clip stop];
		
		clip.delegate = nil;
	}
	
	[availableClips release];
	[activeClips release];
	
	[super dealloc];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	player.delegate = nil;
	[activeClips removeObject: player];
	[availableClips addObject: player];
	
	if (delegate && [activeClips count] == 0) {
		[delegate soundClipPoolDidFinishPlaying: self];
	}
}

- (void) playRandomClip {
	if ([availableClips count] == 0) {
		return;
	}
	
	int index = arc4random() % [availableClips count];

	AVAudioPlayer *clip = [availableClips objectAtIndex: index];
	[availableClips removeObjectAtIndex: index];
	[activeClips addObject: clip];

	clip.delegate = self;
	[clip play];
}

- (void) addSoundClip: (AVAudioPlayer *) clip {
	[availableClips addObject: clip];
}

@end
