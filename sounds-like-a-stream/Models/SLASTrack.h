/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-10
 * Time: 14:12
 */


#import <Foundation/Foundation.h>


@interface SLASTrack : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * permalink;
@property (nonatomic, strong) NSURL * waveformURL;

@end