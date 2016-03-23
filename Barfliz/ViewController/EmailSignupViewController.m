//
//  EmailSignupViewController.m
//  Barfliz
//
//  Created by User on 11/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "EmailSignupViewController.h"
#import "EmailValidationViewController.h"
#import "AppDelegate.h"

@interface EmailSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (nonatomic, strong) NSString* code;

@end

@implementation EmailSignupViewController
- (IBAction)pushValidationButton:(id)sender {

    NSString *strEmail = _emailText.text;
    
    if([strEmail isEqualToString:@""]) return;
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/new_signup.php?mode=email&email=%@",strEmail];
    
    NSURL *url = [NSURL URLWithString:strURL];
    

    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    
    NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    if(error != nil)
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
    
    [self performSegueWithIdentifier:@"ToVerification" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailText.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailText) {
        [self.emailText resignFirstResponder];
        [self dismissKeyboard];
    }
    
    return YES;
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
    if ([segue.identifier isEqualToString:@"ToVerification"]) {
        EmailValidationViewController *validController = [segue destinationViewController];
        validController.emailAddress = self.emailText.text;
        validController.code = self.code;
    }
    
}


@end
