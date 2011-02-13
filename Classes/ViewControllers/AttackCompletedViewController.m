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

static NSString* kAppId = @"189234387766257";
#define ACCESS_TOKEN_KEY @"fb_access_token"
#define EXPIRATION_DATE_KEY @"fb_expiration_date"

@implementation AttackCompletedViewController

@synthesize targetImageView, overlayImageView, scoreLabel, appDelegate, facebook;
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
	[scoreLabel	release];
}

#pragma mark -
#pragma mark UIEvents 
- (IBAction) savePhoto{
	UIImage *killedImage = [[targetImage scaledToSize:overlayImageView.image.size] overlayWith:overlayImageView.image];
	UIImageWriteToSavedPhotosAlbum(killedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction) postToFacebook {
    // on login, use the stored access token and see if it still works
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
    self.facebook.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
    self.facebook.expirationDate = [defaults objectForKey:EXPIRATION_DATE_KEY];
	
    // only authorize if the access token isn't valid
    // if it *is* valid, no need to authenticate. just move on
    if (![self.facebook isSessionValid]) {
		NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
        [self.facebook authorize:permissions delegate:self];
    }
	
	[facebook requestWithGraphPath:@"me/friends" andDelegate:self];
	
}


- (IBAction) emailPhoto {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
		mailComposer.mailComposeDelegate = self; 
		[mailComposer setSubject:NSLocalizedString(@"I assasinated you on Chicken Assasin", @"I assasinated you on chicken assasin")]; 
		[mailComposer addAttachmentData:UIImagePNGRepresentation(targetImage) mimeType:@"image/png" fileName:@"image"]; 
		[mailComposer setMessageBody:NSLocalizedString(@"Here's a picture that I took with my iPhone.", 
													   @"Here's a picture that I took with my iPhone.") isHTML:NO]; 
		[self presentModalViewController:mailComposer animated:YES]; 
		[mailComposer release];
	}
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
#pragma mark Mail Compose Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Facebook delegate
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	NSLog(@"Login succeeded - token - %@", self.facebook.accessToken);
	// store the access token and expiration date to the user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.facebook.accessToken forKey:ACCESS_TOKEN_KEY];
    [defaults setObject:self.facebook.expirationDate forKey:EXPIRATION_DATE_KEY];
    [defaults synchronize];	
	
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
	NSArray *friendArray;
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSDictionary *friendDict = (NSDictionary*) result;
		friendArray = [[friendDict objectForKey:@"data"] retain];  
	}
	NSLog(@"friend count: %d", [friendArray count]);


	PickAFriendTableViewController *pickController = [[PickAFriendTableViewController alloc] initWithNibName:nil bundle:nil friendJSON:friendArray];
	pickController.delegate = self;
	[self presentModalViewController:pickController animated:YES];
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
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
	NSLog(@"Friend picked: %@", friendID);
	[self dismissModalViewControllerAnimated:YES];
}
@end
