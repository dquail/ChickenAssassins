//
//  AssassinsServer.m
//  Assassins
//
//  Created by David Quail on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssassinsServer.h"
#import "ASIFormDataRequest.h"

//static NSString* SERVER_BASE = @"http://nathan.logicaldecay.com";
static NSString* SERVER_BASE = @"http://chickenassassin.heroku.com";
//static NSString* SERVER_BASE = @"http://chickenassassin.com/kills"

static AssassinsServer * sharedServer = nil;

@interface AssassinsServer (Private)
- (BOOL) validateUrl: (NSString *) candidate;
@end
@implementation AssassinsServer

@synthesize delegate;

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

- (void) postKillWithToken:(NSString *) authToken
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
	request.delegate = self;
	[request start];
}

#pragma mark -
#pragma mark ASIHTTPRequest Delegate 

- (void)requestFinished:(ASIHTTPRequest *)request{
	ASIFormDataRequest *formRequest = (ASIFormDataRequest *) request;
	NSError *error = [formRequest error];
	NSString *urlReturned = [formRequest responseString];
	
	if (!error && [self validateUrl:urlReturned]) {
		NSLog(@"Response string: %@", urlReturned);		
		if (self.delegate){
			[self.delegate onRequestDidLoad:urlReturned];
		}
	}
	else {
		NSLog(@"Error creating obituary");
		if (self.delegate)
			[self.delegate onRequestDidFail];	}	
	NSLog(@"Request finished");
}
- (void)requestFailed:(ASIHTTPRequest *)request{
	NSLog(@"Error creating obituary");
	if (self.delegate)
		[self.delegate onRequestDidFail];

}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

@end
