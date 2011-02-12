//
//  AttackCompletedViewController.m
//  Assassins
//
//  Created by David Quail on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AttackCompletedViewController.h"
#import "UIImage+Combine.h"

@implementation AttackCompletedViewController

@synthesize targetImageView, overlayImageView, scoreLabel;
#pragma mark -
#pragma mark ViewController lifecycle

- (id) initWithTargetImage:(UIImage *)image{
	if (self = [super initWithNibName:nil bundle:nil])
		targetImage = [image retain];
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
	[scoreLabel	release];
}

#pragma mark -
#pragma mark UIEvents 
- (IBAction) savePhoto{
	UIImage *killedImage = [[targetImage scaledToSize:overlayImageView.image.size] overlayWith:overlayImageView.image];
	UIImageWriteToSavedPhotosAlbum(killedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction) postToFacebook {
	//TODO: implement postToFacebook
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
}

#pragma mark -
#pragma mark Mail Compose Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}
@end
