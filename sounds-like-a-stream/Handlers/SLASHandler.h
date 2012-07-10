/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-09
 * Time: 23:03
 */


@protocol SLASHandler

-(id)initWithData:(NSData *)data;
-(id)process;

@end