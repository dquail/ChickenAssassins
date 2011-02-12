//
//  AssassinateHUD.m
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AssassinateHUDViewController.h"
#import "AttackViewController.h"

@implementation AssassinateHUDViewController

@synthesize targetImage, overlay;

#pragma mark -
#pragma mark ViewController lifecycle

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	
	camera  = [[UIImagePickerController alloc] init];
	camera.sourceType =  UIImagePickerControllerSourceTypeCamera;
	camera.delegate = self;
	camera.allowsEditing = NO;
	camera.showsCameraControls = NO;
	camera.toolbarHidden = YES;
	camera.wantsFullScreenLayout = YES;
	camera.cameraOverlayView = self.overlay;

}

- (void) viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];
	[self presentModalViewController:camera animated:YES];
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[camera release];
}

#pragma mark CameraOverlay callbacks 
- (IBAction) onLockTarget{
	//Take a photo of the target.  
	[camera takePicture];
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
	self.overlay.alpha = 1.0f;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	self.targetImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	AttackViewController *attackController = [[AttackViewController alloc] initWithTargetImage:self.targetImage];
	[self.view removeFromSuperview];
	[[[UIApplication sharedApplication] keyWindow] addSubview:attackController.view];
	
}

@end
