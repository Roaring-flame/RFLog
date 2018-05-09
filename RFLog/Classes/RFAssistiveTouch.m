//
//  RFAssistiveTouch.m
//  Pods-RFLog_Example
//
//  Created by xiepengxiang on 2018/5/3.
//

#import "RFAssistiveTouch.h"
#import "RFTouchController.h"

typedef NS_ENUM(NSInteger, RFTouchExpandDirection) {
    RFTouchExpandDirectionLeftTop,
    RFTouchExpandDirectionLeftBottom,
    RFTouchExpandDirectionRightTop,
    RFTouchExpandDirectionRightBottom
};

@interface RFAssistiveTouch ()
{
    UIButton *_button;
    RFTouchController *_controller;
}

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) RFTouchExpandDirection direction;

@end

@implementation RFAssistiveTouch

+ (instancetype)touch
{
    RFAssistiveTouch *touch = [[RFAssistiveTouch alloc] initWithFrame:CGRectMake(RFScreenWidth - RFLogTouchWidth - RFLogWindowMargin, 100, RFLogTouchWidth, RFLogTouchHeight)];
    return touch;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        self.windowLevel = UIWindowLevelAlert - 1.f;
        self.clipsToBounds = YES;
        self.isExpand = YES;
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
    [self calculateDirection:_isExpand];
    self.frame = [self calculateFrame:_isExpand];
    _button.frame = [self calculateTouchFrame:_isExpand];
    _pan.enabled = !_isExpand;
    _controller.view.hidden = !_isExpand;
    _isExpand = !_isExpand;
}

-(void)changePosition:(UIPanGestureRecognizer *)pan
{
    NSLog(@"%ld",pan.state);
    
    if(pan.state == UIGestureRecognizerStateBegan) {

        _button.enabled = NO;
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        
        CGPoint point = [pan translationInView:self];
        CGRect originalFrame = self.frame;
        
        originalFrame.origin.x += point.x;
        originalFrame.origin.y += point.y;
        
        self.frame = originalFrame;
        [pan setTranslation:CGPointZero inView:self];
        
    }else if(pan.state == UIGestureRecognizerStateEnded){
        
        CGRect frame = self.frame;
        CGPoint center = self.center;
        BOOL isOver = NO;
        
        if (center.x <= RFScreenWidth * 0.5) {
            
            frame.origin.x = RFLogWindowMargin;
            isOver = YES;
            
        }else{
            frame.origin.x = RFScreenWidth - frame.size.width - RFLogWindowMargin;
            isOver = YES;
        }

        if (frame.origin.y < RFLogWindowMargin) {
            
            frame.origin.y = RFLogWindowMargin;
            isOver = YES;
            
        }else if(frame.origin.y + frame.size.height > RFScreenHeight - RFLogWindowMargin) {
            
            frame.origin.y = RFScreenHeight - frame.size.height - RFLogWindowMargin;
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
- (void)calculateDirection:(BOOL)isExpand
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    
    if (isExpand) {
        if (x + RFLogWindowWidth < RFScreenWidth - RFLogWindowPadding) {
            // left
            if (y + RFLogWindowHeight < RFScreenHeight - RFLogWindowPadding) {
                // top
                _direction = RFTouchExpandDirectionLeftTop;
            }else {
                // bottom
                _direction = RFTouchExpandDirectionLeftBottom;
            }
        }else {
            // right
            if (y + RFLogWindowHeight < RFScreenHeight - RFLogWindowPadding) {
                // top
                _direction = RFTouchExpandDirectionRightTop;
            }else {
                // bottom
                _direction = RFTouchExpandDirectionRightBottom;
            }
        }
    }
}

- (CGRect)calculateFrame:(BOOL)isExpand
{
    CGRect frame = self.frame;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    if (isExpand) {
        if (_direction == RFTouchExpandDirectionLeftTop) {
            
        }else if(_direction == RFTouchExpandDirectionLeftBottom){
            y = y - (RFLogWindowHeight - height);
        }else if(_direction == RFTouchExpandDirectionRightTop){
            x = x - (RFLogWindowWidth - width);
        }else if(_direction == RFTouchExpandDirectionRightBottom){
            x = x - (RFLogWindowWidth - width);
            y = y - (RFLogWindowHeight - height);
        }
        
        width = RFLogWindowWidth;
        height = RFLogWindowHeight;
    }else {
        if (_direction == RFTouchExpandDirectionLeftTop) {
            
        }else if(_direction == RFTouchExpandDirectionLeftBottom){
            y = y + (height - RFLogTouchHeight);
        }else if(_direction == RFTouchExpandDirectionRightTop){
            x = x + (width - RFLogTouchWidth);
        }else if(_direction == RFTouchExpandDirectionRightBottom){
            x = x + (width - RFLogTouchWidth);
            y = y + (height - RFLogTouchHeight);
        }
        
        width = RFLogTouchWidth;
        height = RFLogTouchHeight;
    }
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)calculateTouchFrame:(BOOL)isExpand
{
    CGRect frame = self.frame;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    if (isExpand) {
        if (_direction == RFTouchExpandDirectionLeftTop) {
            x = 0.f;
            y = 0.f;
        }else if(_direction == RFTouchExpandDirectionLeftBottom){
            x = 0.f;
            y = RFLogWindowHeight - RFLogTouchHeight;
        }else if(_direction == RFTouchExpandDirectionRightTop){
            x = RFLogWindowWidth - RFLogTouchWidth;
            y = 0.f;
        }else if(_direction == RFTouchExpandDirectionRightBottom){
            x = RFLogWindowWidth - RFLogTouchWidth;
            y = RFLogWindowHeight - RFLogTouchHeight;
        }
        
    }else {
        x = 0.f;
        y = 0.f;
    }
    
    width = RFLogTouchWidth;
    height = RFLogTouchHeight;
    
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
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePosition:)];
        [_button addGestureRecognizer:_pan];
    }
}

@end
