//
//  DDPWebPagesVC.h
//  minijob
//
//  Created by Dario De pascalis on 09/07/14.
//  Copyright (c) 2014 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPWebPagesVC : UIViewController<UIWebViewDelegate>{
    UIBarButtonItem *refreshButtonItem;
    UIActivityIndicatorView *actIndicator;
    UIBarButtonItem *activityButtonItem;
}


@property (nonatomic, strong) NSString *urlPage;
@property (nonatomic, strong) NSString *titlePage;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonItemRefresh;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)actionExit:(id)sender;
- (IBAction)actionRefresh:(id)sender;

@end
