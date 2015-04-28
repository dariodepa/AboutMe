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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DC = [[CZAuthenticationDC alloc] init];
    DC.delegate = self;
    self.imageHeaderBackground.image = nil;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    [self.buttonNext setTitle:NSLocalizedStringFromTable(@"Avanti", @"CZ-AuthenticationLocalizable", @"") forState:UIControlStateNormal];
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
    NSString *title =  NSLocalizedStringFromTable(@"titleResetPassword", @"CZ-AuthenticationLocalizable", @"");
    NSString *description = NSLocalizedStringFromTable(@"descriptionResetPassword", @"CZ-AuthenticationLocalizable", @"");
    
    NSString *titleFont = [dicHeader objectForKey:@"titleFont"];
    CGFloat titleFontSize = [[dicHeader objectForKey:@"titleFontSize"] floatValue];
    NSString *titleFontColor = [dicHeader objectForKey:@"titleFontColor"];
    NSString *descriptionFont = [dicHeader objectForKey:@"descriptionFont"];
    CGFloat descriptionFontSize = [[dicHeader objectForKey:@"descriptionFontSize"] floatValue];
    NSString *descriptionFontColor = [dicHeader objectForKey:@"descriptionFontColor"];
    
    self.labelHeaderTitle.text = title;
    [self customFontLabel:self.labelHeaderTitle font:titleFont fontSize:titleFontSize color:titleFontColor];
    self.labelHeaderDescription.text = description;
    [self customFontLabel:self.labelHeaderDescription font:descriptionFont fontSize:descriptionFontSize color:descriptionFontColor];

    NSString *colorViewHeader = [dicHeader objectForKey:@"colorViewHeader"];
    NSString *alphaViewHeader = [dicHeader objectForKey:@"alphaViewHeader"];
    if(colorViewHeader){
        self.viewBackgroundHeader.backgroundColor = [CZAuthenticationDC colorWithHexString:colorViewHeader];
        self.viewBackgroundHeader.alpha = [alphaViewHeader floatValue];
    }
    NSString *colorBackground = [dicHeader objectForKey:@"colorBackground"];
    NSString *imageBackground = [dicHeader objectForKey:@"imageBackground"];
    NSString *urlImageBackground = [dicHeader objectForKey:@"urlImageBackground"];
    //NSLog(@"%@ - %@ - %@",colorBackground,imageBackground,urlImageBackground);
    if(colorBackground && colorBackground.length > 2){
        self.imageHeaderBackground.backgroundColor = [CZAuthenticationDC colorWithHexString:colorBackground];
    }
    if(imageBackground && imageBackground.length > 2){
        self.imageHeaderBackground.image = [UIImage imageNamed:imageBackground];
    }
    if(urlImageBackground && urlImageBackground.length > 2){
        [DC loadImageFromUrl:urlImageBackground];
    }
}

-(NSDictionary *)readerPlistForHeader{
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"settingsAuthentication" ofType:@"plist"];
    NSDictionary *plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    return [plistDictionary objectForKey:@"HeaderResetPassword"];
}

-(void)customFontLabel:(UILabel*)label font:(NSString*)font fontSize:(CGFloat)fontSize color:(NSString*)color {
    [label setFont:[UIFont fontWithName:font size:fontSize]];
    UIColor *textColor = [CZAuthenticationDC colorWithHexString:color];
    [label setTextColor:textColor];
}
//--------------------------------------------------------------------//
//END INITIALIZE VIEW
//--------------------------------------------------------------------//

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//START DELEGATE FUNCTIONS DC
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
-(void)refreshImage:(NSData *)imageData name:(NSString*)name
{
    UIImage *image = [UIImage imageWithData:imageData];
    NSLog(@"IMAGES DATA: %@",name);
    if([name isEqualToString:@"imageCover"]){
        //UIImageView *imageUploaded = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.containerA.frame.origin.y)];
        //self.imageHeaderBackgroundUP.image = [UIImage imageNamed:@"CZ-background009.jpg"];
        self.imageHeaderBackgroundUP.alpha = 1.0;
        [self.imageHeaderBackgroundUP setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.viewEmail.frame.origin.y)];
        self.imageHeaderBackgroundUP.contentMode = UIViewContentModeScaleAspectFill;
        self.imageHeaderBackgroundUP.image = image;
        [DC animationAlpha:self.imageHeaderBackgroundUP];
    }
}

- (void)setProgressBar:(NSIndexPath *)indexPath progress:(float)progress
{
    HUD.progress = progress;
    NSLog(@"progress %f", progress);
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//END DELEGATE FUNCTIONS DC
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//





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
-(BOOL)validEmail:(NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}


-(void)animationMessageError:(NSString *)msg{
    viewError.alpha = 0.0;
    labelError.text = msg;
    self.buttonNext.enabled = NO;
    NSLog(@"animationMessageError %@", msg);
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
                                          completion:^(BOOL finished){
                                              //startedAnimation = NO;
                                              self.buttonNext.enabled = YES;
                                          }];
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
-(void)resetPassword{
    NSString *emailValue = [self.textEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"actionEnter email:%@",emailValue);
    [PFUser requestPasswordResetForEmailInBackground:emailValue];
    
    NSLog(@"ERROR LOADING CATEGORIES!");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ResetPassword", @"CZ-AuthenticationLocalizable", @"") message:NSLocalizedStringFromTable(@"MessageResetPassword", @"CZ-AuthenticationLocalizable", @"") delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Ok", @"CZ-AuthenticationLocalizable", @"") otherButtonTitles:nil];
    [alertView show];
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


- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionNext:(id)sender {
  
    if([self validEmail:self.textEmail.text]){
          NSLog(@"validEmail");
        [self resetPassword];
    }else{
          NSLog(@"errorMessage");
        [self setMessageError];
        errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"EmailError", @"CZ-AuthenticationLocalizable", @"")];
        [self animationMessageError:errorMessage];
    }
}

- (void)dealloc {
    NSLog(@"DEALLOC");
    [DC setDelegate:nil];
    self.textEmail.delegate = nil;
}

@end

