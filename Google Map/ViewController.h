//
//  ViewController.h
//  Google Map
//
//  Created by Tecksky Techonologies on 12/16/16.
//  Copyright © 2016 Tecksky Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
     CLLocationManager *locationManager;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;

@end

