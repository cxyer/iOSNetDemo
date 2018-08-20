//
//  ViewController.m
//  iOSNetDemo
//
//  Created by 蔡晓阳 on 2018/7/14.
//  Copyright © 2018 cxy. All rights reserved.
//

#import "ViewController.h"

#import "NSDataVC.h"
#import "NSURLConnectionVC.h"
#import "NSURLSessionVC.h"
#import "WebVC.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)NSArray *dataArr;
@end

@implementation ViewController

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"NSData",@"NSURLConnection",@"NSURLSession",@"NSURLProtocol"];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS网络请求";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        NSDataVC *vc = [[NSDataVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else if (indexPath.row == 1) {
        NSURLConnectionVC *vc = [[NSURLConnectionVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else if (indexPath.row == 2) {
        NSURLSessionVC *vc = [[NSURLSessionVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else if (indexPath.row == 3) {
        WebVC *vc = [[WebVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
}


@end
