//
//  ViewController.m
//  ACRefreshHeaderDemo
//
//  Created by 0x0 on 2017/3/21.
//  Copyright © 2017年 0x0. All rights reserved.
//

#import "ViewController.h"
#import "ACRefreshHeader.h"

@interface ViewController ()
@property (strong, nonatomic) ACRefreshHeader *refreshHeader;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshHeader = [[ACRefreshHeader alloc] initWithScrollView:self.tableView];
    [self.tableView addSubview:_refreshHeader];
    
//    [_refreshHeader startRefreshing];
//    [_refreshHeader stopRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseId = @"reuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"testCell%zd",indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
