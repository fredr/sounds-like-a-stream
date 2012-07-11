/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-11
 * Time: 10:25
 */


#import <Foundation/Foundation.h>


@interface SLASWaveformView : UIView

@property (nonatomic, strong) NSURL * waveformURL;
@property (nonatomic, strong) NSMutableData * imageData;

@end