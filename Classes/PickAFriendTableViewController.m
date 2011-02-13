//
//  PickAFriendTableViewController.m
//  Assassins
//
//  Created by Cameron Linke on 11-02-12.
//  Copyright 2011 Independent. All rights reserved.
//

#import "PickAFriendTableViewController.h"
#import "SBJSON.h"

@implementation PickAFriendTableViewController

@synthesize delegate, friendPic, imageView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil friendJSON:(NSArray*) friendArray friendPic:(UIImage *)friendPicture{
	NSLog(@"Friend Array - %d", [friendArray count]);
	NSDictionary *firstFriendTest = [friendArray objectAtIndex:0];
	NSString *name = (NSString*) [firstFriendTest objectForKey:@"name"];
	NSString *userID = (NSString*) [firstFriendTest objectForKey:@"id"];
	NSLog(@"First friend name: %@ id: %@", name, userID);	
	self.friendPic = friendPicture;
	return [self initWithNibName:nil bundle:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.imageView.image = self.friendPic;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark IBOutlet methods

- (IBAction) onPost{
	//Stub in facebook ID for now
	NSString *facebookFriendID = @"1234";
	if (self.delegate!=nil)
	{
		if ([self.delegate respondsToSelector:@selector(donePickingFriendWithID:)])
		{
			[self.delegate donePickingFriendWithID:facebookFriendID];
		}
	}
}

@end
