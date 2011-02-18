//
//  Facebook+CacheAuth.h
//  Assassins
//
//  Created by David Quail on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Facebook.h"

@interface Facebook(CacheAuth) 
- (void) setTokenFromCache;
- (void) saveTokenToCache;
@end
