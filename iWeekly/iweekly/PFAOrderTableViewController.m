//
//  PFAProductBySupplierViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 29/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAOrderTableViewController.h"

@interface PFAOrderTableViewController ()

@end

@implementation PFAOrderTableViewController

@synthesize results, keys, title, scrollView, tableView;

static float global_full_width = 0;
static float global_height = 0;

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
    
    float total_width = 5;
    total_width += 75; //1
    total_width += 75; //2
    total_width += 110; //3
    total_width += 225; //4
    total_width += 75; //5
    total_width += 75; //6
    total_width += 75; //7
    total_width += 75; //8
    total_width += 80; //9
    total_width += 80; //10
    total_width += 100; //11
    total_width += 100; //12
    total_width += 115; //13
    total_width += 80; //14
    total_width += 80; //15
    total_width += 100; //16
    total_width += 70; //17
    total_width += 55; //18
    
    global_full_width = total_width;
    global_height = self.view.frame.size.height;

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, global_height)];
    [scrollView setContentSize:CGSizeMake(global_full_width, 0)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, total_width, global_height-self.navigationController.navigationBar.frame.size.height-20)];
    } else {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, total_width, global_height-self.navigationController.navigationBar.frame.size.height)];
    }
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    [scrollView addSubview:tableView];
    [self.view addSubview:scrollView];
    self.title = @"Orders";
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
    
    global_height = self.view.frame.size.height;
    
    [self.scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, global_height)];
    [scrollView setContentSize:CGSizeMake(global_full_width, 0)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.tableView setFrame:CGRectMake(0, 0, global_full_width, global_height-self.navigationController.navigationBar.frame.size.height-20)];
    } else {
        [self.tableView setFrame:CGRectMake(0, 0, global_full_width, global_height-self.navigationController.navigationBar.frame.size.height)];        
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 64)];
    [header setBackgroundColor:[UIColor colorWithRed:(217/255.0) green:(242.0/255.0) blue:(208.0/255.0) alpha:1.0]];
    
    UIColor *tint = [UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0];
    
    UILabel *lbl = nil;
    
    float total_width = 5;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"PO#"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 75; //1
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"CusCode"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 75; //2
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 105, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Delivery Date"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 110;  //3
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 220, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Description"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 225; //4
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Size"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 75; //5
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Unit"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 75; //6
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Qty"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 75; //7
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Price"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 75; //8
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Location"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 80; //9
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Prev_Qty"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 80; //10
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 95, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Prev_Price"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 100; //11
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 95, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Original_Qty"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 100; //12
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 110, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Original_Price"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 115; //13
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"PO_Qty"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 80; //14
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"PO_Price"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 80; //15
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 95, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"LatestVer."];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 100; //16
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 65, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"LineNumber"];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 70; //17
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 50, 34)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Seq."];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:headerFontSize]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    total_width += 55;
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0;
}

- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height / label.font.lineHeight);
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
    
    NSDictionary *item = [results objectAtIndex:indexPath.row];
    [label setText:[self prepareString:[item objectForKey:@"Customer"]]];
    
    float custHeight = [self lineCountForLabel:label]*(label.font.lineHeight+8);
    [label setText:[self prepareString:[item objectForKey:@"Des"]]];
    float desHeight = [self lineCountForLabel:label]*(label.font.lineHeight+8);
    
    return MAX(custHeight, desHeight);
}

static float headerFontSize = 16.0;
static float labelFontSize = 15.0;

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [results objectAtIndex:indexPath.row];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    [label setFont:[UIFont fontWithName:@"Lato-Regular" size:labelFontSize]];
    
    [label setText:[self prepareString:[item objectForKey:@"Customer"]]];
    float custHeight = [self lineCountForLabel:label]*(label.font.lineHeight+8);
    
    [label setText:[self prepareString:[item objectForKey:@"Des"]]];
    float desHeight = [self lineCountForLabel:label]*(label.font.lineHeight+8);

    float rowHeight = MAX(custHeight, desHeight);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"order-dets-results"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16.0]];
    
    float total_width = 5;
    UILabel *lbl = nil;
    
    float cellFontSize = 15.0;
    
    UIColor *tint = [UIColor blackColor];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[item valueForKey:@"Reference"]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 75; //1

    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[item valueForKey:@"CusCode"]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 75; //2

    NSString *delDate = [[NSString alloc] initWithString:[item valueForKey:@"DeliveryDate"]];
    NSArray *delDets = [delDate componentsSeparatedByString:@"T00:"];
    delDate = [[NSString alloc] initWithString:[delDets objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *dDate = [dateFormatter dateFromString:delDate];
    [dateFormatter setDateFormat:@"EEE dd/mm/yy"];
    delDate = [dateFormatter stringFromDate:dDate];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 105, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:delDate];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 110; //3
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 220, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[item valueForKey:@"Des"]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 225; //4
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"Size"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 75; //5
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%@", [item valueForKey:@"Unit"]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 75; //6
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"Qty"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 75; //7
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 70, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[formatter stringFromNumber:[item valueForKey:@"Price"]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 75; //8
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%@", [item valueForKey:@"Location"]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 80; //9
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"Prev_Qty"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 80; //10
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 95, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[formatter stringFromNumber:[item valueForKey:@"Prev_Price"]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 100; //11
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 95, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"OriginalOrderQty"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 100; //12
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 110, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[formatter stringFromNumber:[item valueForKey:@"OriginalOrderPrice"]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 115; //13
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"PO_Qty"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 80; //14
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 75, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[formatter stringFromNumber:[item valueForKey:@"PO_Price"]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 80; //15
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 95, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"LastVersion"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 100; //16
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 65, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"LineNumber"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 70; //17
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(total_width, 0, 50, rowHeight)];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:[NSString stringWithFormat:@"%d", [[item valueForKey:@"Seq"] intValue]]];
    [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:cellFontSize]];
    [lbl setTextColor:tint];
    [lbl setNumberOfLines:0];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [cell addSubview:lbl];
    } else {
        [cell.contentView addSubview:lbl];
    }
    
    total_width += 55; //18
    
    if ([[item valueForKey:@"Qty"] intValue] == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(255.0/255.0) blue:(213/255.0) alpha:1.0]];
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