//
//  ViewController.m
//  projectDidYou
//
//  Created by Zirui Branton  on 3/29/16.
//  Copyright © 2016 Project Did You. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
   
    self.geocoder = [[CLGeocoder alloc]init];
    
}


- (IBAction)locationButtonTapped:(id)sender {
    NSLog(@"locationButtontapped: with sender %@", sender);
     self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
     [self.locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError, %@", error);
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get where you are" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [errorAlert addAction:defaultAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    

    CLLocation *currentLocation = locations[0];
    
    if (currentLocation != nil) {
        
        self.latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        self.longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
        //stop location manager
        
        [self.locationManager stopUpdatingLocation];
        
        NSLog(@"resolving the address");
        
        //translate the locate data into a human-readable address
        [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error == nil && [placemarks count] > 0) {
                self.placemark = [placemarks lastObject];
                self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", self.placemark.locality, self.placemark.country];
            
            } else {
                
                NSLog(@"@%@", error.debugDescription);
            }
        }];
    }
    
    
}


@end
