//
//  AssassinsServer.m
//  Assassins
//
//  Created by David Quail on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssassinsServer.h"
#import "ASIFormDataRequest.h"

static NSString* SERVER_BASE = @"http://nathan.logicaldecay.com";
//static NSString* SERVER_BASE = @"http://chickenassassin.com/kills"

static AssassinsServer * sharedServer = nil;

@implementation AssassinsServer

+ (AssassinsServer *)sharedServer{
    @synchronized( self )
    {
        if( sharedServer == nil )
        {
            sharedServer = [[AssassinsServer alloc] init];
        }
    }
    return sharedServer;	
}

- (NSString*) postKillWithToken:(NSString *) authToken
					  imageData:(NSData *) imgData
					   killerID:(NSString *) killer_id
					   victimID:(NSString *) victim_id
					   location:(NSString *) location
				 attackSequence:(NSString *) attack_sequence{
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:
								   [NSURL URLWithString:[NSString stringWithFormat:@"%@/kills", SERVER_BASE]]];

	[request addPostValue: @"true" forKey:@"utf8"];
	[request addPostValue: authToken forKey:@"access_token"];
	[request addPostValue: killer_id forKey:@"killer_id"];
	[request addPostValue: victim_id forKey:@"victim_id"];	
	[request addPostValue: location forKey:@"location"];
	[request addPostValue: 	attack_sequence forKey:@"attack_sequence"];	
	[request addData:imgData withFileName:@"killimage" andContentType:@"image/jpeg" forKey:@"photo"];

	[request startSynchronous];
	NSString *response;
	NSError *error = [request error];
	if (!error) {
		response = [request responseString];
		NSLog(@"Response string: %@", response);
	}
	return response;
}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate 
- (void)requestStarted:(ASIHTTPRequest *)request{
	NSLog(@"Request started");
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
	NSLog(@"Request recieved response header");
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL{
	NSLog(@"Request recieved willredirect");
}
- (void)requestFinished:(ASIHTTPRequest *)request{
	NSLog(@"Request finished");
}
- (void)requestFailed:(ASIHTTPRequest *)request{
	NSLog(@"Request failed");
}
- (void)requestRedirected:(ASIHTTPRequest *)request{
	NSLog(@"Request redirect");
}

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
	NSLog(@"request recieved data");
}

@end
