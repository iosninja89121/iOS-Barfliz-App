//
//  FacebookSignupViewController.m
//  Barfliz
//
//  Created by User on 11/6/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "FacebookSignupViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookSignupViewController ()

@end

@implementation FacebookSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
