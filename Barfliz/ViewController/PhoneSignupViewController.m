//
//  PhoneSignupViewController.m
//  Barfliz
//
//  Created by User on 11/5/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import "PhoneSignupViewController.h"
#import "CountryListTableViewController.h"
#import "CountryInfo.h"
#import "PhoneValidationViewController.h"
#import "AppDelegate.h"

@interface PhoneSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryName;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zipcodeArrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *zipcodeContainerImg;
@property CountryInfo *mCountryInfo;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* number;
@end

@implementation PhoneSignupViewController
- (IBAction)pushVerificationButton:(id)sender {
    NSString *strPhoneNumber = _txtPhoneNumber.text;
    
    if([strPhoneNumber isEqualToString:@""]) return;
    
    NSString *strRealPhoneNumber = [NSString stringWithFormat:@"%@%@", [_mCountryInfo.code substringFromIndex:1], strPhoneNumber];
    
    NSString *strURL = [NSString stringWithFormat:@"http://barfliz.com/mobileApi/new_signup.php?mode=phone&number=%@",strRealPhoneNumber];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    
    NSError * error = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    
    
    NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    if(error != nil)
    {
        [AppDelegate message:@"Can not access the server!"];
        return;
    }
    
    if([strResponse isEqualToString:@"fail"])
    {
        [AppDelegate message:@"Registration failed, please try it."];
        return;
    }
    
    self.code = strResponse;
    
    NSLog(@"phone code - %@", self.code);
    
    [self performSegueWithIdentifier:@"ToVerifyPhone" sender:self];
}


- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    CountryListTableViewController *source = [segue sourceViewController];
    
    NSString *countryCode = [source countryISO];
    
    _mCountryInfo = [self getCountryInfo:countryCode];
    
    _lblCode.text = _mCountryInfo.code;
    _lblCountryName.text = _mCountryInfo.name;
    NSString *strImgName = [[NSString alloc] init];
    strImgName = [NSString stringWithFormat:@"flag%@", [_mCountryInfo.code substringFromIndex:1] ];
    
    _imgFlag.image = [UIImage imageNamed:strImgName];

}

- (CountryInfo *) getCountryInfo:(NSString *) iso{
    int nPos = 0;
    
    CountryInfo *mCountryInfo = [[CountryInfo alloc] init];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"country_code" ofType:@"json"]];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray *countryCodeList = [[dictionary objectForKey:@"countries"] objectForKey:@"country"];
    
    for(int i = 0; i < [countryCodeList count]; i ++)
    {
        NSDictionary *filtered = [countryCodeList objectAtIndex:i];
        NSString *strISO = [filtered objectForKey:@"-iso"];
        
        if([strISO isEqualToString:iso])
        {
            nPos = i;
            break;
        }
    }
    
    NSDictionary *filtered = [countryCodeList objectAtIndex:nPos];
    NSString *strCode = [filtered objectForKey:@"code"];
    NSString *strName = [filtered objectForKey:@"name"];
    NSString *strISO = [filtered objectForKey:@"-iso"];
    
    mCountryInfo.name = strName;
    mCountryInfo.code = strCode;
    mCountryInfo.iso = strISO;
    
    return mCountryInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [_countryLabel setUserInteractionEnabled:YES];
    [_countryLabel addGestureRecognizer:singleTap];
    
    self.txtPhoneNumber.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self                                                                               action:@selector(dismissKeyboard)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.mCountryInfo = [[CountryInfo alloc] init];
    
    self.mCountryInfo.name = @"USA";
    self.mCountryInfo.code = @"+1";
    self.mCountryInfo.iso = @"us";
    
}

-(void)tapDetected{
    [self performSegueWithIdentifier:@"ToSelectCountry" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtPhoneNumber) {
        [self.txtPhoneNumber resignFirstResponder];
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
    if ([segue.identifier isEqualToString:@"ToVerifyPhone"]) {
        PhoneValidationViewController *validController = [segue destinationViewController];
        validController.number = self.number;
        validController.code = self.code;
    }
}


@end
