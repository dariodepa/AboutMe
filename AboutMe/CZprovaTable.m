//
//  CZprovaTable.m
//  AboutMe
//
//  Created by Dario De pascalis on 02/05/15.
//  Copyright (c) 2015 Dario De Pascalis. All rights reserved.
//

#import "CZprovaTable.h"

@interface CZprovaTable ()

@end

@implementation CZprovaTable

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;//self.cells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=(UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *identifierCell = [cell reuseIdentifier];
    if([identifierCell isEqualToString:@"idCellPassword"]){
    }
    if([identifierCell isEqualToString:@"idCellHeader"]){
        return 190.0;
    }
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     UITableViewCell *cell=(UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    NSLog(@"scrollViewDidScroll ::: %f", scrollOffset);
//    CGRect headerImageFrame = self.viewHeader.frame;
//    
//    headerImageFrame.origin.y = -200;
//    if (scrollOffset < 0) {
//        // Adjust image proportionally
//        headerImageFrame.origin.y = -200;//_headerImageYOffset - ((scrollOffset / 3));
//        headerImageFrame.size.height =defaultH-scrollOffset;
//    } else {
//        // We're scrolling up, return to normal behavior
//        // headerImageFrame.origin.y = _headerImageYOffset - scrollOffset;
//    }
//    self.viewHeader.frame = headerImageFrame;
}



@end
