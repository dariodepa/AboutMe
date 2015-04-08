//
//  CZswapvc.m
//  AboutMe
//
//  Created by Dario De pascalis on 04/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZswapvc.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MBProgressHUD.h"


@interface CZswapvc ()
@end

@implementation CZswapvc

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    //self.currentSegueIdentifier =  111;
//    //[self performSegueWithIdentifier : self.currentSegueIdentifier mittente : nil ];
//
//    //self.containerB.hidden = YES;
//    // Do any additional setup after loading the view.
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

-(void)initialize{
    [self.buttonAccedi setTitle:NSLocalizedString(@"ACCEDI", nil) forState:UIControlStateNormal];
    [self.buttonIscriviti setTitle:NSLocalizedString(@"ISCRIVITI", nil) forState:UIControlStateNormal];
       NSLog(@"children : %@", self.childViewControllers);
    
    CZSignInEmailVC *contentSigninEmailVC = [self.childViewControllers objectAtIndex:0];
    contentSigninEmailVC.delegate = self;
    
    CZLoginVC *contentLoginVC = [self.childViewControllers objectAtIndex:1];
    contentLoginVC.delegate = self;
    
}

//--------------------------------------------------------------------//
//START TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//

//--------------------------------------------------------------------//
//END TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FUNCTIONS
//--------------------------------------------------------------------//
-(void)animationMessageError:(NSString *)msg{
    NSLog(@"animationMessageError: %@", msg);
    self.labelError.text = msg;
    self.viewError.alpha = 0.0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.viewError.alpha = 0.9;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:3.0
                                          animations:^{
                                              self.viewError.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.5
                                                               animations:^{
                                                                   self.viewError.alpha = 0.0;
                                                                    //NSLog(@"self.viewError: %@", self.viewError);
                                                               }];
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
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START SEND LOGIN AND PSW
//--------------------------------------------------------------------//
-(void)saveSessionToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [PFUser currentUser].sessionToken;
    [defaults setObject:sessionToken forKey:@"sessionToken"];
    [defaults synchronize];
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
            NSString *errorMessage = nil;
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

//- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated {
//    UserDetailsViewController *detailsViewController = [[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:detailsViewController animated:animated];
//}


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
    } else if ([[segue identifier] isEqualToString:@"toWebView"]) {
        //        UINavigationController *nc = [segue destinationViewController];
        //        DDPWebPagesVC *vc = (DDPWebPagesVC *)[[nc viewControllers] objectAtIndex:0];
        //        //DDPWebPagesVC *vc = (DDPWebPagesVC *)[segue destinationViewController];
        //        vc.urlPage = [self getUrlPageRememberPassword];
    }
}


-(void)prova{
    NSLog(@"prova");

}

- (IBAction)actionSignIn:(id)sender {
    NSLog(@"actionIscriviti");
    //[self performSegueWithIdentifier:@"toInsertEmail" sender:self];
    //[self.navigationController performSegueWithIdentifier:@"toSignInUser" sender:self];
}


- (IBAction)actionLogin:(id)sender {
    [self.containerA setHidden:YES];
    [self.containerB setHidden:NO];
    
}

- (IBAction)actionSignin:(id)sender {
    [self.containerA setHidden:NO];
    [self.containerB setHidden:YES];
}

- (IBAction)actionFacebookLogin:(id)sender {
     [self facebookLogin];
}


-(void)swapViewContainers:(id)swapButton {
    UIView *fromView = nil;
    UIView *toView = nil;
    NSString *swapButtonTitle = nil;
    
    if ([[swapButton title] isEqualToString:@"Swap A"]) {
        fromView = [self containerA];
        toView = [self containerB];
        swapButtonTitle = @"Swap B";
//        self.containerA.hidden = YES;
//        self.containerB.hidden = NO;
    } else {
        fromView = [self containerB];
        toView = [self containerA];
        swapButtonTitle = @"Swap A";
//        self.containerA.hidden = NO;
//        self.containerB.hidden = YES;
    }
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        if (finished) {
                            [swapButton setTitle:swapButtonTitle];
                            
                        }
                    }];
}

- (void)dealloc{
}

@end
