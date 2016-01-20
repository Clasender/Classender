//
//  ViewController.m
//  HZPlaneshootDemo
//
//  Created by Mac on 15/7/16.
//  Copyright (c) 2015年 任彬莹. All rights reserved.
//
#import "zidanImage.h"
#import "ViewController.h"
#import "DijiImageView.h"
#import "AVFoundation/AVFoundation.h"
@interface ViewController (){

        //声明背景图片的两个全局变量
        UIImageView *_bgView1;
        UIImageView *_bgView2;
        NSMutableArray *_diji;
    
        UIImageView *_mainPlan;
        //子弹们
        NSMutableArray *_zArray;
        //NSMutableArray *_zidan;
        NSMutableArray *_plane;
        AVAudioPlayer *_player;
        NSTimer *_timerFind;
        NSTimer *_timerSend;
        UIButton *_gameStatus;
        NSTimer *_bgview;
        NSTimer *_dijiview;
    UIButton *_btn;
}

@end

@implementation ViewController
    
-(void) initView{
        UIImageView *bg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
        //bounds是自身坐标 (0,0,自身宽 自身高)
        bg1.frame = self.view.bounds;
        
        [self.view addSubview:bg1];
        
        
        UIImageView *bg2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
        //frame 是父视图坐标 （x，y，自身宽，自身高）
        bg2.frame = CGRectMake(0, -bg1.frame.size.height, bg1.frame.size.width, bg1.frame.size.height);
        bg2.backgroundColor= [UIColor redColor];
        
        [self.view addSubview:bg2];
        
        _bgView1 = bg1;
        _bgView2 = bg2;
       
    }


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor=[UIColor lightGrayColor] ;
    
    [self initView];
    [self initzhuView];
    
    //定时刷新 启动
    
    _bgview=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(bgMove) userInfo:nil repeats:YES];
    
    
    NSMutableArray *dijiarray = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i = 0; i<20; i++) {
        DijiImageView *diji= [[DijiImageView alloc]initWithImage:[UIImage imageNamed:@"diji"]];
        int beginX = arc4random()%((int)self.view.frame.size.width-40);
        
        diji.frame = CGRectMake(beginX, -40, 35, 25);
        
        [self.view addSubview:diji];
        [dijiarray addObject:diji];
        
    }
    _diji=dijiarray;
    
    UIButton *btStatus = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    btStatus.frame = CGRectMake(280, 30, 28, 30);
//    [btStatus setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [btStatus addTarget:self action:@selector(pauseGame:) forControlEvents:UIControlEventTouchUpInside];
    //    btStatus.selected = NO;
    [self.view addSubview:btStatus];
    
    _gameStatus = btStatus;
    
    
    
    
    
    
    
    
    
    
//    UIButton *stop = [UIButton buttonWithType:UIButtonTypeCustom];
//    stop.frame = CGRectMake(10, 10, 40, 30);
//    [stop setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
//    stop.tag=0;
//    [stop addTarget:self action:@selector(btnClecked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:stop];
    
//    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
//    start.frame = CGRectMake(10, 70, 60, 32);
//    [start setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
//    start.tag=1;
//    [start addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:start];
    NSString *str = [[NSBundle mainBundle]pathForResource:@"bob" ofType:@"aif"];
    NSURL *url = [NSURL URLWithString:str];
    
    AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:url  error:nil];
    //设置为0 是不循环就一次声音 负数是无限循环
    play.numberOfLoops=-1;
    [play play];
    _player = play;
 
    
    
    //定时器
    _dijiview=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(flakeDown) userInfo:self repeats:YES];
 
}
//- (void)btnClecked:(UIButton *)sender {
//    
//    
//    sender.selected = !sender.selected;
//    
//    if (sender.selected) {
//        [_player play];
//    }else{
//        [_player pause];
//    }
//    
//    //    [_player play];
//    
//    
//}






-(void)flakeDown{
    static int count = 0;
    count++;
    if (count >2) {
        [self checkDijiFlake];
        count = 0;
    }
    [self checkDijiDown];
    [self checkBoom:_zArray];
    
}
-(void)checkDijiFlake{
    for (DijiImageView *diji in _diji) {
        if (!diji.isUse) {
            diji.isUse =YES;
            break;
        }
    }
    
}

-(void)checkDijiDown{
    for (DijiImageView *diji in _diji) {
        if (diji.isUse ) {
            diji.center =CGPointMake(diji.center.x, diji.center.y+10) ;
            if (diji.center.y>self.view.frame.size.height )
            {
                
                int beginX = arc4random()%((int)self.view.frame.size.width-40);
                
                diji.frame = CGRectMake(beginX, -40, 35, 25);
                diji.isUse = NO;
            }
        }
        
    }
    
}


//1.3背景图片移动
-(void) bgMove{
    
    //拿到当前要移动的bg 的frame
    CGRect rect = _bgView1.frame;
    if (rect.origin.y> rect.size.height) {
        rect.origin.y=0;
    }
    
    //定时器 没隔一段时间向下移动 0.4像素
    rect.origin.y += 5;
    _bgView1.frame = rect;
    
    rect.origin.y= rect.origin.y - rect.size.height;
    _bgView2.frame = rect;
    
}

-(void) initzhuView{
    //1.1创建主飞机 猪脚
    
    UIImageView *myPlane = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"plane1"]];
    myPlane.frame= CGRectMake(0, 0, 66, 80);
    myPlane.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 80);
    
    [self.view addSubview:myPlane];
    _mainPlan=myPlane;
    //1.2
    NSArray *planeArr = @[[UIImage imageNamed:@"plane1"],[UIImage imageNamed:@"plane2"]];
    myPlane.animationDuration =0.75;
    myPlane.animationImages = planeArr;
    [myPlane startAnimating];
    //2.1让子弹飞一会
    //创建子弹 可变数组
    NSMutableArray *zidanArray= [[NSMutableArray alloc]initWithCapacity:0];
    
    //增加弹夹
    for (NSInteger i =0; i<20; i++) {
        zidanImage *zidan = [[zidanImage alloc]initWithImage:[UIImage imageNamed:@"zidan1"]];
        zidan.frame = CGRectMake(0, -14, 7, 14);
        [self.view addSubview:zidan];
        [zidanArray addObject:zidan];
        
        
    }
    _zArray = zidanArray;
    _timerFind=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(find) userInfo:nil repeats:YES];
    
    _timerSend=[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(send) userInfo:nil repeats:YES];
 
}
- (void)find{
    //发射子弹首先要找到子弹
    for (zidanImage *zidan in _zArray) {
        
        //UIImageView *zidan = _zArray[i];
        if (zidan.tag==0) {
            zidan.frame =CGRectMake(_mainPlan.frame.origin.x+30, _mainPlan.frame.origin.y-20, 7, 14);
            zidan.tag=1;
//            
//            CGPoint planeCenter = _mainPlan.center;
//            planeCenter.y -=47;
//            zidan.center = planeCenter;
            break;
        }
        
    }
    
}



- (void)send{
    //发射子弹
    for (zidanImage *zidan in _zArray) {
        
        // UIImageView *zidan = _zArray[i];
        if (zidan.tag==1) {
            zidan.frame =CGRectMake(zidan.frame.origin.x, zidan.frame.origin.y-5, 7, 14);
            
            
//            CGPoint zidanP = zidan.center;
//            zidanP.y -=30;
//            zidan.center=zidanP;
//        }
        if (zidan.frame.origin.y<-14) {
           
//            CGPoint planeCenter = _mainPlan.center;
//            planeCenter.y = -7;
//            zidan.center = planeCenter;
            zidan.tag=0;
            zidan.frame = CGRectZero;
          }
        }
    }
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint point = [touch locationInView:self.view];
//    
//    // NSLog(@"%@",NSStringFromCGPoint(point));
//    
//    _mainPlan.center = point;
//}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //取出手势
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(_mainPlan.frame, point)) {
        _mainPlan.center = point;
    }
    
  
}

-(void)checkBoom :(NSMutableArray *)arrayboom{
    for (DijiImageView *diji in _diji) {
        
        for (DijiImageView *zidan in _zArray) {
            
            if (CGRectIntersectsRect(zidan.frame, diji.frame)){
                UIImageView *boomview = [[UIImageView alloc]initWithFrame:diji.frame];
                
                [self.view addSubview:boomview];
                boomview.animationDuration = 0.5;
                
                boomview.animationImages = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"bz1"], [UIImage imageNamed:@"bz2"],[UIImage imageNamed:@"bz3"],[UIImage imageNamed:@"bz4"],[UIImage imageNamed:@"bz5"],nil];
                boomview.animationRepeatCount = 1;
                [boomview startAnimating];
                diji.frame  = CGRectZero;
                
                
            }
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"------%ld",buttonIndex);
    
    if (1000 == alertView.tag) {
        switch (buttonIndex) {
            case 0:
                [_timerFind setFireDate:[NSDate distantPast]];
                [_timerSend setFireDate:[NSDate distantPast]];
                [_bgview setFireDate:[NSDate distantPast]];
                [_dijiview setFireDate:[NSDate distantPast]];
                _btn.selected = !_btn.selected;
                break;
            case 1:
                exit(0);
                break;
                
            default:
                break;
        }
    }
    
    
}





- (void)pauseGame:(id)sender {
    
        UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"学员信息" message:@"任彬莹：201216010323" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出游戏", nil];
    
        alertView1.tag = 1000;
    
        [alertView1 show];

    
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _btn=btn;
    if (btn.selected) {//关闭定时器
        [_timerFind setFireDate:[NSDate distantFuture]];
        [_timerSend setFireDate:[NSDate distantFuture]];
        [_dijiview setFireDate:[NSDate distantFuture]];
        [_bgview setFireDate:[NSDate distantFuture]];
        
    
    }else{//开启定时器
        [_timerFind setFireDate:[NSDate distantPast]];
        [_timerSend setFireDate:[NSDate distantPast]];
        [_bgview setFireDate:[NSDate distantPast]];
        [_dijiview setFireDate:[NSDate distantPast]];
        
        
    }
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
