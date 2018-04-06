//
//  PFASupplierAPI.h
//  iWeekly
//
//  Created by Anthony Simonetta on 22/01/2015.
//  Copyright (c) 2015 PerfectionFreshAustralia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFASupplierAPIDelegate.h"

@interface PFASupplierAPI : NSObject <NSURLConnectionDelegate>

@property (strong) NSString *standardEndpoint;
@property (strong) NSString *accessToken;
@property (nonatomic) id<PFASupplierAPIDelegate> delegate;

- (id) initWithDelegate:(id)delegate;
- (void) act:(NSString *)action andFollowUp:(NSString *)followUp;

+ (void) setAccessToken:(NSString *)token;
+ (NSString *) getAccessToken;
+ (void) setExpireTime:(int)expiresIn;
+ (int) getExpireTime;

@end
