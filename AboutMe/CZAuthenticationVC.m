//
//  CZswapvc.m
//  AboutMe
//
//  Created by Dario De pascalis on 04/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZAuthenticationVC.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MBProgressHUD.h"
#import "CZSignInTVC.h"


@interface CZAuthenticationVC ()
@end

@implementation CZAuthenticationVC

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([PFUser currentUser]){
        [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [PFUser logOut];
            [self deleteSessionToken];
        }];
    }
    
    NSLog(@"SOPRA DA ELIMINARE!!!!!!!!!!!!!!!!!! %f",self.containerB.frame.origin.x);
    DC = [[CZAuthenticationDC alloc] init];
    DC.delegate = self;
    self.imageHeaderBackground.image = nil;
    [self initialize];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStartPosition];
    NSLog(@"viewWillAppear %f",self.containerB.frame.origin.x);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setStartPosition];
    [self loadBackgroundCover];
    NSLog(@"viewDidAppear %f",self.containerB.frame.origin.x);
}

//--------------------------------------------------------------------//
//START INITIALIZE VIEW
//--------------------------------------------------------------------//
-(void)initialize{
    animationActive = NO;
    [self setMessageError];
    [self setHeader];
    [self.buttonAccedi setTitle:NSLocalizedStringFromTable(@"Accedi", @"CZ-AuthenticationLocalizable", @"") forState:UIControlStateNormal];
    [self.buttonIscriviti setTitle:NSLocalizedStringFromTable(@"Iscriviti", @"CZ-AuthenticationLocalizable", @"") forState:UIControlStateNormal];
    [self.buttonFacebookLogin setTitle:NSLocalizedStringFromTable(@"AccediConFacebook", @"CZ-AuthenticationLocalizable", @"") forState:UIControlStateNormal];
    
    CZLoginVC *contentLoginVC = [self.childViewControllers objectAtIndex:1];
    contentLoginVC.delegate = self;
    [self addGestureRecognizerToView];
    dicHeader =[self readerPlistForHeader];
}

-(void)setMessageError
{
    //errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Email non corretta", nil)];//[error localizedDescription];
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
    NSString *title =  NSLocalizedStringFromTable(@"titleAuthentication", @"CZ-AuthenticationLocalizable", @"");
    NSString *description = NSLocalizedStringFromTable(@"descriptionAuthentication", @"CZ-AuthenticationLocalizable", @"");
    
    NSString *titleFont = [dicHeader objectForKey:@"titleFont"];
    CGFloat titleFontSize = [[dicHeader objectForKey:@"titleFontSize"] floatValue];
    NSString *titleFontColor = [dicHeader objectForKey:@"titleFontColor"];
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

-(void)loadBackgroundCover{
    if(imageBackground && self.imageHeaderBackground.image == nil){
        NSURL *url = [NSURL URLWithString:imageBackground];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        NSLog(@"imageData: %@",imageData);//[HUD hide:YES];
        PFFile *imageView = (PFFile *)[PFFile fileWithName:@"imageCover" data:imageData];
        [DC loadImage:imageView];
    }
}

-(void)setStartPosition{
    posXTriangleStart = (self.buttonAccedi.frame.origin.x+self.buttonAccedi.frame.size.width/2)-self.imageTriangle.frame.size.width/2;
    self.imageTriangle.frame = CGRectMake(posXTriangleStart, self.imageTriangle.frame.origin.y, self.imageTriangle.frame.size.width, self.imageTriangle.frame.size.height);
    self.containerB.frame = CGRectMake(-self.view.frame.size.width, self.containerB.frame.origin.y, self.containerB.frame.size.width, self.containerB.frame.size.height);
}

-(NSDictionary *)readerPlistForHeader{
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"settingsAuthentication" ofType:@"plist"];
    NSDictionary *plistDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    return [plistDictionary objectForKey:@"HeaderAuthentication"];
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
    NSLog(@"IMAGES DATA: %@",name);//[HUD hide:YES];
    if([name isEqualToString:@"imageCover"]){
        self.imageHeaderBackground.alpha = 0.0;
        [self.imageHeaderBackground setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.containerA.frame.origin.y)];
        //self.imageHeaderBackground.contentMode = UIViewContentModeCenter;
        self.imageHeaderBackground.contentMode = UIViewContentModeScaleAspectFill;
        self.imageHeaderBackground.image = image;
        [DC animationAlpha:self.imageHeaderBackground];
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
    NSLog(@"dismissing keyboard %f",self.containerA.frame.origin.x);
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
-(void)disableAllButton{
    self.buttonAccedi.enabled = NO;
    self.buttonFacebookLogin.enabled = NO;
    self.buttonIscriviti.enabled = NO;
}
-(void)enableAllButton{
    self.buttonAccedi.enabled = YES;
    self.buttonFacebookLogin.enabled = YES;
    self.buttonIscriviti.enabled = YES;
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

-(void)animationChangePage:(UIView *)containerON
{
    animationActive = YES;
    CGRect frameContainerON;
    CGRect frameContainerOFF;
    CGRect frameTriangle = self.imageTriangle.frame;
    if(containerON == self.containerA){
        NSLog(@"containerA ON");
        frameContainerON = CGRectMake(0, self.containerA.frame.origin.y, self.containerA.frame.size.width, self.containerA.frame.size.height);
        frameContainerOFF = CGRectMake(-self.containerB.frame.size.width, self.containerB.frame.origin.y, self.containerB.frame.size.width, self.containerB.frame.size.height);
        self.containerA.frame = CGRectMake(frameContainerON.size.width, frameContainerON.origin.y, frameContainerON.size.width, frameContainerON.size.height);
        CGFloat posXTriangle = (self.buttonAccedi.frame.origin.x+self.buttonAccedi.frame.size.width/2)-self.imageTriangle.frame.size.width/2;
        frameTriangle = CGRectMake(posXTriangle, self.imageTriangle.frame.origin.y, self.imageTriangle.frame.size.width, self.imageTriangle.frame.size.height);
    }
    else{
        NSLog(@"containerB ON");
        frameContainerON = CGRectMake(0, self.containerB.frame.origin.y, self.containerB.frame.size.width, self.containerB.frame.size.height);
        frameContainerOFF = CGRectMake(self.containerA.frame.size.width, self.containerA.frame.origin.y, self.containerA.frame.size.width, self.containerA.frame.size.height);
        self.containerB.frame = CGRectMake(-frameContainerON.size.width, frameContainerON.origin.y, frameContainerON.size.width, frameContainerON.size.height);
        [self.containerB setHidden:NO];
        CGFloat posXTriangle = (self.buttonIscriviti.frame.origin.x+self.buttonIscriviti.frame.size.width/2)-self.imageTriangle.frame.size.width/2;
        frameTriangle = CGRectMake(posXTriangle, self.imageTriangle.frame.origin.y, self.imageTriangle.frame.size.width, self.imageTriangle.frame.size.height);
    }
    [UIView animateWithDuration:0.5
                     animations:^{
                         if(containerON == self.containerA){
                             self.containerA.frame = frameContainerON;
                             self.containerB.frame = frameContainerOFF;
                         }else{
                             NSLog(@"containerB ON");
                             self.containerB.frame = frameContainerON;
                             self.containerA.frame = frameContainerOFF;
                         }
                         self.imageTriangle.frame = frameTriangle;
                     }
                     completion:^(BOOL finished){
                         animationActive = NO;
                     }];
}

//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START SESSION
//--------------------------------------------------------------------//
-(void)saveSessionToken{
    NSLog(@"ENTRATO");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [PFUser currentUser].sessionToken;
    [defaults setObject:sessionToken forKey:@"sessionToken"];
    [defaults synchronize];
}

-(void)deleteSessionToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionToken"];
    [defaults synchronize];
}

- (void)checkAutenticate{
    NSString *sessionToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionToken"];
    NSLog(@"initialize current user ----> : %@", sessionToken);
    if (!sessionToken) {
        NSLog(@"toLogin %@",self);
        if([PFUser currentUser]){
            [self showWaiting:nil];
            [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self hideWaiting];
                [PFUser logOut];
                //[self dismissViewControllerAnimated:YES completion:nil];
            }];
        }else{
            //[self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}
//--------------------------------------------------------------------//
//END SESSION
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FACEBOOK LOGIN
//--------------------------------------------------------------------//
- (void)facebookLogin{
    [self disableAllButton];
    [self showWaiting:NSLocalizedStringFromTable(@"AutenticazioneInCorso", @"CZ-AuthenticationLocalizable", @"")];
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];// @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self hideWaiting];
        [self enableAllButton];
        if (!user) {
            errorMessage = nil;
            if (!error) {
                errorMessage = NSLocalizedStringFromTable(@"FacebookLoginCancellato", @"CZ-AuthenticationLocalizable", @"");
                [self animationMessageError:errorMessage];
            } else {
                errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"FacebookConnectionError", @"CZ-AuthenticationLocalizable", @"")];//[error localizedDescription];
                [self animationMessageError:errorMessage];
            }
        } else {
            if (user.isNew) {
                [self performSegueWithIdentifier:@"toSignInUser" sender:self];
            } else {
                [self saveSessionToken];
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }
    }];
}
//--------------------------------------------------------------------//
//END FACEBOOK LOGIN
//--------------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString: @"firstTable"])
//    {
//        self.firstTableViewController = segue.destinationViewController;
//        self.firstTableViewController.delegate =self;
//    }
    if ([[segue identifier] isEqualToString:@"toSignInUser"]) {
        NSLog(@"prepareForSegue toSignInUser");
        //UINavigationController *nc = [segue destinationViewController];
        //CZSignInTVC *vc = (CZSignInTVC *)[[nc viewControllers] objectAtIndex:0];
        //vc.email = [PFUser currentUser].email;
        
    } else if ([[segue identifier] isEqualToString:@"toWebView"]) {
        //        UINavigationController *nc = [segue destinationViewController];
        //        DDPWebPagesVC *vc = (DDPWebPagesVC *)[[nc viewControllers] objectAtIndex:0];
        //        //DDPWebPagesVC *vc = (DDPWebPagesVC *)[segue destinationViewController];
        //        vc.urlPage = [self getUrlPageRememberPassword];
    }
}



- (IBAction)actionLogin:(id)sender {
    NSLog(@"actionSignin %f - %f - %f",self.containerB.frame.origin.x, self.imageTriangle.frame.origin.x, posXTriangleStart );
    if(!(self.imageTriangle.frame.origin.x == posXTriangleStart)  && animationActive==NO ){
        [self animationChangePage:self.containerA];
    }
    
}

- (IBAction)actionSignin:(id)sender {
    NSLog(@"actionSignin %f - %f - %f",self.containerB.frame.origin.x, self.imageTriangle.frame.origin.x, posXTriangleStart );
    if((self.imageTriangle.frame.origin.x == posXTriangleStart) && animationActive==NO ){
        [self animationChangePage:self.containerB];
    }
}

- (IBAction)actionFacebookLogin:(id)sender {
     [self facebookLogin];
}

- (IBAction)actionExit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self checkAutenticate];
    }];
}

- (IBAction)unwindToAuthenticationVC:(UIStoryboardSegue*)sender{
     NSLog(@"unwindToAuthenticationVC");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc{
    NSLog(@"DEALLOC");
}

@end
