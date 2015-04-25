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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deleteSessionToken];
    NSLog(@"viewDidLoad %f",self.containerB.frame.origin.x);
    [self initialize];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear %f",self.containerB.frame.origin.x);
    posXTriangleStart = (self.buttonAccedi.frame.origin.x+self.buttonAccedi.frame.size.width/2)-self.imageTriangle.frame.size.width/2;
    self.imageTriangle.frame = CGRectMake(posXTriangleStart, self.imageTriangle.frame.origin.y, self.imageTriangle.frame.size.width, self.imageTriangle.frame.size.height);
    //[self checkAutenticate]; da attivare al pulsante chiudi
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    posXTriangleStart = (self.buttonAccedi.frame.origin.x+self.buttonAccedi.frame.size.width/2)-self.imageTriangle.frame.size.width/2;
//    self.imageTriangle.frame = CGRectMake(posXTriangleStart, self.imageTriangle.frame.origin.y, self.imageTriangle.frame.size.width, self.imageTriangle.frame.size.height);
    //[self.containerB setHidden:YES];
    self.containerB.frame = CGRectMake(-self.view.frame.size.width, self.containerB.frame.origin.y, self.containerB.frame.size.width, self.containerB.frame.size.height);
    NSLog(@"viewDidAppear %f",self.containerB.frame.origin.x);
}

-(void)initialize{
    animationActive = NO;
    [self setMessageError];
    [self.buttonAccedi setTitle:NSLocalizedString(@"ACCEDI", nil) forState:UIControlStateNormal];
    [self.buttonIscriviti setTitle:NSLocalizedString(@"ISCRIVITI", nil) forState:UIControlStateNormal];
    NSLog(@"children : %@", self.childViewControllers);
    //CZSignInEmailVC *contentSigninEmailVC = [self.childViewControllers objectAtIndex:0];
    //contentSigninEmailVC.delegate = self;
    CZLoginVC *contentLoginVC = [self.childViewControllers objectAtIndex:1];
    contentLoginVC.delegate = self;
    [self addGestureRecognizerToView];
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
//START SEND LOGIN AND PSW
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
            [[PFUser currentUser] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [PFUser logOut];
            }];
        }
    }
}
//--------------------------------------------------------------------//
//END SEND LOGIN AND PSW
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FACEBOOK LOGIN
//--------------------------------------------------------------------//
- (void)facebookLogin{
    [self disableAllButton];
    [self showWaiting:NSLocalizedString(@"Autenticazione in corso...", nil)];
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];// @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self hideWaiting];
        [self enableAllButton];
        if (!user) {
            errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
                [self animationMessageError:errorMessage];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"FacebookConnectionError", nil)];//[error localizedDescription];
                [self animationMessageError:errorMessage];
            }
        } else {
             NSLog(@"User :: %@",user);
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                [self performSegueWithIdentifier:@"toSignInUser" sender:self];
            } else {
                NSLog(@"User with facebook logged in!");
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
    NSLog(@"actionLogin %f",self.containerB.frame.origin.x);
    if(!(self.imageTriangle.frame.origin.x == posXTriangleStart)  && animationActive==NO ){
        [self animationChangePage:self.containerA];
    }
    
}

- (IBAction)actionSignin:(id)sender {
    NSLog(@"actionSignin %f",self.containerB.frame.origin.x );
    if((self.imageTriangle.frame.origin.x == posXTriangleStart) && animationActive==NO ){
        [self animationChangePage:self.containerB];
    }
}

- (IBAction)actionFacebookLogin:(id)sender {
     [self facebookLogin];
}



- (void)dealloc{
    NSLog(@"DEALLOC");
}

@end
