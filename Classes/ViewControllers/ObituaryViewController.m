//
//  ObituaryViewController.m
//  Assassins
//
//  Created by David Quail on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObituaryViewController.h"
#import "ActivityAlert.h"
#import "SHK.h"

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
	// Create the item to share (in this example, a url)
	NSURL *url = [NSURL URLWithString:obituaryURL];
	SHKItem *item = [SHKItem URL:url title:@"My rubber chicken assassination"];
	
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showFromToolbar:self.toolBar];
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


@end
