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

@interface SLASViewController ()

@end

@implementation SLASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    SCAccount *account = [SCSoundCloud account];
    SLASStreamHandler *handler = [[SLASStreamHandler alloc] init];

    [SCRequest  performMethod:SCRequestMethodGET
                   onResource:[NSURL URLWithString:@"https://api.soundcloud.com/me/activities/track.json"]
              usingParameters:nil
                  withAccount:account
       sendingProgressHandler:nil
              responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                    // Handle the response
                    if (error) {
                        NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                    } else {

                        [handler initWithData:data];
                        SLASStream * stream = [handler process];
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
@end
