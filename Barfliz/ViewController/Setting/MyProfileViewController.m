//
//  MyProfileViewController.m
//  Barfliz
//
//  Created by User on 12/19/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ActivityView.h"
#import <Parse/Parse.h>

@interface MyProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *BiographyTextView;

@property (weak, nonatomic) IBOutlet UIButton *btnCompleteProfile;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIImage *photoImage;
@end

@implementation MyProfileViewController
- (IBAction)btnCompleteProfilePressed:(id)sender {
    [self processFieldEntries];
    
}

- (IBAction)btnPhotoPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self init_dashboard];
    
    self.usernameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.BiographyTextView.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                               action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 480);
    
    [self registerForKeyboardNotifications];
}



- (void) init_dashboard{
    PFUser *currentUser = [PFUser currentUser];
    
    NSData *photoData = [currentUser  objectForKey:keyPhoto];
    UIImage *photoImg = [UIImage imageWithData:photoData];
    [self.btnPhoto setImage:photoImg forState:UIControlStateNormal];
    
    self.usernameTextField.text = [currentUser valueForKey:kpRealUsername];
    self.emailTextField.text    = currentUser.email;
    
    NSString* bioText = [currentUser valueForKey:keyBio];
    
    self.BiographyTextView.text = bioText;
    
    if(bioText.length == 0){
        self.BiographyTextView.text = @"Biography";
        self.BiographyTextView.textColor = [UIColor lightGrayColor];
    }else{
        self.BiographyTextView.textColor = [UIColor blackColor];
    }
    
    self.photoImage = photoImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.photoImage = info[UIImagePickerControllerEditedImage];
    
    [self.btnPhoto setImage:self.photoImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.emailTextField becomeFirstResponder];
    }
    
    if (textField == self.emailTextField) {
        [self.BiographyTextView becomeFirstResponder];
    }
    
    return YES;
}


- (void)processFieldEntries {
    // Check that we have a non-zero username and passwords.
    // Compare password and passwordAgain for equality
    // Throw up a dialog that tells them what they did wrong if they did it wrong.
    
    NSString *realUsername = self.usernameTextField.text;
    NSString *emailAddress = self.emailTextField.text;
    NSString *biography = self.BiographyTextView.text;
    
     if([biography compare:@"Biography"] == NSOrderedSame) biography = @"";
    
    if(realUsername.length == 0){
        [self.usernameTextField becomeFirstResponder];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please enter the user name" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    
    NSString *username = realUsername.lowercaseString;
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser.username = username;
    currentUser.email = emailAddress;
    [currentUser setObject:realUsername forKey:kpRealUsername];
    [currentUser setObject:biography forKey:keyBio];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [self.photoImage drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.05f);
    
    [currentUser setObject:imageData forKey:@"photo"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
            [self.usernameTextField becomeFirstResponder];
            return;
        }
        
        // Success!
        [activityView.activityIndicator stopAnimating];
        [activityView removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.username forKey:@"username"];
        
        [self performSegueWithIdentifier:@"idSegueSettingFromMyProfile" sender:self];
        
    }];
    
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                                  CGRectGetMaxY(self.btnCompleteProfile.frame)));
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
