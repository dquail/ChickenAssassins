//
//  NSMutableURLRequest+WebServiceClient.h
//  Attassa
//
//  Created by Dwayne Mercredi on 1/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (WebServiceClient) 

+ (NSString *) encodeParameters: (NSDictionary *) parameters;

- (void) setFormPostParameters: (NSDictionary *) parameters;

- (void) setHTTPBasicID: (NSString *) userID password: (NSString *) password;

@end