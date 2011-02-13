//
//  PhotoUploader.h
//  Assassins
//
//  Created by David Quail on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoUploaderDelegate <NSObject>
- (void) onUploadSuccess;
- (void) onUploadError;
@end


@interface PhotoUploader : NSObject {
    NSURL *serverURL;
    NSData *imageData;
	NSDictionary *parameters;
    id<PhotoUploaderDelegate> delegate;
	
    BOOL uploadDidSucceed;
}

- (id)initWithURL: (NSURL *)aServerURL   // IN
		imageData: (NSData *)imgData
	   parameters: (NSDictionary *)params// IN
         delegate: (id<PhotoUploaderDelegate>)aDelegate         // IN
;

-   (NSString *)filePath;

@end
