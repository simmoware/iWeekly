//
//  PFANavigationController.m
//  iWeekly
//
//  Created by Anthony Simonetta on 15/09/2014.
//  Copyright (c) 2014 PerfectionFreshAustralia. All rights reserved.
//

#import "PFANavigationController.h"

@interface PFANavigationController ()

@end

@interface AMPNavigationBar : UINavigationBar

@property (nonatomic, assign) CGFloat extraColorLayerOpacity UI_APPEARANCE_SELECTOR;

@end

// .m

@interface AMPNavigationBar ()

@property (nonatomic, strong) CALayer *extraColorLayer;

@end

//static CGFloat const kDefaultColorLayerOpacity = 0.5f;

@implementation AMPNavigationBar

- (void)setBarTintColor:(UIColor *)barTintColor
{
    id su = [[[super superclass] alloc] init];
    if ([su respondsToSelector:@selector(setBarTintColor:)]) {
        [super setBarTintColor:barTintColor];
        if (self.extraColorLayer == nil) {
            // this all only applies to 7.0 - 7.0.2
            if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0.3" options:NSNumericSearch] == NSOrderedAscending) {
                self.extraColorLayer = [CALayer layer];
                self.extraColorLayer.opacity = self.extraColorLayerOpacity;
                [self.layer addSublayer:self.extraColorLayer];
            }
        }
        self.extraColorLayer.backgroundColor = barTintColor.CGColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.extraColorLayer != nil) {
        [self.extraColorLayer removeFromSuperlayer];
        self.extraColorLayer.opacity = self.extraColorLayerOpacity;
        [self.layer insertSublayer:self.extraColorLayer atIndex:1];
        CGFloat spaceAboveBar = self.frame.origin.y;
        self.extraColorLayer.frame = CGRectMake(0, 0 - spaceAboveBar, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + spaceAboveBar);
    }
}

- (void)setExtraColorLayerOpacity:(CGFloat)extraColorLayerOpacity
{
    _extraColorLayerOpacity = extraColorLayerOpacity;
    [self setNeedsLayout];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _extraColorLayerOpacity = [[decoder decodeObjectForKey:@"extraColorLayerOpacity"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:@(self.extraColorLayerOpacity) forKey:@"extraColorLayerOpacity"];
}

@end

@implementation PFANavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id) initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[AMPNavigationBar class] toolbarClass:[UIToolbar class]];
    if (self) {
        self.viewControllers = @[ rootViewController ];
        UIColor *background = [UIColor colorWithRed:(119/255.0) green:(139/255.0) blue:(113/255.0) alpha:1.0];
        if ([self.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            [self.navigationBar setBarTintColor:background];
        } else {
            [self.navigationBar setBarStyle:UIBarStyleBlack];
            [self.navigationBar setTintColor:background];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
