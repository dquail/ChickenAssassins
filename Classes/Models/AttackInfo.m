//
//  AttackInfo.m
//  Assassins
//
//  Created by David Quail on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttackInfo.h"

@implementation AttackInfo

@synthesize hitCombo, location, assassinID, targetID, targetImage, obituaryString;


- (void) dealloc{
	[hitCombo release];
	[location release];
	[assassinID release];
	[targetID release];
	[targetImage release];
	[obituaryString release];
	[super dealloc];
}

@end
