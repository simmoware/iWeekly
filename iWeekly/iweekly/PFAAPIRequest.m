//
//  PFAAPIRequest.m
//  iWeekly
//
//  Created by Anthony Simonetta on 22/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAAPIRequest.h"

@implementation PFAAPIRequest

@synthesize delegate;

- (id) init {
    self = [super init];
    if (self) {
        self.delegate = nil;
    }
    return self;
}

- (void) start:(NSString *)action withParams:(NSDictionary *)params {
    if (self.delegate != nil) {
        NSURL *downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KBaseURL, action]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadURL];
        [request setTimeoutInterval:45];
        [request setHTTPMethod:@"POST"];
        if (params != nil) {
            NSMutableString *params_str = [NSMutableString stringWithFormat:@""];
            if ([[params allKeys] count] > 0) {
                for (NSString *key in [params allKeys]) {
                    [params_str appendFormat:@"%@=%@&",
                     key,
                     [[NSString stringWithFormat:@"%@", [params objectForKey:key]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
                }
                [request setHTTPBody:[[params_str substringWithRange:NSMakeRange(0, [params_str length]-1)] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        [NSThread detachNewThreadSelector:@selector(beginBackgroundDownload:) toTarget:self withObject:request];
    }
}

- (void) urlConnectionComplete:(NSData *)complete {
    if (complete != nil) {
        if ([complete bytes] > 0) {
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(PFAAPIRequestDidComplete:)]) {
                    [self.delegate PFAAPIRequestDidComplete:complete];
                }
            }
        } else {
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(PFAAPIRequestDidFail:)]) {
                    NSError *error = [NSError errorWithDomain:KBaseURL code:11 userInfo:@{@"description":@"Hmmm... The server returned no data... Something has gone wrong. Please try again!"}];
                    [self.delegate PFAAPIRequestDidFail:error];
                }
            }
        }
    } else {
        if (self.delegate != nil) {
            if ([self.delegate respondsToSelector:@selector(PFAAPIRequestDidFail:)]) {
                NSError *error = [NSError errorWithDomain:KBaseURL code:11 userInfo:@{@"description":@"Hmmm... The server returned no data... Something has gone wrong. Please try again!"}];
                [self.delegate PFAAPIRequestDidFail:error];
            }
        }
    }
}

- (void) urlConnectionFailed:(NSError *)error {
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(PFAAPIRequestDidFail:)]) {
            [self.delegate PFAAPIRequestDidFail:error];
        }
    }
}

- (void) beginBackgroundDownload:(NSMutableURLRequest *)request {
    NSError *error = nil;
    NSData *conn = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error == nil) {
        [self performSelectorOnMainThread:@selector(urlConnectionComplete:) withObject:conn waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(urlConnectionFailed:) withObject:error waitUntilDone:NO];
    }
}

@end
