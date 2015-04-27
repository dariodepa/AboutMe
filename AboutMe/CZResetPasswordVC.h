//
//  CZResetPasswordVC.h
//  AboutMe
//
//  Created by Dario De pascalis on 25/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZAuthenticationDC.h"
@class MBProgressHUD;

@interface CZResetPasswordVC : UIViewController<CZAuthenticationDelegate>{
    MBProgressHUD *HUD;
    CZAuthenticationDC *DC;
    bool animationActive;
    NSString *errorMessage;
    UIView *viewError;
    UILabel *labelError;
    NSDictionary *dicHeader;
}


@property (strong, nonatomic) IBOutlet UIView *viewEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelHeaderTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelHeaderDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imageHeaderBackgroundUP;
@property (strong, nonatomic) IBOutlet UIImageView *imageHeaderBackground;
@property (strong, nonatomic) IBOutlet UIView *viewBackgroundHeader;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (strong, nonatomic) IBOutlet UIButton *buttonNext;
@property (strong, nonatomic) IBOutlet UIButton *buttonClose;

- (IBAction)actionClose:(id)sender;
- (IBAction)actionNext:(id)sender;

@end
