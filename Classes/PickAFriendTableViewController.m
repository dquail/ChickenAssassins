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
@synthesize arrayOfFriends;
@synthesize postButton;
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
	arrayOfFriends = friendArray;
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
	postButton.enabled = FALSE;
	currentRow = -1;
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

- (IBAction) onCancel{
	if (self.delegate!=nil)
	{
		if ([self.delegate respondsToSelector:@selector(donePickingFriendWithID:)])
		{
			[self.delegate donePickingFriendWithID:nil];
		}
	}
}

- (IBAction) onPost{
	
	NSDictionary *firstFriendTest = [arrayOfFriends objectAtIndex:currentRow];
	NSString *facebookFriendID = (NSString*) [firstFriendTest objectForKey:@"id"];
	
	if (self.delegate!=nil)
	{
		if ([self.delegate respondsToSelector:@selector(donePickingFriendWithID:)])
		{
			[self.delegate donePickingFriendWithID:facebookFriendID];
		}
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayOfFriends count];
}

/*
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return 51;
 }
 */

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		//[[NSBundle mainBundle] loadNibNamed:@"MissionListCell" owner:self options:NULL];
		//cell = nibLoadedCell;
		//cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell-Green.png"]] autorelease];    
	}
	
	NSUInteger row = [indexPath row];
	
	NSDictionary *firstFriendTest = [arrayOfFriends objectAtIndex:row];
	NSString *name = (NSString*) [firstFriendTest objectForKey:@"name"];
	cell.textLabel.text = name;
	
	//NSDictionary *cellData = [dataArray objectAtIndex:indexPath.row];	
	//UILabel *titleLabel = (UILabel *)[cell viewWithTag:1]; 
	//titleLabel.text = [cellData objectForKey:kMissionName];
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	postButton.enabled = TRUE;
	currentRow = [indexPath row];
	
	/*
	 NSDictionary *cellData = [dataArray objectAtIndex:indexPath.row];
	 
	 MissionDetailViewController *detailViewController = [[MissionDetailViewController alloc] 
	 initWithNibName:@"MissionDetailViewController" bundle:nil];
	 [detailViewController setDataDictionary:cellData];
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 
	 // need to push MissionDetailViewController which should have a nav controller which will return to the table view
	 */
}	
@end