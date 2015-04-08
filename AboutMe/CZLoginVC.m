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

    self.textUsername.placeholder = NSLocalizedString(@"Nome utente", nil);
    self.textPassword.placeholder = NSLocalizedString(@"Password", nil);
    
    [self addGestureRecognizerToView];
    [self addControllChangeTextField:self.textUsername];
    [self addControllChangeTextField:self.textPassword];
    
    self.buttonRememberPassword.hidden = NO;
    self.buttonEnter.hidden = YES;
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
    [textField resignFirstResponder];
    return YES;
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
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START SEND LOGIN AND PSW
//--------------------------------------------------------------------//
-(void)loginViewController{
    NSLog(@"loginViewController");

    [self.delegate showWaiting:NSLocalizedString(@"Autenticazione in corso...", nil)];
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
                                            NSString *errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Username e/o password errate", nil)];
                                            [self.delegate animationMessageError:errorMessage];
                                        }
                                    }];
}

//--------------------------------------------------------------------//
//END SEND LOGIN AND PSW
//--------------------------------------------------------------------//



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toSignInUser"]) {
        NSLog(@"prepareForSegue toSignInUser");
        //UINavigationController *nc = [segue destinationViewController];
        //CZSignInTVC *vc = (CZSignInTVC *)[[nc viewControllers] objectAtIndex:0];
    } else if ([[segue identifier] isEqualToString:@"toWebView"]) {
                UINavigationController *nc = [segue destinationViewController];
                DDPWebPagesVC *vc = (DDPWebPagesVC *)[[nc viewControllers] objectAtIndex:0];
                //DDPWebPagesVC *vc = (DDPWebPagesVC *)[segue destinationViewController];
                vc.urlPage = @"www.google.it";//[self getUrlPageRememberPassword];
    }
}

- (IBAction)actionEnter:(id)sender {
    //NSLog(@"XXX %@",master);
    //[self.delegate animationMessageError:@"ciao"];
    [self loginViewController];
}

- (IBAction)actionRememberPassword:(id)sender {
    [self dismissKeyboard];
    [self performSegueWithIdentifier:@"toWebView" sender:self];
}

- (void)dealloc{
    self.textPassword.delegate = nil;
    self.textUsername.delegate = nil;
}
@end
