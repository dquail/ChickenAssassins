//
//  NSMutableURLRequest+WebServiceClient.m
//  Attassa
//
//  Created by Dwayne Mercredi on 1/12/09.
//  Copyright 2009 Invisible Software Inc. All rights reserved.
//

#import "NSMutableURLRequest+WebServiceClient.h"
#import "NSData+AttassaEncodings.h"

@implementation NSMutableURLRequest (WebServiceClient)

+ (NSString *) encodeParameters: (NSDictionary *) parameters
{
	NSMutableString *formPostParams = [[[NSMutableString alloc] init] autorelease];
	
	NSEnumerator *keys = [parameters keyEnumerator];
	
	NSString *name = [keys nextObject];
	while (name) {
		NSString *encodedValue = [((NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) [parameters objectForKey: name], NULL, CFSTR("=/:"), kCFStringEncodingUTF8)) autorelease];
		
		[formPostParams appendString: name];
		[formPostParams appendString: @"="];
		[formPostParams appendString: encodedValue];
		
		name = [keys nextObject];
		
		if (name) {
			[formPostParams appendString: @"&"];
		}
	}
	
	return formPostParams;
}

- (void) setFormPostParameters: (NSDictionary *) parameters 
{
	NSString *formPostParams = [NSMutableURLRequest encodeParameters: parameters];
	
	[self setHTTPBody: [formPostParams dataUsingEncoding: NSUTF8StringEncoding]];
	[self setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
}

- (void) setHTTPBasicID: (NSString *) userID password: (NSString *) password {
	NSString *combinedIDPassword = [NSString stringWithFormat: @"%@:%@", userID, password];
	
	NSString *credentialLine = [NSString stringWithFormat: @"Basic %@", [[combinedIDPassword dataUsingEncoding:NSUTF8StringEncoding] base64Encoding]];
	
	[self setValue: credentialLine forHTTPHeaderField: @"Authorization"];
}

@end