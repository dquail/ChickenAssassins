//
//  Friend.h
//  Assassins
//
//  Created by David Quail on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Friend : NSObject {
	NSString *name;
	NSString *facebookID;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* facebookID;

@end
