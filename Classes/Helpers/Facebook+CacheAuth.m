//
//  Facebook+CacheAuth.m
//  Assassins
//
//  Created by David Quail on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Facebook+CacheAuth.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"

#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"

@implementation Facebook(CacheAuth)

- (void) setTokenFromCache{
	BOOL valid;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	
	//Set access token
	NSString *accessToken = [defaults secureObjectForKey:ACCESS_TOKEN_KEY valid:&valid];
	if (valid){
		self.accessToken = accessToken;
	}
	else{
		self.accessToken = nil;
	}
    
	//Set expiration date
	NSDate *expirationDate = [defaults secureObjectForKey:EXPIRATION_DATE_KEY valid:&valid];
	if (valid){
		self.expirationDate = expirationDate;
	}
	else{
		self.expirationDate = nil;
	}
	
}

- (void) saveTokenToCache{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setSecureObject:self.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setSecureObject:self.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];		
}

@end
