/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-10
 * Time: 14:13
 */


#import <Foundation/Foundation.h>


@interface SLASStream : NSObject

@property (nonatomic, strong) NSArray * tracks;
@property (nonatomic, strong) NSString * pageCursor;
@property (nonatomic, assign) BOOL haveMore;


@end