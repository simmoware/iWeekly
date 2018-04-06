//
//  PFASuppliersViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 30/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAViewController.h"
#import "PFAAPIRequest.h"
#import "PFAAPIRequestDelegate.h"

@interface PFASuppliersViewController : PFAViewController <PFAAPIRequestDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    BOOL forOrders;
}

@property (strong) NSMutableArray *masterList;
@property (strong) NSMutableArray *searchableList;
@property (strong) UISearchBar *searchBar;
@property (strong) UITableView *tableView;
- (void) setForOrders:(BOOL)flag;

@end
