//
//  SLASViewController.m
//  sounds-like-a-stream
//
//  Created by Fredrik Enestad on 2012-06-18.
//  Copyright (c) 2012 Devloop AB. All rights reserved.
//

#import "SCUI.h"
#import "SLASViewController.h"

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
        [self login];
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
- (void)login;
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
                                                                              NSLog(@"Done!");
                                                                          }
                                                                      }];
        
        [self presentModalViewController:loginViewController
                                animated:YES];
        
    }];
}
@end
