//
//  RadiusSettingViewController.m
//  Barfliz
//
//  Created by User on 11/20/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "RadiusSettingViewController.h"
#import "AppDelegate.h"

@interface RadiusSettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;
@property (weak, nonatomic) IBOutlet UITextField *txtRadius;

@property AppDelegate *appDelegate;
@end

@implementation RadiusSettingViewController

- (IBAction)ChangedUnit:(id)sender {
    if(self.segUnit.selectedSegmentIndex == 0){
        self.lblComment.text = @"Max distance away up to 50";
        self.lblUnit.text = @"km";
        self.appDelegate.strUnit = @"km";
    }else{
        self.lblComment.text = @"Max distance away up to 31";
        self.lblUnit.text = @"miles";
        self.appDelegate.strUnit = @"miles";
        
        NSInteger nRadius = [[self.txtRadius text] integerValue];
        
        if(nRadius > 31) self.txtRadius.text = @"31";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = [AppDelegate appDelegate];
    
    self.txtRadius.delegate = self;
    
    NSString *strUnit = self.appDelegate.strUnit;
    
    if([strUnit isEqualToString:@"km"]){
        self.segUnit.selectedSegmentIndex = 0;
        self.lblComment.text = @"Max distance away up to 50";
        self.lblUnit.text = @"km";
        self.txtRadius.text = self.appDelegate.strRadius;
    }else{
        self.segUnit.selectedSegmentIndex = 1;
        self.lblComment.text = @"Max distance away up to 31";
        self.lblUnit.text = @"miles";
        self.txtRadius.text = self.appDelegate.strRadius;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(dismissKeyboard)];
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

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.txtRadius resignFirstResponder];
    [self dismissKeyboard];
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if([string isEqualToString:@""]) return YES;
    
    NSInteger nRadius = [textField.text integerValue] * 10 + [string integerValue];
    
    if(([self.appDelegate.strUnit isEqualToString:@"km"] && (nRadius > 50))||([self.appDelegate.strUnit isEqualToString:@"miles"] && (nRadius > 31))) return NO;
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        self.appDelegate.strRadius = self.txtRadius.text;
        [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.strRadius forKey:@"radiusValue"];
        [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.strUnit forKey:@"unitValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
