//
//  AssassinsAppDelegate.m
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AssassinsAppDelegate.h"

#define FACEBOOK_APP_ID @"189234387766257"

@implementation AssassinsAppDelegate

@synthesize window;
//@synthesize hudController, attackController, completedController, facebook, attackInfo;
@synthesize facebook, attackInfo;
@synthesize attackController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	// Override point for customization after application launch.
	self.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID];
	
    // Add the view controller's view to the window and display.
	
	//Create the Hudview
	hudController = [[AssassinateHUDViewController alloc] initWithNibName:nil bundle:nil];
    
 	self.attackInfo = [[AttackInfo alloc] init];

    [window addSubview:hudController.view];
	[window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	/*[attackController release];
	[completedController release];
	[hudController release];	*/
	[facebook release];
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	[self.facebook handleOpenURL:url];
	return TRUE;
}

#pragma mark -
#pragma mark View management


/*
 * Show the attack controller that allows a user to select a target
 */
- (void) lockTarget:(UIImage *) targetImage{
	
	if (nil != attackController){
		[attackController resetUsingImage:targetImage];
	}
	

	self.attackController = [[AttackViewController alloc] initWithTargetImage:targetImage];
	
	[hudController.view removeFromSuperview];
	[hudController release];
	hudController = nil;
	[[[UIApplication sharedApplication] keyWindow] addSubview:attackController.view];	
	//[attackController autorelease];
}

- (void) targetKilled:(UIImage *) targetImage{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[[UIApplication sharedApplication] keyWindow] cache:YES];


	if (nil != completedController){
		[completedController release];
		completedController = nil;
	}
	completedController = [[AttackCompletedViewController alloc] initWithTargetImage:targetImage andFacebook:self.facebook];
	[[[UIApplication sharedApplication] keyWindow] addSubview:completedController.view];
	[UIView commitAnimations];			
	[attackController.view removeFromSuperview];
	[self.attackController autorelease];	
}

/* 
 * Show the Screen allowing a user to lock on to a target
 */
- (void) showHud{
	//Create the Hudview
	if (nil != hudController){
		[hudController release];
		hudController = nil;
	}
	hudController = [[AssassinateHUDViewController alloc] initWithNibName:nil bundle:nil];
	[completedController.view removeFromSuperview];
	[completedController release];
	completedController = nil;
	[[[UIApplication sharedApplication] keyWindow] addSubview:hudController.view];
	
}

@end
