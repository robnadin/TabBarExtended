//
//  StreetViewController.h
//  TabBarExtended
//
//  Created by Rob on 09/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface StreetViewController : UIViewController

#pragma mark - Properties

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet GMSPanoramaView *panoramaView;

@end
