/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-09
 * Time: 23:04
 */


#import "SLASStreamHandler.h"
#import "JSONKit.h"
#import "SLASStream.h"
#import "SLASTrack.h"


@implementation SLASStreamHandler

@synthesize trackData;



- (id)initWithData:(NSData *)data {
    self = [super init];
    if (self) {

        self.trackData = [data objectFromJSONData];

    }

    return self;
}

- (SLASStream *)process {

    NSMutableArray * tracks = [[NSMutableArray alloc] init];

    NSArray * collection = [self.trackData objectForKey:@"collection"];

    // extract track data
    for (NSDictionary * trackInfo in collection) {
        NSDictionary * origin = [trackInfo objectForKey:@"origin"];

        SLASTrack * track = [[SLASTrack alloc] init];
        track.name = [origin objectForKey:@"title"];

        [tracks addObject:track];

    }

    SLASStream * stream = [[SLASStream alloc] init];
    stream.tracks = tracks;

    return stream;
}


@end