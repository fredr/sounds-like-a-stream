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



- (void)setData:(NSData *)data {

    self.trackData = [data objectFromJSONData];
}

- (SLASStream *)process {

    NSMutableArray * tracks = [[NSMutableArray alloc] init];

    NSArray * collection = [self.trackData objectForKey:@"collection"];

    // extract track data
    for (NSDictionary * trackInfo in collection) {
        NSDictionary * origin = [trackInfo objectForKey:@"origin"];

        SLASTrack * track = [[SLASTrack alloc] init];
        track.name = [origin objectForKey:@"title"];
        track.id = [origin objectForKey:@"id"];
        track.permalink = [origin objectForKey:@"permalink_url"];
        track.waveformURL = [NSURL URLWithString:[origin objectForKey:@"waveform_url"]];

        [tracks addObject:track];

    }

    SLASStream * stream = [[SLASStream alloc] init];


    // check if there is a next page
    NSString * nextURL = [self.trackData objectForKey:@"next_href"];
    if (nextURL.length == 0) {
        stream.haveMore = NO;
    }
    else {
        // extract the cursor parameter, since the next_href forgets .json

        NSURL *next = [NSURL URLWithString:nextURL];

        for (NSString *param in [[next query] componentsSeparatedByString:@"&"]) {
          NSArray *keyValue = [param componentsSeparatedByString:@"="];
          if([keyValue count] == 2) {
              NSString *key = [keyValue objectAtIndex:0];
              NSString *value = [keyValue objectAtIndex:1];

              if ([key isEqualToString:@"cursor"]) {
                  stream.pageCursor = value;
              }

          }
        }

    }



    stream.tracks = tracks;

    return stream;
}


@end