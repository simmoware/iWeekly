//
//  PFAAPIRequestDelegate.h
//  iWeekly
//
//  Created by Anthony Simonetta on 22/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PFAAPIRequestDelegate <NSObject>

- (BOOL) PFAAPIRequestDidComplete:(NSData *) response;
- (BOOL) PFAAPIRequestDidFail:(NSError *)error;

@end
