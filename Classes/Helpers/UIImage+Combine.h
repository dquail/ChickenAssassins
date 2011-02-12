//
//  UIImage+Combine.h
//  Assassins
//
//  Created by David Quail on 10/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (combine)
- (UIImage *)scaledToSize:(CGSize)newSize ;
- (UIImage*)overlayWith:(UIImage*)overlayImage;

@end
