//
//  ViewController.m
//  AboutMe
//
//  Created by Dario De pascalis on 28/03/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "CZAuthenticationVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)openAuthenticationView{
    NSLog(@"openAuthenticationView!");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    CZAuthenticationVC *vc = (CZAuthenticationVC *)[sb instantiateViewControllerWithIdentifier:@"StartAuthentication"];
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}


- (void)logoutButtonAction{
    [PFUser logOut]; // Log out
    // Return to Login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)actionGo:(id)sender {
    [self openAuthenticationView];
}

- (IBAction)buttonLogout:(id)sender {
    [self logoutButtonAction];
}

@end
