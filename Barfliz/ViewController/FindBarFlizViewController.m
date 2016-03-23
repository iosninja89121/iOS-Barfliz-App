//
//  FindBarFlizViewController.m
//  Barfliz
//
//  Created by User on 11/19/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//



#import "FindBarFlizViewController.h"
#import "AppDelegate.h"
#import "ContactsManager.h"
#import "FriendInfo.h"
#import "NewPushTableViewController.h"
#import "LocationTracker.h"
#import "OtherProfileViewController.h"
#define span 40000



@interface FindBarFlizViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property AppDelegate *appDelegate;
@property NSArray *annotationList;
//@property CLLocationCoordinate2D centre;
@property (nonatomic) NSInteger nIdx;
@end

@implementation FindBarFlizViewController

- (IBAction)UpdateButtonClicked:(id)sender {
    [self LoadMap];
}

- (IBAction)unwindMapFromRadiusDone:(UIStoryboardSegue *)unwindSegue{
    
    [self LoadMap];
    
}

- (IBAction)unwindMapFromRadiusCancel:(UIStoryboardSegue *)unwindSegue{
    
}


- (IBAction)unwindMapFromOtherProfile:(UIStoryboardSegue *)unwindSegue{
    OtherProfileViewController* source = (OtherProfileViewController *) unwindSegue.sourceViewController;
    PFUser* otherUser = source.otherUser;
    
    [self toNewPushView:otherUser];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self LoadMap];
}

- (void)LoadMap{
    
    id userLocation = [self.mapView userLocation];
    
    CLLocationCoordinate2D center;
    
    if ( userLocation != nil ) {
        
        [self.mapView addAnnotation:userLocation]; // will cause user location pin to blink
        
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    double nRadius = [self.appDelegate.strRadius doubleValue];
    
    if([self.appDelegate.strUnit isEqualToString:@"miles"]) nRadius = nRadius * 1.609344;
    
    
    PFUser *pfUser = [PFUser currentUser];
    
    center = self.mapView.userLocation.coordinate;
    
    if(center.longitude < 0.0000001 && center.longitude > - 0.0000001) {
        center = self.appDelegate.locationTracker.myLocation;
    }
    
    PFGeoPoint *point = [pfUser valueForKey:keyLocation];
    point.latitude = center.latitude;
    point.longitude = center.longitude;
    NSString *myUsername = [pfUser username];
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:keyLocation nearGeoPoint:point withinKilometers:nRadius];
    [query whereKey:@"username" notEqualTo:myUsername];
    [query whereKey:kpPrivacy equalTo:[NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            // The find succeeded. The first 100 objects are available in objects
            self.annotationList = objects;
            
            [self setAnnotionsWithList];
            
            //display radius
            
            
            NSInteger radius = 1000;
            
            if([self.appDelegate.strUnit isEqualToString:@"miles"]) radius = 1609;
            
            
            radius = radius * [self.appDelegate.strRadius integerValue];
            
            
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:center radius:radius];
            
            [self.mapView addOverlay:circle];
            
            
            [self.mapView setCenterCoordinate:center animated:YES];
            
            radius = 2 * radius;
            
            MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, radius, radius)];
            [self.mapView setRegion:adjustedRegion animated:YES];
            
        } else {
            
            // Log details of the failure
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
        
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // inside here, userLocation is the MKUserLocation object representing your
    // current position.
    
    CLLocation *whereIAm = userLocation.location;
    NSLog(@"I'm at %@", whereIAm.description);
    
//     {latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude};
//    self.centre = {latitude: whereIAm.coordinate.latitude, longitude: whereIAm.coordinate.longitude};
    // etc.
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.appDelegate = [AppDelegate appDelegate];
    
    self.annotationList = [[NSMutableArray alloc] init];
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
//    self.centre = {latitude: self.appDelegate.locationTracker.myLocation.latitude, longitude: self.appDelegate.locationTracker.myLocation.longitude};
    
    [self LoadMap];
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}



- (void)customMKMapViewDidSelectedWithInfo:(id)info{
    
    NSLog(@"%@",info);
    
}




-(void)setAnnotionsWithList
{
    //    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"first",@"second", @"third", @"fourth", nil];
    
    for (NSInteger idx = 0; idx < [self.annotationList count]; idx ++) {
        
        PFUser *pfUser = [self.annotationList objectAtIndex:idx];
        PFGeoPoint *point = [pfUser valueForKey:keyLocation];
        
        CLLocationDegrees latitude_new = point.latitude;
        
        CLLocationDegrees longitude_new = point.longitude;
        
        CLLocationCoordinate2D location_new = CLLocationCoordinate2DMake(latitude_new, longitude_new);
        
        NSString *strTitlt = [pfUser valueForKey:kpRealUsername];
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location_new,span ,span );
        MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
        [_mapView setRegion:adjustedRegion animated:YES];
        
        //        BasicMapAnnotation *  annotation=[[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude]  autorelease];
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
        myAnnotation.coordinate = location_new;
        myAnnotation.title = strTitlt;
//        myAnnotation.subtitle = [pfUser valueForKey:keyBio];
        myAnnotation.accessibilityValue = [NSString stringWithFormat:@"%ld", idx];
        myAnnotation.accessibilityHint = [NSString stringWithFormat:@"%ld", idx];
        //        myAnnotation.accessibilityValue = [NSString stringWithFormat:@"%ld", dic.no];
        [_mapView   addAnnotation:myAnnotation];
    }
}







 
 #pragma mark - Navigation
 
 
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 // Get the new view controller using [segue destinationViewController].
 
 // Pass the selected object to the new view controller.
 
     if([segue.identifier isEqualToString:@"idSegueToOtherProfile1"]){
         OtherProfileViewController* target = (OtherProfileViewController*)segue.destinationViewController;
         target.otherUser = [self.annotationList objectAtIndex:self.nIdx];
     }
 }




- (void) toNewPushView:(PFUser*) otherUser{
    
    for ( UINavigationController *controller in self.tabBarController.viewControllers ) {
        
        if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[NewPushTableViewController class]]) {
            
            NewPushTableViewController *newPushViewController = [controller.childViewControllers objectAtIndex:0];
            
            [self.tabBarController setSelectedViewController:controller];
            
            newPushViewController.receiverList = [[NSMutableArray alloc] initWithObjects:otherUser, nil];
            newPushViewController.location_expended = false;
            newPushViewController.calendar_expended = false;
            newPushViewController.msgTextView.text = @"";
//            newPushViewController.countLabel.text = @"40";
            
            [newPushViewController.tableView reloadData];
            
            break;
        }
    }
    
}



#pragma MapView mark Delegate Methods



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    
    
    id <MKAnnotation> annotation = [view annotation];
    
    
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        self.nIdx = view.tag;
        
        [self performSegueWithIdentifier:@"idSegueToOtherProfile1" sender:self];
        
        
    }
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Focuss" message:@"Success" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    //    [alertView show];
    
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
}



- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Blur" message:@"Success" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    //    [alertView show];
    
    
    
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        
        return nil;
    
    
    
    // Handle any custom annotations.
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
        
    {
        
        MKPointAnnotation *myAnnotation = annotation;
        
        // Try to dequeue an existing pin view first.
        
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
            
        {
            
            // If an existing pin view was not available, create one.
            
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"pin.png"];
            pinView.calloutOffset = CGPointMake(0, 0);
            pinView.tag = [myAnnotation.accessibilityValue integerValue];
            
            
            

            
            pinView.canShowCallout = YES;
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            UIImage *buttonImage = [UIImage imageNamed:@"blank"];
            
            [rightButton setImage:buttonImage forState:UIControlStateNormal];
            
            pinView.rightCalloutAccessoryView = rightButton;

            UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            UIImage* leftButtonImage = [UIImage imageNamed:@"blank"];
            
            [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
            pinView.leftCalloutAccessoryView = leftButton;
            
        } else {
            
            pinView.annotation = annotation;
            
        }
        
        return pinView;
        
    }
    
    return nil;
    
}



- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay

{
    
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    
    [circleView setFillColor:[UIColor orangeColor]];
    [circleView setStrokeColor:[UIColor blackColor]];
    [circleView setAlpha:0.5f];
    
    return circleView;
    
}







@end

