//
//  HomeViewController.m
//  UIScrollerView+TableView_Lateral_Spreads_To_Delete
//
//  Created by mac on 20/11/2018.
//  Copyright © 2018 Woodsoo. All rights reserved.
//

#import "HomeViewController.h"
#import "MyScrollView.h"
#import "TheStoreViewController.h"
#import "GoodsViewController.h"
#import "VideoViewController.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight   (SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define TopViewHeight   40
#define HomeScrollViewHeight self.homeScrollView.bounds.size.height
#define HomeScrollViewWidth  self.homeScrollView.bounds.size.width

@interface HomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;
//@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic,strong) MyScrollView *homeScrollView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) TheStoreViewController *theStoreVc;
@property (nonatomic, strong) GoodsViewController *goodVc;
@property (nonatomic, strong) VideoViewController *videoVc;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArray = @[@"店铺",@"商品",@"视频"];
//    self.controllerArray = @[[[TheStoreViewController alloc]init],[[GoodsViewController alloc]init],[[VideoViewController alloc]init]];
    [self creatTopView];
    [self createScrollView];
    [self setupChildViewControll];
    
}

-(NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
//-(NSArray *)controllerArray{
//    if (_controllerArray == nil) {
//        _controllerArray = [NSArray array];
//    }
//    return _controllerArray;
//}

-(void)creatTopView{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, TopViewHeight)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<self.titleArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0 + SCREEN_WIDTH / self.titleArray.count *i, 0, SCREEN_WIDTH / self.titleArray.count, TopViewHeight)];
        [topView addSubview:btn];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(40 , 38, 45, 2)];
    [topView addSubview:_lineView];
    _lineView.backgroundColor = [UIColor redColor];
    
}

-(void)btnClick:(UIButton *)sender{
    if (sender.tag == 100) {
        [_homeScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    }else if (sender.tag == 101){
        [_homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }else{
        [_homeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    }
    
}

#pragma mark - 创建ScrollView
-(void)createScrollView{
    
    _homeScrollView = [[MyScrollView alloc]initWithFrame:CGRectMake(0, TopViewHeight + SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TopViewHeight - SafeAreaTopHeight)];
    [self.view addSubview:_homeScrollView];
    _homeScrollView.backgroundColor = [UIColor whiteColor];
    _homeScrollView.delegate = self;
    //隐藏水平滚动条
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    _homeScrollView.showsVerticalScrollIndicator = NO;
    _homeScrollView.scrollEnabled = YES;
    //分页
    _homeScrollView.pagingEnabled = YES;
    //方向锁
    _homeScrollView.directionalLockEnabled = YES;
    //取消自动布局contentInsetAdjustmentBehavior
    _homeScrollView.contentInsetAdjustmentBehavior = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置内容尺寸
    _homeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleArray.count, SCREEN_HEIGHT - TopViewHeight - SafeAreaTopHeight);
    
}

/**
 *  设置控制的每一个子控制器
 */
- (void)setupChildViewControll{
    
    _theStoreVc = [[TheStoreViewController alloc]init];
    _goodVc = [[GoodsViewController alloc]init];
    _videoVc = [[VideoViewController alloc]init];
    //指定该控制器为其子控制器
    [self addChildViewController:_theStoreVc];
    [self addChildViewController:_goodVc];
    [self addChildViewController:_videoVc];
    
    //将视图加入ScrollView上
    [_homeScrollView addSubview:_theStoreVc.view];
    [_homeScrollView addSubview:_goodVc.view];
    [_homeScrollView addSubview:_videoVc.view];
    //设置两个控制器的尺寸
    _theStoreVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, HomeScrollViewHeight);
    _goodVc.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, HomeScrollViewHeight);
    _videoVc.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, HomeScrollViewHeight);
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = HomeScrollViewWidth;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentPage = floor((_homeScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //设置按钮颜色和横线的变化
    
    for (int i = 0; i< self.titleArray.count; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
        btn.selected = NO;
        if (_currentPage == i) {
            btn.selected = YES;

        }
    }
    [UIView animateWithDuration:.2 animations:^{
        self.lineView.frame = CGRectMake(self.currentPage * SCREEN_WIDTH/self.titleArray.count + 40, 38, 45, 2);
    }];
    
    if (scrollView == self.homeScrollView) {
        _theStoreVc.theStoreTableView.scrollEnabled = YES;
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == self.homeScrollView) {
        _theStoreVc.theStoreTableView.scrollEnabled = NO;
    }
    
}


@end
