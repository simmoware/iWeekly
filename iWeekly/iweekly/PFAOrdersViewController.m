//
//  PFAOrdersViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 20/02/2015.
//  Copyright (c) 2015 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAOrdersViewController.h"
#import "PFACustomersViewController.h"
#import "PFAProductListViewController.h"
#import "PFASuppliersViewController.h"

@interface PFAOrdersViewController ()

@end

@implementation PFAOrdersViewController

@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    items = @[@"Customer", @"Products", @"Suppliers"];
    self.title = @"Orders";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [header setBackgroundColor:[UIColor colorWithRed:(217/255.0) green:(242.0/255.0) blue:(208.0/255.0) alpha:1.0]];
    
    UIColor *tint = [UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0];
    
    UILabel *lbl = nil;
    
    lbl  = [[UILabel alloc] initWithFrame:CGRectMake(0, 00, self.view.frame.size.width, 30)];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [lbl setText:@"Search for orders by..."];
    [lbl setFont:[UIFont fontWithName:@"Lato-Bold" size:16.0]];
    [lbl setTextColor:tint];
    [header addSubview:lbl];
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse = @"orders-selection";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];

    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Light" size:16.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *item = [items objectAtIndex:indexPath.row];
    
    if ([item isEqualToString:@"Customer"]) {
        PFACustomersViewController *cust = [[PFACustomersViewController alloc] initWithNibName:nil bundle:nil];
        [cust setForOrders:true];
        [self.navigationController pushViewController:cust animated:YES];
    } else if ([item isEqualToString:@"Products"]) {
        PFAProductListViewController *prods = [[PFAProductListViewController alloc] initWithNibName:nil bundle:nil];
        [prods setForOrders:true];
        [self.navigationController pushViewController:prods animated:YES];
    } else if ([item isEqualToString:@"Suppliers"]) {
        PFASuppliersViewController *suppliers = [[PFASuppliersViewController alloc] initWithNibName:nil bundle:nil];
        [suppliers setForOrders:true];
        [self.navigationController pushViewController:suppliers animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
