//
//  ObituaryViewController.h
//  Assassins
//
//  Created by David Quail on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ObituaryViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *_webView;
	NSString *obituaryURL;
	id <UIWebViewDelegate> delegate;
	UIToolbar *toolBar;
}
@property (nonatomic, retain) IBOutlet UIWebView *_webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;
@property (nonatomic, retain) id delegate;

- (id) initWithObituaryURL:(NSString *)url;
- (IBAction) onPostLink;
- (IBAction) onCloseObituary;

@end
