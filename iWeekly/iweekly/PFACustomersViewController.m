//
//  PFACustomersViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 22/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFACustomersViewController.h"
#import "PFACustomerDetailViewController.h"

@interface PFACustomersViewController ()

@end

@implementation PFACustomersViewController

@synthesize customers;

- (id) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"Customers"];
        customers = @[];
        self->forOrders = false;
    }
    return self;
}

- (void) setForOrders:(BOOL)flag {
    self->forOrders = flag;
}

- (BOOL) PFAAPIRequestDidComplete:(NSData *)response {
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSData *data = [[PFAAppDelegate convertHTML:str]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    customers = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    
    if (error == nil) {
        [self.tableView reloadData];
    }
    
    [self.loading removeFromSuperview];
    self.loading = nil;
    return NO;
}

- (BOOL) PFAAPIRequestDidFail:(NSError *)error {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.title = @"Customers";
    PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
    [request setDelegate:self];
    [request start:@"/GetAllCustomer" withParams:@{}];
    self.loading = [[PFALoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.loading setFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
    [self.parentViewController.view addSubview:self.loading];
}


#pragma start - table view

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [customers count];
}

static float min_height = 120;

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MIN(self.view.frame.size.height/[customers count], min_height);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [[[customers objectAtIndex:indexPath.row] objectForKey:@"banner"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"customer-cell-%@", title]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"customer-cell-%@", title]];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:title]];
        [img setFrame:img.frame];
        [img setContentMode:UIViewContentModeScaleAspectFit];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:img];
        } else {
            [cell.contentView addSubview:img];
        }
    }
    
    
    NSArray *subviews = cell.subviews;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        subviews = cell.contentView.subviews;
    }
    
    for (UIView *v in subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v setFrame:CGRectMake(self.view.frame.size.width*0.05, (MIN(self.view.frame.size.height/[customers count], min_height)*0.05), self.view.frame.size.width*0.9, (MIN(self.view.frame.size.height/[customers count], min_height)*0.9))];
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = [[[customers objectAtIndex:indexPath.row] objectForKey:@"banner"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSDictionary *map = @{@"COLES":@"Coles", @"WOOL":@"Woolworths", @"COSTCO":@"Cost Co.", @"MCDONALD":@"Mc Donalds"};
    
    PFACustomerDetailViewController *detail = [[PFACustomerDetailViewController alloc] initWithNibName:nil bundle:nil];
    [detail setForOrders:self->forOrders];
    [detail setCustomerBanner:title];
    [detail setTitle:[map objectForKey:title]];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma end - table view

- (BOOL) shouldAutorotate {
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [self.tableView reloadData];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.tableView reloadData];
}

@end
