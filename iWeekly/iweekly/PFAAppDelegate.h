//
//  PFAAppDelegate.h
//  iWeekly
//
//  Created by Anthony Simonetta on 15/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFASupplierAPIDelegate.h"

@interface PFAAppDelegate : UIResponder <UIApplicationDelegate, PFASupplierAPIDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSString *) convertHTML:(NSString *)html;

@end
