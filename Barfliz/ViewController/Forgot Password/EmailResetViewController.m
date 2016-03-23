//
//  EmailResetViewController.m
//  Barfliz
//
//  Created by User on 12/21/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "EmailResetViewController.h"
#import "ValidationResetViewController.h"
#import "ActivityView.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface EmailResetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) NSString *strEmail;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) PFUser *pfUser;
@end

@implementation EmailResetViewController
- (IBAction)btnDonePressed:(id)sender {
    NSString *strEmail = self.emailTextField.text;
    
    if(strEmail.length == 0) {
        
        [AppDelegate message:@"There is no email address. please enter the email address."];
        return;
    }
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Submiting";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    PFQuery *emailQuery= [PFUser query];
    [emailQuery whereKey:@"email" equalTo:strEmail];
    
    [emailQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
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
            [self.emailTextField becomeFirstResponder];
            return;
        }
        
        
        
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/new_signup.php?mode=email&email=%@",strEmail];
        
        NSURL *url = [NSURL URLWithString:strURL];
        
        
        NSError * errorOther = nil;
        NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&errorOther];
        
        
        NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        if(errorOther != nil)
        {
            [AppDelegate message:@"Can not access the server!"];
            return;
        }
        
        if([strResponse isEqualToString:@"fail"])
        {
            [AppDelegate message:@"Registration failed, please try it."];
            return;
        }
        
        self.code = strResponse;
        self.pfUser = (PFUser *)object;
        
        [self performSegueWithIdentifier:@"idSegueVerificationInReset" sender:self];
        
    }];
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
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
    
    if([segue.identifier isEqualToString:@"idSegueVerificationInReset"]){
        ValidationResetViewController *targetController = (ValidationResetViewController *)segue.destinationViewController;
        targetController.code = self.code;
        targetController.pfUser = self.pfUser;
    }
}


@end
