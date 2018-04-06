//
//  PFAProductSupplierViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 29/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAProductSupplierViewController.h"
#import "PFAProductBySupplierViewController.h"

@interface PFAProductSupplierViewController ()

@end

@implementation PFAProductSupplierViewController

@synthesize productIdentifier, customers;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->forOrders = false;
    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self->forOrders = false;
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self) {
        self->forOrders = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
    [request setDelegate:self];
    [request start:@"/GetAllBannerByProductDes" withParams:@{@"des":self.productIdentifier}];
    self.loading = [[PFALoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.loading setFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
    [self.parentViewController.view addSubview:self.loading];
    [self setTitle:self.productIdentifier];
    
}

- (BOOL) PFAAPIRequestDidComplete:(NSData *)response {
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSData *data = [[PFAAppDelegate convertHTML:str]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    customers = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    [customers addObject:@"ALL"];
    [self.loading removeFromSuperview];
    self.loading = nil;
    
    [self.tableView reloadData];
    return YES;
}

- (void) setForOrders:(BOOL)flag {
    self->forOrders = flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    
    UITableViewCell *cell = nil;
    
    if ([[customers objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
    
        NSString *title = [[[customers objectAtIndex:indexPath.row] objectForKey:@"BANNER"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"customer-cell-%@", title]];
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
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"customer-cell-all"]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"customer-cell-all"]];
        }
        [cell.textLabel setText:@"ALL"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:22.0]];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"";
    
    if ([[customers objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
        title = [[[customers objectAtIndex:indexPath.row] objectForKey:@"BANNER"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        title = [customers objectAtIndex:indexPath.row];
    }
    
    PFAProductBySupplierViewController *bySupp = [[PFAProductBySupplierViewController alloc] initWithStyle:UITableViewStylePlain];
    [bySupp setBannerName:title];
    [bySupp setProductIdentifier:self.productIdentifier];
    [self.navigationController pushViewController:bySupp animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
