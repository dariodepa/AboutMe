//
//  CZLoginVC.m
//  AboutMe
//
//  Created by Dario De pascalis on 04/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZLoginVC.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "DDPWebPagesVC.h"

@interface CZLoginVC ()
@end

@implementation CZLoginVC

- (BOOL)prefersStatusBarHidden {
    return YES;
}

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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear LOGIN");
}

-(void)initialize{
    self.textUsername.placeholder = NSLocalizedStringFromTable(@"NomeUtente", @"CZ-AuthenticationLocalizable", @"");
    self.textPassword.placeholder = NSLocalizedStringFromTable(@"Password", @"CZ-AuthenticationLocalizable", @"");
    [self.buttonRememberPassword setTitle:NSLocalizedStringFromTable(@"PasswordDimenticata", @"CZ-AuthenticationLocalizable", @"") forState:UIControlStateNormal];
    [self addGestureRecognizerToView];
    [self addControllChangeTextField:self.textUsername];
    [self addControllChangeTextField:self.textPassword];
    self.buttonRememberPassword.hidden = NO;
    self.buttonEnter.hidden = YES;
}

-(void)setMessageError:(NSString*)msgError
{
    //errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Email non corretta", nil)];//[error localizedDescription];
    viewError = [[UIView alloc] init];
    viewError.frame = CGRectMake(0, 0, self.view.frame.size.width, 66);
    viewError.backgroundColor = [UIColor redColor];
    viewError.alpha = 0;
    labelError = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, (self.view.frame.size.width-10), 56)];
    [labelError setTextColor:[UIColor whiteColor]];
    [labelError setBackgroundColor:[UIColor clearColor]];
    [labelError setFont:[UIFont fontWithName: @"Helvetica Neue" size: 14.0f]];
    labelError.text = msgError;
    labelError.textAlignment = NSTextAlignmentCenter;
    labelError.numberOfLines = 3;
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
    if (textField.tag == 2 && ([self.textPassword.text length]>0) && ([self.textUsername.text length]>0)) {
        self.buttonRememberPassword.hidden = YES;
        self.buttonEnter.hidden = NO;
    }
    else if(([self.textPassword.text length]>0) && ([self.textUsername.text length]>0)){
        self.buttonRememberPassword.hidden = YES;
        self.buttonEnter.hidden = NO;
    }else{
        self.buttonRememberPassword.hidden = NO;
        self.buttonEnter.hidden = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [self loginViewController];
    //[textField resignFirstResponder];
    return YES;
}
-(UIButton *)enableButton:(UIButton *)button{
    button.enabled = YES;
    //button.hidden = NO;
    [button setAlpha:1];
    return button;
}

-(UIButton *)disableButton:(UIButton *)button{
    button.enabled = NO;
    //button.hidden = YES;
    [button setAlpha:0.5];
    return button;
}
//--------------------------------------------------------------------//
//END TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START FUNCTIONS
//--------------------------------------------------------------------//
//-(NSString*)getUrlPageRememberPassword{
//    NSDictionary *settingsDictionary = [self.applicationContext.plistDictionary objectForKey:@"Settings"];
//    NSString *urlPageForgotPassword = [settingsDictionary valueForKey:@"urlPageForgotPassword"];
//    NSString *urlWeb=[NSString stringWithFormat:@"%@%@/%@?tenant=%@&domain=%@", hostSite, path, urlPageForgotPassword, tenant, domain];
//    NSString *urlForgotPassword = [urlWeb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlForgotPassword:%@", urlForgotPassword);
//    return urlForgotPassword;
//}

-(void)animationMessageError:(NSString *)msg{
    //startedAnimation = YES;
    [self disableButton:self.buttonEnter];
    [self setMessageError:msg];
    viewError.alpha = 0.0;
    [UIView animateWithDuration:0.5
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
                                              [self enableButton:self.buttonEnter];
                                          }];
                     }];
}
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START SEND LOGIN AND PSW
//--------------------------------------------------------------------//
-(void)loginViewController{
    NSLog(@"loginViewController");
    [self.delegate showWaiting:NSLocalizedStringFromTable(@"AutenticazioneInCorso", @"CZ-AuthenticationLocalizable", @"")]; //]NSLocalizedString(@"Autenticazione in corso...", nil)];
    self.buttonEnter.enabled = NO;
    NSString *username = [self.textUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passwordValue = [self.textPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [PFUser logInWithUsernameInBackground:username password:passwordValue
                                    block:^(PFUser *user, NSError *error) {
                                         NSLog(@"error %@",error);
                                        if (user) {
                                            NSLog(@"ENTRATO");
                                            [self.delegate hideWaiting];
                                            self.buttonEnter.enabled = YES;
                                            [self.delegate saveSessionToken];
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            //[self loginWithEmail:username psw:passwordValue];
                                            [self.delegate hideWaiting];
                                            self.buttonEnter.enabled = YES;
                                            errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"UsernamePasswordError", @"CZ-AuthenticationLocalizable", @"")];
                                            [self animationMessageError:errorMessage];
                                            //[self.delegate animationMessageError:errorMessage];
                                        }
                                    }];
}

//--------------------------------------------------------------------//
//END SEND LOGIN AND PSW
//--------------------------------------------------------------------//



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toResetPassword"]) {
        //
    } else if ([[segue identifier] isEqualToString:@"toWebView"]) {
    }
}

- (IBAction)actionEnter:(id)sender {
    [self loginViewController];
}

- (IBAction)actionRememberPassword:(id)sender {
    [self dismissKeyboard];
    [self performSegueWithIdentifier:@"toResetPassword" sender:self];
}

- (void)dealloc{
    self.textPassword.delegate = nil;
    self.textUsername.delegate = nil;
    self.delegate = nil;
}

@end
