//
//  ProfileViewController.h
//  Barfliz
//
//  Created by User on 11/4/14.
//  Copyright (c) 2014 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic) int nMode;

//0:email   1:phone    2:facebook     3:twitter     4:instagram

@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) NSString *fbToken;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *instagram;
@end
