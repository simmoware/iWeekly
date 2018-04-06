//
//  PFACustomerDetailViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 23/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFACustomerDetailViewController.h"
#import "PFALoadingView.h"
#import "PFAItemDetailViewController.h"
#import "PFAOrderTableViewController.h"

@interface PFACustomerDetailViewController ()

@end

@implementation PFACustomerDetailViewController

@synthesize productId, date, tableView, results, inactiveToolbarItems, activeToolbarItems, dateSelected, title, customerBanner, api;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->forOrders = false;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.date = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [date setDatePickerMode:UIDatePickerModeDate];
        
        NSDate *now = [NSDate date];
        NSDate *mindate = [now dateByAddingTimeInterval:-3*24*60*60];
        NSDate *maxdate = [now dateByAddingTimeInterval:+10*24*60*60];
        
        [date setMaximumDate:maxdate];
        [date setMinimumDate:mindate];
        
        NSDateFormatter *formatter;
        NSString        *dateString;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yy"];
        
        dateString = [formatter stringFromDate:[NSDate date]];
        
        self.productId = [[UIBarButtonItem alloc] initWithTitle:@"Search by PO no." style:UIBarButtonItemStylePlain target:self action:@selector(editProductNo)];
        self.dateSelected = [[UIBarButtonItem alloc] initWithTitle:dateString style:UIBarButtonItemStylePlain target:self action:@selector(editDateSelected)];
        [dateSelected setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(40/255.0) green:(58/255.0) blue:(16/255.0) alpha:1.0],
                                               NSFontAttributeName:[UIFont fontWithName:@"Lato-Light" size:16.0]} forState:UIControlStateNormal];
        [productId setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(40/255.0) green:(58/255.0) blue:(16/255.0) alpha:1.0],
                                               NSFontAttributeName:[UIFont fontWithName:@"Lato-Light" size:16.0]} forState:UIControlStateNormal];
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 44)];
        [self.toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar-bg"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.toolBar];
        [self.toolBar setBackgroundColor:[UIColor blackColor]];
        [self.toolBar setTintColor:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0]];
        [self.toolBar setTranslucent:YES];
        self.results = [[NSMutableArray alloc] initWithCapacity:0];
        self.inactiveToolbarItems = [[NSMutableArray alloc] initWithCapacity:0];
        self.activeToolbarItems = [[NSMutableArray alloc] initWithCapacity:0];
        toolbar_status = 0;
        self.customerBanner = @"";
    }
    return self;
}

- (void) setForOrders:(BOOL)flag {
    self->forOrders = flag;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    toolbar_status = 0;
    [self setTitle:title];
    [self buildInterface];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateDateWithSelected) userInfo:nil repeats:YES];
}

- (void) updateDateWithSelected {
    if (self.date != nil) {
        if ([self.dateSelected respondsToSelector:@selector(setTitle:)]) {
            if ([self.date respondsToSelector:@selector(date)]) {
                NSDateFormatter *formatter;
                NSString        *dateString;
                
                formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd/MM/yy"];
                
                dateString = [formatter stringFromDate:[date date]];
                [dateSelected setTitle:dateString];
            }
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self buildInterface];
}

static int toolbar_status = 0;

- (void) buildInterface {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.toolBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    } else {
        [self.toolBar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, 44)];
    }
    [self.tableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    [self setToolbarStatus];
}

- (void) setToolbarStatus {
    
    if (toolbar_status == 0) {
        
        UIBarButtonItem *cal_icon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"] style:UIBarButtonItemStylePlain target:self action:@selector(editDateSelected)];
        UIBarButtonItem *search_icon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(editProductNo)];
        
        if (dateSelected != nil && productId != nil) {
            [self.toolBar setItems:@[cal_icon, dateSelected,
                                 [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 search_icon, productId] animated:YES];
        }
        
    } else if (toolbar_status == 1) { // editing date
        UIBarButtonItem *cal_icon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"] style:UIBarButtonItemStylePlain target:nil action:nil];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(stopEditDateSelected)];
        [done setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0],
                                       NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14.0]} forState:UIControlStateNormal];
        
        [self.toolBar setItems:@[cal_icon, dateSelected,
                                  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 done] animated:YES];
    } else if (toolbar_status == 2) { // editing product no
        UIBarButtonItem *search_icon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:nil action:nil];
        
        UITextField * productNo = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
        [productNo setKeyboardType:UIKeyboardTypeNumberPad];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone) {
            [productNo setFrame:CGRectMake(0, 0, 500, 32)];
        }
        
        [productNo.layer setCornerRadius:5.0];
        [productNo setFont:[UIFont fontWithName:@"Lato-Light" size:14.0]];
        productNo.clearButtonMode = UITextFieldViewModeWhileEditing;
        productNo.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        [productNo setBackgroundColor:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0]];
        [productNo setTextColor:[UIColor whiteColor]];
        [productNo setDelegate:self];
        if ([productNo respondsToSelector:@selector(setTintColor:)]) {
            [productNo setTintColor:[UIColor whiteColor]];
        }
        
        [productNo setReturnKeyType:UIReturnKeySearch];
        
        if (![productId.title isEqualToString:@"Search by PO no."]) {
            [productNo setText:productId.title];
        }
        
        [productNo becomeFirstResponder];

        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(stopEditProductNo)];
        [done setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0],
                                       NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:14.0]} forState:UIControlStateNormal];
        
        [self.toolBar setItems:@[search_icon, [[UIBarButtonItem alloc] initWithCustomView:productNo],
                                  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 done] animated:YES];
    }
    
    [self updateResults];
}

- (void) updateResults {
    if (self.customerBanner != nil && dateSelected != nil) {
        PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
        [request setDelegate:self];
        
        PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.view.frame];
        [loading setFrame:self.view.frame];
        
        self.loading = loading;
        
        [self.view addSubview:loading];
        
        NSDateFormatter *formatter;
        NSString        *dateString;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yy"];
        
        NSDate *selected = [formatter dateFromString:dateSelected.title];
        
        [formatter setDateFormat:@"MM-dd-yyyy"];
        
        dateString = [formatter stringFromDate:selected];
        
        if (![productId.title isEqualToString:@"Search by PO no."] && [productId.title length] > 0) {
            [request start:@"/GetCustomerDetailsByReference" withParams:@{
                                                                @"banner":customerBanner,
                                                                @"deliveryDate":dateString,
                                                                @"reference":productId.title
                                                                }];
        } else {
            [request start:@"/GetCustomerLocation" withParams:@{
                                                                @"banner":customerBanner,
                                                                @"deliveryDate":dateString
                                                                }];
        }
    }
}

- (BOOL) PFAAPIRequestDidComplete:(NSData *)response {
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSData *data = [[PFAAppDelegate convertHTML:str]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    
    results = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    
    for (NSDictionary *dict in results) {
        if ([[dict valueForKey:@"Notice"] length] > 0) {
            [results removeAllObjects];
        }
    }
    
    [self.tableView reloadData];
    
    [self.loading removeFromSuperview];
    self.loading = nil;
    
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    productId.title = textField.text;
    [self stopEditProductNo];
    return NO;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] > 0) {
        [productId setTitle:textField.text];
    } else {
        [productId setTitle:@"Search by PO no."];
    }
}

- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height / label.font.lineHeight);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 44)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
    NSString *item = [[[results objectAtIndex:indexPath.row] objectForKey:@"CUSTOMER"] capitalizedString];
    [label setText:item];
    
    return 44.0 + ([self lineCountForLabel:label]-1)*10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customers-results"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"customer-results"];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
    }
    
    NSString *item = [[[results objectAtIndex:indexPath.row] objectForKey:@"CUSTOMER"] capitalizedString];
    
    [cell.textLabel setText:item];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    return cell;
}

- (void) editDateSelected {
    toolbar_status = 1;
    
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0, self.toolBar.frame.origin.y+self.toolBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.toolBar.frame.origin.y-self.toolBar.frame.size.height)];
    [v setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];

    [date removeFromSuperview];
    [date setFrame:CGRectMake(0, self.toolBar.frame.origin.y+self.toolBar.frame.size.height, self.view.frame.size.width, 216)];
    
    [date setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, self.toolBar.frame.origin.y+self.toolBar.frame.size.height+216, self.view.frame.size.width, 80)];
    [done setTitle:@"DONE" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(stopEditDateSelected) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:v];
    [self.view addSubview:date];
    [self.view bringSubviewToFront:date];
    
    [self setToolbarStatus];
}

- (void) stopEditDateSelected {
    toolbar_status = 0;
    [self updateDateWithSelected];
    [date removeFromSuperview];
    [[self.view.subviews objectAtIndex:([self.view.subviews count]-1)] removeFromSuperview];
    [self setToolbarStatus];
}

- (void) editProductNo {
    toolbar_status = 2;
    [self setToolbarStatus];
}

- (void) stopEditProductNo {
    toolbar_status = 0;
    
    for (UIView *v in self.toolBar.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)v;
            productId.title = textField.text;
        }
    }

    [self setToolbarStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self buildInterface];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yy"];
    
    NSDate *selected = [formatter dateFromString:dateSelected.title];
    
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    dateString = [formatter stringFromDate:selected];
    NSString *item = [[[results objectAtIndex:indexPath.row] objectForKey:@"CUSTOMER"] capitalizedString];
    NSString *custCode = [[[results objectAtIndex:indexPath.row] objectForKey:@"CUSCODE"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!self->forOrders) {
        PFAItemDetailViewController *detail = [[PFAItemDetailViewController alloc] initWithNibName:nil bundle:nil];
        
        [detail setTitle:item];
        if (![productId.title isEqualToString:@"Search by PO no."] && [productId.title length] > 0) {
            [detail setParams:[NSMutableDictionary dictionaryWithDictionary:@{
                                @"reference":productId.title,
                                @"banner":customerBanner,
                                @"deliveryDate":dateString
                                }]];
        } else {

            [detail setParams:[NSMutableDictionary dictionaryWithDictionary:@{
                                @"banner":customerBanner,
                                @"deliveryDate":dateString,
                                @"custCode":custCode
                                }]];
        }
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        
        NSDateFormatter *formatter;
        NSString        *dateString;
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yy"];
        
        NSDate *selected = [formatter dateFromString:dateSelected.title];
        
        [formatter setDateFormat:@"yyyyMMdd"];
        
        dateString = [formatter stringFromDate:selected];
        
        PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.view.frame];
        [loading setFrame:self.view.frame];
        
        self.loading = loading;
        
        [self.view addSubview:loading];
        
        api = [[PFASupplierAPI alloc] initWithDelegate:self];
        [api act:[NSString stringWithFormat:@"/api/v1/customersorders?banner=%@&cuscode=%@&date=%@", customerBanner, custCode, dateString] andFollowUp:nil];
    }
}

- (BOOL) PFASuppAPIDownloadComplete:(id)json {
    NSArray *arr = [[NSArray alloc] initWithArray:json];
    [self.loading removeFromSuperview];
    self.loading = nil;
    
    PFAOrderTableViewController *orders = [[PFAOrderTableViewController alloc] initWithNibName:nil bundle:nil];
    [orders setResults:[[NSMutableArray alloc] initWithArray:arr]];
    [self.navigationController pushViewController:orders animated:YES];
    
    return YES;
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
