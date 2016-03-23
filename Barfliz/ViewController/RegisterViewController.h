//
//  RegisterViewController.h
//  Barfliz
//
//  Created by User on 11/1/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<FHSTwitterEngineAccessTokenDelegate>
- (void)fbDidLoginSuccess:(NSString*)fbUserID token:(NSString*)fbUserToken;
- (void)fbDidLoginFailedWithError:(NSError*)error;
@end
