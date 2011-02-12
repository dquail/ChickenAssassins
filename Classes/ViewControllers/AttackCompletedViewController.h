//
//  AttackCompletedViewController.h
//  Assassins
//
//  Created by David Quail on 11/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttackCompletedViewController : UIViewController {
	UIImageView *targetImageView;
	UIImage *targetImage;
	UIImageView *overlayImageView;
	UILabel *scoreLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *targetImageView;
@property (nonatomic, retain) IBOutlet UIImageView *overlayImageView;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

- (id) initWithTargetImage:(UIImage *)image;
- (IBAction) savePhoto;
@end
