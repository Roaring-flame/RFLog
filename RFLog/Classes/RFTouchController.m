//
//  RFTouchController.m
//  Pods-RFLog_Example
//
//  Created by xiepengxiang on 2018/5/3.
//

#import "RFTouchController.h"



@interface RFTouchController ()

@property (nonatomic, strong) UITextView *logTextView;

@end

@implementation RFTouchController

- (void)loadView
{
    CGRect frame = (CGRect){0, 0, RFLogWindowWidth, RFLogWindowHeight};
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.clipsToBounds = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadLogTextView];
    
    [self redirectSTD:STDOUT_FILENO];
    [self redirectSTD:STDERR_FILENO];
    
}

#pragma mark - override
-(CGSize)preferredContentSize
{
    return CGSizeMake(RFScreenWidth * 0.5, 100);
}

- (void)redirectSTD:(int)fileDescriptor{
    
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading];
    dup2([[pipe fileHandleForWriting] fileDescriptor], fileDescriptor);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redirectNotificationHandle:)
                                                 name:NSFileHandleReadCompletionNotification
                                               object:pipeReadHandle];
    [pipeReadHandle readInBackgroundAndNotify];
}

#pragma mark - loading
- (void)loadLogTextView
{
    if (!_logTextView) {
        CGRect frame = CGRectMake(RFLogTouchWidth * 0.5, RFLogTouchHeight *0.5, RFLogWindowWidth - RFLogTouchWidth, RFLogWindowHeight - RFLogTouchHeight);
        _logTextView = [[UITextView alloc] initWithFrame:frame];
        _logTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _logTextView.layer.borderWidth = 1.f;
        [self.view addSubview:_logTextView];
    }
}

#pragma mark - Notification Action
- (void)redirectNotificationHandle:(NSNotification *)notification{ // 通知方法
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    self.logTextView.text = [NSString stringWithFormat:@"%@\n\n%@",self.logTextView.text, str];
    NSRange range;
    range.location = [self.logTextView.text length] - 1;
    range.length = 0;
    [self.logTextView scrollRangeToVisible:range];
    [[notification object] readInBackgroundAndNotify];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
