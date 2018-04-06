//
//  PFAProductSupplierViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 29/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"
#import "PFAAPIRequest.h"
#import "PFAAPIRequestDelegate.h"

@interface PFAProductSupplierViewController : PFATableViewController <PFAAPIRequestDelegate> {
    BOOL forOrders;
}

@property (strong) NSString *productIdentifier;
@property (strong) NSMutableArray *customers;

- (void) setForOrders:(BOOL)flag;

@end
