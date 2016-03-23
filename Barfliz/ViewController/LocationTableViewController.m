//
//  LocationTableViewController.m
//  Barfliz
//
//  Created by User on 11/13/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "LocationTableViewController.h"
#import "YelpClient.h"
#import "YelpListingCell.h"
#import "AppDelegate.h"
#import "LocationTracker.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";


@interface LocationTableViewController ()
@property (nonatomic, strong) NSArray *yelpListings;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *restaurantsArray;
@property (nonatomic, strong) UIView *searchBarView;
@property (strong, nonatomic) NSString *searchTerm;
@property NSInteger checkedPos;

- (CLLocationCoordinate2D) getLocation;

@end

@implementation LocationTableViewController
@synthesize tappedItem;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Remove the logo image from the navigation bar.
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    
    // Add the search bar and filter button to header of table view.
    UINavigationBar *headerView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,20,320,44)];
    
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@"whatever"];
    
    
//    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(filter)];
//    [buttonCarrier setLeftBarButtonItem:barBackButton];
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    [headerView setItems:barItemArray];
    [self.tableView setTableHeaderView:headerView];
    
    [headerView setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:40.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [headerView setTintColor:[UIColor darkGrayColor]];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    headerView.topItem.titleView = self.searchBar;
    
    self.checkedPos = 10000;
    
    // get the data through the Yelp api.
//    CLLocationCoordinate2D coordinate = [self getLocation];
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    CLLocationCoordinate2D coordinate = appDelegate.locationTracker.myLocation;
    
    NSString *pos_lat_log = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    
//    pos_lat_log = @"37.788022,-122.399797";
    
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithTerm:@"cafe" location:pos_lat_log success:^(AFHTTPRequestOperation *operation, id response) {
        
        self.yelpListings = [YelpListing yelpListingsWithArray:response[@"businesses"]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.yelpListings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YelpListingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpListingCell" forIndexPath:indexPath];
    YelpListing *listing = self.yelpListings[indexPath.row];
    listing.index    = [NSString stringWithFormat: @"%ld", (long)indexPath.row];
    
    cell.yelpListing = listing;
    
    if(indexPath.row == self.checkedPos){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YelpListing *listing = self.yelpListings[indexPath.row];
    
    NSString *text = listing.title;
    UIFont *fontText = [UIFont boldSystemFontOfSize:17.0];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(165, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:fontText}
                                     context:nil];
    
    CGFloat heightOffset = 90;
    return rect.size.height + heightOffset;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _checkedPos = indexPath.row;
    [tableView reloadData];
}


#pragma mark Search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dismissKeyboard];
    NSString *searchText = searchBar.text;
    
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    CLLocationCoordinate2D coordinate = appDelegate.locationTracker.myLocation;
    
    NSString *pos_lat_log = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    
    [self.client searchWithTerm:searchText location:pos_lat_log success:^(AFHTTPRequestOperation *operation, id response) {
        self.yelpListings = [YelpListing yelpListingsWithArray:response[@"businesses"]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *searchText = searchBar.text;
    
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    CLLocationCoordinate2D coordinate = appDelegate.locationTracker.myLocation;
    
    NSString *pos_lat_log = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    
    [self.client searchWithTerm:searchText location:pos_lat_log success:^(AFHTTPRequestOperation *operation, id response) {
        self.yelpListings = [YelpListing yelpListingsWithArray:response[@"businesses"]];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.tappedItem = [self.yelpListings objectAtIndex:self.checkedPos];
}


@end
