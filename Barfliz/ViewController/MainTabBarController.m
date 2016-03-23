//
//  MainTabBarController.m
//  Barfliz
//
//  Created by User on 11/10/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "MainTabBarController.h"
#import "AppDelegate.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    appDelegate.mainTabCtrl = self;
    
    appDelegate.offTabViewCtrlArray = [NSMutableArray arrayWithArray:self.viewControllers];
    
    appDelegate.onTabViewCtrlArray = [NSMutableArray arrayWithArray:self.viewControllers];
    [appDelegate.onTabViewCtrlArray removeObjectAtIndex:3];
    
    PFUser *currentUser = [PFUser currentUser];
    
    BOOL privacy_flag = [[currentUser valueForKey:kpPrivacy] boolValue];
    
    if(privacy_flag) {
        [self setViewControllers:appDelegate.onTabViewCtrlArray animated:YES];
    }else{
        [self setViewControllers:appDelegate.offTabViewCtrlArray animated:YES];
    }
    
    PFInstallation* installation = [PFInstallation currentInstallation];
    
    [installation fetch];
    
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.selectedIndex = 1;
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
