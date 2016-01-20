//
//  ViewController.m
//  HZBirdJumpDemo
//
//  Created by Box on 15/7/22.
//  Copyright (c) 2015年 Box. All rights reserved.
//

//控制向上向下加速度
#define Spead 0.05

#import "ViewController.h"

@interface ViewController (){
    UIImageView *_bird;
    UIView *_birdClother;
    int maxJumpCount;
    //这个是游戏开始控制开关
    BOOL isStart;
    
    //申明每个管子
    UIView *_p11;
    UIView *_p12;
    UIView *_p21;
    UIView *_p22;
    
    //申明2个全局 背景对象
    UIView *_bgView1;
    UIView *_bgView2;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initBirdAndOthers];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    
//    //让某一个视图 以一个最正的 位置展示
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    bird.transform = CGAffineTransformRotate(transform, -30*M_PI/180);
//    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateBird) userInfo:nil repeats:YES];
   
}

- (void)update{
    
    //刷新UI界面
    
    if (isStart) {//刷新鸟的位置 检查碰撞 以及设置 管子 刷新背景
        [self updateBird];
        [self updateBGMove];
        [self checkCrash];
    }
    
}
-(void)hide{
    if (CGRectIntersectsRect(_bird.frame,_bgView2.frame )) {
        _p11.hidden=NO;
        
        
        _p12.hidden=NO;
    }
    
}


- (void)updateBGMove {
    CGRect rect1 = _bgView1.frame;
    CGRect rect2 = _bgView2.frame;
    
    
    if (rect1.origin.x <= -self.view.frame.size.width) {
        rect1.origin.x = self.view.frame.size.width;
    }
    
    if (rect2.origin.x <= -self.view.frame.size.width) {
        rect2.origin.x = self.view.frame.size.width;
    }
    
    rect1.origin.x -= 1;
    rect2.origin.x -= 1;
    _bgView1.frame = rect1;
    _bgView2.frame = rect2;
}

- (void)checkCrash {
//    CGRect bird = _birdClother.frame;
    
    CGFloat birdY = _birdClother.frame.origin.y + 24;
    CGFloat birdX = _birdClother.frame.origin.x + 34;//28==34
    
    //下边界
    if (birdY >= self.view.frame.size.height - 53) {
        //game over
        [self gameOver];
    }
    //场景1 第二列管子
    
    if (_p11.hidden==YES &&_p12.hidden==YES) {
        //什么也不做
        
    }else {
    //第一个场景的第二根柱子
    if (birdX - 160 == _bgView1.frame.origin.x && birdY <= _p12.frame.origin.y + 319 ) {
        
//        NSLog(@"Point %@  bird %@ ",NSStringFromCGPoint(_p12.frame.origin),NSStringFromCGPoint(_birdClother.frame.origin));
        [self gameOver];
    }else if (birdX - 160 == _bgView1.frame.origin.x && birdY >=  _p12.frame.origin.y + 319 + 120){
        [self gameOver];
    }
    
    //上切面
    
    if (birdY -24  <= _p12.frame.origin.y + 319 && birdX - 160 > _bgView1.frame.origin.x && _bgView1.frame.origin.x + 52 + 160 >= birdX -34) {
        [self gameOver];
    }
    //下切面
        if (birdY >= _p12.frame.origin.y + 319+120 && birdX - 160 > _bgView1.frame.origin.x && _bgView1.frame.origin.x + 52 + 160 >= birdX -34) {
            [self gameOver];
        }
  
        
        
        
        //第一个场景的第一根柱子
        if (birdX  == _bgView1.frame.origin.x && birdY <= _p11.frame.origin.y + 319 ) {
            
            //        NSLog(@"Point %@  bird %@ ",NSStringFromCGPoint(_p12.frame.origin),NSStringFromCGPoint(_birdClother.frame.origin));
            [self gameOver];
        }else if (birdX  == _bgView1.frame.origin.x && birdY >=  _p11.frame.origin.y + 319 + 120){
            [self gameOver];
        }
        
        //上切面
        
        if (birdY -24  <= _p11.frame.origin.y + 319 && birdX  > _bgView1.frame.origin.x && _bgView1.frame.origin.x + 52  >= birdX -34) {
            [self gameOver];
        }
        //下切面
        if (birdY   >= _p11.frame.origin.y + 319+120 && birdX  > _bgView1.frame.origin.x && _bgView1.frame.origin.x + 52  >= birdX -34) {
            [self gameOver];
        }
    }
   
//    
        //第二个场景的第一根柱子
        
        if (birdX == _bgView2.frame.origin.x && birdY <= _p21.frame.origin.y + 319 ) {
            
//                    NSLog(@"Point %@  bird %@ ",NSStringFromCGPoint(_p12.frame.origin),NSStringFromCGPoint(_birdClother.frame.origin));
            [self gameOver];
        }else if (birdX == _bgView2.frame.origin.x && birdY >=  _p21.frame.origin.y + 319 + 120){
            [self gameOver];
        }
        
        //上切面
        
        if (birdY -24  <= _p21.frame.origin.y + 319 && birdX > _bgView2.frame.origin.x && _bgView2.frame.origin.x + 52  >= birdX -34) {
            [self gameOver];
        }
        //下切面
        if (birdY   >= _p21.frame.origin.y + 319+120 && birdX  > _bgView2.frame.origin.x && _bgView2.frame.origin.x + 52  >= birdX -34) {
            [self gameOver];
        }
        
        //第二个场景的第二根柱子
        if (birdX - 160 == _bgView2.frame.origin.x && birdY <= _p22.frame.origin.y + 319 ) {
            
            //        NSLog(@"Point %@  bird %@ ",NSStringFromCGPoint(_p12.frame.origin),NSStringFromCGPoint(_birdClother.frame.origin));
            [self gameOver];
        }else if (birdX - 160 == _bgView2.frame.origin.x && birdY >=  _p22.frame.origin.y + 319 + 120){
            [self gameOver];
        }
        
        //上切面
        
        if (birdY -24  <= _p22.frame.origin.y + 319 && birdX - 160 > _bgView2.frame.origin.x && _bgView2.frame.origin.x + 52 + 160 >= birdX -34) {
            [self gameOver];
        }
        //下切面
        if (birdY   >= _p22.frame.origin.y + 319+120 && birdX - 160 > _bgView2.frame.origin.x && _bgView2.frame.origin.x + 52 + 160 >= birdX -34) {
            [self gameOver];
        }
  
   
    
}

- (void)gameOver {
    isStart = NO;
}

- (void)initBirdAndOthers {
    //桌布
    UIView *bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTap)];
    [self.view addGestureRecognizer:tap];
    
    //管子的背景图也就是管子的场景
    
    UIView *bg1 = [[UIView alloc]initWithFrame:self.view.bounds];
    UIView *bg2 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //把管子的场景添加到主场景中
    
    UIView *p11 = [self addPilesAtX:0];
    [bg1 addSubview:p11];
    p11.hidden = YES;
    UIView *p21 = [self addPilesAtX:0];
    [bg2 addSubview:p21];
    UIView *p12 = [self addPilesAtX:160];
    p12.hidden = YES;
    [bg1 addSubview:p12];
    UIView *p22 = [self addPilesAtX:160];
    [bg2 addSubview:p22];
    
    _p11 = p11;
    _p12 = p12;
    _p21 = p21;
    _p22 = p22;
   
//    bg1.backgroundColor = [UIColor yellowColor];
//    bg2.backgroundColor = [UIColor greenColor];
    [bgView addSubview:bg1];
    [bgView addSubview:bg2];
    
    
    UIImageView *grand1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ground"]];
    grand1.frame = CGRectMake(0, self.view.frame.size.height - 53, self.view.frame.size.width, 53);
    [bg1 addSubview:grand1];
    
    UIImageView *grand2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ground"]];
    grand2.frame = CGRectMake(0, self.view.frame.size.height - 53, self.view.frame.size.width, 53);
    [bg2 addSubview:grand2];
    
    _bgView1 = bg1;
    _bgView2 = bg2;
    
    
    UIView *birdClother = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 34, 24)];
    birdClother.layer.cornerRadius = 10;
    birdClother.clipsToBounds = YES;
    
    [bgView addSubview:birdClother];
    _birdClother = birdClother;
    UIImageView *bird = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bird"]];
    bird.frame = CGRectMake(0, 0, 34, 24);
    //birdClother.backgroundColor = [UIColor redColor];
    [birdClother addSubview:bird];
    _bird = bird;
    birdClother.center = CGPointMake(60, self.view.center.y);
    
    [self.view addSubview:bgView];
}


//增加管子
- (UIView *)addPilesAtX:(CGFloat)x {
    NSInteger tempY = arc4random()%120;
    
    UIImageView *upPile = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 52, 319)];
    UIImageView *downPile = [[UIImageView alloc]initWithFrame:CGRectMake(0, 439, 52, 319)];
    
    UIView *pileView = [[UIView alloc]initWithFrame:CGRectMake(x, tempY - 120, 52, self.view.frame.size.height)];
    
    upPile.image = [UIImage imageNamed:@"up_bar"];
    downPile.image = [UIImage imageNamed:@"down_bar"];
    
    [pileView addSubview:upPile];
    [pileView addSubview:downPile];
    
    return pileView;
    
}


- (void)updateBird{
    
    maxJumpCount--;
    
    CGRect rect = _birdClother.frame;
    
    if (maxJumpCount >= 0) {//鸟一直再跳
        rect.origin.y = rect.origin.y - (2.5-(50-maxJumpCount)*Spead);
    }else{
        rect.origin.y = rect.origin.y - (maxJumpCount)*Spead;
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        _bird.transform = CGAffineTransformRotate(transform, 30*M_PI/180.0);
    }
    
    _birdClother.frame = rect;
    [self hide];
}


- (void)screenTap {
    //NSLog(@"------------------------");
    
    maxJumpCount = 50;
    
    
    if (!isStart) {
        isStart = YES;
        
        for (UIView *v in self.view.subviews) {
            [v removeFromSuperview];
        }
        
        [self initBirdAndOthers];
        
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    _bird.transform = CGAffineTransformRotate(transform, -30*M_PI/180.0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
