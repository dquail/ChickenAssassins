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

@synthesize targetImageView, overlayImageView, scoreLabel, appDelegate, facebook, alertView;//, obituaryController;

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
		
	self.appDelegate = (AssassinsAppDelegate *)[UIApplication sharedApplication].delegate;
	self.targetImageView.image = targetImage;
	//self.obituaryController = [[ObituaryViewController alloc] initWithNibName:nil bundle:nil];	
	
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
	[self.appDelegate showHud];
}

- (IBAction) savePhoto{
	UIImage *killedImage = [[targetImage scaledToSize:overlayImageView.image.size] overlayWith:overlayImageView.image];
	UIImageWriteToSavedPhotosAlbum(killedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction) postToFacebook {
    // on login, use the stored access token and see if it still works
	//TODO: remove this.  Testing the webview
	//[self showObituary:@"http://msn.com"];
	//return;
	
	[self.facebook setTokenFromCache];
	
    // only authorize if the access token isn't valid
    // if it *is* valid, no need to authenticate. just move on
    if (![self.facebook isSessionValid]) {
		NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", @"read_stream", nil];
        [self.facebook authorize:permissions delegate:self];
    }
	
	
	self.alertView = [[ActivityAlert alloc] initWithStatus:@"Loading friend list ..."];

	[self.alertView show];
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
	
}

- (IBAction) emailPhoto {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self;
		[mailComposer setSubject:NSLocalizedString(@"I assasinated you on Chicken Assasin", @"I assasinated you on chicken assasin")]; 
		[mailComposer addAttachmentData:UIImagePNGRepresentation(targetImage) mimeType:@"image/png" fileName:@"image"]; 
		[mailComposer setMessageBody:NSLocalizedString(@"I killed you on Chicken assassin sucker.", 
													   @"I killed you on Chicken assassin sucker.") isHTML:NO]; 
		[self presentModalViewController:mailComposer animated:YES]; 
		[mailComposer release];
	}
}

#pragma mark -
#pragma mark Mail Compose Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIImagePickerController delegate
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo; 
{
	UIAlertView *alert;
	
	// Unable to save the image  
	if (error)
		alert = [[UIAlertView alloc] initWithTitle:@"Error" 
										   message:@"Unable to save image to Photo Album." 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
	else // All is well
		alert = [[UIAlertView alloc] initWithTitle:@"Success" 
										   message:@"Image saved to Photo Album." 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[self.appDelegate showHud];
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
	[self.alertView hide];
	NSArray *friendArray;
	[result retain];
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSDictionary *friendDict = (NSDictionary*) result;
		friendArray = [friendDict objectForKey:@"data"];  
	}
	NSLog(@"friend count: %d", [friendArray count]);

	UIImage *image = [[targetImage scaledToSize:overlayImageView.image.size] overlayWith:overlayImageView.image];
	PickAFriendTableViewController *pickController = [[PickAFriendTableViewController alloc] initWithNibName:nil bundle:nil friendJSON:friendArray 
																							   friendPic:image];
	pickController.delegate = self;
	[self presentModalViewController:pickController animated:YES];
	[pickController autorelease];
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
	if (friendID == nil) {
		[self dismissModalViewControllerAnimated:YES];
		return;
	}

	self.alertView = [[ActivityAlert alloc] initWithStatus:@"Generating obituary ..."];
	[self.alertView show];
	
	NSLog(@"Friend picked: %@", friendID);
	

	NSData *imageData = UIImageJPEGRepresentation(targetImage, 0.5);
	

	NSString *obituaryURL;
	obituaryURL = [[AssassinsServer sharedServer] postKillWithToken:(NSString *) facebook.accessToken
														  imageData:imageData
														   killerID:@"867800458"
														   victimID:@"583002418"
														   location:@"53.523574,-113.524046"
													 attackSequence:self.appDelegate.hitCombo];
	[self.alertView hide];
	[self dismissModalViewControllerAnimated:YES];
	NSLog(@"Obituary returned was: %@", obituaryURL);
	if (obituaryURL==@""){
		UIAlertView *alert;
		
		alert = [[UIAlertView alloc] initWithTitle:@"Error" 
											   message:@"Unable to create obituary." 
											  delegate:self cancelButtonTitle:@"Ok" 
									 otherButtonTitles:nil];

		[alert show];
		[alert release];		
	}
	else{
		//TODO Uncomment the following when server is working
		//[self showObituary:obituaryURL];
		[self showObituary:@"http://msn.com"];
	}
	//TODO - Display a webview with the obituaryURL	or error dialog.		
}
	
- (void) showObituary:(NSString *)obituaryURL{
	//Temporary to test loading the ObituaryView.  Move this to donePicking method
	//[self.view addSubview:obituaryController.view];
	
	if (obituaryViewController)
		[obituaryViewController release];
	
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


@end
