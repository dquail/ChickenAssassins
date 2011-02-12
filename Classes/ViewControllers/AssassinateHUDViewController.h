//
//  AssassinateHUD.h
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssassinsAppDelegate;

@interface AssassinateHUDViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	UIImagePickerController *camera;
	UIView *overlay;
	AssassinsAppDelegate *appDelegate;
}

@property (nonatomic, retain) UIImage *targetImage;
@property (nonatomic, retain) IBOutlet UIView *overlay;
@property (nonatomic, retain) AssassinsAppDelegate *appDelegate;

- (IBAction) onLockTarget; 

@end
