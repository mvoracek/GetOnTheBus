//
//  BusAnnotation.h
//  GetOnTheBus
//
//  Created by Matthew Voracek on 1/21/14.
//  Copyright (c) 2014 Matthew Voracek. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface BusAnnotation : MKPointAnnotation

//next time create a whole dictionary, create methods to return the necessary items to avoid using literals
@property NSString* address;
@property NSString* intermodal;
@property CLLocation* location;


@end
