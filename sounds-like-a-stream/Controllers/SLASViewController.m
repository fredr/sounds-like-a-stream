//
//  SLASViewController.m
//  sounds-like-a-stream
//
//  Created by Fredrik Enestad on 2012-06-18.
//  Copyright (c) 2012 Devloop AB. All rights reserved.
//

#import "SCUI.h"
#import "SLASViewController.h"
#import "SLASStreamHandler.h"
#import "SLASStream.h"
#import "SLASTrack.h"
#import "SLASWaveformView.h"
#import "SLASStreamTableViewCell.h"

@interface SLASViewController ()

@end

@implementation SLASViewController {
}

@synthesize stream, isLoading, loadingView, waveformCache;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.stream = [[SLASStream alloc] init];
    self.isLoading = NO;
    self.waveformCache = [[NSMutableDictionary alloc] init];

    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(0, 0, 360, 40);
    activityIndicatorView.color = [UIColor orangeColor];
    [activityIndicatorView startAnimating];


    self.loadingView = activityIndicatorView;

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([SCSoundCloud account] == nil) {
        // login user if we don't have any account info
        [self login];
    }
    else {
        // get stream if the user is already logged in
        [self getStream];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - SoundCloud
- (void)getStream
{
    // don't request anything if we already got all, or if we are currently waiting for a request
    if (!self.stream.haveMore || self.isLoading) return;

    self.isLoading = YES;

    // show loadingView in footer
    self.tableView.tableFooterView = self.loadingView;

    SCAccount *account = [SCSoundCloud account];
    SLASStreamHandler *handler = [[SLASStreamHandler alloc] init];

    NSDictionary * parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        @"8", @"limit",
                                                        self.stream.pageCursor, @"cursor",
                                                        nil];

    [SCRequest  performMethod:SCRequestMethodGET
                   onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me/activities/track.json"]
              usingParameters:parameters
                  withAccount:account
       sendingProgressHandler:nil
              responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                    // Handle the response
                    if (error) {
                        NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                    } else {

                        [handler setData:data];
                        SLASStream * streamPage = [handler process];

                        self.stream.tracks = [self.stream.tracks arrayByAddingObjectsFromArray:streamPage.tracks];
                        self.stream.pageCursor = streamPage.pageCursor;
                        self.stream.haveMore = streamPage.haveMore;

                        [self.tableView reloadData];
                    }

                  // we are done loading..
                  self.isLoading = NO;

                  // remove loadingView from footer
                  self.tableView.tableFooterView = nil;
      }];
    }

- (void)login
{
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");

                                                                          } else if (error) {
                                                                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);

                                                                          } else {

                                                                              // Succeeded to login, get stream

                                                                              [self getStream];
                                                                              NSLog(@"Done!");
                                                                          }
                                                                      }];
        
        [self presentModalViewController:loginViewController
                                animated:YES];
        
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stream.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {

    static NSString *CellIdentifier = @"StreamCell";

   	// Try to retrieve from the table view a now-unused cell with the given identifier.
    SLASStreamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

   	// If no cell is available, create a new one using the given identifier.
   	if (cell == nil) {
   		// Use the default cell style.
   		cell = [[SLASStreamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   	}

    // try to get the waveform view from cache first, to prevent flickering, and to prevent us from doing lots of requests
    SLASWaveformView * view = [self.waveformCache objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];

    // Set up the cell.
    SLASTrack * track = [self.stream.tracks objectAtIndex:(NSUInteger)indexPath.row];
    cell.trackTitle.text = [track name];
    cell.trackTitle.backgroundColor = [UIColor clearColor];

    if (view == nil) {
        view = [[SLASWaveformView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        view.waveformURL = track.waveformURL;

        // hide things that end up outside the view
        view.clipsToBounds = YES;

        view.backgroundColor = [UIColor whiteColor];

        // add to cache
        [self.waveformCache setObject:view forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
    }

    cell.backgroundView = view;



   	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.stream.tracks.count - 1) {
        [self getStream];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SLASTrack * track = [self.stream.tracks objectAtIndex:(NSUInteger)indexPath.row];

    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"soundcloud:tracks:"]]) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"soundcloud:tracks:%@", track.id]]];

    }
    else {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:track.permalink]];

    }



    // deselect directly, so that the selection don't stick
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IBActions

-(IBAction)logout {
    [SCSoundCloud removeAccess];

    self.stream = [[SLASStream alloc] init];
    self.isLoading = NO;
    self.waveformCache = [[NSMutableDictionary alloc] init];
    [self.tableView reloadData];

    [self login];

}

@end

