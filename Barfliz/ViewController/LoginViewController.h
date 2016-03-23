//
//  LoginViewController.h
//  Barfliz
//
//  Created by User on 11/9/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<FHSTwitterEngineAccessTokenDelegate, UITextFieldDelegate>
- (void)fbDidLoginSuccess:(NSString*)fbUserID token:(NSString*)fbUserToken;
- (void)fbDidLoginFailedWithError:(NSError*)error;

@end
