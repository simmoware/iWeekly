//
//  PFASuppliersViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 30/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFASuppliersViewController.h"
#import "PFAProductOfSupplierViewController.h"

@interface PFASuppliersViewController ()

@end

@implementation PFASuppliersViewController

@synthesize masterList, searchableList, searchBar, tableView;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    masterList = [[NSMutableArray alloc] initWithCapacity:0];
    searchableList = [[NSMutableArray alloc] initWithCapacity:0];
    
    PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
    [request setDelegate:self];
    [request start:@"/GetAllSuppliers" withParams:@{}];
    self.loading = [[PFALoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.loading setFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
    [self.parentViewController.view addSubview:self.loading];
    [self setTitle:@"Suppliers"];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 44)];
    [searchBar setDelegate:self];
    
    if ([searchBar respondsToSelector:@selector(setBarTintColor:)]) {
        [searchBar setBarTintColor:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0]];
    } else {
        [searchBar setTintColor:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0]];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    [self.view addSubview:searchBar];
    [self.searchBar setShowsCancelButton:YES];
}

- (void) setForOrders:(BOOL)flag {
    self->forOrders = flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.searchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    } else {
        [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 44)];
    }
    [self.tableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
}

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 [searchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
 return searchBar;
 }
 
 - (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 44.0;
 }*/

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchableList count];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForItem:self.searchBar.text];
}

- (void) searchForItem:(NSString *)text {
    [searchableList removeAllObjects];
    if ([text length] > 0) {
        for (NSString *prod in masterList) {
            if ([[prod lowercaseString] rangeOfString:[text lowercaseString]].location != NSNotFound) {
                [searchableList addObject:prod];
            }
        }
    } else {
        searchableList = [[NSMutableArray alloc] initWithArray:masterList];
    }
    
    [self.tableView reloadData];
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
    
    NSString *item = [searchableList objectAtIndex:indexPath.row];
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

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prod-listing-cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"prod-listing-cell"];
    }
    
    [cell.textLabel setText:[searchableList objectAtIndex:indexPath.row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Light" size:labelFontSize]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setNumberOfLines:0];
    
    return cell;
}

- (BOOL) PFAAPIRequestDidComplete:(NSData *)response {
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSData *data = [[PFAAppDelegate convertHTML:str]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    
    [masterList removeAllObjects];
    [searchableList removeAllObjects];
    
    for (NSDictionary *dict in results) {
        [masterList addObject:[[dict valueForKey:@"Suppliers"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [searchableList addObject:[[dict valueForKey:@"Suppliers"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    
    [self.tableView reloadData];
    
    [self.loading removeFromSuperview];
    self.loading = nil;
    
    return YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *item = [searchableList objectAtIndex:indexPath.row];
    PFAProductOfSupplierViewController *prods = [[PFAProductOfSupplierViewController alloc] initWithNibName:nil bundle:nil];
    [prods setForOrders:self->forOrders];
    [prods setSupplierIdentifier:item];
    [self.navigationController pushViewController:prods animated:YES];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.searchBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    } else {
        [self.searchBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 44)];
    }
    [self.tableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
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