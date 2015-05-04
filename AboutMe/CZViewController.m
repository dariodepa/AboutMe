//
//  CZViewController.m
//  AboutMe
//
//  Created by Dario De pascalis on 01/05/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZViewController.h"

@interface CZViewController ()

@end

@implementation CZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    originalH = self.imgBck.frame.size.height;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    NSLog(@"scrollViewDidScroll ::: %f", scrollOffset);
    CGRect headerImageFrame = self.imgBck.frame;
    if (scrollOffset < 0) {
        // Adjust image proportionally
        //headerImageFrame.origin.y = _headerImageYOffset - ((scrollOffset / 3));
       // headerImageFrame.size.height =defaultH-scrollOffset;
    //} else {
        // We're scrolling up, return to normal behavior
        // headerImageFrame.origin.y = _headerImageYOffset - scrollOffset;
       headerImageFrame = CGRectMake(0, 0, self.view.frame.size.width, originalH-scrollOffset);
       // headerImageFrame.origin.y = scrollOffset;
    }
   self.imgBck.frame = headerImageFrame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
