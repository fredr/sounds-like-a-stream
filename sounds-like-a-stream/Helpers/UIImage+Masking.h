/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-11
 * Time: 10:04
 */


#import <Foundation/Foundation.h>

@interface UIImage (Masking)

- (UIImage*)maskImage:(UIImage *)image;
- (UIImage*)fixMaskImage;
+ (UIImage*)imageWithColor:(UIColor *)color andSize:(CGSize)size;

@end