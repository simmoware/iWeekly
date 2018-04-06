//
//  PFACustomersViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 22/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAViewController.h"
#import "PFAAPIRequestDelegate.h"
#import "PFAAPIRequest.h"
#import "PFATableViewController.h"

@interface PFACustomersViewController : PFATableViewController <PFAAPIRequestDelegate> {
    BOOL forOrders;
}

@property (strong) NSArray *customers;
- (void) setForOrders:(BOOL)flag;

@end
