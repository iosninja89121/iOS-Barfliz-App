//
//  ValidationResetViewController.m
//  Barfliz
//
//  Created by User on 12/21/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ValidationResetViewController.h"
#import "AppDelegate.h"
#import "ActivityView.h"
#import <Parse/Parse.h>

@interface ValidationResetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

@end

@implementation ValidationResetViewController
- (IBAction)btnDonePressed:(id)sender {
    NSString *strCode = [self.verificationCodeTextField text];
    
    if(strCode.length == 0){
        [AppDelegate message:@"There is no verification code, please enter it."];
        return;
    }
    
    if(![strCode isEqualToString:self.code]) {
        [AppDelegate message:@"Verification code is not correct, please enter again."];
        return;
    }
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Verification";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    NSString *strUsername = self.pfUser.username;
    NSString *strPassword = [self.pfUser valueForKey:@"psw"];
    
    [PFUser logInWithUsernameInBackground:strUsername password:strPassword block:^(PFUser *user, NSError *error){
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        if(error){
            [AppDelegate message:@"Getting Account Info faield."];
            return;
        }
        [self performSegueWithIdentifier:@"idSegueAccountInfoInReset" sender:self];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
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
