//
//  SoundClipPool.h
//  Accelerometer
//
//  Created by David Quail on 01/11/11.
//  Copyright 2011 Invisible Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@protocol SoundClipPoolDelegate;

@interface SoundClipPool : NSObject <AVAudioPlayerDelegate> {
	NSMutableArray *availableClips;
	NSMutableArray *activeClips;
	id<SoundClipPoolDelegate> delegate;
}

- (void) playRandomClip;
- (void) addSoundClip: (AVAudioPlayer *) clip;

@property (nonatomic, assign) id<SoundClipPoolDelegate> delegate;

@end

@protocol SoundClipPoolDelegate<NSObject>

- (void) soundClipPoolDidFinishPlaying: (SoundClipPool *) pool;

@end