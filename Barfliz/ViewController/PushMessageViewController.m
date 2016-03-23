//
//  PushMessageViewController.m
//  Barfliz
//
//  Created by User on 12/13/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "PushMessageViewController.h"

@interface PushMessageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation PushMessageViewController
- (IBAction)btnClosePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *stringArray = [self.msgContent componentsSeparatedByString: @"-"];
    self.usernameLabel.text = stringArray[0];
    self.msgLabel.text = stringArray[1];
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
