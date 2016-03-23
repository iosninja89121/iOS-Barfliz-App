//
//  MainPushMessageViewController.m
//  Barfliz
//
//  Created by User on 12/21/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "MainPushMessageViewController.h"
#import "EditEventViewController.h"
#import "AppDelegate.h"
#import "ActivityView.h"
#import "AnotherProfileViewController.h"
#import <Parse/Parse.h>

@interface MainPushMessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSenderName;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageContent;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblCanlendarInfo;
@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) NSString *strFromUserName;
@property (nonatomic, strong) NSString *locationUrl;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UIButton *btnViewProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnMaybe;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

@end

@implementation MainPushMessageViewController

- (IBAction)btnMoreInfoPressed:(id)sender {
    if(self.strLocationID.length == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"There is no location Info."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.locationUrl]];
}

- (IBAction)btnAddCalendarPressed:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
    
    EditEventViewController * controller = (EditEventViewController *)[storyboard instantiateViewControllerWithIdentifier:mainCalendarScene];
    
    controller.mode = 1;
    controller.strDate = self.strCalendarInfo;
    controller.strLocationInfo = self.strLocationTitle;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnAttendYesPressed:(id)sender {
    [self pushMessage:@"yes"];
}

- (IBAction)btnAttedMaybePressed:(id)sender {
    [self pushMessage:@"maybe"];
}

- (IBAction)btnAttendNoPressed:(id)sender {
    [self pushMessage:@"no"];
}

- (void) pushMessage:(NSString *) strRelpy{
    PFQuery *query = [PFInstallation query];
    
    // only return Installations that belong to a User that
    // matches the innerQuery
    
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"user" containedIn:@[self.fromUser]];
    //    [query whereKey:@"user" equalTo:self.testUser];
    
    NSString *strAlert = [NSString stringWithFormat:@"%@-%@", [currentUser valueForKey:kpRealUsername], strRelpy];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          strAlert, @"alert",
                          @"cheering.caf", @"sound",
                          @"no",           @"reply_mode",
//                          @"zhs",          @"action", 
                          nil];
    
    
    // Send the notification.
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setData:data];
    //    [push setMessage:self.strContent];
    [push sendPushInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];

    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:self.strReceiverID];
    
    NSArray *wtf = [query findObjects];
    
    self.fromUser = [wtf objectAtIndex:0];
    
    self.strFromUserName = [self.fromUser valueForKey:kpRealUsername];
    self.locationUrl = [NSString stringWithFormat:@"http://m.yelp.com/biz/%@", self.strLocationID];
    
    self.lblSenderName.text = self.strFromUserName;
    self.lblMessageContent.text = self.strMessageContnet;
    self.lblLocationInfo.text = self.strLocationTitle;
    self.lblCanlendarInfo.text = self.strCalendarInfo;
    
    [self setBorderRadiusForButton];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) setBorderRadiusForButton {
    self.btnLocation.layer.cornerRadius = 10;
    self.btnLocation.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnLocation.layer.borderWidth=1.0f;
    
    self.btnCalendar.layer.cornerRadius = 10;
    self.btnCalendar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnCalendar.layer.borderWidth=1.0f;
    
    self.btnViewProfile.layer.cornerRadius = 10;
    self.btnViewProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnViewProfile.layer.borderWidth=1.0f;
    
    self.btnYes.layer.cornerRadius = 10;
    self.btnYes.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnYes.layer.borderWidth=1.0f;
    
    self.btnNo.layer.cornerRadius = 10;
    self.btnNo.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnNo.layer.borderWidth=1.0f;
    
    self.btnMaybe.layer.cornerRadius = 10;
    self.btnMaybe.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnMaybe.layer.borderWidth=1.0f;
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
    
    if([segue.identifier isEqualToString:@"idSegueAnotherProfile"]){
        AnotherProfileViewController *targetCtrl = (AnotherProfileViewController*)segue.destinationViewController;
        targetCtrl.anotherUser = self.fromUser;
    }
}


@end
