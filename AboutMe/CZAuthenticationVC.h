//
//  CZAuthenticationVC.h
//  AboutMe
//
//  Created by Dario De pascalis on 28/03/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "ViewController.h"

@class MBProgressHUD;

@interface CZAuthenticationVC : ViewController <UITextFieldDelegate>{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UILabel *labelHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelHeaderDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonIscriviti;
@property (weak, nonatomic) IBOutlet UIButton *buttonAccedi;
@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonRemember;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonEnter;
@property (weak, nonatomic) IBOutlet UIView *viewError;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (strong, nonatomic) IBOutlet UIImageView *imageHeaderBackground;

- (IBAction)actionFacebook:(id)sender;
- (IBAction)actionRemember:(id)sender;
- (IBAction)actionSignIn:(id)sender;
- (IBAction)actionEnter:(id)sender;
@end
