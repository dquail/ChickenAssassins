//
//  ObituaryViewController.m
//  Assassins
//
//  Created by David Quail on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObituaryViewController.h"
#import "ActivityAlert.h"
#import "AssassinsAppDelegate.h"

@interface ObituaryViewController (Private)
- (void) postToFacebook;
- (void) sendViaEmail;
@end

@implementation ObituaryViewController

@synthesize _webView, delegate, toolBar;

- (id) initWithObituaryURL:(NSString *)url{
    self = [super initWithNibName:@"ObituaryViewController" bundle:nil];
    if (self) {
		obituaryURL = [url retain];
        // Custom initialization.
    }
    return self;
	
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self._webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:obituaryURL]]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[obituaryURL release];
	[_webView release];
	
    [super dealloc];
}

#pragma mark  - 
#pragma mark Button handlers

- (IBAction) onPostLink{
	//TODO - Post the message to facebook or twitter?
	NSLog(@"Attempting to post to facebook");
	
    UIActionSheet * actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Share Obituary"
																   delegate:self
														  cancelButtonTitle:@"Cancel"
													 destructiveButtonTitle:nil
														  otherButtonTitles:@"Facebook", @"Email", nil] autorelease];
	
	//actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
	[actionSheet showInView:self.view];
		
	// Display the action sheet
	//[actionSheet showFromToolbar:self.toolBar];
}

- (IBAction) onCloseObituary{
	//remove this view from superview.
	//TODO: this animation is not working for some stupid reason
	NSLog(@"Closing obituary view");
	[UIView beginAnimations:@"closeObituary" context:nil];
	NSLog(@"Alpha: %d", self.view.alpha);
	self.view.alpha = 0.0f;
	NSLog(@"Alpha: %d", self.view.alpha);
	[UIView commitAnimations];	
	[self.view removeFromSuperview];
}

#pragma mark -
#pragma mark ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"Facebook"]){
		[self postToFacebook];
	}
	else if ([buttonTitle isEqualToString:@"Email"]){
		[self sendViaEmail];
	}
}

- (void) postToFacebook{
	AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									appDelegate.attackInfo.obituaryString, @"link",
								   @"http://a2.twimg.com/profile_images/1255491684/Icon_2x_bigger.png", @"picture",
								   @"Rubber chicken assassination", @"name",
								   @"I just finished killing off my friend with a rubber chicken.  Check it out", @"caption",
								   @"In a searies of blows, I managed to beat up my newest target.  What an assassination", @"description",
								   nil];
	[appDelegate.facebook requestWithGraphPath:@"me/feed" 
									  andParams:params
								  andHttpMethod:@"POST"
									andDelegate:self];
	
	NSLog(@"Attempting to post to facebook");
}

- (void) sendViaEmail{
	NSLog(@"Attempting to send obituary in email");
}

#pragma mark -
#pragma mark UIWebView delegate


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	if (delegate){
		[delegate webViewDidFinishLoad:webView];
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"Error loading request");
	/*
	if (delegate){
		[delegate webView:webView didFailLoadWithError:error];
	}*/
}

#pragma mark -
#pragma mark FBRequestDelegate
////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"Request loaded");
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"REquest failed");
};


@end
