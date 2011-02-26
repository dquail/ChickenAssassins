//
//  AttackInfo.h
//  Assassins
//
//  Created by David Quail on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AttackInfo : NSObject {
	NSString *hitCombo;
	NSString *location;
	NSString *assassinID;
	NSString *targetID;
	UIImage *targetImage;
	NSString *obituaryString;
}

@property (nonatomic, retain) NSString *hitCombo;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *assassinID;
@property (nonatomic, retain) NSString *targetID;
@property (nonatomic, retain) UIImage *targetImage;
@property (nonatomic, retain) NSString *obituaryString;

@end
