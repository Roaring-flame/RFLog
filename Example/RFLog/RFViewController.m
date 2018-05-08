//
//  RFViewController.m
//  RFLog
//
//  Created by xiepengxiang93@sina.com on 05/03/2018.
//  Copyright (c) 2018 xiepengxiang93@sina.com. All rights reserved.
//

#import "RFViewController.h"

@interface RFViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [NSString stringWithFormat:@"RFCell %ld",indexPath.row];
    cell.textLabel.text = text;
    NSLog(@"%@",text);
}


- (void)loadTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
    }
}

@end
