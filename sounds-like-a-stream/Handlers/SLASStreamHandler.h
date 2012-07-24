/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-09
 * Time: 23:04
 */


#import <Foundation/Foundation.h>
#import "SLASHandler.h"

@class SLASStream;


@interface SLASStreamHandler : NSObject<SLASHandler>


@property (nonatomic, strong) NSDictionary * trackData;


- (void)setData:(NSData *)data;
- (SLASStream *)process;

@end