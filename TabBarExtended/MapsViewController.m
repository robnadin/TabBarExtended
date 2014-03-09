//
//  MapsViewController.m
//  TabBarExtended
//
//  Created by Rob on 09/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "MapsViewController.h"
#import "StreetViewController.h"

@interface MapsViewController () <GMSMapViewDelegate>
{
    GMSMarker *_selectedMarker;
    CLLocationCoordinate2D _streetViewCoordinate;
    GMSPanoramaService *_panoramaService;
}

@property (strong, nonatomic) NSLayoutConstraint *markerDetailBottomConstraint;

@end

    
@implementation MapsViewController

@synthesize markerDetailBottomConstraint = _markerDetailBottomConstraint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self sharedInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    NSLog(@"MapsViewController initialised");
    
    _panoramaService = [[GMSPanoramaService alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    NSLog(@"MapsViewController view loaded");
    
    // Set the map delegate
    self.mapView.delegate = self;
    
    // Configure the marker detail view
    self.markerDetailView.layer.shadowOpacity = 0.4f;
    self.markerDetailView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.markerDetailView.bounds].CGPath;
    self.markerDetailView.layer.shadowRadius = 5.0f;
    
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.secondAttribute == NSLayoutAttributeBottom && constraint.secondItem == self.markerDetailView) {
            constraint.constant = -50.0f;
            *stop = YES;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"MapsViewController view will appear");
    
    if (!self.mapView.myLocationEnabled)
        self.mapView.myLocationEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Add KVO for user location
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:0 context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PanoramaSegue"]) {
        StreetViewController *viewController = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
        viewController.coordinate = _streetViewCoordinate;
    }
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (!self.mapView.camera) {
        // Create a GMSCameraPosition that tells the map to display the
        // user's location at zoom level 10.
        CLLocationCoordinate2D userLocation = self.mapView.myLocation.coordinate;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:userLocation.latitude
                                                                longitude:userLocation.longitude
                                                                     zoom:10];
    [self.mapView animateToCameraPosition:camera];
//    }
    
    [((GMSMapView *)object) removeObserver:self forKeyPath:@"myLocation"];
}

#pragma mark - Map view delegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    _selectedMarker = marker;
    
    self.streetViewButton.enabled = NO;
    
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [_panoramaService requestPanoramaNearCoordinate:marker.position
                                             radius:250
                                           callback:^(GMSPanorama *panorama, NSError *error)
    {
        app.networkActivityIndicatorVisible = NO;
        
        if (!error && panorama) {
            self.streetViewButton.enabled = YES;
            
            _streetViewCoordinate = panorama.coordinate;
        }
    }];
    
//    NSLayoutConstraint *constraint = self.markerDetailBottomConstraint;
//    CGFloat constant = (constraint.constant != 0) ? 0 : -50.0f;
    [self animateConstraint:self.markerDetailBottomConstraint offset:0];
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    _selectedMarker = nil;

    [self animateConstraint:self.markerDetailBottomConstraint offset:-50.0f];
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    _selectedMarker = [GMSMarker markerWithPosition:coordinate];
    _selectedMarker.map = mapView;
    
    self.streetViewButton.enabled = NO;
    
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [_panoramaService requestPanoramaNearCoordinate:coordinate
                                             radius:250
                                           callback:^(GMSPanorama *panorama, NSError *error)
    {
        app.networkActivityIndicatorVisible = NO;
        
        if (!error && panorama) {
            self.streetViewButton.enabled = YES;
            
            _streetViewCoordinate = panorama.coordinate;
        }
    }];
    
    [self animateConstraint:self.markerDetailBottomConstraint offset:0];
}

#pragma mark -

- (NSLayoutConstraint *)markerDetailBottomConstraint
{
    if (!_markerDetailBottomConstraint) {
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if (constraint.secondAttribute == NSLayoutAttributeBottom && constraint.secondItem == self.markerDetailView) {
                _markerDetailBottomConstraint = constraint;
                *stop = YES;
            }
        }];
    }
    
    return _markerDetailBottomConstraint;
}

- (void)animateConstraint:(NSLayoutConstraint *)constraint offset:(CGFloat)offset
{
    [UIView animateWithDuration:0.2 animations:^{
        constraint.constant = offset;
        [self.view layoutIfNeeded];
    }];
}

@end
