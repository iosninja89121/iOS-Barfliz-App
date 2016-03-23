//
//  OtherProfileViewController.m
//  Barfliz
//
//  Created by User on 1/12/15.
//  Copyright (c) 2015 Jane. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "ActivityView.h"

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnSaveToContacts;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation OtherProfileViewController
- (IBAction)btnSendMessageClicked:(id)sender {
}
- (IBAction)btnSaveToContactsClicked:(id)sender {
    NSString *myUsername = [[PFUser currentUser] username];
    NSString *otherUsername = [self.otherUser username];

    PFObject *newFriendItem = [PFObject objectWithClassName:pClassFriend];
    [newFriendItem setObject:myUsername     forKey:keyMyUsername];
    [newFriendItem setObject:self.otherUser     forKey:keyOtherUser];
    [newFriendItem setObject:@"0"           forKey:keyFavoirte];
    [newFriendItem setObject:otherUsername  forKey:keyOtherUsername];
    
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    
    UILabel *label = activityView.label;
    
    label.text = @"Saving...";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    [self.view addSubview:activityView];
    
    [newFriendItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        if (error) {
            NSLog(@"Couldn't save!");
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
        
        if(succeeded){
            [self.btnSaveToContacts setHidden:YES];
        }
    }];

}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSData *photoData = [self.otherUser  objectForKey:keyPhoto];
    UIImage *photoImg = [UIImage imageWithData:photoData];
    [self.btnPhoto setImage:photoImg forState:UIControlStateNormal];
    
    self.usernameTextField.text = [self.otherUser valueForKey:kpRealUsername];
    
    NSString* bioText = [self.otherUser valueForKey:keyBio];
    
    self.biographyTextView.text = bioText;
    
    if(bioText.length == 0){
        self.biographyTextView.text = @"Biography";
        self.biographyTextView.textColor = [UIColor lightGrayColor];
    }else{
        self.biographyTextView.textColor = [UIColor blackColor];
    }
    
    [self.usernameTextField setEnabled:NO];
    [self.biographyTextView setEditable:NO];
    
    self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 480);
    
    self.btnSaveToContacts.layer.cornerRadius = 10;
    self.btnSaveToContacts.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnSaveToContacts.layer.borderWidth=1.0f;
    
    BOOL flag = [self checkExisting];
    
    [self.btnSaveToContacts setHidden:flag];
}

- (BOOL) checkExisting{
    
    PFQuery *query = [PFQuery queryWithClassName:pClassFriend];
    
    NSString *myUsername = [[PFUser currentUser] username];
//    NSString* otherUsername = [self.otherUser username];
    
    [query whereKey:keyMyUsername equalTo:myUsername];
    [query whereKey:keyOtherUser equalTo:self.otherUser];
    
    NSArray* objects = [query findObjects];
    
    if([objects count] == 0) return NO;
    
    return YES;
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
