//
//  ContactsTabListViewController.m
//  Barfliz
//
//  Created by User on 11/16/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ContactsTabListViewController.h"
#import "AppDelegate.h"
#import "ContactsManager.h"
#import "FriendInfo.h"
#import "UIImageView+AFNetworking.h"
#import "AddContactViewController.h"
#import "NewPushTableViewController.h"
#import "AnotherProfileViewController.h"



@interface ContactsTabListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblContacts;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *friendList;
@property (nonatomic) long nIdx;
@property (nonatomic) BOOL flag;
@end

@implementation ContactsTabListViewController

- (IBAction)unwindContactFromAdd:(UIStoryboardSegue *)unwindSegue{
    AddContactViewController *source = [unwindSegue sourceViewController];
    
    if(source.checkedPos == 10000) return;
    PFUser *newContact = source.selContact;
    
    if([self checkExisting:newContact])
    {
        [AppDelegate message:@"Your selected contact is already registered as friend! please select other contact as friend"];
        return;
    }
    
    NSString *myUsername = [[PFUser currentUser] username];
    NSString *otherUsername = [newContact username];
//    NSString *otherUsername = [newContact username];
//    NSData *photoData = [newContact objectForKey:keyPhoto];
//    NSString *email = [newContact objectForKey:keyEmail];
//    NSString *phone = [newContact objectForKey:keyPhone];
//    NSString *bio   = [newContact objectForKey:keyBio];
//    NSString *favorite = @"0";
    
    PFObject *newFriendItem = [PFObject objectWithClassName:pClassFriend];
    [newFriendItem setObject:myUsername     forKey:keyMyUsername];
    [newFriendItem setObject:newContact     forKey:keyOtherUser];
    [newFriendItem setObject:@"0"           forKey:keyFavoirte];
    [newFriendItem setObject:otherUsername  forKey:keyOtherUsername];
  
    [newFriendItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Couldn't save!");
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
        if (succeeded) {
            [self getFriendList];
        } else {
            NSLog(@"Failed to save.");
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
            self.friendList = objects;
            [self.tblContacts reloadData];
        }
    }];
}

- (BOOL) checkExisting:(PFUser*) newContact{
    self.flag = NO;
    
    PFQuery *query = [PFQuery queryWithClassName:pClassFriend];
    
    NSString *myUsername = [[PFUser currentUser] username];
    
    [query whereKey:keyMyUsername equalTo:myUsername];
    [query whereKey:keyOtherUser equalTo:newContact];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.flag = YES;
        }
    }];
    
    return self.flag;
}


- (IBAction)unwindContactFromFavorite:(UIStoryboardSegue *)unwindSegue{
    
}

- (IBAction)ShowFavorites:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Instantiate the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Make self the delegate and datasource of the table view.
    self.tblContacts.delegate = self;
    self.tblContacts.dataSource = self;
    
    [self getFriendList];
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
    return [self.friendList count] + 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellGeneral"];
        cell.textLabel.text = @"+ Add a new contact...";
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCellItem"];
        
        // Get each single event.
        PFObject *pfObj = [self.friendList objectAtIndex:indexPath.row - 1];
        
        PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
        
        UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:20];
        lblID.text = [pfUser valueForKey:kpRealUsername];
        
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:10];
        NSData *photoData = [pfUser  objectForKey:keyPhoto];
        UIImage *photoImg = [UIImage imageWithData:photoData];
        [imgView  setImage:photoImg];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}


//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    // Keep the identifier of the event that's about to be edited.
////    self.appDelegate.eventManager.selectedEventIdentifier = [[self.arrEvents objectAtIndex:indexPath.row - 1] eventIdentifier];
//    [AppDelegate message:@"Content"];
//    
//    // Perform the segue.
////    [self performSegueWithIdentifier:@"idSegueEvent" sender:self];
//}
//
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == 0) return;
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        PFObject *pfObj = [self.friendList objectAtIndex:indexPath.row - 1];
//        
//        [pfObj delete];
//        [self getFriendList];
//    }
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"idSegueAddContacts" sender:self];
        return;
    }
    else{
        self.nIdx = indexPath.row - 1;
        
        NSMutableArray *shareList =[[NSMutableArray alloc] initWithObjects:@"Message", @"View Profile", @"Remove", nil];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *item in shareList) {
            [actionSheet addButtonWithTitle:item];
        }
        
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
        
        [actionSheet showInView:self.view];
        
    }
}

#pragma mark - Action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0) [self GotoMessage];
    if(buttonIndex == 1) [self GotoViewProfile];
    if(buttonIndex == 2) [self GotoRemove];
    
}

- (void) GotoMessage{
    for ( UINavigationController *controller in self.tabBarController.viewControllers ) {
        
        if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[NewPushTableViewController class]]) {
            
            NewPushTableViewController *newPushViewController = [controller.childViewControllers objectAtIndex:0];
            
            [self.tabBarController setSelectedViewController:controller];
            
            PFObject *pfObj = [self.friendList objectAtIndex:self.nIdx];
            
            PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
            
            newPushViewController.receiverList = [[NSMutableArray alloc] initWithObjects:pfUser, nil];
            newPushViewController.location_expended = false;
            newPushViewController.calendar_expended = false;
            newPushViewController.msgTextView.text = @"";
            //                newPushViewController.countLabel.text = @"40";
            
            [newPushViewController.tableView reloadData];
            
            break;
        }
    }

}

- (void) GotoViewProfile{
    PFObject *pfObj = [self.friendList objectAtIndex:self.nIdx];
    PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
    
    AnotherProfileViewController * controller = (AnotherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:another_profile_scene];
    
    controller.anotherUser = pfUser;
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (void) GotoRemove{
    PFObject *pfObj = [self.friendList objectAtIndex:self.nIdx];
    
    [pfObj delete];
    [self getFriendList];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
