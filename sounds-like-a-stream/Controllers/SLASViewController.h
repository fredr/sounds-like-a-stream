//
//  SLASViewController.h
//  sounds-like-a-stream
//
//  Created by Fredrik Enestad on 2012-06-18.
//  Copyright (c) 2012 Devloop AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLASStream;

@interface SLASViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SLASStream * stream;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIActivityIndicatorView * loadingView;
@property (nonatomic, strong) NSMutableDictionary * waveformCache;


@end
