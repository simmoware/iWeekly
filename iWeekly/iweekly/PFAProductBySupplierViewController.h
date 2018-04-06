//
//  PFAProductBySupplierViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 29/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"
#import "PFAAPIRequestDelegate.h"
#import "PFAAPIRequest.h"

@interface PFAProductBySupplierViewController : PFATableViewController <PFAAPIRequestDelegate>

@property (strong) NSString *bannerName;
@property (strong) NSString *productIdentifier;
@property (strong) NSMutableArray *results;
@property (strong) NSMutableDictionary *keys;
@property (strong) NSString *title;

@end
