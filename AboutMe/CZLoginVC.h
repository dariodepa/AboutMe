//
//  CZLoginVC.h
//  AboutMe
//
//  Created by Dario De pascalis on 04/04/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol CZLoginDelegate
-(void)animationMessageError:(NSString *)msg;
-(void)showWaiting:(NSString *)label;
-(void)hideWaiting;
-(void)saveSessionToken;
@end

@interface CZLoginVC : UIViewController<UITextFieldDelegate>{
}

@property (nonatomic, assign) id <CZLoginDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textUsername;
@property (strong, nonatomic) IBOutlet UITextField *textPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonRememberPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonEnter;

//@property (nonatomic, assign) id <CZLoginDelegate> delegate;

- (IBAction)actionEnter:(id)sender;
- (IBAction)actionRememberPassword:(id)sender;

@end
