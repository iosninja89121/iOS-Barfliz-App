//
//  AddContactViewController.m
//  Barfliz
//
//  Created by User on 11/17/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "AddContactViewController.h"
#import "AppDelegate.h"
#import "FriendInfo.h"
#import "UIImageView+AFNetworking.h"
#import "ActivityView.h"

@interface AddContactViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tblAddContact;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) UIView *searchBarView;
@property (strong, nonatomic) NSString *searchTerm;

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Add the search bar and filter button to header of table view.
    UINavigationBar *headerView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,20,320,44)];
    
    UINavigationItem *buttonCarrier = [[UINavigationItem alloc]initWithTitle:@"whatever"];
    
    
    //    UIBarButtonItem *barBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleDone target:self action:@selector(filter)];
    //    [buttonCarrier setLeftBarButtonItem:barBackButton];
    NSArray *barItemArray = [[NSArray alloc]initWithObjects:buttonCarrier,nil];
    [headerView setItems:barItemArray];
    [self.tblAddContact setTableHeaderView:headerView];
    
    [headerView setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:40.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [headerView setTintColor:[UIColor darkGrayColor]];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    headerView.topItem.titleView = self.searchBar;
    
    self.checkedPos = 10000;
    self.selContact = nil;
    
    self.tblAddContact.dataSource = self;
    self.tblAddContact.delegate = self;
    
//    self.resultArray = [self.appDelegate.contactsManager getSearchFriends:@""];
    
    [self getSearchContacts:@""];
}

- (void) getSearchContacts:(NSString*) searchItem{
    if([searchItem isEqualToString:@""]){
        self.resultArray = [[NSArray alloc] init];
        [self.tblAddContact reloadData];
        return;
    }
    
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Searching";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    
    PFQuery *query = [PFUser query];
    PFUser *currentUser = [PFUser currentUser];
    
    [query whereKey:@"username" containsString:searchItem];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
            // Bring the keyboard back up, because they'll probably need to change something.
            
//            [self.txtUserID becomeFirstResponder];
            return;
        }
        
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        NSMutableArray * resArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for(PFUser *item in objects){
            if([item.objectId isEqualToString:currentUser.objectId]) continue;
            [resArray addObject:item];
        }
        
        self.resultArray = (NSArray *)resArray;
        
        [self.tblAddContact reloadData];
        
        if([resArray count] == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"There are no users you want to search"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];

        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.resultArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"idCellAddContact"];
    
    PFUser *pfUser = [self.resultArray objectAtIndex:indexPath.row];
    
        
    // Get each single event.
//    FriendInfo *friendInfo = [self.resultArray objectAtIndex:indexPath.row];
    
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:20];
    lblID.text = [pfUser valueForKey:kpRealUsername];
        
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:10];
    NSData *photoData = [pfUser objectForKey:@"photo"];
    UIImage *imgPhoto = [UIImage imageWithData:photoData];
    [imgView setImage:imgPhoto];
    
    if(indexPath.row == self.checkedPos){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.checkedPos = indexPath.row;
    [self.tblAddContact reloadData];
}

#pragma mark Search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    searchBar.showsCancelButton = YES;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
//    NSString *searchText = searchBar.text;
    
//    [self dismissKeyboard];
//    //    self.resultArray = [self.appDelegate.contactsManager getSearchFriends:searchText];
//    self.resultArray = [self getSearchContacts:searchText];
//    [self.tblAddContact reloadData];
//    self.checkedPos = 10000;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *searchText = searchBar.text.lowercaseString;
    
    [self dismissKeyboard];
//    self.resultArray = [self.appDelegate.contactsManager getSearchFriends:searchText];
    
    [self getSearchContacts:searchText];
    
    self.checkedPos = 10000;
//    self.selContact = [[FriendInfo alloc] init];
}

#pragma mark Keyboard
- (void)dismissKeyboard {
    [self.view endEditing:YES];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if(self.checkedPos < 1000) self.selContact = [self.resultArray objectAtIndex:self.checkedPos];
}

@end
