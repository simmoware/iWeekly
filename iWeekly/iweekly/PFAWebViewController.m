//
//  PFACappsViewController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 30/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFAWebViewController.h"

@interface PFAWebViewController ()

@end

@implementation PFAWebViewController

@synthesize web;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (web == nil) {
        web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:web];
        [web setDelegate:self];
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://perfection.com.au"]]];
    }
    [self setTitle:@"Perfection Fresh"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [web setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, webView.frame.size.width, webView.frame.size.height)];
    [lbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
    [webView addSubview:lbl];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((webView.frame.size.width/2)-18.5, (webView.frame.size.height/2)-18.5, 37, 37)];
    [loading startAnimating];
    [webView addSubview:loading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSArray *subviews = webView.subviews;
    for (int i = 0; i < [subviews count]; i++) {
        UIView *v = (UIView *)[subviews objectAtIndex:i];
        if ([v isKindOfClass:[UIActivityIndicatorView class]]) {
            [v removeFromSuperview];
        }
        
        if ([v isKindOfClass:[UILabel class]]) {
            [v removeFromSuperview];
        }
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    NSLog(@"%@", error);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [web setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
