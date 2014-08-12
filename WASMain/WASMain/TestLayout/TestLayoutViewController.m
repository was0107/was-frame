//
//  ViewController.m
//  LayoutMain
//
//  Created by allen.wang on 12/4/12.
//  Copyright (c) 2012 b5m. All rights reserved.
//

#import "TestLayoutViewController.h"
#import "DetailViewControllerViewController.h"


#define kViewWithHeight(x)  [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, x)] autorelease]

static NSString *titles[] = {@"流式布局",@"边框布局",@"卡片布局",@"表格布局",@"盒式布局",@"嵌套布局",@"UIViewController"};
@interface TestLayoutViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TestLayoutViewController
@synthesize tableView = _tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"布局控件";
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-0) style:UITableViewStylePlain] autorelease ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableHeaderView = kViewWithHeight(1.0f);//[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1)] autorelease];
    self.tableView.tableFooterView =  kViewWithHeight(1.0f);//[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.1)] autorelease];
    self.tableView.sectionHeaderHeight = 0.1f;
    self.tableView.sectionFooterHeight = 0.1f;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor redColor];
        
    }
    cell.textLabel.text = titles[indexPath.row % 7];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  kViewWithHeight(1.0f);//[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.1)] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return  kViewWithHeight(1.0f);//[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.1)] autorelease];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = 6;//indexPath.row % 7;
    switch (index) {
        case 0:
        {
            DetailViewControllerViewControllerFlow *detail = [[[DetailViewControllerViewControllerFlow alloc] init] autorelease];
            detail.title = titles[index];
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
        case 1:
        {
            DetailViewControllerViewControllerBorder *detail = [[[DetailViewControllerViewControllerBorder alloc] init] autorelease];
            detail.title = titles[index];
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
        case 2:
        {
            
            DetailViewControllerViewControllerCard *detail = [[[DetailViewControllerViewControllerCard alloc] init] autorelease];         
            detail.title = titles[index];
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
        case 3:
        {
            
            DetailViewControllerViewControllerGrid *detail = [[[DetailViewControllerViewControllerGrid alloc] init] autorelease];         
            detail.title = titles[index];
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
        case 4:
        {
            DetailViewControllerViewControllerBox *detail = [[[DetailViewControllerViewControllerBox alloc] init] autorelease];
            detail.title = titles[index];
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
        case 5:
        {
            DetailViewControllerViewControllerAll *detail = [[[DetailViewControllerViewControllerAll alloc] init] autorelease];
            detail.title = titles[index];
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
            
        default:
        {
            UIViewController *detail = [[[UIViewController alloc] init] autorelease];
            detail.title = titles[index];
            detail.view.backgroundColor = [UIColor redColor];
            detail.view.transform = CGAffineTransformIdentity;
            [self.navigationController   pushViewController:detail animated:YES];
        }
            break;
    }
}
@end
