//
//  AssassinateHUD.h
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AssassinateHUDViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate> {
	UIImagePickerController *camera;
	UIView *overlay;
	AssassinsAppDelegate *appDelegate;
	CLLocationManager	*locationManager;
	CLLocation			*startingPoint;
}

@property (nonatomic, retain) UIImage *targetImage;
@property (nonatomic, retain) IBOutlet UIView *overlay;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *startingPoint;
@property (nonatomic, retain) AssassinsAppDelegate *appDelegate;

- (IBAction) onLockTarget; 

@end
