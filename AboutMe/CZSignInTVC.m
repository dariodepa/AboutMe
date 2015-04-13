//
//  CZSignInTVC.m
//  AboutMe
//
//  Created by Dario De pascalis on 29/03/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZSignInTVC.h"
#import "CZAuthenticationDC.h"
#import "MBProgressHUD.h"

@interface CZSignInTVC ()
@end

@implementation CZSignInTVC



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textNameComplete.delegate = self;
    self.textPassword.delegate = self;
    self.textEmail.delegate = self;
    self.textUsername.delegate = self;
    DC = [[CZAuthenticationDC alloc] init];
    //add view message
    [self.view addSubview:self.viewError];
    [self initialize];
}

-(void)initialize{
    if(self.email){
        self.textEmail.text = self.email;
    }
    self.imageProfile.userInteractionEnabled = TRUE;
    UITapGestureRecognizer* tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(didTapImage)];
    [self.imageProfile addGestureRecognizer:tapRec];
    // init the action menu & profile image
    //[self resetUserPhoto];
    
    self.textNameComplete.placeholder = NSLocalizedString(@"Nome completo", nil);
    self.textUsername.placeholder = NSLocalizedString(@"Username", nil);
    self.textEmail.placeholder = NSLocalizedString(@"Email", nil);
    self.textPassword.placeholder = NSLocalizedString(@"Password", nil);
    
    [self addGestureRecognizerToView];
    [self addControllChangeTextField:self.textNameComplete];
    [self addControllChangeTextField:self.textEmail];
    [self addControllChangeTextField:self.textPassword];
    self.buttonNext.enabled = NO;
}

//--------------------------------------------------------------------//
//START FUNCTIONS
//--------------------------------------------------------------------//
-(void)animationMessageError:(NSString *)msg{
    NSLog(@"animationMessageError: %@", msg);
    //CGRect startFrame = self.viewError.frame;
    CGRect startFrame = CGRectMake(0, -50,  self.view.frame.size.width, 50);
    CGRect endFrame = CGRectMake(0, 0,  self.view.frame.size.width, 50);
    self.viewError.frame = startFrame;
    
    self.labelError.text = msg;
    self.viewError.alpha = 0.0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.viewError.alpha = 0.9;
                         self.viewError.frame = endFrame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"self.viewError: %@", self.viewError);
                         [UIView animateWithDuration:3.0
                                          animations:^{
                                              self.viewError.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.5
                                                               animations:^{
                                                                   self.viewError.alpha = 0.0;
                                                                   NSLog(@"self.viewError: %@", self.viewError);
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
    if(self.textUsername.text.length==0 || self.textNameComplete.text.length==0 || self.textPassword.text.length==0 || self.textEmail.text==0){
        self.buttonNext.enabled = NO;
    }else{
        self.buttonNext.enabled = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    if(self.textUsername.text.length==0){
        self.imageUsername.image = [UIImage imageNamed:@"username"];
    }
    if(self.textNameComplete.text.length==0){
        self.imageNameComplete.image = [UIImage imageNamed:@"badge"];
    }
    if(self.textPassword.text.length==0){
        self.imagePassword.image = [UIImage imageNamed:@"password"];
    }
    if(self.textEmail.text==0){
        self.imageEmail.image = [UIImage imageNamed:@"mail"];
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear");
    return YES;
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
-(BOOL)validEmail:(NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL)validateForm {
    NSLog(@"switchTermOfUse STATE: %u", self.switchTermOfUse.on);
    NSString *errorMessage ;
    NSString *usernameValue = [self.textUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *nameValue = [self.textNameComplete.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *emailValue = [self.textEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passwordValue = [self.textPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![self validEmail:emailValue]) {
        self.imageEmail.image = [UIImage imageNamed:@"mail_red"];
        errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Email errata", nil)];
        [self animationMessageError:errorMessage];
        return false;
    }else{
        self.imageEmail.image = [UIImage imageNamed:@"mail_green"];
    }
    if ([usernameValue isEqualToString:@""] || usernameValue.length<MIN_CHARS_USERNAME) {
        self.imageUsername.image = [UIImage imageNamed:@"username_red"];
        errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Username non valida. L'username deve essere di almeno %d caratteri", nil), MIN_CHARS_USERNAME];
        [self animationMessageError:errorMessage];
        return false;
    }else{
        self.imageUsername.image = [UIImage imageNamed:@"username_green"];
    }
    if([passwordValue isEqualToString:@""] || passwordValue.length<MIN_CHARS_PASSWORD) {
        self.imagePassword.image = [UIImage imageNamed:@"password_red"];
        errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Password non valida. La password deve essere di almeno %d caratteri", nil), MIN_CHARS_PASSWORD];
        [self animationMessageError:errorMessage];
        return false;
    }else{
        self.imagePassword.image = [UIImage imageNamed:@"password_green"];
    }
    if ([nameValue isEqualToString:@""] || nameValue.length<MIN_CHARS_NAMECOMPLETE) {
        self.imageNameComplete.image = [UIImage imageNamed:@"badge_red"];
        errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Nome Utente non valido", nil)];
        [self animationMessageError:errorMessage];
        return false;
    }else{
        self.imageNameComplete.image = [UIImage imageNamed:@"badge_green"];
    }
    if (self.switchTermOfUse.on==NO) {
        errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Devi accettare i termini e le condizioni d'uso", nil)];
        [self animationMessageError:errorMessage];
        return false;
    }
    return true;
}
//--------------------------------------------------------------------//
//END FUNCTIONS
//--------------------------------------------------------------------//



//-------------------------------------------------------------------//
//START FUNCTION IMAGE PROFILE
//-------------------------------------------------------------------//
-(void)didTapImage {
    NSLog(@"tapped");
    takePhotoMenu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"CancelLKey", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TakePhotoLKey", nil), NSLocalizedString(@"PhotoFromGalleryLKey", nil), NSLocalizedString(@"RemoveProfilePhotoLKey", nil), nil];
    takePhotoMenu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [takePhotoMenu showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Alert Button!");
    NSString *option = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([option isEqualToString:NSLocalizedString(@"TakePhotoLKey", nil)]) {
        NSLog(@"Take Photo");
        [self takePhoto];
    }
    else if ([option isEqualToString:NSLocalizedString(@"PhotoFromGalleryLKey", nil)]) {
        NSLog(@"Choose from Gallery");
        [self chooseExisting];
    }
    else if ([option isEqualToString:NSLocalizedString(@"RemoveProfilePhotoLKey", nil)]) {
        NSLog(@"Choose from Gallery");
        [self resetUserPhoto];
    }
}

-(void)resetUserPhoto {
    self.imageProfile.image = nil;
    //UIImage *image = [UIImage imageNamed:@"noProfile.jpg"];
    //CGSize newSize = CGSizeMake(280,280);
    //self.photoProfile.image =[DDPImage scaleAndCropImage:image intoSize:newSize];
    //[imageTool saveImageWithoutDelegate:nil nameImage:NAME_IMAGE_PROFILE key:KEY_IMAGE_PROFILE];
}

- (void)takePhoto {
    if (imagePickerController == nil) {
        [self initializeCamera];
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)chooseExisting {
    if (photoLibraryController == nil) {
        [self initializePhotoLibrary];
    }
    [self presentViewController:photoLibraryController animated:YES completion:nil];
}

-(void)initializeCamera {
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
}

-(void)initializePhotoLibrary {
    photoLibraryController = [[UIImagePickerController alloc] init];
    photoLibraryController.delegate = self;
    photoLibraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoLibraryController.allowsEditing = YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"imagePickerController");
    //self.image = selectedImage;
    UIImage *image = [[UIImage alloc] init];
    //image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = [UIImage imageNamed:@"noProfile.jpg"];
    }
    self.imageProfile.image = image;
    //CGSize newSize = CGSizeMake(280,280);
    //self.photoProfile.image = [DDPImage scaleAndCropImage:image intoSize:newSize];
    //[imageTool customRoundImage:self.photoProfile];
    //self.applicationContext.myImageProfile = image;
    [DC saveImageWithoutDelegate:image nameImage:NAME_IMAGE_PROFILE key:KEY_IMAGE_PROFILE];
}


//-(void)loadImageProfile{
//    imageTool.delegate = self;
//    if([[PFUser currentUser] objectForKey:@"image"] && !([[PFUser currentUser] objectForKey:@"image"]==nil)){
//        HUD = [[MBProgressHUD alloc] initWithView:self.photoProfile];
//        [self.photoProfile addSubview:HUD];
//        HUD.mode = MBProgressHUDModeDeterminate;
//        HUD.delegate = self;
//        [HUD show:YES];
//        PFFile *imageView = [[PFUser currentUser] objectForKey:@"image"];
//        [imageTool loadImage:imageView];
//        NSLog(@"11111111-load image");
//    }else{
//        [HUD hide:YES];
//        UIImage *image = [UIImage imageNamed:@"noProfile.jpg"];
//        CGSize newSize = CGSizeMake(280,280);
//        self.photoProfile.image =[DDPImage scaleAndCropImage:image intoSize:newSize];
//        [imageTool customRoundImage:self.photoProfile];
//        self.applicationContext.myImageProfile = image;
//    }
//}


//+++++++++++++++++++++++++++++++++++++++//
//DELEGATE DDPImageDownloaderDelegate
//+++++++++++++++++++++++++++++++++++++++//
//-(void)refreshImage:(NSData *)imageData
//{
//    [HUD hide:YES];
//    UIImage *image = [UIImage imageWithData:imageData];
//    CGSize newSize = CGSizeMake(280,280);
//    self.photoProfile.image =[DDPImage scaleAndCropImage:image intoSize:newSize];
//    [imageTool customRoundImage:self.photoProfile];
//    self.applicationContext.myImageProfile = image;
//    [imageTool saveImageWithoutDelegate:self.photoProfile.image nameImage:NAME_IMAGE_PROFILE key:KEY_IMAGE_PROFILE];
//}
//
//- (void)setProgressBar:(NSIndexPath *)indexPath progress:(float)progress
//{
//    HUD.progress = progress;
//    NSLog(@"progress %f", progress);
//}
//+++++++++++++++++++++++++++++++++++++++//
//-------------------------------------------------------------------//
//END FUNCTION IMAGE PROFILE
//-------------------------------------------------------------------//


//--------------------------------------------------------------------//
//START SIGNIN
//--------------------------------------------------------------------//
- (void)registrationUser {
    [self showWaiting:NSLocalizedString(@"Registrazione in corso...", nil)];
    NSString *nameValue = [self.textNameComplete.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *usernameValue = [self.textUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *emailValue = [self.textEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passwordValue = [self.textPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    PFUser *user = [PFUser user];
    user.username = usernameValue;
    user.password = passwordValue;
    user.email = emailValue;
    // other fields can be set just like with PFObject
    user[@"name"] = nameValue;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self hideWaiting];
        if (!error) {
            NSLog(@"ENTRATO");
            [self saveSessionToken];
            [self dismissViewControllerAnimated:YES completion:nil];
            // Hooray! Let them use the app now.
        } else {
            NSString *errorMessage = [error userInfo][@"error"];
                NSNumber *errorCode = [error userInfo][@"code"];
            if([errorCode  isEqual: @202]){
                errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Username '%@' già in uso", nil), usernameValue];
                self.imageUsername.image = [UIImage imageNamed:@"username_red"];
            }else if([errorCode  isEqual: @203]){
                errorMessage =  [NSString stringWithFormat:NSLocalizedString(@"Email '%@' già presente", nil), emailValue];
                self.imageEmail.image = [UIImage imageNamed:@"email_red"];
            }
            [self animationMessageError:errorMessage];
        }
    }];
}

-(void)saveSessionToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionToken = [PFUser currentUser].sessionToken;
    [defaults setObject:sessionToken forKey:@"sessionToken"];
    [defaults synchronize];
}
//--------------------------------------------------------------------//
//END SIGNIN
//--------------------------------------------------------------------//


//-------------------------------------------------------------------//
//START FUNCTION BUILD TABLE
//-------------------------------------------------------------------//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *identifierCell = [cell reuseIdentifier];
    if([identifierCell isEqualToString:@"idCellPassword"]){
        if(self.email){
            //return 0.0;
       }
    }
    if([identifierCell isEqualToString:@"idCellHeader"]){
        return 190.0;
    }
    return 40.0;
}

//-------------------------------------------------------------------//
//END FUNCTION BUILD TABLE
//-------------------------------------------------------------------//



- (IBAction)actionPreviou:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionNext:(id)sender {
    if([self validateForm]){
        [self registrationUser];
    }
}
@end
