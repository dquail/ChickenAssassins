//
//  ShakeEventSource.m
//  Accelerometer
//
//  Created by Dwayne Mercredi on 11/2/10.
//  Copyright 2010 Invisible Software Inc. All rights reserved.
//

#import "ShakeEventSource.h"

#define MAX_PAST_ACCELERATION_EVENTS 2

#define NONSHAKE_DELTA 0.4
#define SHAKE_DELTA 1.4

@implementation ShakeEventSource

- (id) init {
	if (self = [super init]) {
		delegates = [[NSMutableArray alloc] init];
		recentEvents = [[NSMutableArray alloc] init];
		
		currentShakeDirections = AccelerometerShakeDirectionNone;
		
		UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
		
		accelerometer.delegate = self;
		accelerometer.updateInterval = 1.0 / 15.0;

	}
	
	return self;
}

- (void) dealloc {
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	
	accelerometer.delegate = nil;
	
	[delegates release];
	[recentEvents release];
	
	[super dealloc];
}

- (void) addDelegate: (id<ShakeDelegate>) delegate {
	NSValue *value = [NSValue valueWithNonretainedObject: delegate];
	
	if ([delegates indexOfObject: value] == NSNotFound) {
		[delegates addObject: value];
	}
}

- (void) removeDelegate: (id<ShakeDelegate>) delegate {
	NSValue *value = [NSValue valueWithNonretainedObject: delegate];
	[delegates removeObject: value];
}

- (void) onShake: (int) shakeDirection {
	for (int i = 0; i < [delegates count]; i++) {
		NSValue *value = [delegates objectAtIndex: i];
		id<ShakeDelegate> delegate = [value nonretainedObjectValue];
		
		[delegate shake: shakeDirection];
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	int lastShakeDirections = currentShakeDirections;
	
	if ([recentEvents count] == MAX_PAST_ACCELERATION_EVENTS) {
		double maxPreviousX = 0;
		double minPreviousX = 0;
		
		double maxPreviousY = 0;
		double minPreviousY = 0;
		
		double maxPreviousZ = 0;
		double minPreviousZ = 0;
		
		UIAcceleration *oldestValue = [recentEvents objectAtIndex: 0];
		
		maxPreviousX = minPreviousX = [oldestValue x];
		maxPreviousY = minPreviousY = [oldestValue y];
		maxPreviousZ = minPreviousZ = [oldestValue z];
		
		for (int i = 1; i < [recentEvents count]; i++) {
			UIAcceleration *previousValue = [recentEvents objectAtIndex: i];
			
			minPreviousX = MIN(minPreviousX, [previousValue x]);
			maxPreviousX = MAX(maxPreviousX, [previousValue x]);
			
			minPreviousY = MIN(minPreviousY, [previousValue y]);
			maxPreviousY = MAX(maxPreviousY, [previousValue y]);
			
			minPreviousZ = MIN(minPreviousZ, [previousValue z]);
			maxPreviousZ = MAX(maxPreviousZ, [previousValue z]);			
		}
		
		double x = [acceleration x], y = [acceleration y], z = [acceleration z];
		
		double dxRight = MAX(x - minPreviousX, 0), 
				dxLeft = MAX(maxPreviousX - x, 0), 
				dyPull = MAX(y - minPreviousY, 0), 
				dyPush = MAX(maxPreviousY - y, 0), 
				dzUp = MAX(z - minPreviousZ, 0), 
				dzDown = MAX(maxPreviousZ - z, 0);
		
		if (dxRight < NONSHAKE_DELTA && dxLeft < NONSHAKE_DELTA) {
			currentShakeDirections &= ~AccelerometerShakeDirectionRight;
			currentShakeDirections &= ~AccelerometerShakeDirectionLeft;
		}
		else if (dxRight > SHAKE_DELTA && dxRight > dxLeft) {
			if ((currentShakeDirections & AccelerometerShakeDirectionRight) == 0 || (currentShakeDirections & AccelerometerShakeDirectionLeft) != 0) {
				currentShakeDirections |= AccelerometerShakeDirectionRight;
				currentShakeDirections &= ~AccelerometerShakeDirectionLeft;
			}
		}
		else if (dxLeft > SHAKE_DELTA && dxLeft > dxRight) {
			if ((currentShakeDirections & AccelerometerShakeDirectionLeft) == 0 || (currentShakeDirections & AccelerometerShakeDirectionRight) != 0) {
				currentShakeDirections |= AccelerometerShakeDirectionLeft;
				currentShakeDirections &= ~AccelerometerShakeDirectionRight;
			}
		}
		
		if (dyPush < NONSHAKE_DELTA && dyPull < NONSHAKE_DELTA) {
			currentShakeDirections &= ~AccelerometerShakeDirectionPush;
			currentShakeDirections &= ~AccelerometerShakeDirectionPull;
		}
		else if (dyPush > SHAKE_DELTA && dyPush > dyPull) {
			if ((currentShakeDirections & AccelerometerShakeDirectionPull) == 0 || (currentShakeDirections & AccelerometerShakeDirectionPush) != 0) {
				currentShakeDirections |= AccelerometerShakeDirectionPull;
				currentShakeDirections &= ~AccelerometerShakeDirectionPush;
			}
		}
		else if (dyPull > SHAKE_DELTA && dyPull > dyPush) {
			if ((currentShakeDirections & AccelerometerShakeDirectionPush) == 0 || (currentShakeDirections & AccelerometerShakeDirectionPull) != 0) {
				currentShakeDirections |= AccelerometerShakeDirectionPush;
				currentShakeDirections &= ~AccelerometerShakeDirectionPull;
			}
		}
		
		if (dzUp < NONSHAKE_DELTA && dzDown < NONSHAKE_DELTA) {
			currentShakeDirections &= ~AccelerometerShakeDirectionUp;
			currentShakeDirections &= ~AccelerometerShakeDirectionDown;
		}
		else if (dzUp > SHAKE_DELTA && dzUp > dzDown) {
			if ((currentShakeDirections & AccelerometerShakeDirectionUp) == 0 || (currentShakeDirections & AccelerometerShakeDirectionDown) != 0) {
				currentShakeDirections |= AccelerometerShakeDirectionUp;
				currentShakeDirections &= ~AccelerometerShakeDirectionDown;
			}
		}
		else if (dzDown > SHAKE_DELTA && dzDown > dzUp) {
			if ((currentShakeDirections & AccelerometerShakeDirectionDown) == 0 || (currentShakeDirections & AccelerometerShakeDirectionUp) != 0) {
				currentShakeDirections |= AccelerometerShakeDirectionDown;
				currentShakeDirections &= ~AccelerometerShakeDirectionUp;
			}
		}
	}
	
	if ([recentEvents count] >= MAX_PAST_ACCELERATION_EVENTS) {
		[recentEvents removeObjectAtIndex: 0];
	}
	
	[recentEvents addObject: acceleration];
	
	int shakeChanges = currentShakeDirections & ~lastShakeDirections;
	
	if (shakeChanges != 0) {
		[self onShake: shakeChanges];
	}
}

@end
