//
//  FindBarFlizViewController.h
//  Barfliz
//
//  Created by User on 11/19/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FindBarFlizViewController : UIViewController<MKMapViewDelegate>
- (IBAction)unwindMapFromRadiusDone:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindMapFromRadiusCancel:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindMapFromOtherProfile:(UIStoryboardSegue *)unwindSegue;
@end
