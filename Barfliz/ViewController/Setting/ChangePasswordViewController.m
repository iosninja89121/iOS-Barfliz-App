//
//  ChangePasswordViewController.m
//  Barfliz
//
//  Created by User on 12/18/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ActivityView.h"
#import <Parse/Parse.h>

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ChangePasswordViewController
- (IBAction)btnChangePasswordPressed:(id)sender {
    [self processFieldEntries];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtOldPassword.delegate = self;
    self.txtNewPassword.delegate = self;
    self.txtConfirmPassword.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                               action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtOldPassword) {
        [self.txtNewPassword becomeFirstResponder];
    }
    
    if(textField == self.txtNewPassword){
        [self.txtConfirmPassword becomeFirstResponder];
    }
    
    if (textField == self.txtConfirmPassword) {
        [self.txtConfirmPassword resignFirstResponder];
        [self processFieldEntries];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Sign Up

- (void)processFieldEntries {
    
    // Check that we have a non-zero username and passwords.
    
    // Compare password and passwordAgain for equality
    
    // Throw up a dialog that tells them what they did wrong if they did it wrong.
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *realOldPassword = [currentUser valueForKey:@"psw"];
    
    NSString *oldPassword     = self.txtOldPassword.text;
    NSString *newPassord      = self.txtNewPassword.text;
    NSString *confirmPassword = self.txtConfirmPassword.text;
    
    NSString *errorText = @"Please ";
    NSString *oldPasswordBlankText = @"enter a old password";
    NSString *newPasswordBlankText = @"enter a new password";
    NSString *joinText = @", and ";
    NSString *newPasswordMismatchText = @"enter the same password twice";
    NSString *oldPasswordMismatchText = @"enter the coreect old password";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    
    if (oldPassword.length == 0 || newPassord.length == 0 || confirmPassword.length == 0) {
        
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        
        if (confirmPassword.length == 0) {
            [self.txtConfirmPassword becomeFirstResponder];
        }
        
        if (newPassord.length == 0) {
            [self.txtNewPassword becomeFirstResponder];
        }
        
        if (oldPassword.length == 0) {
            [self.txtOldPassword becomeFirstResponder];
        }
        
        if (oldPassword.length == 0) {
            errorText = [errorText stringByAppendingString:oldPasswordBlankText];
        }
        
        if (newPassord.length == 0 || confirmPassword.length == 0) {
            
            if (oldPassword.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            
            errorText = [errorText stringByAppendingString:newPasswordBlankText];
        }
    }else if ([oldPassword compare:realOldPassword] != NSOrderedSame){
        textError = YES;
        errorText = [errorText stringByAppendingString:oldPasswordMismatchText];
        
        [self.txtOldPassword becomeFirstResponder];
        
    }else if ([newPassord compare:confirmPassword] != NSOrderedSame) {
        
        // We have non-zero strings.
        // Check for equal password strings.
        
        textError = YES;
        errorText = [errorText stringByAppendingString:newPasswordMismatchText];
        
        [self.txtNewPassword becomeFirstResponder];
    }
    
    if (textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
        return;
    }
    
    // Everything looks good; try to log in.
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    
    UILabel *label = activityView.label;
    
    label.text = @"Changing Password";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    [self.view addSubview:activityView];
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.
    
    currentUser.password = newPassord;
    [currentUser setObject:newPassord forKey:@"psw"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
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
            
            [self.txtNewPassword becomeFirstResponder];
            
            return;
        }
        
        // Success!
        
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.password forKey:@"password"];
        
        [self performSegueWithIdentifier:@"idSegueSettingFromChangePassword" sender:self];
        
    }];

}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat scrollViewOffsetY = (keyboardFrame.size.height -
                                 (CGRectGetHeight(self.view.bounds) -
                                  CGRectGetMaxY(self.btnChangePassword.frame)));
    // Check if scrolling needed
    if (scrollViewOffsetY < 0) {
        return;
    }
    
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointMake(0.0f, scrollViewOffsetY) animated:NO];
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
//    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointZero animated:NO];
                     }
                     completion:nil];
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
