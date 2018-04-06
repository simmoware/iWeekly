//
//  PFACustomerDetailViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 23/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAViewController.h"
#import "PFAAPIRequest.h"
#import "PFAAPIRequestDelegate.h"
#import "PFASupplierAPIDelegate.h"
#import "PFASupplierAPI.h"

@interface PFACustomerDetailViewController : PFAViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PFAAPIRequestDelegate> {
    BOOL forOrders;
}

@property (strong) UIDatePicker *date;
@property (strong) UITableView *tableView;
@property (strong) UIBarButtonItem *productId;
@property (strong) UIBarButtonItem *dateSelected;
@property (strong) NSMutableArray *inactiveToolbarItems;
@property (strong) NSMutableArray *activeToolbarItems;
@property (strong) NSMutableArray *results;
@property (strong) UIToolbar *toolBar;
@property (strong) NSString *title;
@property (strong) PFASupplierAPI *api;

@property (strong) NSString *customerBanner;

- (void) setForOrders:(BOOL)flag;

@end
