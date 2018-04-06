//
//  PFAProductOfSupplierViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 30/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAProductOfSupplierViewController.h"
#import "PFASupplierDetailViewController.h"
#import "PFAOrderTableViewController.h"

@interface PFAProductOfSupplierViewController ()

@end

@implementation PFAProductOfSupplierViewController

@synthesize products, supplierIdentifier, api;


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
    [request start:@"/GetProductsBySupplier" withParams:@{@"supplier":self.supplierIdentifier}];
    self.loading = [[PFALoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.loading setFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
    [self.parentViewController.view addSubview:self.loading];
    [self setTitle:self.supplierIdentifier];
}

- (void) setForOrders:(BOOL)flag {
    self->forOrders = flag;
}

- (BOOL) PFAAPIRequestDidComplete:(NSData *)response {
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSData *data = [[PFAAppDelegate convertHTML:str]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    products = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    [products addObject:@"ALL"];
    [self.loading removeFromSuperview];
    self.loading = nil;
    
    [self.tableView reloadData];
    return YES;
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
    return [products count];
}

- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height / label.font.lineHeight);
}

static float labelFontSize = 14.0;

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-55, 44)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
    
    NSString *item = [products objectAtIndex:indexPath.row];
    
    if ([[products objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
        item = [[[products objectAtIndex:indexPath.row] objectForKey:@"Products"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    [label setText:[self prepareString:item]];
    
    return MAX([self lineCountForLabel:label]*(label.font.lineHeight+4),44);
}

- (NSString *) prepareString:(NSString *) str {
    if ([str isKindOfClass:[NSString class]]) {
        return [[str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return [NSString stringWithFormat:@"%@", str];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if ([[products objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
        
        NSString *title = [[[products objectAtIndex:indexPath.row] objectForKey:@"Products"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"customer-cell-%@", title]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"customer-cell-%@", title]];
        }
        
        [cell.textLabel setText:title];
//        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"customer-cell-all"]];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"customer-cell-all"]];
        }
        [cell.textLabel setText:@"ALL"];
//        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:labelFontSize]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = @"";
    
    if ([[products objectAtIndex:indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
        title = [[[products objectAtIndex:indexPath.row] objectForKey:@"Products"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        title = [products objectAtIndex:indexPath.row];
    }
    
    if (!self->forOrders) {
        PFASupplierDetailViewController *bySupp = [[PFASupplierDetailViewController alloc] initWithStyle:UITableViewStylePlain];
        [bySupp setSupplierName:self.supplierIdentifier];
        [bySupp setProductIdentifier:title];
        [self.navigationController pushViewController:bySupp animated:YES];
    } else {
        
        PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.view.frame];
        [loading setFrame:self.view.frame];
        
        self.loading = loading;
        
        [self.view addSubview:loading];
        
        api = [[PFASupplierAPI alloc] initWithDelegate:self];
        [api act:[NSString stringWithFormat:@"/api/v1/suppliersorders?supplier=%@&itemdescription=%@", self.supplierIdentifier, [title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]] andFollowUp:nil];
    }
}

- (void) PFASuppAPIDownloadComplete:(id)json {
  //  NSLog(@"%@", json);
    [self.loading removeFromSuperview];
    self.loading = nil;
    PFAOrderTableViewController *orderTable = [[PFAOrderTableViewController alloc] initWithNibName:nil bundle:nil];
    NSArray *arr = [[NSArray alloc] initWithArray:json];
    [orderTable setResults:[[NSMutableArray alloc] initWithArray:arr]];
    [self.navigationController pushViewController:orderTable animated:YES];
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
