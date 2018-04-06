//
//  PFAItemDetailViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 23/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAItemDetailViewController.h"

@interface PFAItemDetailViewController ()

@end

@implementation PFAItemDetailViewController

@synthesize params, results, title, keys, tableView, dateToolbar, currentDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (results == nil) {
        results = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    if (keys == nil) {
        keys = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    if (title != nil) {
        [self setTitle:title];
    }
    
    if (params != nil) {
        PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
        [request setDelegate:self];
        if ([params objectForKey:@"reference"] != nil) {
            [request start:@"/GetCustomerDetailsByReference" withParams:params];
        } else {
            [request start:@"/GetCustomerDetails" withParams:params];
        }
        PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.parentViewController.view.frame];
        [loading setFrame:self.parentViewController.view.frame];
        [self.parentViewController.view addSubview:loading];
        self.loading = loading;
    }
    
    if (tableView == nil) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [self.view addSubview:tableView];
    }
    
    if (dateToolbar == nil) {
        dateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, 44)];
        [dateToolbar setTintColor:[UIColor colorWithRed:(217/255.0) green:(242.0/255.0) blue:(208.0/255.0) alpha:1.0]];
        if ([dateToolbar respondsToSelector:@selector(setBarTintColor:)]) {
            [dateToolbar setBarTintColor:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0]];
        }
        
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-left"] style:UIBarButtonItemStylePlain target:self action:@selector(goToPreviousDate)];
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-right"] style:UIBarButtonItemStylePlain target:self action:@selector(goToNextDate)];
        
        
        if (currentDate == nil) {
            currentDate = [[UIBarButtonItem alloc] initWithTitle:@"date" style:UIBarButtonItemStylePlain target:nil action:nil];
            [currentDate setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:(217/255.0) green:(242.0/255.0) blue:(208.0/255.0) alpha:1.0]} forState:UIControlStateNormal];
            [self setDate];
        }
        
        
        [self.dateToolbar setItems:@[
                                     left,
                                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                     currentDate,
                                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                     right
                                     ]];
        [self.view addSubview:dateToolbar];

    }
}

- (void) setDate {
    
    NSDateFormatter *df_in = [[NSDateFormatter alloc] init];
    [df_in setDateFormat:@"MM-dd-yyyy"];
    
    NSDateFormatter *df_out = [[NSDateFormatter alloc] init];
    [df_out setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [df_in dateFromString:[params valueForKey:@"deliveryDate"]];
    
    [currentDate setTitle:[NSString stringWithFormat:@"%@",
                           [df_out stringFromDate:date]
                           ]];
}

- (void) goToPreviousDate {
    NSDateFormatter *df_in = [[NSDateFormatter alloc] init];
    [df_in setDateFormat:@"MM-dd-yyyy"];
    
    NSDate *current = [df_in dateFromString:[params valueForKey:@"deliveryDate"]];
    NSDate *less = [NSDate dateWithTimeIntervalSince1970:([current timeIntervalSince1970]-86400)];
    
    [params setValue:[NSString stringWithFormat:@"%@", [df_in stringFromDate:less]] forKey:@"deliveryDate"];
    
    PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
    [request setDelegate:self];
    if ([params objectForKey:@"reference"] != nil) {
        [request start:@"/GetCustomerDetailsByReference" withParams:params];
    } else {
        [request start:@"/GetCustomerDetails" withParams:params];
    }
    PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.parentViewController.view.frame];
    [loading setFrame:self.parentViewController.view.frame];
    [self.parentViewController.view addSubview:loading];
    self.loading = loading;
    [self setDate];
}

- (void) goToNextDate {
    NSDateFormatter *df_in = [[NSDateFormatter alloc] init];
    [df_in setDateFormat:@"MM-dd-yyyy"];
    
    NSDate *current = [df_in dateFromString:[params valueForKey:@"deliveryDate"]];
    NSDate *less = [NSDate dateWithTimeIntervalSince1970:([current timeIntervalSince1970]+86400)];
    
    [params setValue:[NSString stringWithFormat:@"%@", [df_in stringFromDate:less]] forKey:@"deliveryDate"];
    
    PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
    [request setDelegate:self];
    if ([params objectForKey:@"reference"] != nil) {
        [request start:@"/GetCustomerDetailsByReference" withParams:params];
    } else {
        [request start:@"/GetCustomerDetails" withParams:params];
    }
    PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.parentViewController.view.frame];
    [loading setFrame:self.parentViewController.view.frame];
    [self.parentViewController.view addSubview:loading];
    self.loading = loading;
    [self setDate];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self buildInterface];
}

- (void) buildInterface {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [dateToolbar setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, 44)];
        [tableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    } else {
        [dateToolbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [dateToolbar setBackgroundColor:[UIColor colorWithRed:(217/255.0) green:(242.0/255.0) blue:(208.0/255.0) alpha:1.0]];
        [dateToolbar setTintColor:[UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0]];
        [tableView setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self buildInterface];
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[keys objectForKey:[results objectAtIndex:section]] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [results count];
}

- (BOOL) PFAAPIRequestDidComplete:(NSData *)response {
    
    NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSData *data = [[PFAAppDelegate convertHTML:str]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    [results removeAllObjects];
    keys = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    NSMutableArray *objects = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    
    for (NSDictionary *dict in objects) {
        NSString *key = [NSString stringWithFormat:@"%@ PO#%@", [dict valueForKey:@"CUSCODE"], [dict valueForKey:@"reference"]];
        
        if ([key rangeOfString:@"(null)"].location == NSNotFound) {
            if ([keys objectForKey:key] == nil) {
                [keys setValue:[[NSMutableArray alloc] initWithCapacity:0] forKey:key];
                [results addObject:key];
            }
            
            [[keys valueForKey:key] addObject:dict];
        }
    }
    
    [self.loading removeFromSuperview];
    self.loading = nil;
    [self.tableView reloadData];
    
    return YES;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [header setBackgroundColor:[UIColor colorWithRed:(217/255.0) green:(242.0/255.0) blue:(208.0/255.0) alpha:1.0]];
    
    UIColor *tint = [UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0];
    
    UILabel *lbl = nil;
    
    if ([results count] > 0) {
        NSDictionary *item = [[keys objectForKey:[results objectAtIndex:section]] objectAtIndex:0];
        
        lbl  = [[UILabel alloc] initWithFrame:CGRectMake(0, 00, self.view.frame.size.width, 30)];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [lbl setText:[NSString stringWithFormat:@"%@ PO#%@", [self prepareString:[item valueForKey:@"CUSCODE"]], [self prepareString:[item valueForKey:@"reference"]]]];
        [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
        [lbl setTextColor:tint];
        [header addSubview:lbl];
    }
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, self.view.frame.size.width*0.20, 30)];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"Product"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.20, 34, self.view.frame.size.width*0.125, 30)];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"QTY"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.325, 34, self.view.frame.size.width*0.215, 30)];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"Price"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];

    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.54, 34, self.view.frame.size.width*0.125, 30)];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"ORG Q"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.665, 34, self.view.frame.size.width*0.215, 30)];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"ORG $"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.88, 34, self.view.frame.size.width*0.12, 30)];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:@"LOC"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0;
}

- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height / label.font.lineHeight);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.01, 0, self.view.frame.size.width*0.18, 44)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
    
    NSDictionary *item = [[keys objectForKey:[results objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [label setText:[self prepareString:[item objectForKey:@"des"]]];
    
    return MAX([self lineCountForLabel:label]*(label.font.lineHeight+6), 44.0);
}

static float headerFontSize = 16.0;
static float labelFontSize = 14.0;

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"final-detail-results"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"final-detail-results"];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
        
        UILabel *product = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [product setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [product setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [product setTextAlignment:NSTextAlignmentLeft];
        [product setNumberOfLines:0];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:product];
        } else {
            [cell.contentView addSubview:product];
        }
        
        UILabel *latestQty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [latestQty setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [latestQty setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [latestQty setTextAlignment:NSTextAlignmentCenter];
        [latestQty setNumberOfLines:0];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:latestQty];
        } else {
            [cell.contentView addSubview:latestQty];
        }
        
        UILabel *latestPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                [latestPrice setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [latestPrice setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [latestPrice setTextAlignment:NSTextAlignmentCenter];
        [latestPrice setNumberOfLines:0];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:latestPrice];
        } else {
            [cell.contentView addSubview:latestPrice];
        }
        
        UILabel *originalQty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [originalQty setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [originalQty setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [originalQty setTextAlignment:NSTextAlignmentCenter];
        [originalQty setNumberOfLines:0];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:originalQty];
        } else {
            [cell.contentView addSubview:originalQty];
        }
        
        UILabel *originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [originalPrice setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [originalPrice setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [originalPrice setTextAlignment:NSTextAlignmentCenter];
        [originalPrice setNumberOfLines:0];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:originalPrice];
        } else {
            [cell.contentView addSubview:originalPrice];
        }
        
        UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [loc setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [loc setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [loc setTextAlignment:NSTextAlignmentCenter];
        [loc setNumberOfLines:0];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:loc];
        } else {
            [cell.contentView addSubview:loc];
        }
    }
    
    NSDictionary *item = [[keys objectForKey:[results objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.18, 44)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
    [label setText:[self prepareString:[item objectForKey:@"des"]]];
    
    float rowHeight = MAX([self lineCountForLabel:label]*(label.font.lineHeight+6), 44.0);
    
    int count = 0;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSArray *subviews = cell.subviews;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        subviews = cell.contentView.subviews;
    }
    
    for (UIView *v in subviews) {
        if ([v isKindOfClass:[UILabel class]] && ![v isEqual:cell.textLabel]) {
            UILabel *txt = (UILabel *)v;
            [txt setNumberOfLines:0];
            if (count == 0) {
                [txt setText:[self prepareString:[item objectForKey:@"des"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.01, 0, self.view.frame.size.width*0.18, rowHeight)];
            } else if (count == 1) {
                [txt setText:[self prepareString:[item objectForKey:@"qty"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.20, 0, self.view.frame.size.width*0.125, rowHeight)];
            } else if (count == 2) {
                [txt setText:[self prepareString:[formatter stringFromNumber:[NSNumber numberWithFloat:[[item objectForKey:@"price"] floatValue]]]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.325, 0, self.view.frame.size.width*0.215, rowHeight)];
            } else if (count == 3) {
                [txt setText:[self prepareString:[item objectForKey:@"original_order_qty"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.54, 0, self.view.frame.size.width*0.125, rowHeight)];
            } else if (count == 4) {
                [txt setText:[self prepareString:[formatter stringFromNumber:[NSNumber numberWithFloat:[[item objectForKey:@"original_order_price"] floatValue]]]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.665, 0, self.view.frame.size.width*0.215, rowHeight)];
            } else if (count == 5) {
                [txt setText:[self prepareString:[item objectForKey:@"Location"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.88, 0, self.view.frame.size.width*0.12, rowHeight)];
            }
            count++;
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSString *) prepareString:(NSString *) str {
    if ([str isKindOfClass:[NSString class]]) {
        return [[str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return [NSString stringWithFormat:@"%@", str];
    }
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
