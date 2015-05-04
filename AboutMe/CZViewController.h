//
//  CZViewController.h
//  AboutMe
//
//  Created by Dario De pascalis on 01/05/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZViewController : UIViewController<UIScrollViewDelegate>{
    CGFloat originalH;
}
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIImageView *imgBck;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
