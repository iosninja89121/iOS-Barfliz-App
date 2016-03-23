//
//  ContactListTableViewController.m
//  Barfliz
//
//  Created by User on 11/12/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "NewPushTableViewController.h"


@interface ContactListTableViewController ()
@property NSArray *curList;
@property AppDelegate *appDelegate;
@property NSMutableArray *arrFlag;
@end

@implementation ContactListTableViewController
@synthesize selectedItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.appDelegate = [AppDelegate appDelegate];
    self.arrFlag = [[NSMutableArray alloc] init];
    
    [self loadInitialData];
}

- (void) getFavoriteList{
    PFQuery *query = [PFQuery queryWithClassName:pClassFriend];
    
    NSString *myUsername = [[PFUser currentUser] username];
    
    [query whereKey:keyMyUsername equalTo:myUsername];
    [query whereKey:keyFavoirte equalTo:@"1"];
    [query includeKey:keyOtherUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            self.curList = objects;
            
            for(int i = 0; i < [objects count]; i ++){
                [self.arrFlag addObject:@"0"];
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (void) getFriendList{
    PFQuery *query = [PFQuery queryWithClassName:pClassFriend];
    
    NSString *myUsername = [[PFUser currentUser] username];
    [query whereKey:keyMyUsername equalTo:myUsername];
    [query includeKey:keyOtherUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            self.curList = objects;
            
            for(int i = 0; i < [objects count]; i ++){
                [self.arrFlag addObject:@"0"];
            }
            
            [self.tableView reloadData];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadInitialData {
//    [self.appDelegate.contactsManager getContactsList];
    
    if([self.selectedItem isEqualToString:@"Favorites"]){
        [self getFavoriteList];
    }
    else{
        [self getFriendList];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.curList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idGeneralItem" forIndexPath:indexPath];
    
    // Configure the cell...
    // Get each single event.
    PFObject *pfObj = [self.curList objectAtIndex:indexPath.row];
    
    PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
    
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:20];
    lblID.text = [pfUser valueForKey:kpRealUsername] ;
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:10];
    NSData *photoData = [pfUser  objectForKey:keyPhoto];
    UIImage *photoImg = [UIImage imageWithData:photoData];
    [imgView  setImage:photoImg];
    
    NSString* strFlag = [self.arrFlag objectAtIndex:indexPath.row];
    
    if([strFlag compare:@"1"] == NSOrderedSame)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString* strFlag = [self.arrFlag objectAtIndex:indexPath.row];
    
    if([strFlag compare:@"1"] == NSOrderedSame)
       [self.arrFlag replaceObjectAtIndex:indexPath.row withObject:@"0"];
    else
        [self.arrFlag replaceObjectAtIndex:indexPath.row withObject:@"1"];
    
    [tableView reloadData];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NewPushTableViewController *targetViewCtrl = segue.destinationViewController;
    
    for(int i = 0; i < self.curList.count; i ++)
    {
        NSString* strFlag = [self.arrFlag objectAtIndex:i];
        
        if([strFlag compare:@"0"] == NSOrderedSame) continue;
       
        PFObject *pfObj = [self.curList objectAtIndex:i];
        PFUser *pfUser = [pfObj valueForKey:keyOtherUser];
        
        [targetViewCtrl.receiverList addObject:pfUser];
        
    }
    
}


@end
