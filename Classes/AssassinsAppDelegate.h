//
//  AssassinsAppDelegate.h
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssassinateHUDViewController.h"
#import "AttackViewController.h"
#import "AttackCompletedViewController.h"

#import "Facebook.h"

@class AssassinsViewController;

@interface AssassinsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	AttackViewController *attackController;
	AttackCompletedViewController *completedController;
    AssassinsViewController *viewController;
	AssassinateHUDViewController *hudController;	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AssassinsViewController *viewController;
@property (nonatomic, retain) AttackViewController *attackController;
@property (nonatomic, retain) AttackCompletedViewController *completedController;
@property (nonatomic, retain) AssassinateHUDViewController *hudController;

- (void) lockTarget: (UIImage *) targetImage;
- (void) targetKilled: (UIImage *)targetImage;
- (void) showHud;
@end

