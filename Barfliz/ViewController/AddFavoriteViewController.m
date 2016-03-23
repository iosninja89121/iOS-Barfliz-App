//
//  AddFavoriteViewController.m
//  Barfliz
//
//  Created by User on 11/18/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "AddFavoriteViewController.h"
#import "AppDelegate.h"
#import "FriendInfo.h"
#import "UIImageView+AFNetworking.h"


@interface AddFavoriteViewController ()
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tblContacts;

@property (nonatomic, strong) NSArray *friendList;

@property NSMutableArray *flagArray;
@end

@implementation AddFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Make self the delegate and datasource of the table view.
    self.tblContacts.delegate = self;
    self.tblContacts.dataSource = self;
    
    self.flagArray = [[NSMutableArray alloc] init];
    
    [self getFriendList];
    
}
- (IBAction)btnDonePressed:(id)sender {
    for(int i = 0 ; i < [self.flagArray count]; i ++)
    {
        NSString *flagStr = [self.flagArray objectAtIndex:i];
        
        PFObject *pfObj = [self.friendList objectAtIndex:i];
        
        if([flagStr isEqualToString:@"yes"]){
            [pfObj setObject:@"1" forKey:keyFavoirte];
        }else{
            [pfObj setObject:@"0" forKey:keyFavoirte];
        }
    }
    [PFObject saveAllInBackground:self.friendList block:^(BOOL succeeded, NSError *error){
        if(succeeded){
            [self performSegueWithIdentifier:@"idSegueFavoriteFromAdd" sender:self];
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
            
            for(int i = 0; i < [self.friendList count]; i ++)
            {
                PFObject *pfObj = [self.friendList objectAtIndex:i];
                NSString *favoriteItem = [pfObj valueForKey:keyFavoirte];
                
                if([favoriteItem isEqualToString:@"1"]){
                    [self.flagArray addObject:@"yes"];
                }else{
                    [self.flagArray addObject:@"no"];
                }
            }
            
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

#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"idCellGeneral"];
    
    // Get each single event.
    PFObject *pfObj = [self.friendList objectAtIndex:indexPath.row];
    
    PFUser *pfUser = [pfObj objectForKey:keyOtherUser];
    
    UILabel *lblID = (UILabel *)[cell.contentView viewWithTag:20];
    lblID.text = [pfUser valueForKey:kpRealUsername];
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:10];
    NSData *photoData = [pfUser  objectForKey:keyPhoto];
    UIImage *photoImg = [UIImage imageWithData:photoData];
    [imgView  setImage:photoImg];
    
    NSString *flagStr = [self.flagArray objectAtIndex:indexPath.row];
    if([flagStr isEqualToString:@"yes"]){
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
    NSString *flagStr = [self.flagArray objectAtIndex:indexPath.row];
    
    if([flagStr isEqualToString:@"yes"]){
        [self.flagArray replaceObjectAtIndex:indexPath.row withObject:@"no"];
    }else{
        [self.flagArray replaceObjectAtIndex:indexPath.row withObject:@"yes"];
    }
    
    [self.tblContacts reloadData];
}


@end
