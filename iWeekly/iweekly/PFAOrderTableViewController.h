//
//  PFAOrderTableViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 20/02/2015.
//  Copyright (c) 2015 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"

@interface PFAOrderTableViewController : PFAViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong) UIScrollView *scrollView;
@property (strong) NSMutableArray *results;
@property (strong) NSMutableDictionary *keys;
@property (strong) NSString *title;
@property (strong) UITableView *tableView;

@end
