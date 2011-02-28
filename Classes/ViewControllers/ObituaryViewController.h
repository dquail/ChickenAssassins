//
//  ObituaryViewController.h
//  Assassins
//
//  Created by David Quail on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "ActivityAlert.h"
#import "AssassinsServer.h"

@interface ObituaryViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, 
													MFMailComposeViewControllerDelegate,FBRequestDelegate>{
	UIWebView *_webView;
	NSString *obituaryURL;
	id <UIWebViewDelegate> delegate;
	UIToolbar *toolBar;
    ActivityAlert *alertView;
														
}
@property (nonatomic, retain) IBOutlet UIWebView *_webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) ActivityAlert *alertView;

@property (nonatomic, retain) id delegate;

- (id) initWithObituaryURL:(NSString *)url;
- (IBAction) onPostLink;
- (IBAction) onCloseObituary;

@end
