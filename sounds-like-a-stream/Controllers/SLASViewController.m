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

@interface SLASViewController ()

@end

@implementation SLASViewController {
}

@synthesize stream;


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.stream = [[SLASStream alloc] init];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([SCSoundCloud account] == nil) {
        // login user if we dont have any account info
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - SoundCloud
- (void)getStream
{
    // don't request anything if we already got all
    if (!self.stream.haveMore) return;

    SCAccount *account = [SCSoundCloud account];
    SLASStreamHandler *handler = [[SLASStreamHandler alloc] init];

    NSDictionary * parameters = [[NSDictionary alloc] initWithObjectsAndKeys:
            @"12", @"limit",
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

                        [handler initWithData:data];
                        SLASStream * streamPage = [handler process];

                        self.stream.tracks = [self.stream.tracks arrayByAddingObjectsFromArray:streamPage.tracks];
                        self.stream.pageCursor = streamPage.pageCursor;
                        self.stream.haveMore = streamPage.haveMore;

                        [self.tableView reloadData];
                    }
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

    static NSString *MyIdentifier = @"StreamCell";

   	// Try to retrieve from the table view a now-unused cell with the given identifier.
   	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

   	// If no cell is available, create a new one using the given identifier.
   	if (cell == nil) {
   		// Use the default cell style.
   		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
   	}

   	// Set up the cell.
    SLASTrack * track = [self.stream.tracks objectAtIndex:(NSUInteger)indexPath.row];
   	cell.textLabel.text = [track name];

   	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.stream.tracks.count - 1) {
        [self getStream];
    }
}

@end

