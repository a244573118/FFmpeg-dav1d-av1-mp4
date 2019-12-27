//
//  ViewController.m
//  FFmpegTest
//
//  Created by 张洋 on 2019/12/13.
//  Copyright © 2019 offcn. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FFmpegManager.h"
#import "UIWindow+Extension.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIButton *converBtn;

@property (nonatomic, strong) UILabel *progressLab;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.converBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.5*(kScreenWidth-60), 0.5*(kScreenHeight-40), 60, 40)];
    [self.converBtn setTitle:@"转码" forState:UIControlStateNormal];
    [self.converBtn addTarget:self action:@selector(converBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.converBtn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:self.converBtn];
    self.playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.5*(kScreenWidth-60), CGRectGetMaxY(self.converBtn.frame)+20, 60, 40)];
    [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:self.playBtn];
    
    self.progressLab = [[UILabel alloc] initWithFrame:CGRectMake(0.5*(kScreenWidth-60), CGRectGetMaxY(self.playBtn.frame)+20, 60, 40)];
    self.progressLab.textAlignment = NSTextAlignmentCenter;
    self.progressLab.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:self.progressLab];
}
- (void)converBtnClick{
    NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"video.av1" ofType:@"mp4"];
    NSString *outputPath = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], @"test.mp4"];
    __weak __typeof(self)weakSelf = self;
    self.view.userInteractionEnabled = NO;
    [[FFmpegManager sharedManager] converWithInputPath:inputPath outputPath:outputPath processBlock:^(float process) {
        weakSelf.progressLab.text = [NSString stringWithFormat:@"%.2f%%", process*100];
    } completionBlock:^(NSError * _Nonnull error) {
        weakSelf.view.userInteractionEnabled = YES;
        [UIWindow showTips:@"转码完成,可以播放"];
    }];
}
- (void)playBtnClick{
    NSString *mp4Path = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject], @"test.mp4"];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:mp4Path]];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.frame = self.view.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    [self.player play];
}
@end
