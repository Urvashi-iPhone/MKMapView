//
//  ViewController.m
//  Google Map
//
//  Created by Tecksky Techonologies on 12/16/16.
//  Copyright © 2016 Tecksky Technologies. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "MapUtils.h"


@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapviewc;

@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self loadView];
    
    [_mapviewc setMapType:MKMapTypeStandard];
    CLLocation *surat = [MapUtils getLatLongFromAddress:@"surat"];
      CLLocation *abad = [MapUtils getLatLongFromAddress:@"ahmedabad"];
    MKPointAnnotation *annotation_surat = [[MKPointAnnotation alloc] init];
    //[annotation setCoordinate:CLLocationCoordinate2DMake(21.1702, 72.8311)];
    [annotation_surat setCoordinate:surat.coordinate];
    [annotation_surat setTitle:@"surat"];
    //You can set the subtitle too
    [_mapviewc addAnnotation:annotation_surat];
    
    MKPointAnnotation *annotation_abad = [[MKPointAnnotation alloc] init];
    //[annotation setCoordinate:CLLocationCoordinate2DMake(21.1702, 72.8311)];
    [annotation_abad setCoordinate:abad.coordinate];
    [annotation_abad setTitle:@"surat"];
    //You can set the subtitle too
    [_mapviewc addAnnotation:annotation_abad];
    
//    CLLocation *surat = [[CLLocation alloc] initWithLatitude:21.1702 longitude:72.8311];
//    CLLocation *vdodra = [[CLLocation alloc] initWithLatitude:22.3072 longitude:73.1812];
//    CLLocation *abad = [[CLLocation alloc] initWithLatitude:23.0225 longitude:72.5714];
    
    //CLLocation *surat = [MapUtils getLatLongFromAddress:@"surat"];
  
   
    NSString *pathUrl = [MapUtils getPathURL:surat :abad];
    NSDictionary *pathDic = [MapUtils getPathResponse:pathUrl];
    NSMutableDictionary *pathPoints = [MapUtils getAllPointPath:pathDic];
    [MapUtils drawRoute:pathPoints:_mapviewc];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
  }

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Didspose of any resources that can be recreated.
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"Current Location"]) {
        return nil;
    }
    
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    if ([[annotation title] isEqualToString:@"McDonald's"])
        annView.image = [ UIImage imageNamed:@"mcdonalds.png" ];
    else if ([[annotation title] isEqualToString:@"Apple store"])
        annView.image = [ UIImage imageNamed:@"applestore.png" ];
    else
        annView.image = [ UIImage imageNamed:@"location-pin.png" ];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(showDetailsView)
         forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = infoButton;
    annView.canShowCallout = YES;
    return annView;
}
-(void)showDetailsView
{
    NSLog(@"click");
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 2.0;
    
    return polylineView;
}

@end
