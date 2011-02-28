//
//  AttackCompletedViewController.h
//  Assassins
//
//  Created by David Quail on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PickAFriendTableViewController.h"
#import "Facebook+CacheAuth.h"
#import "FBConnect.h"
#import "ActivityAlert.h"
#import "ObituaryViewController.h"

@class AssassinsAppDelegate;

@interface AttackCompletedViewController : UIViewController <MFMailComposeViewControllerDelegate, AssassinsServerDelegate,
				PickAFriendDelegate, FBRequestDelegate, FBDialogDelegate,FBSessionDelegate, UIWebViewDelegate, UIAlertViewDelegate> {
	UIImageView *targetImageView;
	UIImage *targetImage;
	UIImageView *overlayImageView;
	UILabel *scoreLabel;
	ActivityAlert *alertView;
	//Week reference
	Facebook *facebook;
	ObituaryViewController *obituaryViewController;
					
	//ObituaryViewController *obituaryController;
}

@property (nonatomic, retain) IBOutlet UIImageView *targetImageView;
@property (nonatomic, retain) IBOutlet UIImageView *overlayImageView;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) ActivityAlert *alertView;
//@property (nonatomic, retain) ObituaryViewController *obituaryController;

- (id) initWithTargetImage:(UIImage *)image andFacebook:(Facebook *) fbook;
- (IBAction) savePhoto;
- (IBAction) startAttack;
- (IBAction) postToFacebook;
- (IBAction) emailPhoto;
@end
