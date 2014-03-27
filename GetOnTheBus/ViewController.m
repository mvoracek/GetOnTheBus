//
//  ViewController.m
//  GetOnTheBus
//
//  Created by Matthew Voracek on 1/21/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "BusAnnotation.h"
#import "MapDetailViewController.h"
static const double LATITUDE = 41.89373984;
static const double LONGITUDE = -87.63532979;

@interface ViewController () <MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *busMapView;
    NSArray *busStopArray;
    CLLocationCoordinate2D MMHQCoordinate;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dev.mobilemakers.co/lib/bus.json"]];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         busStopArray = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&connectionError][@"row"];
         for (NSDictionary *busStop in busStopArray)
         {
             NSString *stopLatitude = busStop [@"location"][@"latitude"];
             NSString *stopLongitude = busStop [@"location"][@"longitude"];
             CLLocationCoordinate2D location = CLLocationCoordinate2DMake(stopLatitude.doubleValue, stopLongitude.doubleValue);
             
             BusAnnotation *annotation = [BusAnnotation new];
             annotation.title = busStop[@"cta_stop_name"];
             annotation.subtitle = busStop[@"routes"];
             annotation.address = busStop[@"address"];
             annotation.intermodal = busStop[@"inter_modal"];
             
             if ([annotation.intermodal  isEqual: @"Pace"])
             {
                 
             }
             else if ([annotation.intermodal  isEqual: @"Metra"])
             {
                 
             }
             
             annotation.coordinate = location;
             annotation.location = [[CLLocation alloc] initWithLatitude:stopLatitude.doubleValue longitude:stopLongitude.doubleValue];
             
             
             
             [busMapView addAnnotation:annotation];
         }
     }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.3, 0.3);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake (LATITUDE,LONGITUDE);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [busMapView setRegion:region animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(BusAnnotation *)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapReuseID"];
    /*
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    */
    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapReuseID"];
    } else
    {
        annotationView.annotation = annotation;
    }
    
    /*
     UIGraphicsBeginImageContext(newSize);
     [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
     UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     */
    CGSize newSize;
    UIImage *image;
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    
    if ([annotation.intermodal isEqualToString:@"Pace"])
    {
        annotationView.image = [UIImage imageNamed:@"pacelogosmall"];
        
        
        //UIImage *small = [UIImage imageWithCGImage:original.CGImage scale:0.25 orientation:original.imageOrientation];

    }
    else if ([annotation.intermodal isEqualToString:@"Metra"])
    {
        annotationView.image = [UIImage imageNamed:@"metralogosmall"];
    }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detailSegue" sender:view];

}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    MapDetailViewController *vc = segue.destinationViewController;
    BusAnnotation *busAnnotation = sender.annotation;
    vc.viewBusStop = busAnnotation;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
