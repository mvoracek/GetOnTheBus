//
//  MapDetailViewController.m
//  GetOnTheBus
//
//  Created by Matthew Voracek on 1/21/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "MapDetailViewController.h"


@interface MapDetailViewController ()
{
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *routesLabel;
    __weak IBOutlet UILabel *transfersLabel;
    
}

@end

@implementation MapDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _viewBusStop.title;
    routesLabel.text = _viewBusStop.subtitle;
    
    if(_viewBusStop.intermodal.length > 0)
    {
        transfersLabel.text = _viewBusStop.intermodal;
    } else {
        transfersLabel.text = @"No nearby Pace/Metra";

    }
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation:_viewBusStop.location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        CLPlacemark *placemark = placemarks[0];
        addressLabel.text = [NSString stringWithFormat:@"%@",placemark.name];
    }];
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
