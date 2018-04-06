//
//  PFAProductListViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 29/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"
#import "PFAAPIRequest.h"
#import "PFAAPIRequestDelegate.h"
#import "PFASupplierAPI.h"
#import "PFASupplierAPIDelegate.h"

@interface PFAProductListViewController : PFAViewController <PFAAPIRequestDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, PFASupplierAPIDelegate> {
    BOOL forOrders;
}

@property (strong) NSMutableArray *masterList;
@property (strong) NSMutableArray *searchableList;
@property (strong) UISearchBar *searchBar;
@property (strong) UITableView *tableView;
@property (strong) PFASupplierAPI *api;

- (void) setForOrders:(BOOL)flag;

@end
