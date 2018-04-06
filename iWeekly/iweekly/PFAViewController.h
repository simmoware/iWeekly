//
//  PFAViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 15/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFALoadingView.h"

@interface PFAViewController : UIViewController {
    BOOL shouldRotate;
}

@property (strong) PFALoadingView *loading;

@end
