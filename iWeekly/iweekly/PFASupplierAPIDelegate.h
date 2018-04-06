//
//  PFASupplierAPIDelegate.h
//  iWeekly
//
//  Created by Anthony Simonetta on 22/01/2015.
//  Copyright (c) 2015 PerfectionFreshAustralia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PFASupplierAPIDelegate <NSObject>

- (void) PFASuppAPIDownloadComplete:(id)json;
- (void) PFASuppAPIDownloadFailed:(NSError *)error andMsg:(NSString *)msg;

@end