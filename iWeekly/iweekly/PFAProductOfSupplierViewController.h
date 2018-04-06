//
//  PFAProductOfSupplierViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 30/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"
#import "PFAAPIRequestDelegate.h"
#import "PFAAPIRequest.h"
#import "PFASupplierAPIDelegate.h"
#import "PFASupplierAPI.h"

@interface PFAProductOfSupplierViewController : PFATableViewController <PFAAPIRequestDelegate, PFASupplierAPIDelegate> {
    BOOL forOrders;
}

@property (strong) NSString *supplierIdentifier;
@property (strong) NSMutableArray *products;
@property (strong) PFASupplierAPI *api;

- (void) setForOrders:(BOOL)flag;

@end
