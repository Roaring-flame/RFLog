//
//  RFAssistiveTouch.m
//  Pods-RFLog_Example
//
//  Created by xiepengxiang on 2018/5/3.
//

#import "RFAssistiveTouch.h"
#import "RFTouchController.h"

@interface RFAssistiveTouch ()
{
    UIButton *_button;
    RFTouchController *_controller;
    BOOL _isExpand;
}

@end

@implementation RFAssistiveTouch

+ (instancetype)touch
{
    RFAssistiveTouch *touch = [[RFAssistiveTouch alloc] initWithFrame:CGRectMake(100, 100, RFLogTouchWidth, RFLogTouchHeight)];
    return touch;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.windowLevel = UIWindowLevelAlert - 1.f;
        self.clipsToBounds = YES;
        _isExpand = YES;
        [self setRootController];
        [self makeKeyAndVisible];
        [self resignKeyWindow];
        [self addTouchView];
    }
    return self;
}

#pragma mark - action
-(void)choose
{
    self.frame = [self calculateFrame:_isExpand];
    _controller.view.hidden = !_isExpand;
    _isExpand = !_isExpand;
}

-(void)changePosition:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x + originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y + originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    
    self.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {

        _button.enabled = NO;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){

    } else {
        
        CGRect frame = self.frame;
        
        //记录是否越界
        BOOL isOver = NO;

        if (frame.origin.x < 0) {
            
            frame.origin.x = 0;
            
            isOver = YES;
            
        } else if (frame.origin.x+frame.size.width > width) {
            
            frame.origin.x = width - frame.size.width;
            
            isOver = YES;
        }

        if (frame.origin.y < 0) {
            
            frame.origin.y = 0;
            
            isOver = YES;
            
        } else if (frame.origin.y+frame.size.height > height) {
            
            frame.origin.y = height - frame.size.height;
            
            isOver = YES;
            
        }
        
        if (isOver) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = frame;
            }];
        }
        _button.enabled = YES;
    }
}

#pragma mark - private method
- (CGRect)calculateFrame:(BOOL)isExpand
{
    CGRect frame = self.frame;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    if (isExpand) {
        if (x + RFLogWindowWidth > RFScreenWidth - RFLogWindowPadding) {
            x = x - RFLogWindowWidth;
        }
        if (y + RFLogWindowHeight > RFScreenHeight - RFLogWindowPadding) {
            y = y - RFLogWindowHeight;
        }
        width = RFLogWindowWidth;
        height = RFLogWindowHeight;
    }else {
        width = RFLogTouchWidth;
        height = RFLogTouchHeight;
    }
    
    return CGRectMake(x, y, width, height);
}

#pragma mark - loading & setting

- (void)setRootController
{
    if (!_controller) {
        _controller = [[RFTouchController alloc] init];
        self.rootViewController = _controller;
        _controller.view.hidden = YES;
    }
}

- (void)addTouchView
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor grayColor];
        _button.frame = CGRectMake(0, 0, RFLogTouchWidth, RFLogTouchHeight);
        _button.layer.cornerRadius = self.frame.size.width/2;
        [_button addTarget:self action:@selector(choose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePosition:)];
        [_button addGestureRecognizer:pan];
    }
}

@end
