//
//  WelcomViewController.m
//  Barfliz
//
//  Created by User on 11/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "WelcomViewController.h"
#import "MainTabBarController.h"
//#import "Quartz"

@interface WelcomViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnReg;

@end

@implementation WelcomViewController

- (IBAction)unwindFromSetting:(UIStoryboardSegue *)segue{
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"start...");
    [NSThread sleepForTimeInterval:3];
    NSLog(@"end...");
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
//    NSString *strUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
//    NSString *strPSW =      [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
//    
//    if(strUsername.length > 0 && strPSW.length > 0){
//        [PFUser logInWithUsername:strUsername password:strPSW];
//        [self performSegueWithIdentifier:@"ToMainPageFromWelcome" sender:self];
//    }
    
    // Do any additional setup after loading the view.
    [self setBorderRadiusForButton];
}

-(void) setBorderRadiusForButton {
    self.btnReg.layer.cornerRadius = 10;
    self.btnReg.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.btnLogin.layer.cornerRadius = 10;
    self.btnLogin.layer.borderColor = [[UIColor blackColor] CGColor];
    
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
    if([segue.identifier isEqualToString:@"ToMainPageFromWelcome"]){
        MainTabBarController *controller = (MainTabBarController *)segue.destinationViewController;
        controller.selectedIndex = 1;
    }
}


@end
