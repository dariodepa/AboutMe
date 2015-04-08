//
//  CZAuthenticationVC.m
//  AboutMe
//
//  Created by Dario De pascalis on 28/03/15.
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
    self.textUsername.delegate = self;
    self.textPassword.delegate = self;
    [self initialize];
}

-(void)initialize{
    [self.buttonAccedi setTitle:NSLocalizedString(@"ACCEDI", nil) forState:UIControlStateNormal];
    [self.buttonIscriviti setTitle:NSLocalizedString(@"ISCRIVITI", nil) forState:UIControlStateNormal];
    [self.buttonRemember setTitle:NSLocalizedString(@"password dimenticata?", nil) forState:UIControlStateNormal];
    [self.buttonFacebook setTitle:NSLocalizedString(@"Accedi con Facebook", nil) forState:UIControlStateNormal];
    
    self.textUsername.placeholder = NSLocalizedString(@"Nome utente", nil);
    self.textPassword.placeholder = NSLocalizedString(@"Password", nil);
    
    [self addGestureRecognizerToView];
    [self addControllChangeTextField:self.textUsername];
    [self addControllChangeTextField:self.textPassword];

    [self enableButton:self.buttonRemember];
    [self disableButton:self.buttonEnter];
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
    NSLog(@"dismissing keyboard");
    [self.view endEditing:YES];
}

-(void)addControllChangeTextField:(UITextField *)textField
{
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(UITextField *)textField{
    if (textField.tag == 2 && ([self.textPassword.text length]>0)) {
        [self disableButton:self.buttonRemember];
        [self enableButton:self.buttonEnter];
    }
    else if(([self.textPassword.text length]>0) && ([self.textUsername.text length]>0)){
        [self disableButton:self.buttonRemember];
        [self enableButton:self.buttonEnter];
    }else{
        [self enableButton:self.buttonRemember];
        [self disableButton:self.buttonEnter];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
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
//END TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FUNCTIONS
//--------------------------------------------------------------------//
-(void)animationMessageError:(NSString *)msg{
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
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START SEND LOGIN AND PSW
//--------------------------------------------------------------------//
-(void)loginViewController{
    [self showWaiting:NSLocalizedString(@"Autenticazione in corso...", nil)];
    [self.buttonEnter setEnabled:NO];
    NSString *username = [self.textUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passwordValue = [self.textPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [PFUser logInWithUsernameInBackground:username password:passwordValue
                                    block:^(PFUser *user, NSError *error) {
                                        
                                        if (user) {
                                            NSLog(@"ENTRATO");
                                            [self hideWaiting];
                                            [self.buttonEnter setEnabled:YES];
                                            [self saveSessionToken];
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            //[self loginWithEmail:username psw:passwordValue];
                                            NSString *errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Username e/o password errate", nil)];
                                            [self animationMessageError:errorMessage];
                                        }
                                    }];
}

-(void)loginWithEmail:(NSString*)username psw:(NSString *)psw{
    //NON FUNZIONA PERCHE' NN HO I PERMESSI PER LEGGERE LA PSW!!!!!!!
    NSLog(@"loginWithEmail");
    NSString *emailIdentifier = @"@";
    if ([username rangeOfString:emailIdentifier].location != NSNotFound) {
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = '%@' AND password = %@", username, psw];
        //PFQuery *query = [PFQuery queryWithClassName:@"_User" predicate:predicate];
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:username];
        [query whereKey:@"password" equalTo:@"123456"];
        //NSArray *foundUsers = [query findObjects];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self hideWaiting];
            [self.buttonEnter setEnabled:YES];
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
                NSString *errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Email e/o password errate", nil)];
                [self animationMessageError:errorMessage];
            } else {
                // The find succeeded.
                NSLog(@"LOGIN :%@", object);
                NSLog(@"Successfully retrieved the object.");
                [self saveSessionToken];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }else{
        [self hideWaiting];
        [self.buttonEnter setEnabled:YES];
        NSString *errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Username e/o password errate", nil)];
        [self animationMessageError:errorMessage];
    }
}

-(void)saveSessionToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [PFUser currentUser].sessionToken;
    [defaults setObject:sessionToken forKey:@"sessionToken"];
    [defaults synchronize];
}



//-(void)signedin:(SHPUser *)justSignedUser {
//    NSLog(@"Signin successfull!");
//    [self hideWaiting];
//    [self didSignedIn:justSignedUser];
//}
//
//-(void)didSignedIn:(SHPUser *)user {
//    NSLog(@"didSignedIn........................");
//    [self prepareSignedUser:user];
//}
//
//-(void)prepareSignedUser:(SHPUser *)user {
//    NSLog(@"prepareSignedUser. %@",self.applicationContext);
//    [self.applicationContext signin:user];
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//    [self registerOnProviderForNotifications];
//}
//
//-(void)registerOnProviderForNotifications {
//    SHPSendTokenDC *tokenDC = [[SHPSendTokenDC alloc] init];
//    NSString *langID = [[NSLocale preferredLanguages] objectAtIndex:0];
//    SHPAppDelegate *appDelegate = (SHPAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSString *devToken = appDelegate.deviceToken;
//    if (devToken) {
//        [tokenDC sendToken:devToken withUser:self.applicationContext.loggedUser lang:langID completionHandler:^(NSError *error) {
//            if (!error) {
//                NSLog(@"Successfully registered DEVICE to Provider WITH USER.");
//                
//            }
//            else {
//                NSLog(@"Error while registering devToken to Provider!");
//                [self hideWaiting];
//            }
//        }];
//    }
//}
//--------------------------------------------------------------------//
//END SEND LOGIN AND PSW
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FACEBOOK LOGIN
//--------------------------------------------------------------------//
- (void)facebookLogin{
    [self.buttonEnter setEnabled:NO];
    [self showWaiting:NSLocalizedString(@"Autenticazione in corso...", nil)];
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];// @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self hideWaiting];
        [self.buttonEnter setEnabled:YES];
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
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
            //[self _presentUserDetailsViewControllerAnimated:YES];
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



- (IBAction)actionSignIn:(id)sender {
    NSLog(@"actionIscriviti");
    [self performSegueWithIdentifier:@"toInsertEmail" sender:self];
    //[self.navigationController performSegueWithIdentifier:@"toSignInUser" sender:self];
}


- (IBAction)actionFacebook:(id)sender {
    [self facebookLogin];
}

- (IBAction)actionEnter:(id)sender{
    [self loginViewController];
}

- (void)dealloc{
    self.textPassword.delegate = nil;
    self.textUsername.delegate = nil;
}
@end
