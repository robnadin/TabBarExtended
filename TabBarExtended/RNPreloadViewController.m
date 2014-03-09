//
//  RNPreloadViewController.m
//  TabBarExtended
//
//  Created by Rob on 09/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNPreloadViewController.h"

@interface RNPreloadViewController ()

@end


@implementation RNPreloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Perform any additional tasks associated with presenting the view.
    [self performSegueWithIdentifier:@"PreloadMaps" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Stub
}

#pragma mark - User actions

- (IBAction)buttonPressed:(UIButton *)sender
{
    if (_mapsViewController) {
        NSLog(@"Button pressed");
        [self.navigationController pushViewController:_mapsViewController animated:YES];
    }
}

@end
