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
#import "FlurryAPI.h"

@interface ObituaryViewController (Private)
- (void) postToFacebook;
- (void) sendViaEmail;
@end

@implementation ObituaryViewController

@synthesize _webView, toolBar, alertView;

- (id) initWithObituaryURL:(NSString *)url{
	NSLog(@"Initializing obituary at %@", url);
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

	self.alertView =  [[ActivityAlert alloc] initWithStatus:@"Displaying obituary ..."];
	[self.alertView show];	
	[self._webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:obituaryURL]]];
	NSLog(@"Loading request");
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
	[toolBar release];
    [alertView release];
	
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

- (IBAction) onCloseObituary {
	[self dismissModalViewControllerAnimated: YES];
}

#pragma mark -
#pragma mark ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString * buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:@"Facebook"]){
		[FlurryAPI logEvent:@"ShareWithFacebook"];			
		[self postToFacebook];
	}
	else if ([buttonTitle isEqualToString:@"Email"]){
		[FlurryAPI logEvent:@"ShareWithEmail"];			
		[self sendViaEmail];
	}
}

- (void) postToFacebook{

	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									appDelegate.attackInfo.obituaryString, @"link",
								   @"http://a2.twimg.com/profile_images/1255491684/Icon_2x_bigger.png", @"picture",
								   [NSString stringWithFormat:@"%@'s obituary", appDelegate.attackInfo.targetName], @"name",
								   [NSString stringWithFormat:@"I just killed %@ with ... a Rubber Chicken!!!", appDelegate.attackInfo.targetName], @"caption",
								   [NSString stringWithFormat:@"In a series of jabs, slaps and pokes I just completed assassinating my newest victim using Rubber Chicken Assassins.  Boowahahaha!!!",appDelegate.attackInfo.targetName], @"description",
								   nil];
	self.alertView =  [[ActivityAlert alloc] initWithStatus:@"Posting obituary to Facebook ..."];
	[self.alertView show];
	
	NSString *graphPath = [NSString stringWithFormat:@"%@/feed",appDelegate.attackInfo.targetID];
	//[appDelegate.facebook requestWithGraphPath:@"me/feed" 
	[appDelegate.facebook requestWithGraphPath:graphPath 
									  andParams:params
								  andHttpMethod:@"POST"
									andDelegate:self];
	
	NSLog(@"Attempting to post to facebook");
}

- (void) sendViaEmail{
	NSLog(@"Attempting to send obituary in email");
	if ([MFMailComposeViewController canSendMail]) {
		AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];

		NSString *htmlMessage = [NSString stringWithFormat:
								  @"I just killed you using Rubber Chicken Assassins.  Check out your obituary here %@.  You could also get revenge by reverse assasination.  Start by downloading the app http://chickenassassin.com", appDelegate.attackInfo.obituaryString];


		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
		[mailComposer setSubject:NSLocalizedString(@"I assasinated you on Chicken Assasin", @"I assasinated you on chicken assasin")]; 
		[mailComposer addAttachmentData:UIImagePNGRepresentation(appDelegate.attackInfo.targetImage) mimeType:@"image/png" fileName:@"image"]; 
		[mailComposer setMessageBody:htmlMessage isHTML:YES]; 		
		[self presentModalViewController:mailComposer animated:YES]; 
		[mailComposer release];
	}	
}

#pragma mark -
#pragma mark UIWebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
	[self.alertView hide];	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	//self.alertView =  [[ActivityAlert alloc] initWithStatus:@"Posting obituary to Facebook ..."];
	[self.alertView hide];	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	NSLog(@"Error loading request");
	[self.alertView hide];
	
	UIAlertView *alert;
	alert = [[UIAlertView alloc] initWithTitle:@"Error" 
									   message:@"Unable generate obituary." 
									  delegate:self cancelButtonTitle:@"Ok" 
							 otherButtonTitles:nil];
	[alert show];
	[alert release];
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
	NSLog(@"received facebook response");
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
	//TODO - display load success.  Dismiss dialog
	[self.alertView hide];
	UIAlertView *alert;
	alert = [[UIAlertView alloc] initWithTitle:@"Success" 
									   message:@"The obituary was posted to your victims wall." 
									  delegate:self cancelButtonTitle:@"Ok" 
							 otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	NSLog(@"Request loaded");
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	//TODO - display load failed.  Dismiss dialog
	UIAlertView *alert;
	alert = [[UIAlertView alloc] initWithTitle:@"Error" 
									   message:@"Unable to post obituary to your wall." 
									  delegate:self cancelButtonTitle:@"Ok" 
							 otherButtonTitles:nil];
	[alert show];
	[alert release];	
	NSLog(@"Request failed");
};

#pragma mark -
#pragma mark Mail Compose Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

@end
