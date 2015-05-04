//
//  CZProvaTVC.h
//  AboutMe
//
//  Created by Dario De pascalis on 02/05/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZAuthenticationDC.h"

@interface CZProvaTVC : UITableViewController<CZAuthenticationDelegate>{
    CGFloat defaultH;
    CZAuthenticationDC *DC;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageBck;
@property (strong, nonatomic) IBOutlet UIImageView *imageBackground;
@property (strong, nonatomic) IBOutlet UIView *viewProfile;
@property (strong, nonatomic) IBOutlet UIImageView *imageProfile;
@property (strong, nonatomic) IBOutlet UITableView *viewNavBar;

@end
