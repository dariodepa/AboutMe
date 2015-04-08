//
//  CZSignInEmailVC.m
//  AboutMe
//
//  Created by Dario De pascalis on 29/03/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZSignInEmailVC.h"
#import "CZSignInTVC.h"

@interface CZSignInEmailVC ()
@end

@implementation CZSignInEmailVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textEmail.delegate = self;
    [self initialize];
}

-(void)initialize{
    [self.buttonNext setTitle:NSLocalizedString(@"Avanti", nil) forState:UIControlStateNormal];
    self.textEmail.placeholder = NSLocalizedString(@"Inserisci la tua e-mail", nil);
    [self disableButton:self.buttonNext];
    [self.textEmail becomeFirstResponder];
    [self addControllChangeTextField:self.textEmail];
}

//--------------------------------------------------------------------//
//START TEXTFIELD CONTROLLER
//--------------------------------------------------------------------//
-(void)addControllChangeTextField:(UITextField *)textField
{
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(UITextField *)textField{
    if ([self.textEmail.text length]>0) {
        [self enableButton:self.buttonNext];
    }else{
        [self disableButton:self.buttonNext];
    }
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

-(void)dismissKeyboard{
    NSLog(@"dismissing keyboard");
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
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toSignInUser"]) {
        NSLog(@"prepareForSegue toSignInUser");
        UINavigationController *nc = [segue destinationViewController];
        CZSignInTVC *vc = (CZSignInTVC *)[[nc viewControllers] objectAtIndex:0];
        vc.email = self.textEmail.text;
    }
}

-(void)goNextStep{
    if([self validEmail:self.textEmail.text]){
        [self performSegueWithIdentifier:@"toSignInUser" sender:self];
    }else{
        NSString *errorMessage =  [NSString stringWithFormat:@"%@",NSLocalizedString(@"Email non corretta", nil)];//[error localizedDescription];
        [self.delegate animationMessageError:errorMessage];
    }
}

- (IBAction)actionNext:(id)sender {
     [self goNextStep];
}

- (void)dealloc{
    self.textEmail.delegate = nil;
}
@end
