//
//  RFLog.m
//  Pods-RFLog_Example
//
//  Created by xiepengxiang on 2018/5/3.
//

#import "RFLog.h"
#import "RFAssistiveTouch.h"

static RFAssistiveTouch *touch = nil;

@implementation RFLog

+ (void)turnOnConsole
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touch = [RFAssistiveTouch touch];
    });
}

@end
