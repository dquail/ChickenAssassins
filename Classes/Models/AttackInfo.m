//
//  AttackInfo.m
//  Assassins
//
//  Created by David Quail on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttackInfo.h"

@implementation AttackInfo

@synthesize hitCombo, location, assassinID, targetID, targetImage, obituaryString, assassinName, targetName;

- (id) init{
	if (self = [super init]){
		self.targetID = @"";
		self.location = @"";
		self.assassinID = @"";
		self.targetID = @"";
		self.obituaryString = @"";
		self.assassinName = @"";
		self.hitCombo = [NSMutableString stringWithCapacity:30];
		self.targetName = @"";
	}
	return self;
}

- (void) dealloc{
	[hitCombo release];
	[location release];
	[assassinID release];
	[assassinName release];
	[targetID release];
	[targetName release];
	[targetImage release];
	[obituaryString release];
	[super dealloc];
}

@end
