//
//  AssassinsServer.h
//  Assassins
//
//  Created by David Quail on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"


@interface AssassinsServer : NSObject<ASIHTTPRequestDelegate> {

}
+ (AssassinsServer *)sharedServer;

/*
 * - Posts the kill to our server
 * - Returns url to kill
*/
- (NSString*) postKillWithToken:(NSString *) authToken
					  imageData:(NSData *) imgData
					   killerID:(NSString *) killer_id
					   victimID:(NSString *) victim_id
					   location:(NSString *) location
				 attackSequence:(NSString *) attack_sequence;

@end
