//
//  PhoneValidationViewController.m
//  Barfliz
//
//  Created by User on 11/6/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "PhoneValidationViewController.h"
#import "ProfileViewController.h"

@interface PhoneValidationViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtCode;

@end

@implementation PhoneValidationViewController
- (IBAction)PushProfileButton:(id)sender {
    
    NSString *strCode = _txtCode.text;
    
    if([strCode isEqualToString:@""]) return;
    
    if(![strCode isEqualToString:self.code]){
        [self message:@"Your code is incorrect"];
        return;
    }
    
    [self performSegueWithIdentifier:@"ToProfilePhone" sender:self];

}

- (void) message:(NSString*)content{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                      message:content
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtCode.delegate = self;
    
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
    
    if(textField == self.txtCode){
        [self.txtCode resignFirstResponder];
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
    if ([segue.identifier isEqualToString:@"ToProfilePhone"]) {
        ProfileViewController *targetController = [segue destinationViewController];
        targetController.nMode = 1;
        targetController.phone = self.number;
    }
}


@end
