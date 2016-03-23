//
//  RegisterViewController.m
//  Barfliz
//
//  Created by User on 11/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "ActivityView.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;

@property AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *ID;
@end

@implementation RegisterViewController
- (IBAction)PushEmailButton:(id)sender {
    NSString *strRegistered = [[NSUserDefaults standardUserDefaults] objectForKey:@"registered"];
    
    if(strRegistered == nil || strRegistered.length == 0){
        [self performSegueWithIdentifier:@"ToEmailValidFromReg" sender:self];
    }else{
        [AppDelegate message:@"This information is already linked to an existing account."];
    }
    
    
}
- (IBAction)PushPhoneButton:(id)sender {
    
    NSString *strRegistered = [[NSUserDefaults standardUserDefaults] objectForKey:@"registered"];
    
    if(strRegistered == nil || strRegistered.length == 0){
        [self performSegueWithIdentifier:@"ToPhoneValidFromReg" sender:self];
    }else{
        [AppDelegate message:@"This information is already linked to an existing account."];
    }
}

- (IBAction)PushTwitterButton:(id)sender {
    NSString *strRegistered = [[NSUserDefaults standardUserDefaults] objectForKey:@"registered"];
    
    if(strRegistered == nil || strRegistered.length == 0){
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            if(!success)
            {
                [AppDelegate message:@"Login failed! Please try agin."];
                return;
            }
            
            NSString *strID = FHSTwitterEngine.sharedEngine.authenticatedID;
            self.token = strID;
            
            ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
            UILabel *label = activityView.label;
            label.text = @"Registering with Twitter";
            label.font = [UIFont boldSystemFontOfSize:20.f];
            [activityView.activityIndicator startAnimating];
            [activityView layoutSubviews];
            
            PFQuery *twitterQuery= [PFUser query];
            [twitterQuery whereKey:kpTwitter equalTo:strID];
            
            [twitterQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                
                if (error) {
                    if(error.code == 101){
                        [self performSegueWithIdentifier:@"ToProfileFromTwitter" sender:self];
                    }else{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                            message:nil
                                                                           delegate:self
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"OK", nil];
                        [alertView show];
                        [activityView.activityIndicator stopAnimating];
                        [activityView removeFromSuperview];
                    }
                    
                    // Bring the keyboard back up, because they'll probably need to change something.
                    return;
                }
                
                [activityView.activityIndicator stopAnimating];
                [activityView removeFromSuperview];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You are already registered with twitter"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                
                [alertView show];
                
            }];
            
        }];
        [self presentViewController:loginController animated:YES completion:nil];

    }else{
        [AppDelegate message:@"This information is already linked to an existing account."];
    }
}


- (IBAction)PushFacebookButton:(id)sender {
    
    NSString *strRegistered = [[NSUserDefaults standardUserDefaults] objectForKey:@"registered"];
    
    if(strRegistered == nil || strRegistered.length == 0){
        AppDelegate* delegate = [AppDelegate appDelegate];
        delegate.fbDelegate = self;
        
        [delegate openSession];
    }else{
        [AppDelegate message:@"This information is already linked to an existing account."];
    }
}


- (void)loadView {
    [super loadView];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"RzkGrW55GQcCLD2Hp1pmkTaON" andSecret:@"W6i4aeSxrqzkxIxr62pb4EQAjfxSceif03lXsdaPLOjEXGH4Hk"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}



- (void)fbDidLoginSuccess:(NSString*)fbUserID token:(NSString*)fbUserToken
{
    self.token = fbUserToken;
    self.ID    = fbUserID;
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Registering with Facebook";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    PFQuery *facebookQuery= [PFUser query];
    
    [facebookQuery whereKey:kpFacebookID    equalTo:fbUserID];
    [facebookQuery whereKey:kpFacebookToken equalTo:fbUserToken];
    
    [facebookQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (error) {
            if(error.code == 101){
                [self performSegueWithIdentifier:@"ToProfileFromFacebook" sender:self];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                [activityView.activityIndicator stopAnimating];
                [activityView removeFromSuperview];
            }
            
            // Bring the keyboard back up, because they'll probably need to change something.
            return;
        }
        
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You are already registered with facebook"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        
    }];
}

- (void)fbDidLoginFailedWithError:(NSError*)error
{
//    [self showLoadingView:NO];
    
    
    [AppDelegate message:@"Fail"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self setBorderRadiusForButton];
}

-(void) setBorderRadiusForButton {
    self.btnEmail.layer.cornerRadius = 10;
    self.btnEmail.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.btnPhoneNumber.layer.cornerRadius = 10;
    self.btnPhoneNumber.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.btnFacebook.layer.cornerRadius = 10;
    self.btnFacebook.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.btnTwitter.layer.cornerRadius = 10;
    self.btnTwitter.layer.borderColor = [[UIColor blackColor] CGColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - TwitterDelegate

- (NSString *)loadAccessToken{
    return self.appDelegate.twitterToken;
}

- (void)storeAccessToken:(NSString *)accessToken{
    self.appDelegate.twitterToken = accessToken;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"ToEmailValidFromReg"] || [segue.identifier isEqualToString:@"ToPhoneValidFromReg"]) return;

    ProfileViewController *targetController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"ToProfileFromInstagram"]){
        targetController.nMode = 4;
        targetController.instagram = self.token;
    }else if([segue.identifier isEqualToString:@"ToProfileFromFacebook"]){
        targetController.nMode = 2;
        targetController.fbToken = self.token;
        targetController.fbID = self.ID;
    }else{
        targetController.nMode = 3;
        targetController.twitter = self.token;
    }
}


@end
