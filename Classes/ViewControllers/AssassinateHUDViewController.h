//
//  AssassinateHUD.h
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weapon.h"
#import "RayGun.h"

@interface AssassinateHUDViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	UIImagePickerController *camera;
	UIView *overlay;
}

@property (nonatomic, retain) UIImage *targetImage;
@property (nonatomic, retain) IBOutlet UIView *overlay;

- (IBAction) onLockTarget; 

@end
