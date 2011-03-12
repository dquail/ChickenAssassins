//
//  PickAFriendTableViewController.m
//  Assassins
//
//  Created by Cameron Linke on 11-02-12.
//  Copyright 2011 Independent. All rights reserved.
//

#import "PickAFriendTableViewController.h"
#import "SBJSON.h"
#import "AssassinsAppDelegate.h"
#import "Friend.h"

@implementation PickAFriendTableViewController

@synthesize delegate, friendPic, imageView;
@synthesize arrayOfFriends;
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
	if (self = [self initWithNibName:nil bundle:nil]) {
		arrayOfFriends = [friendArray mutableCopy];
		[arrayOfFriends sortUsingComparator: ^NSComparisonResult(id obj1, id obj2){
			NSDictionary* dict1 = (NSDictionary*)obj1;
			NSDictionary* dict2 = (NSDictionary*)obj2;
			NSString* str1 = [dict1 objectForKey: @"name"];
			NSString* str2 = [dict2 objectForKey: @"name"];
			NSComparisonResult cr = [str1 compare: str2];
			return cr;
		}];	
		
		index = [[NSMutableArray alloc] initWithCapacity:26];
		friendData = [[NSMutableDictionary alloc] initWithCapacity:26];
		
		Friend *friend;
		for (int i = 0; i < [arrayOfFriends count]; i++){
			friend = [[[Friend alloc] init] autorelease];
			friend.name = (NSString*)[[arrayOfFriends objectAtIndex:i] objectForKey:@"name"];
			friend.facebookID = (NSString*) [[arrayOfFriends objectAtIndex:i] objectForKey:@"id"]; 
			NSRange range = {0, 1};
			NSString* firstChar = [friend.name substringWithRange:range];
			NSMutableArray *array = [friendData valueForKey:firstChar];
			if (!array){
				array = [[[NSMutableArray alloc] initWithCapacity:20] autorelease];
				//Add this to the sectionHeaders index
				[index addObject:firstChar];
			}
			[array addObject:friend];
			[friendData setObject:array forKey:firstChar];			 
		}
		self.friendPic = friendPicture;
	}
	
	return self;
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
	[friendPic release];
	[imageView release];
	[arrayOfFriends release];
	[postButton release];	
	[friendData release];
	[index release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark IBOutlet methods

- (IBAction) onCancel{
	if (self.delegate!=nil)
	{
		if ([self.delegate respondsToSelector:@selector(donePickingFriendWithID:)])
		{
			[self.delegate donePickingFriendWithID:nil];
		}
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	NSLog(@"returning %d", [friendData count]);
    return [friendData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"Returning %d", [[friendData objectForKey:[index objectAtIndex:section]] count]);
	return [[friendData objectForKey:[index objectAtIndex:section]] count];

    //return [arrayOfFriends count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [index objectAtIndex: section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    NSArray *array = [friendData objectForKey:[index objectAtIndex:indexPath.section]];
	Friend *friend = [array objectAtIndex:indexPath.row];
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.textLabel.text = friend.name;
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AssassinsAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	
	NSString *key = [index objectAtIndex:indexPath.section];
	Friend *friend = [[friendData objectForKey:key] objectAtIndex:indexPath.row];
	
	appDelegate.attackInfo.targetID = friend.facebookID;
	appDelegate.attackInfo.targetName = friend.name;
	
	if (self.delegate!=nil)
	{
		if ([self.delegate respondsToSelector:@selector(donePickingFriendWithID:)])
		{
			[self.delegate donePickingFriendWithID:appDelegate.attackInfo.targetID];
		}
	}
	
}	
@end