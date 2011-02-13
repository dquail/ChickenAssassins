//
//  PhotoUploader.h
//  Assassins
//
//  Created by David Quail on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoUploader : NSObject {
    NSURL *serverURL;
    NSData *imageData;
	NSDictionary *parameters;
    id delegate;
    SEL doneSelector;
    SEL errorSelector;
	
    BOOL uploadDidSucceed;
}

-   (id)initWithURL: (NSURL *)serverURL
			 params: (NSDictionary *) params
		   imageData: (NSData *)imgData 
		   delegate: (id)delegate 
	   doneSelector: (SEL)doneSelector 
	  errorSelector: (SEL)errorSelector;

-   (NSString *)filePath;

}

@end
