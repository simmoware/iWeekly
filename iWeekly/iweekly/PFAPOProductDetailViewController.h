//
//  PFAPOProductDetailViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 7/10/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFATableViewController.h"
#import "PFAAPIRequestDelegate.h"
#import "PFAAPIRequest.h"

@interface PFAPOProductDetailViewController : PFATableViewController <PFAAPIRequestDelegate>

@property (strong) NSString *cusCode;
@property (strong) NSString *productIdentifier;
@property (strong) NSMutableArray *results;
@property (strong) NSMutableDictionary *keys;
@property (strong) NSString *title;

@end
