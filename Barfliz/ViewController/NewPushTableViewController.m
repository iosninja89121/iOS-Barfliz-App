//
//  NewPushTableViewController.m
//  Barfliz
//
//  Created by User on 11/11/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "NewPushTableViewController.h"
#import "AppDelegate.h"
#import "ContactListTableViewController.h"
#import "LocationTableViewController.h"
#import "YelpListing.h"
#import "FriendInfo.h"
#import "FindBarFlizViewController.h"
#import "MainPushMessageViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EditEventViewController.h"


@interface NewPushTableViewController ()

@property YelpListing *yelpListItem;
@property AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *userName;
@property UIButton *locationTextButton;
@property UIButton *calendarTextButton;
@end

@implementation NewPushTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"10");
    [super viewWillAppear:animated];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"logo.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"11");
    [super viewDidAppear:animated];
    
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"logo.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"5");
    self.appDelegate = [AppDelegate appDelegate];
    
//    [self.appDelegate.contactsManager getContactsList];
    
    self.receiverList = [[NSMutableArray alloc] init];
    
    self.strLocation = @"";
    self.strContent = @"";
    
    self.location_expended = NO;
    self.calendar_expended = NO;
    
    self.strMsg = @"";
    
//    NSDate *today = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"cccc/MMM/d, hh:mm aa"];
//    self.strDate = [dateFormat stringFromDate:today];
    
    NSLog(@"6");
    self.yelpListItem = [[YelpListing alloc] init];
    
    NSLog(@"7");
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"logo.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
//    [[PFUser currentUser] fetch];
    
    NSLog(@"8");
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSLog(@"9");
    
    self.userName = [currentUser valueForKey:kpRealUsername];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)message{
    [AppDelegate message:@"OK"];
}

//From Contacts List to New Push Tab
- (IBAction)unwindToNewPushFromContactsList:(UIStoryboardSegue *)unwindSegue{
    [self.tableView reloadData];
}

//From Calendar to New Push Tab
- (IBAction)unwindToNewPushFromCalendar:(UIStoryboardSegue *)unwindSegue{
    if(self.appDelegate.eventManager.currentEvent == nil) {
        [self.calendarTextButton setTitle: @"" forState: UIControlStateNormal];
//        self.calendarTextButton.titleLabel.text = @"";
    }else{
        NSString *strDate = [self.appDelegate.eventManager getStringFromDate:self.appDelegate.eventManager.currentEvent.startDate];
        [self.calendarTextButton setTitle:strDate forState:UIControlStateNormal];
//        self.calendarTextButton.titleLabel.text = [self.appDelegate.eventManager getStringFromDate:self.appDelegate.eventManager.currentEvent.startDate];
    }
    
//    [self.tableView reloadData];
}

// From Location to New Push Tab
- (IBAction)unwindToNewPushFromLocation:(UIStoryboardSegue *)unwindSegue{
    LocationTableViewController *source = [unwindSegue sourceViewController];
    
    YelpListing *yelpItem = source.tappedItem;
    
    self.strLocation = yelpItem.id_str;
    
    [self.locationTextButton setTitle:yelpItem.title forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}


// When clicking the remove button for specified one of contact list
- (void) btnRemoveClicked:(id) sender{
    UIButton *temp = (UIButton*) sender;
    NSInteger nRow = [temp.accessibilityHint integerValue];
    [self.receiverList removeObjectAtIndex:nRow];
    
//    [self.tableView  beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 2 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView endUpdates];
    [self.tableView reloadData];
}

//When clicking the Yes button for Location
- (void) btnYesForLocationClicked{
    [self performSegueWithIdentifier:@"ToLocation" sender:self];
}

//When clicking the No button for Location
- (void) btnNoForLocationClicked:(id) sender{
    [self.locationTextButton setTitle:@"" forState:UIControlStateNormal];
    
    self.location_expended = NO;
    UIButton *temp = (UIButton*) sender;
    NSInteger nRow = [temp.accessibilityHint integerValue];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

//When clicking the Yes button for Calendar
- (void) btnYesForCalendarClicked{
    [self performSegueWithIdentifier:@"idSegueTotalCalendarAPI" sender:self];
}

//When clicking the No button for Calendar
- (void) btnNoForCalendarClicked:(id) sender{
    [self.calendarTextButton setTitle:@"" forState:UIControlStateNormal];
    
    self.calendar_expended = NO;
    UIButton *temp = (UIButton*) sender;
    NSInteger nRow = [temp.accessibilityHint integerValue];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

//When clicking the Send Push button
- (void) btnSendPushClicked{
    
    if([self.receiverList count] == 0)
    {
        [AppDelegate message:@"There is no recipient."];
        return;
    }
    
    if([self.strContent length] == 0)
    {
        [AppDelegate message:@"There is no content"];
        return;
    }
    
    
    // Build the actual push notification target query
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    [query whereKey:@"user" containedIn:self.receiverList];

    
    PFUser *currentUser = [PFUser currentUser];
    NSString *objId = currentUser.objectId;
    
    NSString *locationName = [[self.locationTextButton titleLabel] text];
    NSString *timeName = [[self.calendarTextButton titleLabel] text];
    
    if(locationName == nil) locationName = @"";
    if(timeName == nil) timeName = @"";
    
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.strContent, @"alert",
                          @"cheering.caf", @"sound",
                          timeName,          @"time_name",
                          self.strLocation, @"location",
                          objId,           @"from",
                          @"yes",           @"reply_mode",
                          locationName,      @"location_name",
//                          @"zhs",          @"action", 
                          nil];
   
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setData:data];
//    [push setMessage:self.strContent];
    [push sendPushInBackground];
//    [self simulate_receive_push];
    [self initPushDashboard];
}

- (void) simulate_receive_push{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
    
    MainPushMessageViewController * controller = (MainPushMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:mainPushScene];
    
    NSString *locationName = [[self.locationTextButton titleLabel] text];
    NSString *timeName = [[self.calendarTextButton titleLabel] text];
    
    controller.strMessageContnet = self.strContent;
    controller.strLocationID = self.strLocation;
    controller.strLocationTitle = locationName;
    controller.strCalendarInfo = timeName;
    
    PFUser *receiverUser = [self.receiverList objectAtIndex:0];
    
    controller.strReceiverID = receiverUser.objectId;
    
//    [self presentViewController:controller animated:YES completion:nil];
    
        [self.navigationController pushViewController:controller animated:YES];

}

- (void) initPushDashboard{
    SystemSoundID soundID;
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"SentMessage.wav", NULL, NULL);
    AudioServicesCreateSystemSoundID(ref, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Your Push Message has been transfered successfully."
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
    [alertView show];

    
    self.receiverList = [[NSMutableArray alloc] initWithObjects:nil];
    self.location_expended = false;
    self.calendar_expended = false;
    self.strContent = @"";
//    self.countLabel.text = @"40";
    
    [self.calendarTextButton setTitle:@"" forState:UIControlStateNormal];
    [self.locationTextButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.tableView reloadData];

}

//When clicking the Add Barfliz cell
- (void) cellAddBarflizClicked{
    [self performSegueWithIdentifier:@"ToChooseCategory" sender:self];
}

#pragma TextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
//    NSInteger u = 40 - textView.text.length;
//    if(u > -1)
//    {
//        self.countLabel.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)u];
//    }
    
    self.strContent = textView.text;
    
    NSString *entireText = textView.text;
    
    if(entireText.length > 40)
    {
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:entireText];
        
        NSRange myRange = NSMakeRange(40, entireText.length - 40);
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:myRange];
//        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Didot-Bold" size:18] range:myRange];
        
        [self.msgTextView setAttributedText:string];
        [self.msgTextView setFont:[UIFont systemFontOfSize:18]];
    }
}


#pragma mark - Table view data source

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger nRow = [indexPath row];
    
    if(nRow == 1)
    {
        [self cellAddBarflizClicked];
        return nil;
    }
    
    NSInteger nList = [self.receiverList count];
    
    //cell for Location Header
    if(nRow == nList + 4){
        self.location_expended = !self.location_expended;
        
        [self.tableView beginUpdates];
        
        if(self.location_expended){
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        [self.tableView endUpdates];
        
        if(self.location_expended){
            NSIndexPath *indexPath_bottom = [NSIndexPath indexPathForRow:nRow + 3 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath_bottom atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        return nil;
    }
    
    NSInteger p = nList + 4;
    
    if(self.location_expended) p ++;
    
    //cell for Calendar Header
    if(nRow == p + 1)
    {
        self.calendar_expended = !self.calendar_expended;
        
        [self.tableView beginUpdates];
        
        if(self.calendar_expended){
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }else{
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:nRow + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        [self.tableView endUpdates];
        
        
        if(self.calendar_expended){
            NSIndexPath *indexPath_bottom = [NSIndexPath indexPathForRow:nRow + 2 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath_bottom atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger ans = [self.receiverList count] + 7;
    
    if(self.location_expended) ans ++;
    if(self.calendar_expended) ans ++;
    
    return ans;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger nRow = indexPath.row;
    // cell for User Name
    if(nRow == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserNameCell" forIndexPath:indexPath];
        UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:10];
        lblName.text = self.userName;
        return cell;
    }
    
    //cell for Contact Header
    if(nRow == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendHeaderCell" forIndexPath:indexPath];
        return cell;
    }
    
    // cell for Contact List Item
    NSInteger nList = [self.receiverList count];
    
    if(nRow > 1 && nRow < nList + 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
        
        PFUser *pfUser = [self.receiverList objectAtIndex:nRow - 2];
        
        UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:10];
        lblName.text = [pfUser valueForKey:kpRealUsername];
        
        UIButton *btnRemove = (UIButton *)[cell.contentView viewWithTag:20];
        
        btnRemove.accessibilityHint = [NSString stringWithFormat:@"%ld", nRow - 2];
        
        [btnRemove addTarget:self action:@selector(btnRemoveClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    // cell for Content Header
    if(nRow == nList + 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentHeaderCell" forIndexPath:indexPath];
        return cell;
    }
    
    // cell for Content Item
    if(nRow == nList + 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
//        self.countLabel = (UILabel *)[cell.contentView viewWithTag:10];
        self.msgTextView = (UITextView *)[cell.contentView viewWithTag:20];
        self.msgTextView.delegate = self;
        
        self.msgTextView.text = self.strContent;
        
//        NSInteger u = 40 - self.msgTextView.text.length;
//        self.countLabel.text = [NSString stringWithFormat:@"%ld", u];
        
        return cell;

    }
    
    // cell for Location Header
    if(nRow == nList + 4)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationHeaderCell" forIndexPath:indexPath];
        return cell;
    }
    
    // cell for Location Item
    if(self.location_expended && nRow == nList + 5)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
        
        UIButton *btnYesForLocation = (UIButton *)[cell.contentView viewWithTag:10];
        
        [btnYesForLocation addTarget:self action:@selector(btnYesForLocationClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnNoForLocation = (UIButton *)[cell.contentView viewWithTag:20];
        
        btnNoForLocation.accessibilityHint = [NSString stringWithFormat:@"%ld", nRow];
        
        [btnNoForLocation addTarget:self action:@selector(btnNoForLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.locationTextButton = (UIButton *)[cell.contentView viewWithTag:30];
        return cell;
    }
    
    NSInteger p = nList + 4;
    
    if(self.location_expended) p ++;
    
    //cell for Calendar Header
    if(nRow == p + 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarHeaderCell" forIndexPath:indexPath];
        return cell;
    }
    
    // cell for Calendar Item
    if(self.calendar_expended && nRow == p + 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarCell" forIndexPath:indexPath];
        
        UIButton *btnYesForCalendar = (UIButton *)[cell.contentView viewWithTag:10];
        
        [btnYesForCalendar addTarget:self action:@selector(btnYesForCalendarClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnNoForCalendar = (UIButton *)[cell.contentView viewWithTag:20];
        
        btnNoForCalendar.accessibilityHint = [NSString stringWithFormat:@"%ld", nRow];
        
        [btnNoForCalendar addTarget:self action:@selector(btnNoForCalendarClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.calendarTextButton = (UIButton *)[cell.contentView viewWithTag:30];
        
        return cell;
    }
    
    //cell for send push
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonHeaderCell" forIndexPath:indexPath];
    UIButton *btnSendPush = (UIButton *)[cell.contentView viewWithTag:10];

    btnSendPush.layer.cornerRadius = 10;
    btnSendPush.layer.borderColor = [[UIColor blackColor] CGColor];

    [btnSendPush addTarget:self action:@selector(btnSendPushClicked) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger nRow = indexPath.row;
    
    if(nRow == 0) return 80; //UserName Cell
    if(nRow == 1) return 40; //Friend Header Cell
    
    NSInteger nList = [self.receiverList count];
    
    if(nRow > 1 && nRow < nList + 2) return 60; // Friend Cell
    if(nRow == nList + 2) return 40;   // Content Header Cell
    if(nRow == nList + 3) return 150;   // Content Cell
    if(nRow == nList + 4) return 40;   // Location Header Cell
    if(self.location_expended && nRow == nList + 5) return 80;  // Location Cell
    
    NSInteger p = nList + 4;
    
    if(self.location_expended) p ++;
    
    if(nRow == p + 1) return 40;  //Calendar Header Cell
    if(self.calendar_expended && nRow == p + 2) return 80;  // Calendar Cell
    
    return 60; // Button Header Cell
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"idSegueTotalCalendarAPI"]){
        EditEventViewController *targetController = (EditEventViewController *)segue.destinationViewController;
        targetController.mode = 0;
        
        NSString *locationName = [[self.locationTextButton titleLabel] text];
        
        targetController.strLocationInfo = locationName;
    }
}


@end
