//
//  Facebook+CacheAuth.m
//  Assassins
//
//  Created by David Quail on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Facebook+CacheAuth.h"

#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"

@implementation Facebook(CacheAuth)

- (void) setTokenFromCache{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
    self.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
    self.expirationDate = [defaults objectForKey:EXPIRATION_DATE_KEY];	
}

- (void) saveTokenToCache{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:self.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];		
}

@end
