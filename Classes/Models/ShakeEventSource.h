//
//  ShakeEventSource.h
//  Accelerometer
//
//  Created by Dwayne Mercredi on 11/2/10.
//  Copyright 2010 Invisible Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	AccelerometerShakeDirectionNone		= 0x00,	
	AccelerometerShakeDirectionLeft		= 0x01,	
	AccelerometerShakeDirectionRight	= 0x02,	
	AccelerometerShakeDirectionUp		= 0x04,	
	AccelerometerShakeDirectionDown		= 0x08,	
	AccelerometerShakeDirectionPush		= 0x10,	
	AccelerometerShakeDirectionPull		= 0x20,	
} AccelerometerShakeDirections;

@protocol ShakeDelegate <NSObject> 

- (void) shake: (int) directions;

@end

@interface ShakeEventSource : NSObject <UIAccelerometerDelegate> {
	NSMutableArray *delegates;
	NSMutableArray *recentEvents;
	
	int currentShakeDirections;
}

- (void) addDelegate: (id<ShakeDelegate>) delegate;
- (void) removeDelegate: (id<ShakeDelegate>) delegate;

@end
