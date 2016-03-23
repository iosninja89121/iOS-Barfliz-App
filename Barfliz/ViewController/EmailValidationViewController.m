//
//  EmailValidationViewController.m
//  Barfliz
//
//  Created by User on 11/4/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "EmailValidationViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface EmailValidationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeText;

@end

@implementation EmailValidationViewController

- (IBAction)pushProfile:(id)sender {
    NSString *strCode = _codeText.text;
    
    if([strCode isEqualToString:@""]) return;
    /*
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *currentDeviceId = [[device identifierForVendor] UUIDString];
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/signup.php?mode=email&step=1&device_id=%@&code=%@", currentDeviceId, strCode];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    //    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    //    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    
    NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can not access the server!"];
        return;
    }
    
    if(![strResponse isEqualToString:@"success"])
    {
        [AppDelegate message:@"Registration failed, please try it."];
        return;
    }
     
     */
    
    if(![self.code isEqualToString:strCode])
    {
        [AppDelegate message:@"Please "];
        return;
    }
    
     [self performSegueWithIdentifier:@"ToProfile" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.codeText.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                               action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.codeText) {
        [self.codeText resignFirstResponder];
        [self dismissKeyboard];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ToProfile"]) {
        ProfileViewController *targetController = [segue destinationViewController];
        targetController.nMode = 0;
        targetController.emailAddress = self.emailAddress;
    }
}


@end
