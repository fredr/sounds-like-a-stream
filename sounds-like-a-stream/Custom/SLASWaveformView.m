/**
 * Author: Fredrik Enestad @ Devloop AB (fredrik@devloop.se)
 * Date: 2012-07-11
 * Time: 10:25
 */


#import "SLASWaveformView.h"
#import "UIImage+Masking.h"


@implementation SLASWaveformView {

}
@synthesize waveformURL;
@synthesize imageData;


- (void)setWaveformURL:(NSURL *)aWaveformURL {
    self.imageData = [NSMutableData data];
    waveformURL = aWaveformURL;

    // start request to get mask image
    NSURLRequest *request = [NSURLRequest requestWithURL:aWaveformURL];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.imageData = nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *mask = [[UIImage alloc] initWithData:self.imageData];
    mask = [mask fixMaskImage];

    UIImage * waveform = [mask maskImage:[UIImage imageWithColor:[UIColor orangeColor] andSize:self.frame.size]];

    UIImageView *waveImageView = [[UIImageView alloc] initWithImage:waveform];
    waveImageView.frame = CGRectMake(self.frame.origin.x, self.frame.size.height/2, self.frame.size.width, self.frame.size.height);
    [self addSubview:waveImageView];

    self.imageData = nil;
}

@end