//
//  SLASStreamHandlerTests.m
//  sounds-like-a-stream
//
//  Created by Fredrik Enestad on 2012-08-22.
//  Copyright (c) 2012 Devloop AB. All rights reserved.
//

#import "SLASStreamHandlerTests.h"
#import "SLASStream.h"
#import "SLASStreamHandler.h"
#import "SLASTrack.h"

@implementation SLASStreamHandlerTests

- (void)setUp
{
    [super setUp];
    self.handler = [[SLASStreamHandler alloc] init];
}

- (void)tearDown {
    self.handler = nil;
    [super tearDown];
}

- (void)testParseStreamData
{
    [self.handler setData:[self dataWithNextUrl]];
    SLASStream * stream = [self.handler process];

    STAssertEquals(2, (NSInteger)[stream.tracks count], @"Number of tracks are incorrect");
    STAssertEqualObjects(@"5901fd00-ea3e-11e1-876f-556d60ed9c36", stream.pageCursor, @"Couldn't parse page cursor");
}

- (void)testParseStreamTracksData
{
    [self.handler setData:[self dataWithNextUrl]];
    SLASStream * stream = [self.handler process];
    SLASTrack * track1 = [stream.tracks objectAtIndex:0];
    SLASTrack * track2 = [stream.tracks objectAtIndex:1];

    STAssertEqualObjects([NSNumber numberWithInteger:56866635], track1.id, @"Incorrect ID");
    STAssertEqualObjects([NSNumber numberWithInteger:56865922], track2.id, @"Incorrect ID");

    STAssertEqualObjects(@"Document One - Body Pump (D Is for Document One)", track1.name, @"Incorrect name");
    STAssertEqualObjects(@"Document One - Shouting from a mountain", track2.name, @"Incorrect name");

    STAssertEqualObjects([NSURL URLWithString:@"http://soundcloud.com/buygore/document-one-body-pump-d-is"], track1.permalink, @"Incorrect permalink");
    STAssertEqualObjects([NSURL URLWithString:@"http://soundcloud.com/buygore/document-one-shouting-from-a"], track2.permalink, @"Incorrect permalink");

    STAssertEqualObjects([NSURL URLWithString:@"https://w1.sndcdn.com/vtAlbEJUukbU_m.png"], track1.waveformURL, @"Incorrect wave form url");
    STAssertEqualObjects([NSURL URLWithString:@"https://w1.sndcdn.com/Ww8CkeclNbH8_m.png"], track2.waveformURL, @"Incorrect wave form url");

}

- (void)testHaveMore
{
    [self.handler setData:[self dataWithNextUrl]];
    SLASStream * stream = [self.handler process];

    STAssertTrue(stream.haveMore, @"Stream have more info is incorrect");
}

- (void)testHaveNoMore
{
    [self.handler setData:[self dataWithoutNextUrl]];
    SLASStream * stream = [self.handler process];

    STAssertFalse(stream.haveMore, @"Stream have more info is incorrect");
}

- (NSData *)dataWithNextUrl {
    return [@"{\n"
            "    \"collection\":  [\n"
            "         {\n"
            "             \"origin\":  {\n"
            "                 \"id\": 56866635,\n"
            "                 \"title\": \"Document One - Body Pump (D Is for Document One)\",\n"
            "                 \"permalink_url\": \"http://soundcloud.com/buygore/document-one-body-pump-d-is\",\n"
            "                 \"waveform_url\": \"https://w1.sndcdn.com/vtAlbEJUukbU_m.png\"\n"
            "             }\n"
            "         },\n"
            "         {\n"
            "             \"origin\":  {\n"
            "                 \"id\": 56865922,\n"
            "                 \"title\": \"Document One - Shouting from a mountain\",\n"
            "                 \"permalink_url\": \"http://soundcloud.com/buygore/document-one-shouting-from-a\",\n"
            "                 \"waveform_url\": \"https://w1.sndcdn.com/Ww8CkeclNbH8_m.png\"\n"
            "             }\n"
            "         }\n"
            "         ],\n"
            " \"next_href\": \"https://api.soundcloud.com/me/activities/track?cursor=5901fd00-ea3e-11e1-876f-556d60ed9c36&limit=2\"\n"
            "}" dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataWithoutNextUrl {
    return [@"{\n"
            "    \"collection\":  [\n"
            "         {\n"
            "             \"origin\":  {\n"
            "                 \"id\": 56866635,\n"
            "                 \"title\": \"Document One - Body Pump (D Is for Document One)\",\n"
            "                 \"permalink_url\": \"http://soundcloud.com/buygore/document-one-body-pump-d-is\",\n"
            "                 \"waveform_url\": \"https://w1.sndcdn.com/vtAlbEJUukbU_m.png\"\n"
            "             }\n"
            "         },\n"
            "         {\n"
            "             \"origin\":  {\n"
            "                 \"id\": 56865922,\n"
            "                 \"title\": \"Document One - Shouting from a mountain\",\n"
            "                 \"permalink_url\": \"http://soundcloud.com/buygore/document-one-shouting-from-a\",\n"
            "                 \"waveform_url\": \"https://w1.sndcdn.com/Ww8CkeclNbH8_m.png\"\n"
            "             }\n"
            "         }\n"
            "         ]\n"
            "}" dataUsingEncoding:NSUTF8StringEncoding];
}




@end
