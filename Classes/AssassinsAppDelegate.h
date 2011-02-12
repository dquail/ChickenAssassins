//
//  AssassinsAppDelegate.h
//  Assassins
//
//  Created by David Quail on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssassinsViewController;

@interface AssassinsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AssassinsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AssassinsViewController *viewController;

@end

