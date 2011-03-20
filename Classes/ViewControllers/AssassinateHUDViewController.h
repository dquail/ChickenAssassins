//
//  AssassinateHUD.h
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AssassinsAppDelegate;

@interface AssassinateHUDViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate> {
	UIImagePickerController *camera;
	UIView *overlay;
	
	CLLocationManager	*locationManager;
	CLLocation			*startingPoint;
}

//@property (nonatomic, retain) UIImage *targetImage;
@property (nonatomic, retain) IBOutlet UIView *overlay;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;

- (IBAction) onLockTarget; 
@end
