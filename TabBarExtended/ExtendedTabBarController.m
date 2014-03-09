//
//  ExtendedTabBarController.m
//  TabBarExtended
//
//  Created by Rob on 08/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "ExtendedTabBarController.h"

@interface ExtendedTabBarController () <UITabBarControllerDelegate>
{
    UITabBar *_customTabBar;
}

@end


@implementation ExtendedTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the tab bar controller delegate to ourselves,
    // although I don't think this is entirely necessary
    self.delegate = self;
    
    // Do not allow customization of the view controllers
    self.customizableViewControllers = nil;

    // Create a new tab bar copy to replace the old tab bar
    _customTabBar = [self copyOfTabBar:self.tabBar];
    _customTabBar.delegate = self;
    [self.tabBar removeFromSuperview];
    [self.view addSubview:_customTabBar];
    
    // Only show the first 4 items on the tab bar
    NSMutableArray *items = [NSMutableArray arrayWithArray:_customTabBar.items];
    [_customTabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        if (idx >= 4) {
            [items removeObject:item];
        }
    }];
    _customTabBar.items = [NSArray arrayWithArray:items];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Select the correct index
    _customTabBar.selectedItem = [_customTabBar.items objectAtIndex:self.selectedIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tab bar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger index = [_customTabBar.items indexOfObject:item];
    
    if (index != NSNotFound) {
        UIViewController *viewController = [self.viewControllers objectAtIndex:index];
        self.selectedViewController = viewController;
        if ([self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
            [self.delegate tabBarController:self didSelectViewController:viewController];
        }
    } else {
        // Error
    }
}

#pragma mark - Tab bar controller delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *vc = [((UINavigationController *)viewController).viewControllers firstObject];
        vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More"
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(showMoreNavigationController)];
    }
}

#pragma mark - User actions

- (void)showMoreNavigationController
{
    self.selectedViewController = self.moreNavigationController;
    _customTabBar.selectedItem = nil;
}

#pragma mark -

- (UITabBar *)copyOfTabBar:(UITabBar *)tabBar
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tabBar];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
