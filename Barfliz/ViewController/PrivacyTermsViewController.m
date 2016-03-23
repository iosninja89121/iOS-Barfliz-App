//
//  PrivacyTermsViewController.m
//  Barfliz
//
//  Created by User on 12/2/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "PrivacyTermsViewController.h"

@interface PrivacyTermsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PrivacyTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fileName = @"about";
    self.navigationItem.title = @"About";
    
    if(self.nMode == 1){
        fileName = @"privacy_terms";
        self.navigationItem.title = @"Privacy Policy and Terms";
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -80.f) forBarMetrics:UIBarMetricsDefault];
    
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
//    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//    
//    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"html" inDirectory:@"html"]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
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
