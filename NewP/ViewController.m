//
//  ViewController.m
//  NewP
//
//  Created by hao on 2017/11/4.
//  Copyright © 2017年 hao. All rights reserved.
//

#import "ViewController.h"
#import "VideoViewController.h"
#import "HotViewController.h"
#import "TopViewController.h"
#import "ReaderViewController.h"
#import "NewsViewController.h"
#define mainscreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *titleScrollview;
@property (nonatomic,strong) UIScrollView *contentScrollview;
@property (nonatomic,weak)UIButton *selectButton;
@property (nonatomic,strong) NSMutableArray *titleButtons;
@end

@implementation ViewController
-(NSMutableArray *)titleButtons{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网易新闻";
    //设置头部标题
    [self settitleViews];
    //设置中间内容
    [self setContentViews];
    //设置所以控制器
    [self setAllViewController];
    //设置所有标题
    [self setAllTitleButton];
    
//    [self setOneViewConroller:0];
}
-(void)setAllViewController{
    VideoViewController *video = [[VideoViewController alloc]init];
    video.title = @"video";
//    video.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:video];
    
    HotViewController *hot = [[HotViewController alloc]init];
    hot.title = @"hot";
//    hot.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:hot];
    
    TopViewController *top = [[TopViewController alloc]init];
    top.title = @"top";
//    top.view.backgroundColor = [UIColor orangeColor];
    [self addChildViewController:top];
    
    ReaderViewController *reader = [[ReaderViewController alloc]init];
    reader.title = @"reader";
//    reader.view.backgroundColor = [UIColor greenColor];
    [self addChildViewController:reader];
    
    NewsViewController *news = [[NewsViewController alloc]init];
    news.title=@"news";
//    news.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:news];
}
-(void)setTitlecenter:(UIButton *)button{
    CGFloat titleVeiwOffset = button.center.x - mainscreenWidth * 0.5;
    if (titleVeiwOffset < 0) {
        titleVeiwOffset = 0;
    }
    
    CGFloat maxOffset =  self.titleScrollview.contentSize.width -mainscreenWidth;
    if (titleVeiwOffset > maxOffset) {
        titleVeiwOffset = maxOffset;
    }
    
    [self.titleScrollview setContentOffset:CGPointMake(titleVeiwOffset, 0) animated:YES];
    
    
}
-(void)setButtonTile:(UIButton *)button{
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _selectButton = button;
    
    [self setTitlecenter:button];
}
-(void)setOneViewConroller:(int)number{
    UIViewController *vc = self.childViewControllers[number];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentScrollview.frame.size.height;
    vc.view.frame = CGRectMake(width*number, 0, width, height);
    [self.contentScrollview addSubview:vc.view];
}
-(void)titleClick:(UIButton *)button{
    
    [self setButtonTile:button];
    int number = (int)button.tag;
    [self setOneViewConroller:number];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.contentScrollview.contentOffset = CGPointMake(number * width, 0);
    
}
-(void)setAllTitleButton{
    int count = (int)self.childViewControllers.count;
    for (int i = 0; i<count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        UIViewController *vc = self.childViewControllers[i];
        
        [but setTitle:vc.title forState:UIControlStateNormal];
        CGFloat width = 100;
        but.frame = CGRectMake(width*i, 0, width, CGRectGetHeight(self.titleScrollview.frame));
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTag:i];
        [but addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleButtons addObject:but];
        [self.titleScrollview addSubview:but];
 
    }
    self.titleScrollview.contentSize = CGSizeMake(count*100, 0);
    self.titleScrollview.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollview.contentSize = CGSizeMake(count *[UIScreen mainScreen].bounds.size.width, 0);

}
-(void)settitleViews{
    UIScrollView *titleScrollview = [[UIScrollView alloc] init];
    CGFloat y = self.navigationController.navigationBar.hidden?20:64;
    CGFloat width = self.view.frame.size.width;
    titleScrollview.frame = CGRectMake(0, y, width, 40);
    
    [self.view addSubview:titleScrollview];
    _titleScrollview = titleScrollview;
    
}
-(void)setContentViews{
    UIScrollView *contentScrollview = [[UIScrollView alloc] init];
    contentScrollview.backgroundColor = [UIColor blueColor];
    CGFloat y = CGRectGetMaxY(self.titleScrollview.frame);
    CGFloat width = self.view.frame.size.width;
    CGFloat height =self.view.frame.size.height;
    contentScrollview.frame = CGRectMake(0, y, width, height-y);
    
    [self.view addSubview:contentScrollview];
    _contentScrollview = contentScrollview;
    _contentScrollview.delegate = self;
    _contentScrollview.pagingEnabled = YES;
    self.contentScrollview.showsHorizontalScrollIndicator = NO;
}
#pragma mark ScrollviewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int PageNumber = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    UIButton *but = self.titleButtons[PageNumber];
    [self setButtonTile:but];
 
    [self setOneViewConroller:PageNumber];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger leftI = scrollView.contentOffset.x / mainscreenWidth;
    //左边按钮
    
    UIButton *leftBut = self.titleButtons[leftI];
    //右边按钮
    NSInteger rightI = leftI +1;
    UIButton *rightBut;
    
    if (rightI < self.titleButtons.count) {
        rightBut =self.titleButtons[rightI];
    }
    CGFloat scaleR = scrollView.contentOffset.x / mainscreenWidth;
    scaleR -=leftI;
    CGFloat scaleL = 1-scaleR;
    
    leftBut.transform = CGAffineTransformMakeScale(scaleL*0.3 +1, scaleL*0.3 +1);
    rightBut.transform = CGAffineTransformMakeScale(scaleR*0.3 +1, scaleR*0.3 +1);
    

}
@end
