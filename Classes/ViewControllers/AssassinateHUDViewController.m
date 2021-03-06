//
//  AssassinateHUD.m
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AssassinateHUDViewController.h"
#import "AttackViewController.h"
#import "AssassinsAppDelegate.h"

@implementation AssassinateHUDViewController

@synthesize locationManager;
@synthesize startingPoint;
//@synthesize targetImage, 
@synthesize overlay;

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
	camera.delegate = self;
	camera.allowsEditing = NO;
	camera.toolbarHidden = YES;
	camera.wantsFullScreenLayout = YES;
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		camera.sourceType =  UIImagePickerControllerSourceTypeCamera;
		camera.showsCameraControls = NO;
		camera.cameraOverlayView = self.overlay;
        camera.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.15);        
	} else {
		camera.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	[locationManager startUpdatingLocation];
}

- (void) viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];


	[self presentModalViewController:camera animated:YES];

	//Only show once
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	BOOL shouldShowAlert =  ![defaults boolForKey:@"hudAlertedOnce"];
	
	if (shouldShowAlert){
		[defaults setBool:YES forKey:@"hudAlertedOnce"];	
		[defaults synchronize];
		
		UIAlertView *alert;
		
		alert = [[UIAlertView alloc] initWithTitle:@"Lock your target" 
										   message:@"Once you've got your target in your crosshairs, tap the screen.  Then you can start attacking them with your rubber chicken!" 
										  delegate:self cancelButtonTitle:@"Ok" 
								 otherButtonTitles:nil];
		[alert show];		
	}
	
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

	[overlay release];
	
	[locationManager stopUpdatingLocation];
	[locationManager release];
	[startingPoint release];

}

#pragma mark CameraOverlay callbacks 
- (IBAction) onLockTarget{
	//Take a photo of the target.  
	[camera takePicture];
}
#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	[locationManager stopUpdatingLocation];
	
	appDelegate.attackInfo.location = [NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
	NSLog(@"Location set to %@", appDelegate.attackInfo.location);
	self.startingPoint = newLocation;
}

#pragma mark -
#pragma mark UIImagePickerController delegate
/*
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
*/
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Select a photo" 
									   message:@"You must select a photo to use Rubber Chicken Assassins." 
									  delegate:self cancelButtonTitle:@"Ok" 
							 otherButtonTitles:nil] autorelease];
	[alert show];
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	AssassinsAppDelegate *appDelegate = (AssassinsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	//self.targetImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	[appDelegate lockTarget:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
}

@end
