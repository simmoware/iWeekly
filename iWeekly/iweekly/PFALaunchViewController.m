//
//  PFALaunchViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 15/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFALaunchViewController.h"
#import "PFACustomersViewController.h"
#import "PFAProductListViewController.h"
#import "PFACappsViewController.h"
#import "PFAWebViewController.h"
#import "PFAOrdersViewController.h"

@interface PFALaunchViewController ()

@end

@implementation PFALaunchViewController

@synthesize top, bottom, customersButton, productsButton, suppliersButton, cappsButton, overlay, perfectionButton, ordersButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"iWeekly"];
        top = nil;
        bottom = nil;
        overlay = nil;
        suppliersButton = nil;
        productsButton = nil;
        customersButton = nil;
        ordersButton = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildInterface];
}

- (void) buildInterface {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    float centreX = self.view.frame.size.width/2.0;
    float centreY = self.view.frame.size.height/2.0;
    
    float button_height = 45;
    float button_width = 200;
    
    float startingY = centreY - (((button_height+10)*4)/2.0);
    
    if (bottom == nil) {
        bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:bottom];
    } else {
        [bottom setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    [self.view bringSubviewToFront:bottom];
    
    if (top == nil) {
        top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:top];
    } else {
        [top setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    [self.view bringSubviewToFront:top];
    
    [top setContentMode:UIViewContentModeScaleAspectFill];
    [top setOpaque:NO];
    [bottom setOpaque:NO];
    [bottom setContentMode:UIViewContentModeScaleAspectFill];
    
    if (overlay == nil) {
        overlay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:overlay];
    } else {
        [overlay setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    [self.view bringSubviewToFront:overlay];
    
    [overlay setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.15]];
    
    if (customersButton == nil) {
        customersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customersButton setBackgroundImage:[UIImage imageNamed:@"customers-button"] forState:UIControlStateNormal];
        [customersButton addTarget:self action:@selector(goToCustomers) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:customersButton];
    }
    
    [self.view bringSubviewToFront:customersButton];
    
    if (suppliersButton == nil) {
        suppliersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [suppliersButton setBackgroundImage:[UIImage imageNamed:@"suppliers-button"] forState:UIControlStateNormal];
        [suppliersButton addTarget:self action:@selector(goToSuppliers) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:suppliersButton];
    }
    
    [self.view bringSubviewToFront:suppliersButton];
    
    if (productsButton == nil) {
        productsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [productsButton setBackgroundImage:[UIImage imageNamed:@"products-button"] forState:UIControlStateNormal];
        [productsButton addTarget:self action:@selector(goToProducts) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:productsButton];
    }
    
    [self.view bringSubviewToFront:productsButton];
    
    if (ordersButton == nil) {
        ordersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ordersButton setBackgroundImage:[UIImage imageNamed:@"orders-button"] forState:UIControlStateNormal];
        [ordersButton addTarget:self action:@selector(goToOrders) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:ordersButton];
    }
    
    [self.view bringSubviewToFront:ordersButton];
    
    if (cappsButton == nil) {
        cappsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cappsButton setBackgroundImage:[UIImage imageNamed:@"connected-apps-logo"] forState:UIControlStateNormal];
        [cappsButton addTarget:self action:@selector(goToCapps) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cappsButton];
    }
    
    [self.view bringSubviewToFront:cappsButton];
    
    if (perfectionButton == nil) {
        perfectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [perfectionButton setBackgroundImage:[UIImage imageNamed:@"pfa-button"] forState:UIControlStateNormal];
        [perfectionButton addTarget:self action:@selector(goToPFA) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:perfectionButton];
    }

    [self.view bringSubviewToFront:perfectionButton];
    
    [customersButton setFrame:CGRectMake(centreX-(button_width/2.0), startingY, button_width, button_height)];
    
    startingY += button_height+10;
    
    [productsButton setFrame:CGRectMake(centreX-(button_width/2.0), startingY, button_width, button_height)];
    
    startingY += button_height+10;
    
    [suppliersButton setFrame:CGRectMake(centreX-(button_width/2.0), startingY, button_width, button_height)];
    
    startingY += button_height+10;
    
    [ordersButton setFrame:CGRectMake(centreX-(button_width/2.0), startingY, button_width, button_height)];

    startingY += 35+10;
    
    [cappsButton setFrame:CGRectMake(5, self.view.frame.size.height-21.5, 150, 16.5)];
    
    [perfectionButton setFrame:CGRectMake(centreX-(100/2.0), startingY, 100, 100)];

    [self beginBackgroundAnimation];
}

- (void) goToCustomers {
    PFACustomersViewController *customers = [[PFACustomersViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:customers animated:YES];
}

- (void) goToProducts {
    PFAProductListViewController *prods = [[PFAProductListViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:prods animated:YES];
}

- (void) goToSuppliers {
    PFASuppliersViewController *supps = [[PFASuppliersViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:supps animated:YES];
}

- (void) goToOrders {
    PFAOrdersViewController *orders = [[PFAOrdersViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:orders animated:YES];
}

- (void) goToCapps {
    PFACappsViewController *supps = [[PFACappsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:supps animated:YES];
}

- (void) goToPFA {
    PFAWebViewController *supps = [[PFAWebViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:supps animated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    animate = true;
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(animationTick) userInfo:nil repeats:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self buildInterface];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    animate = false;
}

static bool animate = false;
static int tickCount = 0;
static int currentImage = -1;
static int lastTick = 0;

- (void) beginBackgroundAnimation {
    int nextImage = arc4random_uniform(9) + 1;
    currentImage = nextImage;
    animate = true;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSString *suffix = @"~portrait";
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        suffix = @"~landscape";
    }

    [bottom setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.jpg", nextImage, suffix]]];
    if (tickCount == 0) {
        [top setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.jpg", nextImage, suffix]]];
    }
    
    [bottom setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.jpg", nextImage, suffix]]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedFadeIn)];
    [UIView setAnimationDuration:1.0];
    top.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void) animationTick {
    if (animate) {
        
        int current_time = [NSDate timeIntervalSinceReferenceDate];
        
        if ((current_time-lastTick) >= 5) {
            
            lastTick = [NSDate timeIntervalSinceReferenceDate];
            int nextImage = arc4random_uniform(9) + 1;
            while (nextImage == currentImage) {
                nextImage = arc4random_uniform(9) + 1;
            }
            
            currentImage = nextImage;
            animate = true;
            
            UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
            
            NSString *suffix = @"~portrait";
            
            if (UIDeviceOrientationIsLandscape(orientation)) {
                suffix = @"~landscape";
            }
            
            [bottom setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.jpg", nextImage, suffix]]];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [top setAlpha:0.0];
            [UIView commitAnimations];
            
            [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(animationTick) userInfo:nil repeats:NO];
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(finishedFadeIn) userInfo:nil repeats:NO];
        }
    }
}

- (void) finishedFadeIn {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSString *suffix = @"~portrait";
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        suffix = @"~landscape";
    }
    
    [top setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%@.jpg", currentImage, suffix]]];
    [top setAlpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self buildInterface];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self buildInterface];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
