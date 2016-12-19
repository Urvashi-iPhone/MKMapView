//
//  MapUtils.h
//  Google Map
//
//  Created by Tecksky Techonologies on 12/19/16.
//  Copyright © 2016 Tecksky Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapUtils : NSObject
+(NSString*)getPathURL:(CLLocation*)source:(CLLocation*)destination;
+(NSDictionary*)getPathResponse:(NSString*)pathUrl;
+(NSMutableArray*)getAllPointPath:(NSDictionary*)pathDic;
+(void)drawRoute:(NSMutableArray*)points:(MKMapView*)map;

+(CLLocation*)getLatLongFromAddress:(NSString*)address;
@end
