//
//  FavoriteTabListViewController.m
//  Barfliz
//
//  Created by User on 11/18/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "FavoriteTabListViewController.h"
#import "AppDelegate.h"
#import "FriendInfo.h"
#import "UIImageView+AFNetworking.h"
#import "NewPushTableViewController.h"
#import "AnotherProfileViewController.h"


@interface FavoriteTabListViewController ()
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tblContacts;
@property (nonatomic, strong) NSArray *favoriteList;
@property (nonatomic) long nIdx;
@end

@implementation FavoriteTabListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Make self the delegate and datasource of the table view.
    self.tblContacts.delegate = self;
    self.tblContacts.dataSource = self;
    
//    [self.appDelegate.contactsManager getContactsList];
    [self getFavoriteList];

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
            self.favoriteList = objects;
            [self.tblContacts reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)unwindFavoriteFromAdd:(UIStoryboardSegue *)unwindSegue{
    [self getFavoriteList];
}

#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.favoriteList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"idCellGeneral"];
        
    // Get each single event.
    // Get each single event.
    PFObject *pfObj = [self.favoriteList objectAtIndex:indexPath.row];
    
    PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
    
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:20];
    lblID.text = [pfUser valueForKey:kpRealUsername];
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:10];
    NSData *photoData = [pfUser  objectForKey:keyPhoto];
    UIImage *photoImg = [UIImage imageWithData:photoData];
    [imgView  setImage:photoImg];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}


//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    // Keep the identifier of the event that's about to be edited.
//    //    self.appDelegate.eventManager.selectedEventIdentifier = [[self.arrEvents objectAtIndex:indexPath.row - 1] eventIdentifier];
//    [AppDelegate message:@"Content"];
//    
//    // Perform the segue.
//    //    [self performSegueWithIdentifier:@"idSegueEvent" sender:self];
//}
//
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        PFObject *pfObj = [self.favoriteList objectAtIndex:indexPath.row];
//        [pfObj setObject:@"0" forKey:keyFavoirte];
//        [pfObj saveInBackground];
//        
//        [self getFavoriteList];
//    }
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.nIdx = indexPath.row;
    
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
            
            PFObject *pfObj = [self.favoriteList objectAtIndex:self.nIdx];
            
            PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
            
            newPushViewController.receiverList = [[NSMutableArray alloc] initWithObjects:pfUser, nil];
            newPushViewController.location_expended = false;
            newPushViewController.calendar_expended = false;
            newPushViewController.msgTextView.text = @"";
            //            newPushViewController.countLabel.text = @"40";
            
            [newPushViewController.tableView reloadData];
            
            break;
        }
    }
    
}

- (void) GotoViewProfile{
    PFObject *pfObj = [self.favoriteList objectAtIndex:self.nIdx];
    PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
    
    AnotherProfileViewController * controller = (AnotherProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:another_profile_scene];
    
    controller.anotherUser = pfUser;
    
    [self.navigationController pushViewController:controller animated:NO];
}


- (void) GotoRemove{
    PFObject *pfObj = [self.favoriteList objectAtIndex:self.nIdx];
    [pfObj setObject:@"0" forKey:keyFavoirte];
    [pfObj saveInBackground];
    
    [self getFavoriteList];
}




@end
