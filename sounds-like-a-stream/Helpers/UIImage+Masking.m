/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-11
 * Time: 10:04
 */


#import "UIImage+Masking.h"


@implementation UIImage (Masking)

/**
* Modified code from http://stackoverflow.com/a/9691918/87750
*/
- (UIImage*)fixMaskImage {

    UIImage * sourceImage = [UIImage imageWithColor:[UIColor whiteColor] andSize:self.size];

    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, sourceImage.scale);
    [sourceImage drawAtPoint:CGPointZero];
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

/**
* Modified code from http://stackoverflow.com/questions/10992290/how-to-create-own-mask-in-ios
*/
- (UIImage*)maskImage:(UIImage *)image {

    CGImageRef maskRef = self.CGImage;

    CGImageRef mask = CGImageMaskCreate(
                                        CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false
                                        );

    CGImageRef masked = CGImageCreateWithMask(image.CGImage, mask);
    CGImageRelease(mask);
    return [UIImage imageWithCGImage:masked];
}


/**
* Modified code from http://stackoverflow.com/a/1213816/87750
*/
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
  //Create a context of the appropriate size
  UIGraphicsBeginImageContext(size);
  CGContextRef currentContext = UIGraphicsGetCurrentContext();

  //Build a rect of appropriate size at origin 0,0
  CGRect fillRect = CGRectMake(0,0,size.width,size.height);

  //Set the fill color
  CGContextSetFillColorWithColor(currentContext, color.CGColor);

  //Fill the color
  CGContextFillRect(currentContext, fillRect);

  //Snap the picture and close the context
  UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return retval;
}

@end