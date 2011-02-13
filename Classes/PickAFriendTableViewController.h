//
//  PickAFriendTableViewController.h
//  Assassins
//
//  Created by Cameron Linke on 11-02-12.
//  Copyright 2011 Independent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickAFriendDelegate <NSObject>
- (void) donePickingFriendWithID:(NSString *) friendID;
@end



@interface PickAFriendTableViewController : UIViewController {
	id<PickAFriendDelegate> delegate;
}

@property (nonatomic, retain) id<PickAFriendDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil friendJSON:(NSArray *) friendsJSON;
- (IBAction) onPost;
@end
