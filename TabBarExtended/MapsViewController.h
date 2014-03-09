//
//  MapsViewController.h
//  TabBarExtended
//
//  Created by Rob on 09/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapsViewController : UIViewController

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *markerDetailView;
@property (weak, nonatomic) IBOutlet UIButton *streetViewButton;

@end
