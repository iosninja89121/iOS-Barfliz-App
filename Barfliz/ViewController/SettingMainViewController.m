//
//  SettingMainViewController.m
//  Barfliz
//
//  Created by User on 12/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "SettingMainViewController.h"
#import "FindNavigationController.h"
#import <Social/Social.h>
#import <Parse/Parse.h>
#import "PrivacyTermsViewController.h"
#import "AppDelegate.h"

@interface SettingMainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblSettingCategory;
@property (nonatomic, strong) NSMutableArray *categoryList;
@property BOOL privacy_expended;
@property FindNavigationController *findNaviationController;
@property NSInteger nHelpMode;
@property bool flag_first;
@property bool flag_second;

@end

@implementation SettingMainViewController

- (IBAction)unwindSettingFromMyProfile:(UIStoryboardSegue *)unwindSegue{
}

- (IBAction)unwindSettingFromChangePassword:(UIStoryboardSegue *)unwindSegue{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tblSettingCategory.delegate = self;
    self.tblSettingCategory.dataSource = self;
    
    self.categoryList = [[NSMutableArray alloc] initWithObjects:@"My Profile", @"About Barfliz/Help?", @"Tell a Friend", @"Change Password", @"Turn on Public or Private Visiblity", @"Privacy Policy and Terms", @"Delete Account", @"Logout", nil];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"banner_bg.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont fontWithName:@"Didot" size:25.0f], NSFontAttributeName,nil];
    
    [navBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    self.privacy_expended = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showFacebookShare
{
    //    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
//        [self.actView stopAnimating];
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        if (!mySLComposerSheet)
            return;
        
        //        [mySLComposerSheet setInitialText:@"I want to share Potsticker expressions with you.\n 1.  Open Potsticker (Download URL:\n  https://itunes.apple.com/us/app/potsticker/id495268369)\n\n 2.  Copy everything below the dotted line. Paste into Potsticker.\n \"expression1\", \"expression2\", \"expression3\""];
        //        [mySLComposerSheet addURL:[NSURL URLWithString:Share_URL]];
        
        [mySLComposerSheet setInitialText:@"Check out the Barfliz App and never drink or eat alone again. Download it today from https://barfliz.com"];
        //        [mySLComposerSheet addURL:[NSURL URLWithString:Share_URL]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}


- (void)showTwitterShare
{
    //    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        //        [self.actView stopAnimating];
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        if (!mySLComposerSheet)
            return;
        
        //        [mySLComposerSheet setInitialText:@"I want to share Potsticker expressions with you.\n 1.  Open Potsticker (Download URL:\n  https://itunes.apple.com/us/app/potsticker/id495268369)\n\n 2.  Copy everything below the dotted line. Paste into Potsticker.\n \"expression1\", \"expression2\", \"expression3\""];
        //        [mySLComposerSheet addURL:[NSURL URLWithString:Share_URL]];
        
        [mySLComposerSheet setInitialText:@"Check out the Barfliz App and never drink or eat alone again. Download it today from https://barfliz.com"];
        //        [mySLComposerSheet addURL:[NSURL URLWithString:Share_URL]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (void) showEmailShare{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Please Check out"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:nil];
        [mailer setToRecipients:toRecipients];
        
        NSString *emailBody = @"Check out the Barfliz App and never drink or eat alone again. Download it today from https://barfliz.com";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }}

- (void) showMessageShare{
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    if([MFMessageComposeViewController canSendText]){
        messageController.body = @"Check out the Barfliz App and never drink or eat alone again. Download it today from https://barfliz.com";
        messageController.recipients = [NSArray arrayWithObjects:nil];
        [self presentViewController:messageController animated:YES completion:nil];
    }
}


- (void) showShareList{
    NSMutableArray *shareList =[[NSMutableArray alloc] initWithObjects:@"Mail", @"Message", @"Twitter", @"Facebook", nil];
    
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

- (void)stateChanged:(UISwitch *)switchState
{
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    
    
    
    if ([switchState isOn]) {
        [self.tabBarController setViewControllers:appDelegate.onTabViewCtrlArray animated:YES];
        
    } else {
        [self.tabBarController setViewControllers:appDelegate.offTabViewCtrlArray animated:YES];
    }
    
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:[NSNumber numberWithBool:[switchState isOn]] forKey:kpPrivacy];
    
    [currentUser saveInBackground];
}

- (void) alertLogout{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you really want to log out?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    alert.tag = 0;
    [alert show];
}


- (void) alertDeactivate{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you really want to deactivate your account?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    alert.tag = 1;
    [alert show];
}


#pragma - mark AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0 && buttonIndex == 0)
    {
        [PFUser logOut];
        [self performSegueWithIdentifier:@"idUnwindSegueWelcomFromSetting" sender:self];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    }
    
    if(alertView.tag == 1 && buttonIndex == 0){
        PFUser *currentUser = [PFUser currentUser];
        
//        [[PFUser currentUser] delete];
        
        self.flag_first = false;
        self.flag_second = false;
        
        [self delete_user_data:currentUser];
        
        
        [self performSegueWithIdentifier:@"idUnwindSegueWelcomFromSetting" sender:self];
    }
}

- (void) delete_user_data:(PFUser *)user{
    NSString *myUsername = [user username];

    // first, delete the friends of current user
    
    PFQuery *query = [PFQuery queryWithClassName:pClassFriend];
    
    [query whereKey:keyMyUsername equalTo:myUsername];
    [query includeKey:keyOtherUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in friend query!"); // todo why is this ever happening?
        } else {
            [PFObject deleteAllInBackground:objects];
            self.flag_first = true;
            if(self.flag_first && self.flag_second) {
                PFUser *currentUser = [PFUser currentUser];
                [currentUser delete];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"registered"];
                [PFUser logOut];
            }
        }
    }];
    
    // second, delete the current user from the friend list of other user
    
    PFQuery *userQuery = [PFUser query];
    
    [userQuery whereKey:@"username" equalTo:myUsername];
    
    PFQuery *friendQuery = [PFQuery queryWithClassName:pClassFriend];
//    [friendQuery whereKey:keyOtherUser equalTo:nil];
    [friendQuery whereKey:keyOtherUser matchesQuery:userQuery];
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"error in friend query");
        }else{
            [PFObject deleteAllInBackground:objects];
            self.flag_second = true;
            if(self.flag_first && self.flag_second){
                PFUser *currentUser = [PFUser currentUser];
                [currentUser delete];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
                [PFUser logOut];
            }
        }
    }];
    
}


#pragma mark - Mail Composer

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:  (NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Message Composer

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultSent: NSLog(@"SENT"); [self dismissViewControllerAnimated:YES completion:nil]; break;
        case MessageComposeResultFailed: NSLog(@"FAILED"); [self dismissViewControllerAnimated:YES completion:nil]; break;
        case MessageComposeResultCancelled: NSLog(@"CANCELLED"); [self dismissViewControllerAnimated:YES completion:nil]; break;
    }
    
}

#pragma mark - Action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 0) [self showEmailShare];
    if(buttonIndex == 1) [self showMessageShare];
    if(buttonIndex == 2) [self showTwitterShare];
    if(buttonIndex == 3) [self showFacebookShare];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger nTotal = [self.categoryList count];
    
    if(self.privacy_expended) nTotal ++;
    
    return nTotal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    // Configure the cell...
    // Get each single event.
    if(indexPath.row == 5 && self.privacy_expended){
        cell = [tableView dequeueReusableCellWithIdentifier:@"idPrivacyCell" forIndexPath:indexPath];

        UISwitch *privacySwitch = (UISwitch *)[cell.contentView viewWithTag:1];
        
        PFUser *currentUser = [PFUser currentUser];
        
        BOOL privacy_flag = [[currentUser valueForKey:kpPrivacy] boolValue];
        
        if(privacy_flag) privacySwitch.on = YES; else privacySwitch.on = NO;
        
        [privacySwitch addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    NSInteger nRow = indexPath.row;
    
    if(self.privacy_expended && nRow > 5) nRow --;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"idGeneralCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.categoryList objectAtIndex:nRow];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger nRow = indexPath.row;
    
    if (nRow == 5 && self.privacy_expended) return;
    
    if(nRow > 5 && self.privacy_expended) nRow --;
    
    switch (nRow) {
        case 0:
            //My Profile
            [self performSegueWithIdentifier:@"idSegueMyProfile" sender:self];
            break;
            
        case 1:
        case 5:
            // About or Privacy Policy and Terms
            self.nHelpMode = nRow;
            [self performSegueWithIdentifier:@"idSegueHelp" sender:self];
            break;
            
        case 2:
            //For Tell a Friend
            [self showShareList];
            break;
            
        case 3:
            //Change Password
            [self performSegueWithIdentifier:@"idSegueChangePassword" sender:self];
            break;
            
        case 4:
            // On/Off Privacy
            self.privacy_expended = !self.privacy_expended;
            
            [tableView beginUpdates];
            
            if(self.privacy_expended){
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }else{
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }
            
            [tableView endUpdates];
            break;

        case 6:
            //Deactive Accounts
            [self alertDeactivate];
            break;
            
        case 7:
            //Logout
            [self alertLogout];            
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"idSegueHelp"]){
        PrivacyTermsViewController *target = [segue destinationViewController];
        
        if(self.nHelpMode == 1) target.nMode = 0; else target.nMode = 1;
    }
}

@end
