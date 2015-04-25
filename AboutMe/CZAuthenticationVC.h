//
//  CZswapvc.h
//  AboutMe
//
//  Created by Dario De pascalis on 04/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CZLoginVC.h"
#import "CZSignInEmailVC.h"

@class MBProgressHUD;


@interface CZAuthenticationVC : UIViewController<CZLoginDelegate>{
    MBProgressHUD *HUD;
    bool animationActive;
    NSString *errorMessage;
    UIView *viewError;
    UILabel *labelError;
    CGFloat posXTriangleStart;
}


@property (nonatomic, weak) IBOutlet UIView *containerA;//login
@property (nonatomic, weak) IBOutlet UIView *containerB;//signin
@property (weak, nonatomic) IBOutlet UILabel *labelHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelHeaderDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imageHeaderBackground;
@property (weak, nonatomic) IBOutlet UIButton *buttonIscriviti;
@property (weak, nonatomic) IBOutlet UIButton *buttonAccedi;
//@property (weak, nonatomic) IBOutlet UIView *viewError;
//@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (strong, nonatomic) IBOutlet UIButton *buttonFacebookLogin;
@property (strong, nonatomic) IBOutlet UIImageView *imageTriangle;

- (IBAction)actionLogin:(id)sender;
- (IBAction)actionSignin:(id)sender;
- (IBAction)actionFacebookLogin:(id)sender;

-(void)animationMessageError:(NSString *)msg;


@end
