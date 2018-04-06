//
//  PFASupplierAPI.m
//  iWeekly
//
//  Created by Anthony Simonetta on 22/01/2015.
//  Copyright (c) 2015 PerfectionFreshAustralia. All rights reserved.
//

#import "PFASupplierAPI.h"
#import "GZIP.h"

@implementation PFASupplierAPI

@synthesize standardEndpoint;

static int expireTime = -1;
static char accessToken[200];
static NSString *TOKEN_END = @"/api/token";
static NSString *BASIC_AUTH = @"SVdlZWtseUV4dDppZU4/OXM3NG5r";

- (id) init {
    self = [super init];
    if (self) {
        self.standardEndpoint = @"https://www.pfasuppliersportal.com.au:44343/IWeeklyExt";
        expireTime = -1;
        self.delegate = nil;
    }
    return self;
}

- (id) initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.standardEndpoint = @"https://www.pfasuppliersportal.com.au:44343/IWeeklyExt";
        expireTime = -1;
        self.delegate = delegate;
    }
    return self;
}

- (void) beginAction:(NSString *)action andFollowUp:(NSString *)followUp {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:
                                                                             [NSString stringWithFormat:@"%@%@", self.standardEndpoint, action]]];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
//    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-encoding"];
    
    if ([action isEqualToString:TOKEN_END]) {
        [request setValue:[NSString stringWithFormat:@"Basic %@", BASIC_AUTH] forHTTPHeaderField:@"Authorization"];
    } else {
        [request setValue:[NSString stringWithFormat:@"Session %@", [PFASupplierAPI getAccessToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    
    NSError *e = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&e];
    
    if (e == nil && data != nil) {
//        data = [data gunzippedData];
        
        NSError *error = nil;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error == nil) {
            if ([action isEqualToString:TOKEN_END]) {
                NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:jsonObj];
                NSString *accessToken = [dict valueForKey:@"access_token"];
                int expiresIn = [[dict valueForKey:@"expires_in"] intValue];
                [PFASupplierAPI setAccessToken:accessToken];
                [PFASupplierAPI setExpireTime:expiresIn];
                [self performSelectorOnMainThread:@selector(followUp:) withObject:followUp waitUntilDone:NO];
            } else {
                [self performSelectorOnMainThread:@selector(handleResponse:) withObject:jsonObj waitUntilDone:NO];
            }
        } else {
            NSLog(@"%@", error);
            NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", output);
            
            [self performSelectorOnMainThread:@selector(handleError:) withObject:error waitUntilDone:NO];
        }
    } else {
        NSLog(@"%@", e);
        [self performSelectorOnMainThread:@selector(handleError:) withObject:e waitUntilDone:NO];
    }
}

- (void) followUp:(NSString *)action {
    [self act:action andFollowUp:nil];
}

- (void) handleResponse:(id)json {
    [self.delegate PFASuppAPIDownloadComplete:json];
}

- (void) handleError:(NSError *)e {
//    [self.delegate PFASuppAPIDownloadFailed:e andMsg:[e description]];
}

- (void) act:(NSString *)action andFollowUp:(NSString *)followUp {
    if (self.delegate == nil) { return; }
    
    if ([[PFASupplierAPI getAccessToken] length] > 0 || [action isEqualToString:TOKEN_END]) {
        if ([action isEqualToString:TOKEN_END] || [[NSDate date] timeIntervalSince1970] < expireTime) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self beginAction:action andFollowUp:followUp];
            });
        } else {
            [self act:@"/api/token" andFollowUp:action];
        }
    } else {
        [self act:@"/api/token" andFollowUp:action];
    }
}

+ (void) setAccessToken:(NSString *)token {
    const char *t = [token UTF8String];
    strcpy(accessToken, t);
}

+ (NSString *) getAccessToken {
    return [NSString stringWithFormat:@"%s", accessToken];
}

+ (void) setExpireTime:(int)expiresIn {
    int secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    expireTime = secondsSinceUnixEpoch + expiresIn;
}

+ (int) getExpireTime {
    return expireTime;
}

@end
