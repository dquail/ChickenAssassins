//
//  UIImage+Combine.m
//  Assassins
//
//  Created by David Quail on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Combine.h"


@implementation UIImage(combine)
- (UIImage*)overlayWith:(UIImage*)overlayImage {
	// size is taken from the background image
	UIGraphicsBeginImageContext(self.size);
	
	[self drawAtPoint:CGPointZero];
	[overlayImage drawAtPoint:CGPointZero];
	
	UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return combinedImage;
}

- (UIImage *)scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}
@end
