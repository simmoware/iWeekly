//
//  PFAItemDetailViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 23/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAViewController.h"
#import "PFALoadingView.h"
#import "PFAAPIRequest.h"
#import "PFAAPIRequestDelegate.h"

@interface PFAItemDetailViewController : PFAViewController <PFAAPIRequestDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong) NSMutableDictionary *params;
@property (strong) NSMutableArray *results;
@property (strong) NSString *title;
@property (strong) NSDictionary *keys;
@property (strong) UITableView *tableView;
@property (strong) UIToolbar *dateToolbar;
@property (strong) UIBarButtonItem *currentDate;

@end
