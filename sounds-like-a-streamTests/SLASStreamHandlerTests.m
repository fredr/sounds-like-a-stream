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
    
    NSData *data = [[NSString stringWithString:@"{\n"
                                                "    \"collection\":  [\n"
                                                "         {\n"
                                                "             \"type\": \"track\",\n"
                                                "             \"created_at\": \"2012/08/19 20:48:57 +0000\",\n"
                                                "             \"origin\":  {\n"
                                                "                 \"kind\": \"track\",\n"
                                                "                 \"id\": 56866635,\n"
                                                "                 \"created_at\": \"2012/08/19 20:48:57 +0000\",\n"
                                                "                 \"user_id\": 1537611,\n"
                                                "                 \"duration\": 84146,\n"
                                                "                 \"commentable\": true,\n"
                                                "                 \"state\": \"finished\",\n"
                                                "                 \"original_content_size\": 3364600,\n"
                                                "                 \"sharing\": \"public\",\n"
                                                "                 \"tag_list\": \"\",\n"
                                                "                 \"permalink\": \"document-one-body-pump-d-is\",\n"
                                                "                 \"streamable\": true,\n"
                                                "                 \"embeddable_by\": \"all\",\n"
                                                "                 \"downloadable\": false,\n"
                                                "                 \"purchase_url\": null,\n"
                                                "                 \"label_id\": null,\n"
                                                "                 \"purchase_title\": null,\n"
                                                "                 \"genre\": \"\",\n"
                                                "                 \"title\": \"Document One - Body Pump (D Is for Document One)\",\n"
                                                "                 \"description\": \"\",\n"
                                                "                 \"label_name\": \"\",\n"
                                                "                 \"release\": \"\",\n"
                                                "                 \"track_type\": null,\n"
                                                "                 \"key_signature\": null,\n"
                                                "                 \"isrc\": null,\n"
                                                "                 \"video_url\": null,\n"
                                                "                 \"bpm\": null,\n"
                                                "                 \"release_year\": null,\n"
                                                "                 \"release_month\": null,\n"
                                                "                 \"release_day\": null,\n"
                                                "                 \"original_format\": \"mp3\",\n"
                                                "                 \"license\": \"all-rights-reserved\",\n"
                                                "                 \"uri\": \"https://api.soundcloud.com/tracks/56866635\",\n"
                                                "                 \"user\":  {\n"
                                                "                     \"id\": 1537611,\n"
                                                "                     \"kind\": \"user\",\n"
                                                "                     \"permalink\": \"buygore\",\n"
                                                "                     \"username\": \"Buygore\",\n"
                                                "                     \"uri\": \"https://api.soundcloud.com/users/1537611\",\n"
                                                "                     \"permalink_url\": \"http://soundcloud.com/buygore\",\n"
                                                "                     \"avatar_url\": \"https://i1.sndcdn.com/avatars-000003113844-v133dj-large.jpg?4b4189b\"\n"
                                                "                 },\n"
                                                "                 \"user_playback_count\": 1,\n"
                                                "                 \"user_favorite\": false,\n"
                                                "                 \"permalink_url\": \"http://soundcloud.com/buygore/document-one-body-pump-d-is\",\n"
                                                "                 \"artwork_url\": \"https://i1.sndcdn.com/artworks-000028449014-nzjueu-large.jpg?4b4189b\",\n"
                                                "                 \"waveform_url\": \"https://w1.sndcdn.com/vtAlbEJUukbU_m.png\",\n"
                                                "                 \"stream_url\": \"https://api.soundcloud.com/tracks/56866635/stream\",\n"
                                                "                 \"playback_count\": 1756,\n"
                                                "                 \"download_count\": 0,\n"
                                                "                 \"favoritings_count\": 122,\n"
                                                "                 \"comment_count\": 23,\n"
                                                "                 \"attachments_uri\": \"https://api.soundcloud.com/tracks/56866635/attachments\"\n"
                                                "             },\n"
                                                "             \"tags\": \"affiliated\"\n"
                                                "         },\n"
                                                "         {\n"
                                                "             \"type\": \"track\",\n"
                                                "             \"created_at\": \"2012/08/19 20:42:10 +0000\",\n"
                                                "             \"origin\":  {\n"
                                                "                 \"kind\": \"track\",\n"
                                                "                 \"id\": 56865922,\n"
                                                "                 \"created_at\": \"2012/08/19 20:42:10 +0000\",\n"
                                                "                 \"user_id\": 1537611,\n"
                                                "                 \"duration\": 80147,\n"
                                                "                 \"commentable\": true,\n"
                                                "                 \"state\": \"finished\",\n"
                                                "                 \"original_content_size\": 3204748,\n"
                                                "                 \"sharing\": \"public\",\n"
                                                "                 \"tag_list\": \"\",\n"
                                                "                 \"permalink\": \"document-one-shouting-from-a\",\n"
                                                "                 \"streamable\": true,\n"
                                                "                 \"embeddable_by\": \"all\",\n"
                                                "                 \"downloadable\": false,\n"
                                                "                 \"purchase_url\": null,\n"
                                                "                 \"label_id\": null,\n"
                                                "                 \"purchase_title\": null,\n"
                                                "                 \"genre\": \"\",\n"
                                                "                 \"title\": \"Document One - Shouting from a mountain\",\n"
                                                "                 \"description\": \"\",\n"
                                                "                 \"label_name\": \"\",\n"
                                                "                 \"release\": \"\",\n"
                                                "                 \"track_type\": null,\n"
                                                "                 \"key_signature\": null,\n"
                                                "                 \"isrc\": null,\n"
                                                "                 \"video_url\": null,\n"
                                                "                 \"bpm\": null,\n"
                                                "                 \"release_year\": null,\n"
                                                "                 \"release_month\": null,\n"
                                                "                 \"release_day\": null,\n"
                                                "                 \"original_format\": \"mp3\",\n"
                                                "                 \"license\": \"all-rights-reserved\",\n"
                                                "                 \"uri\": \"https://api.soundcloud.com/tracks/56865922\",\n"
                                                "                 \"user\":  {\n"
                                                "                     \"id\": 1537611,\n"
                                                "                     \"kind\": \"user\",\n"
                                                "                     \"permalink\": \"buygore\",\n"
                                                "                     \"username\": \"Buygore\",\n"
                                                "                     \"uri\": \"https://api.soundcloud.com/users/1537611\",\n"
                                                "                     \"permalink_url\": \"http://soundcloud.com/buygore\",\n"
                                                "                     \"avatar_url\": \"https://i1.sndcdn.com/avatars-000003113844-v133dj-large.jpg?4b4189b\"\n"
                                                "                 },\n"
                                                "                 \"user_playback_count\": 1,\n"
                                                "                 \"user_favorite\": false,\n"
                                                "                 \"permalink_url\": \"http://soundcloud.com/buygore/document-one-shouting-from-a\",\n"
                                                "                 \"artwork_url\": null,\n"
                                                "                 \"waveform_url\": \"https://w1.sndcdn.com/Ww8CkeclNbH8_m.png\",\n"
                                                "                 \"stream_url\": \"https://api.soundcloud.com/tracks/56865922/stream\",\n"
                                                "                 \"playback_count\": 1547,\n"
                                                "                 \"download_count\": 0,\n"
                                                "                 \"favoritings_count\": 127,\n"
                                                "                 \"comment_count\": 26,\n"
                                                "                 \"attachments_uri\": \"https://api.soundcloud.com/tracks/56865922/attachments\"\n"
                                                "             },\n"
                                                "             \"tags\": \"affiliated\"\n"
                                                "         }\n"
                                                "         ],\n"
                                                " \"next_href\": \"https://api.soundcloud.com/me/activities/track?cursor=5901fd00-ea3e-11e1-876f-556d60ed9c36&limit=2\",\n"
                                                " \"future_href\": \"https://api.soundcloud.com/me/activities/track?limit=2&uuid%5Bto%5D=4b994280-ea3f-11e1-9d65-bfc2fc4397af\"\n"
                                                "}"] dataUsingEncoding:NSUTF8StringEncoding];

    self.handler = [[SLASStreamHandler alloc] init];
    [self.handler setData:data];
}

- (void)tearDown {
    self.handler = nil;
    [super tearDown];
}

- (void)testParseStreamData
{
    SLASStream * stream = [self.handler process];

    STAssertEquals(2, (NSInteger)[stream.tracks count], @"Number of tracks are incorrect");
    STAssertEqualObjects(@"5901fd00-ea3e-11e1-876f-556d60ed9c36", stream.pageCursor, @"Couldn't parse page cursor");
    STAssertEquals(YES, stream.haveMore, @"Stream should have more data");
}

- (void)testParseStreamTracksData
{
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




@end
