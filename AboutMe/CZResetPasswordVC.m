//
//  CZResetPasswordVC.m
//  AboutMe
//
//  Created by Dario De pascalis on 25/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZResetPasswordVC.h"
#import "MBProgressHUD.h"

@implementation CZResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    DC = [[CZAuthenticationDC alloc] init];
    DC.delegate = self;
    self.imageHeaderBackground.image = nil;
    [self initialize];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//--------------------------------------------------------------------//
//START INITIALIZE VIEW
//--------------------------------------------------------------------//
-(void)initialize{
    animationActive = NO;
    [self setMessageError];
    [self setHeader];
    [self addGestureRecognizerToView];
    dicHeader =[self readerPlistForHeader];
}

-(void)setMessageError
{
    viewError = [[UIView alloc] init];
    viewError.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    viewError.backgroundColor = [UIColor redColor];
    viewError.alpha = 0;
    labelError = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, (self.view.frame.size.width-10), 50)];
    [labelError setTextColor:[UIColor whiteColor]];
    [labelError setBackgroundColor:[UIColor clearColor]];
    [labelError setFont:[UIFont fontWithName: @"Helvetica Neue" size: 12.0f]];
    labelError.text = errorMessage;
    labelError.textAlignment = NSTextAlignmentCenter;
    [viewError addSubview:labelError];
    [[[UIApplication sharedApplication] keyWindow] addSubview:viewError];
}

-(void)setHeader{
    dicHeader = [self readerPlistForHeader];
    NSLog(@"dicHeader %@",dicHeader);
    NSString *title = [dicHeader objectForKey:@"title"];
    NSString *titleFont = [dicHeader objectForKey:@"titleFont"];
    CGFloat titleFontSize = [[dicHeader objectForKey:@"titleFontSize"] floatValue];
    NSString *titleFontColor = [dicHeader objectForKey:@"titleFontColor"];
    NSString *description = [dicHeader objectForKey:@"description"];
    NSString *descriptionFont = [dicHeader objectForKey:@"descriptionFont"];
    CGFloat descriptionFontSize = [[dicHeader objectForKey:@"descriptionFontSize"] floatValue];
    NSString *descriptionFontColor = [dicHeader objectForKey:@"descriptionFontColor"];
    NSString *buttonFont = [dicHeader objectForKey:@"buttonFont"];
    CGFloat buttonFontSize = [[dicHeader objectForKey:@"buttonFontSize"] floatValue];
    NSString *buttonFontColor = [dicHeader objectForKey:@"buttonFontColor"];
    self.labelHeaderTitle.text = title;
    [self customFontLabel:self.labelHeaderTitle font:titleFont fontSize:titleFontSize color:titleFontColor];
    self.labelHeaderDescription.text = description;
    [self customFontLabel:self.labelHeaderDescription font:descriptionFont fontSize:descriptionFontSize color:descriptionFontColor];
    //[self.buttonAccedi setTitle:NSLocalizedString(@"ACCEDI", nil) forState:UIControlStateNormal];
    [self customFontLabel:self.buttonAccedi.titleLabel font:buttonFont fontSize:buttonFontSize color:buttonFontColor];
    //[self.buttonIscriviti setTitle:NSLocalizedString(@"ISCRIVITI", nil) forState:UIControlStateNormal];
    [self customFontLabel:self.buttonIscriviti.titleLabel font:buttonFont fontSize:buttonFontSize color:buttonFontColor];
    NSString *colorBackground = [dicHeader objectForKey:@"colorBackground"];
    imageBackground = [dicHeader objectForKey:@"imageBackground"];
    if(colorBackground){
        self.imageHeaderBackground.backgroundColor = [CZAuthenticationDC colorWithHexString:colorBackground];
        self.viewBackgroundHeader.backgroundColor = [CZAuthenticationDC colorWithHexString:colorBackground];
        self.viewBackgroundHeader.alpha = [[dicHeader objectForKey:@"alphaViewHeader"] floatValue];
    }
}



-(NSDictionary *)readerPlistForHeader{
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"settingsAuthentication" ofType:@"plist"];
    NSDictionary *plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    return [plistDictionary objectForKey:@"Header"];
}

-(void)customFontLabel:(UILabel*)label font:(NSString*)font fontSize:(CGFloat)fontSize color:(NSString*)color {
    [label setFont:[UIFont fontWithName:font size:fontSize]];
    UIColor *textColor = [CZAuthenticationDC colorWithHexString:color];
    [label setTextColor:textColor];
}
//--------------------------------------------------------------------//
//END INITIALIZE VIEW
//--------------------------------------------------------------------//






//--------------------------------------------------------------------//
//START TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//
-(void)addGestureRecognizerToView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)
                                   ];
    tap.cancelsTouchesInView = NO;// without this, tap on buttons is captured by the view
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard{
    [self.view endEditing:YES];
}
//--------------------------------------------------------------------//
//END TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FUNCTIONS
//--------------------------------------------------------------------//
-(void)animationMessageError:(NSString *)msg{
    viewError.alpha = 0.0;
    labelError.text = msg;
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: (UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         viewError.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:2.5
                                             options: (UIViewAnimationCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                                          animations:^{
                                              viewError.alpha = 0.0;
                                          }
                                          completion:nil];
                     }];
}


-(void)showWaiting:(NSString *)label {
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithWindow:self.view.window];
        [self.view.window addSubview:HUD];
    }
    HUD.center = self.view.center;
    HUD.labelText = label;
    HUD.animationType = MBProgressHUDAnimationZoom;
    [HUD show:YES];
}

-(void)hideWaiting {
    [HUD hide:YES];
}

-(UIButton *)enableButton:(UIButton *)button{
    button.enabled = YES;
    button.hidden = NO;
    [button setAlpha:1];
    return button;
}
-(UIButton *)disableButton:(UIButton *)button{
    button.enabled = NO;
    button.hidden = YES;
    [button setAlpha:0.5];
    return button;
}
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START RESET PASSWORD
//--------------------------------------------------------------------//
- (IBAction)actionEnter:(id)sender {
    NSString *emailValue = [self.textEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"actionEnter email:%@",emailValue);
    [PFUser requestPasswordResetForEmailInBackground:emailValue];
    
    NSLog(@"ERROR LOADING CATEGORIES!");
    UIAlertView *categoriesAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"resetPassword", nil) message:NSLocalizedString(@"Il sistema invierà alla e-mail associata al profilo le istruzioni per poter inserire una nuova password.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"TryAgainLKey", nil) otherButtonTitles:nil];
    [categoriesAlertView show];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"reset password", nil) message:NSLocalizedString(@"Il sistema invierà alla e-mail associata al profilo le istruzioni per poter inserire una nuova password.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--------------------------------------------------------------------//
//END RESET PASSWORD
//--------------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toSignInUser"]) {
        NSLog(@"prepareForSegue toSignInUser");
    } else if ([[segue identifier] isEqualToString:@"toWebView"]) {
    }
}



- (void)dealloc{
    NSLog(@"DEALLOC");
}

@end

