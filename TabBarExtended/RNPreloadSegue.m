//
//  RNPreloadSegue.m
//  TabBarExtended
//
//  Created by Rob on 09/03/2014.
//  Copyright (c) 2014 Rob Nadin. All rights reserved.
//

#import "RNPreloadSegue.h"

@protocol PreloadViewController <NSObject>

@property (strong, nonatomic) UIViewController *mapsViewController;

@end


@implementation RNPreloadSegue

- (void)perform
{
    __block UIViewController<PreloadViewController> *sourceViewController = self.sourceViewController;
    __block UIViewController *destinationViewController = self.destinationViewController;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // Store a reference to the destination controller on the source
        sourceViewController.mapsViewController = destinationViewController;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Load the view on the main thread
            [destinationViewController view];
        }];
    }];
}

@end
