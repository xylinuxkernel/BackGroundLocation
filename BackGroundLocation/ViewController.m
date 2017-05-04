//
//  ViewController.m
//  BackGroundLocation
//
//  Created by 徐银 on 2017/3/23.
//  Copyright © 2017年 徐银. All rights reserved.
//

#import "ViewController.h"
#import "LocationService.h"
#import "LocationBaseInfoModel.h"

static  void * localDataSourceMontior =  &localDataSourceMontior;
#define scaleVarabile     [UIScreen mainScreen].bounds.size.width/320.0

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LocationService *_locationService;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationService = [LocationService getInstance];
    [_locationService addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:localDataSourceMontior];
    _tableView.rowHeight = 65;
    _tableView.tableFooterView = self.footerView;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(clearCache)];
    self.navigationItem.leftBarButtonItem = leftBar;
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    @try {
        [_locationService removeObserver:self forKeyPath:@"dataSource" context:localDataSourceMontior];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }@finally {
    }
}

- (void)clearCache {
    [_locationService removeArchieveData];
}

- (UIView *)footerView {
    if(!_footerView) {
        _footerView = [UIView new];
        _footerView.frame = CGRectMake(0, 0, self.view.frame.size.width , 150);
        UILabel *_footerLabel = [UILabel new];
        _footerLabel.frame = CGRectMake(20, -20, _footerView.frame.size.width - 20*2, _footerView.frame.size.height);
        _footerLabel.text = @"在APP打开\\后台，挂起或者被杀掉下测试，在后台或者被杀掉情况下大概每五百米和最多五分钟会刷新一次。(因为里面加了反地理编码，请打开蜂窝网或者连上wifi才能正常看到日志记录)";
        _footerLabel.numberOfLines = 0;
        _footerLabel.font = [UIFont systemFontOfSize:14];
        _footerLabel.textColor = [UIColor darkTextColor];
        _footerLabel.textAlignment = NSTextAlignmentCenter;
        [_footerView addSubview:_footerLabel];
    }
    return _footerView;
}

#pragma mark -- tableView delegate/dataSource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _locationService.dataSource.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionKey = _locationService.dataSource.allKeys[section];
    NSArray *locationList = _locationService.dataSource[sectionKey];
    return locationList.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView =[UIView new];
    headView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(12, 0, CGRectGetWidth(headView.frame) - 12, CGRectGetHeight(headView.frame));
    label.textColor = [UIColor grayColor];
    label.font =  [UIFont systemFontOfSize:scaleVarabile*13.0f];
    NSString *sectionKey = _locationService.dataSource.allKeys[section];
    label.text = sectionKey;
    [headView addSubview:label];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewCell" forIndexPath:indexPath];
    if(indexPath.section < [_locationService.dataSource.allKeys count]) {
        NSString *sectionKey = _locationService.dataSource.allKeys[indexPath.section];
        NSArray *locationList = _locationService.dataSource[sectionKey];
        LocationBaseInfoModel *model = (LocationBaseInfoModel *)locationList[indexPath.row] ;
        cell.textLabel.text = [NSString stringWithFormat:@"%@--%@",model.recordTime,model.appStateDescription];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@__[经度]%@[纬度]%@",model.addressInfo,model.longitude,model.latitude];
    }
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(context == localDataSourceMontior) {
        //刷新表数据....
        [_tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
