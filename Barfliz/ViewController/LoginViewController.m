//
//  LoginViewController.m
//  Barfliz
//
//  Created by User on 11/9/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "LoginViewController.h"
#import "ActivityView.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <Parse/Parse.h>


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblWarning;
@property AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextField *txtUserID;
@property (weak, nonatomic) IBOutlet UITextField *txtPSW;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;


@end

@implementation LoginViewController


- (IBAction)PushTwitterButton:(id)sender {
    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
        if(!success)
        {
            [AppDelegate message:@"Login failed! Please try agin."];
            return;
        }
        
        NSString *strID = FHSTwitterEngine.sharedEngine.authenticatedID;
        
        
        ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
        UILabel *label = activityView.label;
        label.text = @"Login";
        label.font = [UIFont boldSystemFontOfSize:20.f];
        [activityView.activityIndicator startAnimating];
        [activityView layoutSubviews];
        
        [self.view addSubview:activityView];
        
        PFQuery *twitterQuery= [PFUser query];
        [twitterQuery whereKey:kpTwitter equalTo:strID];
        
        [twitterQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
            
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
                [self.txtUserID becomeFirstResponder];
                return;
            }
            
//            [activityView.activityIndicator stopAnimating];
//            [activityView removeFromSuperview];
            
            NSString *objectId = [object objectForKey:@"objectId"];
            NSString *username_new = [object objectForKey:@"username"];
            NSString *password = [object objectForKey:@"psw"];
            
            [PFUser logInWithUsernameInBackground:username_new password:password block:^(PFUser *user, NSError *error){
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"OK", nil];
                    [alertView show];
                    [activityView.activityIndicator stopAnimating];
                    [activityView removeFromSuperview];
                    // Bring the keyboard back up, because they'll probably need to change something.
                    
                    [self.txtUserID becomeFirstResponder];
                    return;
                }else{
                    
                    [activityView.activityIndicator stopAnimating];
                    [activityView removeFromSuperview];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:username_new forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                    
                    self.appDelegate.objectId = objectId;
                    
                    PFInstallation *installation = [PFInstallation currentInstallation];
                    installation[@"user"] = user;
                    
                    [installation saveInBackground];
                    
                    [self performSegueWithIdentifier:@"ToMainPage" sender:self];
                }
            }];
            
        }];

        
    }];
    [self presentViewController:loginController animated:YES completion:nil];
}

- (IBAction)PushFacebookButton:(id)sender {
    AppDelegate* delegate = [AppDelegate appDelegate];
    delegate.fbDelegate = self;
    
    [delegate openSession];
}

- (IBAction)PushDoneButton:(id)sender {
    NSString* strUserID = _txtUserID.text.lowercaseString;
    NSString* strPSW = _txtPSW.text;
    
    if([strUserID isEqualToString:@""] || [strPSW isEqualToString:@""]) return;

    [self processFieldEntries];
    
    
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtUserID) {
        [self.txtPSW becomeFirstResponder];
    }
    if (textField == self.txtPSW) {
        [self.txtPSW resignFirstResponder];
        [self processFieldEntries];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Private

#pragma mark Field validation

- (void)processFieldEntries {
    // Get the username text, store it in the app delegate for now
    NSString *username = self.txtUserID.text;
    NSString *password = self.txtPSW.text;
    NSString *noUsernameText = @"username or email";
    NSString *noPasswordText = @"password";
    NSString *errorText = @"No ";
    NSString *errorTextJoin = @" or ";
    NSString *errorTextEnding = @" entered";
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (password.length == 0) {
            [self.txtPSW becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.txtUserID becomeFirstResponder];
        }
    }
    
    if ([username length] == 0) {
        textError = YES;
        errorText = [errorText stringByAppendingString:noUsernameText];
    }
    
    if ([password length] == 0) {
        textError = YES;
        if ([username length] == 0) {
            errorText = [errorText stringByAppendingString:errorTextJoin];
        }
        errorText = [errorText stringByAppendingString:noPasswordText];
    }
    
    if (textError) {
        errorText = [errorText stringByAppendingString:errorTextEnding];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    // Everything looks good; try to log in.
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Login";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    PFQuery *usernameQuery= [PFUser query];
    [usernameQuery whereKey:@"username" equalTo:username];
    
    PFQuery *emailQuery= [PFUser query];
    [usernameQuery whereKey:@"email" equalTo:username];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[usernameQuery,emailQuery]];
    [query whereKey:@"psw" equalTo:password];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
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
            
            [self.txtUserID becomeFirstResponder];
            return;
        }
        
        NSString *objectId = [object objectForKey:@"objectId"];
        NSString *username_new = [object objectForKey:@"username"];
        
        [PFUser logInWithUsernameInBackground:username_new password:password block:^(PFUser *user, NSError *error){
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                [activityView.activityIndicator stopAnimating];
                [activityView removeFromSuperview];
                // Bring the keyboard back up, because they'll probably need to change something.
                
                [self.txtUserID becomeFirstResponder];
                return;
            }else{
                
                [activityView.activityIndicator stopAnimating];
                [activityView removeFromSuperview];
                
                [[NSUserDefaults standardUserDefaults] setObject:username_new forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                
                self.appDelegate.objectId = objectId;
                
                PFInstallation *installation = [PFInstallation currentInstallation];
                installation[@"user"] = user;
                
                [installation saveInBackground];
                
                [self performSegueWithIdentifier:@"ToMainPage" sender:self];
            }
        }];
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) setBorderRadiusForButton {
    self.btnFacebook.layer.cornerRadius = 10;
    self.btnFacebook.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.btnTwitter.layer.cornerRadius = 10;
    self.btnTwitter.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lblWarning.text = @"";
   
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.txtUserID.delegate = self;
    self.txtPSW.delegate = self;
    
    [self setBorderRadiusForButton];
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fbDidLoginSuccess:(NSString*)fbUserID token:(NSString*)fbUserToken
{
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Login";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    PFQuery *facebookQuery= [PFUser query];
    [facebookQuery whereKey:kpFacebookToken equalTo:fbUserToken];
    
    [facebookQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
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
            [self.txtUserID becomeFirstResponder];
            return;
        }
        
//        [activityView.activityIndicator stopAnimating];
//        [activityView removeFromSuperview];
        
        NSString *objectId = [object objectForKey:@"objectId"];
        NSString *username_new = [object objectForKey:@"username"];
        NSString *password = [object objectForKey:@"psw"];
        
        [PFUser logInWithUsernameInBackground:username_new password:password block:^(PFUser *user, NSError *error){
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                [alertView show];
                [activityView.activityIndicator stopAnimating];
                [activityView removeFromSuperview];
                // Bring the keyboard back up, because they'll probably need to change something.
                
                [self.txtUserID becomeFirstResponder];
                return;
            }else{
                
                [activityView.activityIndicator stopAnimating];
                [activityView removeFromSuperview];
                
                [[NSUserDefaults standardUserDefaults] setObject:username_new forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                
                self.appDelegate.objectId = objectId;
                
                PFInstallation *installation = [PFInstallation currentInstallation];
                installation[@"user"] = user;
                
                [installation saveInBackground];
                
                [self performSegueWithIdentifier:@"ToMainPage" sender:self];
            }
        }];
        
    }];
}

- (void)fbDidLoginFailedWithError:(NSError*)error
{
    //    [self showLoadingView:NO];
    
    
    [AppDelegate message:@"Fail"];
}

- (void)loadView {
    [super loadView];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"RzkGrW55GQcCLD2Hp1pmkTaON" andSecret:@"W6i4aeSxrqzkxIxr62pb4EQAjfxSceif03lXsdaPLOjEXGH4Hk"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ToMainPage"]) {
        [(MainTabBarController*)segue.destinationViewController setSelectedIndex:1];
    }
}


#pragma - TwitterDelegate

- (NSString *)loadAccessToken{
    return self.appDelegate.twitterToken;
}

- (void)storeAccessToken:(NSString *)accessToken{
    self.appDelegate.twitterToken = accessToken;
}



@end
