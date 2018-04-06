//
//  PFASupplierDetailViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 30/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"
#import "PFAAPIRequestDelegate.h"
#import "PFAAPIRequest.h"

@interface PFASupplierDetailViewController : PFATableViewController <PFAAPIRequestDelegate>

@property (strong) NSString *supplierName;
@property (strong) NSString *productIdentifier;
@property (strong) NSMutableArray *results;
@property (strong) NSMutableDictionary *keys;
@property (strong) NSString *title;

@end
