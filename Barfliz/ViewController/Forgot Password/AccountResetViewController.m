//
//  AccountResetViewController.m
//  Barfliz
//
//  Created by User on 12/22/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "AccountResetViewController.h"
#import "AppDelegate.h"
#import "ActivityView.h"
#import "MainTabBarController.h"

@interface AccountResetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@end

@implementation AccountResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    
    if (textField == self.passwordTextField) {
        [self.confirmTextField becomeFirstResponder];
    }
    
    if (textField == self.confirmTextField) {
        [self.confirmTextField resignFirstResponder];
        [self dismissKeyboard];
        [self processFieldEntries];
    }
    
    return YES;
}


- (void)processFieldEntries {
    // Check that we have a non-zero username and passwords.
    // Compare password and passwordAgain for equality
    // Throw up a dialog that tells them what they did wrong if they did it wrong.
    
    NSString *username = self.usernameTextField.text;
//    NSString *emailAddress = self.EmailTextField.text;
//    NSString *biography = self.BiographyTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *passwordAgain = self.confirmTextField.text;
    
    NSString *errorText = @"Please ";
    NSString *usernameBlankText = @"enter a username";
    NSString *passwordBlankText = @"enter a password";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (passwordAgain.length == 0) {
            [self.confirmTextField becomeFirstResponder];
        }
        if (password.length == 0) {
            [self.passwordTextField becomeFirstResponder];
        }
        if (username.length == 0) {
            [self.usernameTextField becomeFirstResponder];
        }
        
        if (username.length == 0) {
            errorText = [errorText stringByAppendingString:usernameBlankText];
        }
        
        if (password.length == 0 || passwordAgain.length == 0) {
            if (username.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame) {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.passwordTextField becomeFirstResponder];
    }
    
    if (textError) {
        [AppDelegate message:errorText];
        return;
    }
    
    // Everything looks good; try to log in.
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    
    UILabel *label = activityView.label;
    
    label.text = @"Reset";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    [self.view addSubview:activityView];
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.
    
    PFUser *currentUser = [PFUser currentUser];
    
    currentUser.password = password;
    [currentUser setObject:password forKey:@"psw"];
    currentUser.username = username;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            
            [AppDelegate message:[error userInfo][@"error"]];
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
            
            // Bring the keyboard back up, because they'll probably need to change something.
            
            [self.passwordTextField becomeFirstResponder];
            
            return;
        }
        
        // Success!
        
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.password forKey:@"password"];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
        MainTabBarController * tabController = (MainTabBarController *)[storyboard instantiateViewControllerWithIdentifier:mainTab_scene];
        tabController.selectedIndex = 1;
        [self.navigationController pushViewController:tabController animated:YES];
        
    }];
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
