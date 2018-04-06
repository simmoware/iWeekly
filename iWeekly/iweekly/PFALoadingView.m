//
//  PFALoadingView.m
//  iWeekly
//
//  Created by Anthony Simonetta on 22/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFALoadingView.h"

@implementation PFALoadingView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
        [self.layer setCornerRadius:10.0];
        [self.layer setMasksToBounds:YES];
        [self setFrame:CGRectMake((frame.size.width/2.0)-20, (frame.size.height/2.0)-20, 40, 40)];
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [loading startAnimating];
        [loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:loading];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:CGRectMake((frame.size.width/2.0)-20, (frame.size.height/2.0)-20, 40, 40)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
