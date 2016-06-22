//
//  StartViewController.m
//  HongPei
//
//  Created by lanou on 15/11/23.
//  Copyright © 2015年 Yang Song. All rights reserved.
//

#import "StartViewController.h"
#import "ViewController.h"

@interface StartViewController ()<UIScrollViewDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIImageView *imageView;
@property(strong,nonatomic)UIPageControl *pageControl;
@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //调用ScrollView相关属性的方法
        [self layoutScrollView];
        
        //调用在滑动视图设置图片的方法
        [self layoutImageView];
        
        //调用agPae
        [self layoutPageControl];
        
                //调用轮播时间的方法
//        [self scrollViewTime:2];
    }
//#pragma -mark设置滑动视图自动滑动的方法
//-(void)scrollViewTime:(NSTimeInterval )time
//{
//    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(doTime) userInfo:nil repeats:YES];
//}
//
//#pragma -mark定时器实行的方法
//-(void)doTime
//{
//    static  int i = 0;
//    DLog(@"i=%d",i);
//    //处理每次滑动到最后的时候，都需要从新开始，所以需要手动的让循环变量i从最后变为开始
//    if (i%4==0&&i!=0)
//    {
//        i=0;
//    }
//    self.scrollView.contentOffset=CGPointMake(self.view.bounds.size.width*i, 0);
//    i++;
//    
//}




#pragma -mark ScrollView的布局和相关属性
-(void)layoutScrollView
{
    self.scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    //（1）将滑动视图添加到self.view上
    [self.view addSubview:self.scrollView];
    
    //（2）设置一个背景色
    self.scrollView.backgroundColor=[UIColor redColor];
    
    //(3)设置滑动视图的滑动区间
    self.scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*4, 0);
    
    //(4)设置滑动条是否显示(默认是yes)
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    //(5)设置滑动条的样式
    self.scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    
    //(6)设置滑动到边界是否回弹(默认是YES)
    self.scrollView.bounces=NO;
    
    //(7)设置是否整屏滑动(默认是NO)
    self.scrollView.pagingEnabled=YES;
    
    //(8)关于缩放的属性，设置缩放的最大值
    self.scrollView.maximumZoomScale=2;
    
    //(9)设置缩放的最小值
    self.scrollView.minimumZoomScale=0.5;
    
    //(10)设置缩放比例
    self.scrollView.zoomScale=1;
    
    //(11)设置代理（使用系统协议第二步）
    self.scrollView.delegate=self;
    
}

#pragma -mark布局在ScrollView上的要滑动的图片
-(void)layoutImageView
{
    
    for (int i=0; i<4; i++)
    {
        //(1)在ContextView上面创建需要显示的UIImageView
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        //(2)给每个相框添加图片
        self.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"引%d",i+1]];
        if (i==3)
        {
            //(1)打开用户交互
            self.imageView.userInteractionEnabled=YES;
            //(2)创建一个轻拍手势
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(welcome:)];
            //(3)将手势添加到视图上
            [self.imageView addGestureRecognizer:tap];
        }
        //(3)将创建好的相框添加到滑动视图上
        [self.scrollView addSubview:self.imageView];
    }
}
#pragma -mark当滑动到最后一页，点击页面，就会执行方法
-(void)welcome:(UITapGestureRecognizer *)tap
{
    [self.scrollView removeFromSuperview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma - mark PageControl相关设置的方法
-(void)layoutPageControl
{
    
    self.pageControl=[[UIPageControl alloc]init];
    CGRect mainFrame = [UIScreen mainScreen].bounds;
    if (mainFrame.size.height>=736) {
        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(100, self.view.bounds.size.height-50, 220, 30)];
    }
    else if(mainFrame.size.height>=667)
    {
        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(80, self.view.bounds.size.height-50, 220, 30)];
    }
    else
    {
        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(50, self.view.bounds.size.height-50, 220, 30)];
    }
    // [self.pageControl setBackgroundColor:[UIColor yellowColor]];
//    [self.view addSubview:self.pageControl];
    //(1)设置页数
    self.pageControl.numberOfPages=4;
    //(2)设置当前页面颜色
    self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    //(3)设置其他页面的颜色
    self.pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    //(4)当只有一个页面的时候，隐藏pageControl
    self.pageControl.hidesForSinglePage=YES;
    //(5)添加点击事件
    [self.pageControl addTarget:self action:@selector(doPageControl:) forControlEvents:UIControlEventValueChanged];
}

#pragma -- mark 点击pageControl时执行的方法
-(void)doPageControl:(UIPageControl *)page
{
    //pageControl控制滑动视图的代码
    self.scrollView.contentOffset=CGPointMake(self.view.bounds.size.width*self.pageControl.currentPage, 0);
}






#pragma -mark 滑动视图的代理方法

#pragma -mark 选择可以缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //缩放完毕之后，滑动就有问题
    return [self.scrollView.subviews objectAtIndex:0];
}
#pragma  -mark正在缩放时执行的方法
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
}
#pragma -mark正在滑动时执行的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // DLog(@"偏移量=%f",scrollView.contentOffset.x);
    if ((int)scrollView.contentOffset.x<=-50)
    {
        DLog(@"正在刷新，请骚等~~！");
    }
    
    //滑动视图控制pageControl的代码
    self.pageControl.currentPage=(int)(self.scrollView.contentOffset.x/self.view.bounds.size.width);
    
    
}

@end
