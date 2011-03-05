//
//  AttackCompletedViewController.m
//  Assassins
//
//  Created by David Quail on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AttackCompletedViewController.h"
#import "UIImage+Combine.h"
#import "AssassinsAppDelegate.h"
#import "PickAFriendTableViewController.h"
#import "AssassinsServer.h"

@interface AttackCompletedViewController (Private)
- (void) showObituary:(NSString *)obituaryURL;
@end


@implementation AttackCompletedViewController

@synthesize targetImageView, overlayImageView, scoreLabel, facebook, alertView;

#pragma mark -
#pragma mark ViewController lifecycle

- (id) initWithTargetImage:(UIImage *)image andFacebook:(Facebook *) fbook;{
	if (self = [super initWithNibName:nil bundle:nil])
	{
		targetImage = [image retain];
		self.facebook = fbook;
	}
	return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	self.targetImageView.image = targetImage;
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
    [super dealloc];
	[targetImageView release];
	[targetImage release];
	[overlayImageView release];
	[scoreLabel release]; 
	[alertView release];
	[facebook release];
	[obituaryViewController release];
}

#pragma mark -
#pragma mark UIEvents 

- (IBAction) startAttack{
	//Start a new attack
	AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate showHud];
}

- (IBAction) postToFacebook {
	
	AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	if (nil != appDelegate.attackController)
	{
		[appDelegate.attackController release];
		appDelegate = nil;
	}
	
	[self.facebook setTokenFromCache];
	
    // only authorize if the access token isn't valid
    // if it *is* valid, no need to authenticate. just move on
    if (![self.facebook isSessionValid]) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:@"Facebook" 
											   message:@"We use Facebook data to create a fake obituary for your target.  Nothing will be posted on Facebook without your permission.  You'll be asked to enter your Facebook info now." 
											  delegate:self cancelButtonTitle:@"Ok" 
									 otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return;
    }
	
	
	self.alertView = [[ActivityAlert alloc] initWithStatus:@"Loading friend list ..."];

	[self.alertView show];
	[facebook requestWithGraphPath:@"me" andDelegate:self];
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
	
}

#pragma mark -
#pragma mark Facebook delegate
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	NSLog(@"Login succeeded - token - %@", self.facebook.accessToken);
	// store the access token and expiration date to the user defaults
	[self.facebook saveTokenToCache];
	
	// get the logged-in user's friends	
	[facebook requestWithGraphPath:@"me" andDelegate:self];	
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	NSLog(@"Failed login");
}


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
	//Result could be the users info or a friend list
	[result retain];
	NSDictionary *resultDict;
	if ([result isKindOfClass:[NSDictionary class]]){
		resultDict = (NSDictionary *) result;
		if ([resultDict objectForKey:@"id"])
		{
			//This is a callback from get user info
			AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
			appDelegate.attackInfo.assassinID = [resultDict objectForKey:@"id"];
			appDelegate.attackInfo.assassinName = [resultDict objectForKey:@"name"];
		}
		else {
			[self.alertView hide];
			NSArray *friendArray;
			friendArray = [resultDict objectForKey:@"data"];

			UIImage *image = [[targetImage scaledToSize:overlayImageView.image.size] overlayWith:overlayImageView.image];
			PickAFriendTableViewController *pickController = [[PickAFriendTableViewController alloc] initWithNibName:nil bundle:nil friendJSON:friendArray 
																										   friendPic:image];
			pickController.delegate = self;
			[self presentModalViewController:pickController animated:YES];
			[pickController autorelease];
		}

	}
	else {
		NSLog(@"Something went wrong with the json returned");
	}
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[self.alertView hide];
	//[self.label setText:[error localizedDescription]];
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	//[self.label setText:@"publish successfully"];
}

#pragma mark -
#pragma mark PickAFriendDelegate
- (void) donePickingFriendWithID:(NSString *) friendID{
	[self dismissModalViewControllerAnimated:YES];
	if (friendID == nil) {
		return;
	}
	
	AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.attackInfo.targetID = friendID;
	NSLog(@"Friend picked: %@", friendID);
	

	NSData *imageData = UIImageJPEGRepresentation(targetImage, 0.2);
	NSLog(@"Location: %@", appDelegate.attackInfo.location);
	
	 //Todo - Use this to post to our server
	AssassinsServer *server = [AssassinsServer sharedServer];
	server.delegate = self;
	
	self.alertView = [[ActivityAlert alloc] initWithStatus:@"Generating obituary.  This may take up to a minute ..."];
	[self.alertView show];
	
	[server postKillWithToken:(NSString *) facebook.accessToken
														  imageData:imageData
														   killerID:appDelegate.attackInfo.assassinID
														   victimID:appDelegate.attackInfo.targetID
														   location:appDelegate.attackInfo.location
													 attackSequence:appDelegate.attackInfo.hitCombo];
	
}
	
- (void) showObituary:(NSString *)obituaryURL{

	if (obituaryViewController){
		[obituaryViewController release];
		obituaryURL = nil;
	}
	
	
	obituaryViewController = [[ObituaryViewController alloc] initWithObituaryURL:obituaryURL];
	[self.view addSubview:obituaryViewController.view];
	obituaryViewController.view.center = self.view.center;
	obituaryViewController.view.alpha = 0.0f;
	[UIView beginAnimations:@"showObituary" context:nil];
	obituaryViewController.view.alpha = 1.0f;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (void) webViewDidFinishLoad:(UIWebView *)webView{
	NSLog(@"finished loading");	
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	//Only called when the user has seen the mesage about facebook
	
	NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"read_stream", @"read_friendlists", @"offline_access", nil];
	[self.facebook authorize:permissions delegate:self];
	self.alertView = [[ActivityAlert alloc] initWithStatus:@"Loading friend list ..."];
	
	[self.alertView show];
	[facebook requestWithGraphPath:@"me" andDelegate:self];
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
	
}

#pragma mark -
#pragma mark AssassinsServerDelegate
- (void) onRequestDidLoad:(NSString*) response{
	AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[self.alertView hide];
	appDelegate.attackInfo.obituaryString = response;
	
	NSLog(@"Obituary returned was: %@", response);
	if (response==@""){
		UIAlertView *alert;
		
		alert = [[UIAlertView alloc] initWithTitle:@"Error" 
										   message:@"Unable to create obituary." 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
		
		[alert show];
		[alert release];		
	}
	else{
		[self showObituary:	appDelegate.attackInfo.obituaryString];
	}	
}

- (void) onRequestDidFail{
	[self.alertView hide];
	UIAlertView *alert;
	
	alert = [[UIAlertView alloc] initWithTitle:@"Error" 
									   message:@"Unable to create obituary." 
									  delegate:self cancelButtonTitle:@"Ok" 
							 otherButtonTitles:nil];
	
	[alert show];
	[alert release];		
}

@end
