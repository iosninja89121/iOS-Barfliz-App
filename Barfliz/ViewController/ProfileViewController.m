//
//  ProfileViewController.m
//  Barfliz
//
//  Created by User on 11/4/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainTabBarController.h"
#import "ActivityView.h"
#import "AppDelegate.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
@property (weak, nonatomic) IBOutlet UITextView *BiographyTextView;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnPhtoView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateProfile;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImage *photoImage;

@property AppDelegate *appDelegate;
@end

@implementation ProfileViewController
- (IBAction)btnSelectPhotoPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)btnCreatePressed:(id)sender {
    [self processFieldEntries];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.UsernameTextField.delegate = self;
    self.EmailTextField.delegate = self;
    self.BiographyTextView.delegate = self;
    self.PasswordTextField.delegate = self;
    self.ConfirmTextField.delegate = self;
    
    //Placeholder for Textview.
    
    self.BiographyTextView.text = @"Biography";
    self.BiographyTextView.textColor = [UIColor lightGrayColor];
    
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.photoImage = [UIImage imageNamed:@"empty_photo.png"];
    
    switch (self.nMode) {
        case 0:
            self.EmailTextField.text = self.emailAddress;
            break;
        case 1:
            break;
        case 2:
            [self loadMediaDatawithFacebook];

            break;
        case 3:
            [self loadMediaDataWithTwitter];
            break;
            
        default:
            [self loadMediaDataWithInstagram:self.instagram];
            break;
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                               action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    
    [self registerForKeyboardNotifications];
    
//    [self.UsernameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.UsernameTextField becomeFirstResponder];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.photoImage = info[UIImagePickerControllerEditedImage];
    
    [self.btnPhtoView setImage:self.photoImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark -
#pragma mark UITextViewDelegate


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    NSString* strContent = [textView text];
    if([strContent compare:@"Biography"] != NSOrderedSame) return YES;
    self.BiographyTextView.text = @"";
    self.BiographyTextView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.BiographyTextView.text.length == 0){
        self.BiographyTextView.textColor = [UIColor lightGrayColor];
        self.BiographyTextView.text = @"Biography";
        [self.BiographyTextView resignFirstResponder];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.UsernameTextField) {
        [self.EmailTextField becomeFirstResponder];
    }
    if (textField == self.EmailTextField) {
        [self.BiographyTextView becomeFirstResponder];
    }
    
    if (textField == self.PasswordTextField) {
        [self.ConfirmTextField becomeFirstResponder];
    }
    if (textField == self.ConfirmTextField) {
        [self.ConfirmTextField resignFirstResponder];
        [self dismissKeyboard];
        [self processFieldEntries];
    }
    
    return YES;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Sign Up

- (void)processFieldEntries {
    // Check that we have a non-zero username and passwords.
    // Compare password and passwordAgain for equality
    // Throw up a dialog that tells them what they did wrong if they did it wrong.
    
    NSString *realUsername = self.UsernameTextField.text;
    NSString *emailAddress = self.EmailTextField.text;
    NSString *biography = self.BiographyTextView.text;
    
    if([biography compare:@"Biography"] == NSOrderedSame) biography = @"";
    
    NSString *password = self.PasswordTextField.text;
    NSString *passwordAgain = self.ConfirmTextField.text;
    
    NSString *errorText = @"Please ";
    NSString *usernameBlankText = @"enter a username";
    NSString *passwordBlankText = @"enter a password";
    NSString *joinText = @", and ";
    NSString *passwordMismatchText = @"enter the same password twice";
    
    BOOL textError = NO;
    
    // Messaging nil will return 0, so these checks implicitly check for nil text.
    if (realUsername.length == 0 || password.length == 0 || passwordAgain.length == 0) {
        textError = YES;
        
        // Set up the keyboard for the first field missing input:
        if (passwordAgain.length == 0) {
            [self.ConfirmTextField becomeFirstResponder];
        }
        if (password.length == 0) {
            [self.PasswordTextField becomeFirstResponder];
        }
        if (realUsername.length == 0) {
            [self.UsernameTextField becomeFirstResponder];
        }
        
        if (realUsername.length == 0) {
            errorText = [errorText stringByAppendingString:usernameBlankText];
        }
        
        if (password.length == 0 || passwordAgain.length == 0) {
            if (realUsername.length == 0) { // We need some joining text in the error:
                errorText = [errorText stringByAppendingString:joinText];
            }
            errorText = [errorText stringByAppendingString:passwordBlankText];
        }
    } else if ([password compare:passwordAgain] != NSOrderedSame) {
        // We have non-zero strings.
        // Check for equal password strings.
        textError = YES;
        errorText = [errorText stringByAppendingString:passwordMismatchText];
        [self.PasswordTextField becomeFirstResponder];
    }
    
    if (textError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }
    
    // Everything looks good; try to log in.
    ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *label = activityView.label;
    label.text = @"Saving Profile";
    label.font = [UIFont boldSystemFontOfSize:20.f];
    [activityView.activityIndicator startAnimating];
    [activityView layoutSubviews];
    
    [self.view addSubview:activityView];
    
    // Call into an object somewhere that has code for setting up a user.
    // The app delegate cares about this, but so do a lot of other objects.
    // For now, do this inline.
    NSString *phone = @"";
    NSString *facebookID = @"";
    NSString *facebookToken = @"";
    NSString *twitterToken = @"";
    NSString *instagramToken = @"";
    
    switch (self.nMode) {
        case 1:
            phone = self.phone;
            break;
        case 2:
            facebookID = self.fbID;
            facebookToken = self.fbToken;
            break;
        case 3:
            twitterToken = self.twitter;
            break;
        case 4:
            instagramToken = self.instagram;
        default:
            break;
    }
    
    NSString *username = realUsername.lowercaseString;
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = emailAddress;
    
    [user setObject:realUsername     forKey:kpRealUsername];
    [user setObject:password         forKey:@"psw"];
    [user setObject:phone            forKey:@"phone"];
    [user setObject:biography        forKey:@"bio"];
    [user setObject:facebookID       forKey:kpFacebookID];
    [user setObject:facebookToken    forKey:kpFacebookToken];
    [user setObject:twitterToken     forKey:kpTwitter];
    [user setObject:instagramToken   forKey:kpInstagram];
    [user setObject:[NSNumber numberWithBool:NO]   forKey:kpPrivacy];
    
    CLLocationCoordinate2D currentCoordinate = self.appDelegate.myLocation;
    PFGeoPoint *currentPoint = [PFGeoPoint geoPointWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
    
    [user setObject:currentPoint forKey:@"location"];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [self.photoImage drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.05f);
    
    [user setObject:imageData forKey:@"photo"];
    
//    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [alertView show];
            [activityView.activityIndicator stopAnimating];
            [activityView removeFromSuperview];
            // Bring the keyboard back up, because they'll probably need to change something.
            [self.UsernameTextField becomeFirstResponder];
            return;
        }
        
        // Success!
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.delegate newUserViewControllerDidSignup:self];
        
        self.appDelegate.objectId = user.objectId;
        
        // Associate the device with a user
        PFInstallation *installation = [PFInstallation currentInstallation];
        installation[@"user"] = [PFUser currentUser];
        
        [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"registered"];
        
        [installation saveInBackground];
//        [installation saveEventually];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:main_storyboard bundle:nil];
        MainTabBarController * tabController = (MainTabBarController *)[storyboard instantiateViewControllerWithIdentifier:mainTab_scene];
        tabController.selectedIndex = 1;
        [self.navigationController pushViewController:tabController animated:YES];
        
    }];
}

- (void) uploadImage:(NSData *)imageData {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loadMediaDataWithTwitter{
    NSDictionary *details = [[FHSTwitterEngine sharedEngine] verifyCredentials];
    self.UsernameTextField.text = [details objectForKey:@"screen_name"];
    NSString *imageUrl =          [details objectForKey:@"profile_image_url"];
    
    self.photoImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]]];
    
    [self.btnPhtoView setImage:self.photoImage forState:UIControlStateNormal];
    
//    NSLog(@"details-%@", details);
    
}

-(void)loadMediaDataWithInstagram:(NSString*) strToken {
    
    NSArray *strParts = [strToken componentsSeparatedByString:@"."];
    NSString *strUserID = [strParts objectAtIndex:0];
    NSString* strUrl = [NSString stringWithFormat:@"%@%@/?access_token=%@",kAPIURl, strUserID, strToken];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
    // Here you can handle response as well
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *dataDic = [dictResponse objectForKey:@"data"];
    
    self.BiographyTextView.text = [dataDic objectForKey:@"bio"];
    self.UsernameTextField.text  = [dataDic objectForKey:@"username"];
    NSString *imageUrl =           [dataDic objectForKey:@"profile_picture"];
    
    self.photoImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrl]]];
    
    [self.btnPhtoView setImage:self.photoImage forState:UIControlStateNormal];
    
    NSLog(@"Response : %@",dictResponse);
}

- (void) loadMediaDatawithFacebook{
    self.UsernameTextField.text  = self.appDelegate.fbUserInfo.serviceName;
    
    self.photoImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: self.appDelegate.fbUserPhoto]]];
    
    [self.btnPhtoView setImage:self.photoImage forState:UIControlStateNormal];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGFloat scrollViewOffsetY = (keyboardFrame.size.height -
                                 (CGRectGetHeight(self.view.bounds) -
                                  CGRectGetMaxY(self.btnCreateProfile.frame)));
    // Check if scrolling needed
    if (scrollViewOffsetY < 0) {
        return;
    }
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointMake(0.0f, scrollViewOffsetY) animated:NO];
                         
                     }
                     completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:endFrame fromView:self.view.window];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:curve << 16 | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:CGPointZero animated:NO];
                    }
                     completion:nil];
}


@end
