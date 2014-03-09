//
//  StreetViewController.m
//  TabBarExtended
//
//  Created by Rob on 09/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "StreetViewController.h"

@interface StreetViewController () <GMSPanoramaViewDelegate>

@end


@implementation StreetViewController

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
    GMSPanoramaView *panView = [GMSPanoramaView panoramaWithFrame:self.view.bounds                                            nearCoordinate:self.coordinate];
//    self.panoramaView.delegate = self;
    panView.delegate = self;
//    self.view = panView;
    [self.view addSubview:panView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User actions

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Panorama view delegate

- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate
{
    // Stub
}

- (void)panoramaView:(GMSPanoramaView *)view didMoveToPanorama:(GMSPanorama *)panorama
{
    // Stub
}

@end
