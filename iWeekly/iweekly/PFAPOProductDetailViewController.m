//
//  PFAProductBySupplierViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 29/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAPOProductDetailViewController.h"

@interface PFAPOProductDetailViewController ()

@end

@implementation PFAPOProductDetailViewController

@synthesize results, keys, title;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (results == nil) {
        results = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    if (keys == nil) {
        keys = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    if (title != nil) {
        [self setTitle:title];
    }
    
    PFAAPIRequest *request = [[PFAAPIRequest alloc] init];
    [request setDelegate:self];
    
    [request start:@"/GetPODetailsByDesAndCusCode" withParams:@{@"des":self.productIdentifier, @"cusCode":self.cusCode}];
    
    PFALoadingView *loading = [[PFALoadingView alloc] initWithFrame:self.parentViewController.view.frame];
    [loading setFrame:self.parentViewController.view.frame];
    [self.parentViewController.view addSubview:loading];
    self.loading = loading;
    
    [self setTitle:[NSString stringWithFormat:@"%@", self.productIdentifier]];
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
    
    NSMutableArray *objects = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:0 error:&error]];
    
    NSDateFormatter *df_in = [[NSDateFormatter alloc] init];
    [df_in setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *df_out = [[NSDateFormatter alloc] init];
    [df_out setDateFormat:@"dd/MM/yyyy"];
    
    for (NSDictionary *dict in objects) {
        NSDate *date = [df_in dateFromString:[dict valueForKey:@"DATE"]];
        
        NSString *key = [NSString stringWithFormat:@"%@ | %@", self.cusCode, [df_out stringFromDate:date]];
        
        if ([keys objectForKey:key] == nil) {
            [keys setValue:[[NSMutableArray alloc] initWithCapacity:0] forKey:key];
            [results addObject:key];
        }
        
        [[keys valueForKey:key] addObjectsFromArray:[dict valueForKey:@"Product"]];
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
        lbl  = [[UILabel alloc] initWithFrame:CGRectMake(0, 00, self.view.frame.size.width, 30)];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setText:[results objectAtIndex:section]];
        [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
        [lbl setTextColor:tint];
        [header addSubview:lbl];
    }
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, self.view.frame.size.width*0.28, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"PO"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.28, 34, self.view.frame.size.width*0.15, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"QTY"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.43, 34, self.view.frame.size.width*0.15, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Price"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.58, 34, self.view.frame.size.width*0.10, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"ORG Q"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.68, 34, self.view.frame.size.width*0.20, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"ORG $"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.88, 34, self.view.frame.size.width*0.12, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Location"];
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
        
        UILabel *ponum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [ponum setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [ponum setTextAlignment:NSTextAlignmentCenter];
        [ponum setNumberOfLines:0];
        [ponum setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:ponum];
        } else {
            [cell.contentView addSubview:ponum];
        }
        
        UILabel *latestQty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [latestQty setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [latestQty setTextAlignment:NSTextAlignmentCenter];
        [latestQty setNumberOfLines:0];
        [latestQty setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:latestQty];
        } else {
            [cell.contentView addSubview:latestQty];
        }
        
        UILabel *latestPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [latestPrice setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [latestPrice setTextAlignment:NSTextAlignmentCenter];
        [latestPrice setNumberOfLines:0];
        [latestPrice setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:latestPrice];
        } else {
            [cell.contentView addSubview:latestPrice];
        }
        
        UILabel *originalQty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [originalQty setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [originalQty setTextAlignment:NSTextAlignmentCenter];
        [originalQty setNumberOfLines:0];
        [originalQty setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:originalQty];
        } else {
            [cell.contentView addSubview:originalQty];
        }
        
        UILabel *originalPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [originalPrice setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [originalPrice setTextAlignment:NSTextAlignmentCenter];
        [originalPrice setNumberOfLines:0];
        [originalPrice setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [cell addSubview:originalPrice];
        } else {
            [cell.contentView addSubview:originalPrice];
        }
        
        UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [loc setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
        [loc setTextAlignment:NSTextAlignmentCenter];
        [loc setNumberOfLines:0];
        [loc setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
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
            if (count == 0) {
                [txt setText:[self prepareString:[item objectForKey:@"PO"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.01, 0, self.view.frame.size.width*0.28, rowHeight)];
            } else if (count == 1) {
                [txt setText:[self prepareString:[item objectForKey:@"qty"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.28, 0, self.view.frame.size.width*0.15, rowHeight)];
            } else if (count == 2) {
                [txt setText:[self prepareString:[formatter stringFromNumber:[NSNumber numberWithFloat:[[item objectForKey:@"price"] floatValue]]]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.43, 0, self.view.frame.size.width*0.15, rowHeight)];
            } else if (count == 3) {
                [txt setText:[self prepareString:[item objectForKey:@"original_order_qty"]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.58, 0, self.view.frame.size.width*0.10, rowHeight)];
            } else if (count == 4) {
                [txt setText:[self prepareString:[formatter stringFromNumber:[NSNumber numberWithFloat:[[item objectForKey:@"original_order_price"] floatValue]]]]];
                [txt setFrame:CGRectMake(self.view.frame.size.width*0.68, 0, self.view.frame.size.width*0.2, rowHeight)];
            } else if (count == 5) {
                [txt setText:[self prepareString:[item objectForKey:@"FROM"]]];
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