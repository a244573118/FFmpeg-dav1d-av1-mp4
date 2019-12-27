//
//  FFmpegConverOC.h
//  FFmpegTest
//
//  Created by 张洋 on 2019/12/26.
//  Copyright © 2019 offcn. All rights reserved.
//

/**
 监测ffmpeg中C方法转化为OC方法
 */

/** 转换停止回调 */
void stopRuning(void);

/** 获取总时间长度 */
void setDuration(long long int time);

/** 获取当前时间 */
void setCurrentTime(char info[1024]);


