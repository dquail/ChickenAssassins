//
//  AttackCompletedViewController.h
//  Assassins
//
//  Created by David Quail on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Facebook.h"
#import "FBConnect.h"

@class AssassinsAppDelegate;

@interface AttackCompletedViewController : UIViewController <MFMailComposeViewControllerDelegate, FBRequestDelegate, FBDialogDelegate,FBSessionDelegate> {
	UIImageView *targetImageView;
	UIImage *targetImage;
	UIImageView *overlayImageView;
	UILabel *scoreLabel;
	AssassinsAppDelegate *appDelegate;
	Facebook *facebook;
}

@property (nonatomic, retain) IBOutlet UIImageView *targetImageView;
@property (nonatomic, retain) IBOutlet UIImageView *overlayImageView;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) AssassinsAppDelegate *appDelegate;
@property (nonatomic, retain) Facebook *facebook;

- (id) initWithTargetImage:(UIImage *)image andFacebook:(Facebook *) fbook;
- (IBAction) savePhoto;

- (IBAction) postToFacebook;
- (IBAction) emailPhoto;
@end
