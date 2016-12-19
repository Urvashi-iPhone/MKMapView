//
//  MapUtils.m
//  Google Map
//
//  Created by Tecksky Techonologies on 12/19/16.
//  Copyright © 2016 Tecksky Technologies. All rights reserved.
//

#import "MapUtils.h"
#import <MapKit/MapKit.h>

@implementation MapUtils
+(NSString*)getPathURL:(CLLocation *)source :(CLLocation *)destination
{
    NSString *pathUrl = [NSString stringWithFormat:@"%@%f,%f&destination=%f,%f&sensor=false",@"http://maps.googleapis.com/maps/api/directions/json?origin=",source.coordinate.latitude,source.coordinate.longitude,destination.coordinate.latitude,destination.coordinate.longitude];
   
    return pathUrl;
}
+(NSDictionary*)getPathResponse:(NSString *)pathUrl
{
    @try {
        NSURL *url1 = [NSURL URLWithString:pathUrl];
        NSData *jsondata = [NSData dataWithContentsOfURL:url1];
        NSError *error;
        NSDictionary *pathDic = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
        return pathDic;
    } @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    return nil;
}
+(NSMutableArray*)getAllPointPath:(NSDictionary*)pathDic
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    NSString *status = [pathDic valueForKey:@"status"];
    if ([status isEqualToString:@"OK"]) {
        NSMutableArray *routes = [pathDic valueForKey:@"routes"];
        NSMutableDictionary *route = [routes objectAtIndex:0];
        NSMutableArray *legs = [route valueForKey:@"legs"];
        NSMutableDictionary *leg = [legs objectAtIndex:0];
        NSMutableArray *steps = [leg valueForKey:@"steps"];
        
        for (int i=0; i<[steps count]; i++)
        {
            NSMutableDictionary *step = [steps objectAtIndex:i];
            NSMutableDictionary *start_location = [step valueForKey:@"start_location"];
            
            CLLocation *latlong = [[CLLocation alloc] initWithLatitude:[[start_location valueForKey:@"lat"] floatValue]longitude:[[start_location valueForKey:@"lng"] floatValue]];
            [points addObject:latlong];
        }
    }
    return points;
}
+(void)drawRoute:(NSMutableArray*)points:(MKMapView*)map
{
    NSInteger numberOfSteps = points.count;
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++) {
        CLLocation *location = [points objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        coordinates[index] = coordinate;
    }
    MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
    [map addOverlay:polyLine];
}

+(CLLocation*)getLatLongFromAddress:(NSString *)address
{
    address = [address stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *str1 = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false" , address];
    NSURL *url1 = [NSURL URLWithString:str1];
    NSData *jsondata = [NSData dataWithContentsOfURL:url1];
    NSError *error;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
    NSString *status = [dic valueForKey:@"status"];
    if ([status isEqualToString:@"OK"]) {
        NSMutableArray *results = [dic valueForKey:@"results"];
        NSMutableDictionary *result = [results objectAtIndex:0];
        float lat = [[[[result valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] floatValue];
        float lng = [[[[result valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] floatValue];
        return [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    }
    return nil;
}
@end
