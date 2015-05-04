//
//  CZProvaTVC.m
//  AboutMe
//
//  Created by Dario De pascalis on 02/05/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZProvaTVC.h"
#import "CZAuthenticationDC.h"

@interface CZProvaTVC ()

@end

@implementation CZProvaTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    DC = [[CZAuthenticationDC alloc] init];
    DC.delegate = self;
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFill;
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;
        self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    defaultH = self.imageBck.frame.size.height;
    self.imageBck.image = [DC blur:self.imageBck.image radius:16];
    [CZAuthenticationDC arroundImage:(self.imageProfile.frame.size.height/2) borderWidth:0.0 layer:[self.imageProfile layer]];
    //self.imageProfile.image = image;
    //self.imageBackground.alpha = 0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    NSLog(@"scrollViewDidScroll ::: %f", scrollOffset);
   
    CGRect headerImageFrame = self.imageBck.frame;

        self.imageBackground.alpha = -scrollOffset/100;
        self.viewProfile.alpha = 1+scrollOffset/150;
        //headerImageFrame.origin.y = -200;
        if (scrollOffset < 0) {
            // Adjust image proportionally
            headerImageFrame.origin.y = ((scrollOffset / 1));
            headerImageFrame.size.height =defaultH-scrollOffset;

            //self.imageBck.image = [DC blur:self.imageBck.image radius:(20+scrollOffset/2)];
            
           
        } else if (scrollOffset >= 120) {
            //self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = YES;
            self.imageBackground.contentMode = UIViewContentModeScaleAspectFill;
            [self.navigationController.navigationBar setBackgroundImage:self.imageBackground.image
                                                          forBarMetrics:UIBarMetricsDefault];
            //self.navigationController.navigationBar.shadowImage = [UIImage new];
            self.navigationController.navigationBar.contentMode = UIViewContentModeScaleAspectFill;
            self.navigationController.navigationBar.translucent = YES;
            //self.navigationController.view.backgroundColor = [UIColor clearColor];
            
            // We're scrolling up, return to normal behavior
            // headerImageFrame.origin.y = _headerImageYOffset - scrollOffset;
            //self.imageBackground.alpha = 0,35;
            //self.imageBackground.alpha -= scrollOffset/100;
        }else{
            self.extendedLayoutIncludesOpaqueBars = NO;
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                           forBarMetrics:UIBarMetricsDefault];
             self.navigationController.navigationBar.shadowImage = [UIImage new];
             self.navigationController.navigationBar.translucent = YES;
             self.navigationController.view.backgroundColor = [UIColor clearColor];
        }

        self.imageBackground.frame = headerImageFrame;
        self.imageBck.frame = headerImageFrame;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
