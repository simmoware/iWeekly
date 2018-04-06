//
//  PFALaunchViewController.h
//  iWeekly
//
//  Created by Anthony Simonetta on 15/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAViewController.h"
#import "PFASuppliersViewController.h"

@interface PFALaunchViewController : PFAViewController

@property (strong) UIImageView *top;
@property (strong) UIImageView *bottom;
@property (strong) UILabel *overlay;
@property (strong) UIButton *customersButton;
@property (strong) UIButton *productsButton;
@property (strong) UIButton *suppliersButton;
@property (strong) UIButton *ordersButton;
@property (strong) UIButton *cappsButton;
@property (strong) UIButton *perfectionButton;

@end
