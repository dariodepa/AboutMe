//
//  CZSignInTVC.h
//  AboutMe
//
//  Created by Dario De pascalis on 29/03/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSignInTVC : UITableViewController

@property (strong, nonatomic) NSString *email;

@property (weak, nonatomic) IBOutlet UIImageView *imageBackground;
@property (weak, nonatomic) IBOutlet UIView *viewPhotoUser;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoto;

@property (weak, nonatomic) IBOutlet UIImageView *imageEmail;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imageUsername;
@property (weak, nonatomic) IBOutlet UITextField *textUsername;
@property (weak, nonatomic) IBOutlet UIImageView *imagePassword;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageNameComplete;
@property (weak, nonatomic) IBOutlet UITextField *textNameComplete;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonPreviou;

- (IBAction)actionPreviou:(id)sender;
@end
