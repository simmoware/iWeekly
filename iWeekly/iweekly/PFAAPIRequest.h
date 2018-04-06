//
//  PFAAPIRequest.h
//  iWeekly
//
//  Created by Anthony Simonetta on 22/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFAAPIRequestDelegate.h"
#define KBaseURL @"http://www.pfasuppliersportal.com.au/iweekly_API/iWeeklyCustomerService.asmx"

@interface PFAAPIRequest : NSObject

@property (nonatomic, weak) id<PFAAPIRequestDelegate> delegate;

- (void) start:(NSString *)action withParams:(NSDictionary *)params;

@end
