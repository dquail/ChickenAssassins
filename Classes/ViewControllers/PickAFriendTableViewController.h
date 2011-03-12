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
	UIImage *friendPic;
	IBOutlet UIImageView *imageView;
	NSMutableArray *arrayOfFriends;
	NSMutableDictionary *friendData;
	NSMutableArray *index;
	UIButton *postButton;
}

@property (nonatomic, assign) id<PickAFriendDelegate> delegate;
@property (nonatomic, retain) UIImage *friendPic;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSMutableArray *arrayOfFriends;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil friendJSON:(NSArray*) friendArray friendPic:(UIImage *)friendPicture;

- (IBAction) onCancel;
@end