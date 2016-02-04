//
//  UIView+MySet.m
//
//  Created by bear on 15/11/25.
//  Copyright (c) 2015年 Bear. All rights reserved.
//
#import "UIView+BearSet.h"

@implementation UIView (MySet)


#pragma mark - 界面处理，设置属性，画线的一些方法


//  毛玻璃效果处理
- (void)blurEffectWithStyle:(UIBlurEffectStyle)style Alpha:(CGFloat)alpha
{
    //系统版本
    CGFloat currentDevice = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (currentDevice < 8.0) {
        /*
         iOS7模糊处理
         */
        
        //暂时用背景色处理
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
    }else{
        /*
         iOS8模糊处理
         */
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.alpha = alpha;
        visualEffectView.frame = self.frame;
        [self addSubview:visualEffectView];
    }
}


/**
 *  设置边框
 *
 *  设置边框颜色和宽度
 */
- (void)setBorder:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}


/**
 *  自定义分割线View OffY
 *
 *  根据offY在任意位置画横向分割线
 */
- (void)setSeparatorLineOffY:(int)offStart offEnd:(int)offEnd lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor offY:(CGFloat)offY
{
    int parentView_width    = CGRectGetWidth(self.frame);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offStart, offY, parentView_width - offStart - offEnd, lineWidth)];
    
    if (!lineColor) {
        lineView.backgroundColor = [UIColor blackColor];
    }else{
        lineView.backgroundColor = lineColor;
    }
    
    [self addSubview:lineView];
}


/**
 *  自定义分底部割线View
 *
 *  自动在底部横向分割线
 */
- (void)setSeparatorLine:(CGFloat)offStart offEnd:(CGFloat)offEnd lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    CGFloat parentView_height   = CGRectGetHeight(self.frame);
    CGFloat parentView_width    = CGRectGetWidth(self.frame);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offStart, parentView_height - lineWidth, parentView_width - offStart - offEnd, lineWidth)];
    
    if (!lineColor) {
        lineView.backgroundColor = [UIColor blackColor];
    }else{
        lineView.backgroundColor = lineColor;
    }
    
    [self addSubview:lineView];
}


/**
 *  画线--View
 *
 *  通过view，画任意方向的线
 */
- (void) drawLine:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = lineColor;
    
    //竖线
    if (startPoint.x == endPoint.x) {
        lineView.frame = CGRectMake(startPoint.x, startPoint.y, lineWidth, endPoint.y - startPoint.y);
    }
    
    //横线
    else if (startPoint.y == endPoint.y){
        lineView.frame = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, lineWidth);
    }
    
    [self addSubview:lineView];
    
}


/**
 *  画线--Layer
 *
 *  通过layer，画任意方向的线
 *  该方法只能在DrawRect中使用
 */
- (void) drawLineWithLayer:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor
{
    //1.获得图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将上下文复制一份到栈中
    CGContextSaveGState(context);
    
    //2.绘制图形
    //设置线段宽度
    CGContextSetLineWidth(context, lineWidth);
    //设置线条头尾部的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    
    //设置颜色
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    //设置起点
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    //画线
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    //3.显示到View
    CGContextStrokePath(context);//以空心的方式画出
    
    //将图形上下文出栈，替换当前的上下文
    CGContextRestoreGState(context);
    
    [self setNeedsDisplay];
}






#pragma mark - 布局扩展方法

#pragma mark Getter

//  x
- (CGFloat)x
{
    return self.frame.origin.x;
}

//  y
- (CGFloat)y
{
    return self.frame.origin.y;
}

//  maxX
- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

//  maxY
- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

//  width
- (CGFloat)width
{
    return self.frame.size.width;
}

//  height
- (CGFloat)height
{
    return self.frame.size.height;
}

//  origin
- (CGPoint)origin
{
    return self.frame.origin;
}

//  size
- (CGSize)size
{
    return self.frame.size;
}

//  centerX
- (CGFloat)centerX
{
    return self.center.x;
}

//  centerY
- (CGFloat)centerY
{
    return self.center.y;
}



#pragma mark    Setter

//  setX
- (void)setX:(CGFloat)x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}

//  setMaxX
- (void)setMaxX:(CGFloat)maxX
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = maxX - CGRectGetWidth(self.frame);
    self.frame = tempFrame;
}

//  setMaxX_DontMoveMinX
- (void)setMaxX_DontMoveMinX:(CGFloat)maxX
{
    if (maxX < self.x) {
        NSLog(@"!!! setMaxX_DontMoveMinX: maxX > self.x, 无法布局");
        return;
    }
    [self setWidth:maxX - self.x];
}

//  setY
- (void)setY:(CGFloat)y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}

//  setMaxY
- (void)setMaxY:(CGFloat)maxY
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = maxY - CGRectGetHeight(self.frame);
    self.frame = tempFrame;
}

//  setMaxY_DontMoveMinY:
- (void)setMaxY_DontMoveMinY:(CGFloat)maxY
{
    if (maxY < self.y) {
        NSLog(@"!!! setMaxY_DontMoveMinY: maxY < self.y, 无法布局");
        return;
    }
    [self setHeight:maxY - self.y];
}

//  setWidth
- (void)setWidth:(CGFloat)width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

//  setHeight
- (void)setHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

//  setOrigin
- (void)setOrigin:(CGPoint)point
{
    CGRect tempFrame = self.frame;
    tempFrame.origin = point;
    self.frame = tempFrame;
}

//  setOrigin sizeToFit
- (void)setOrigin:(CGPoint)point sizeToFit:(BOOL)sizeToFit
{
    if (sizeToFit == YES) {
        [self sizeToFit];
    }
    
    CGRect tempFrame = self.frame;
    tempFrame.origin = point;
    self.frame = tempFrame;
}

//  setSize
- (void)setSize:(CGSize)size
{
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

//  setCenterX
- (void)setCenterX:(CGFloat)x
{
    CGPoint tempCenter = self.center;
    tempCenter.x = x;
    self.center = tempCenter;
}

//  setCenterY
- (void)setCenterY:(CGFloat)y
{
    CGPoint tempCenter = self.center;
    tempCenter.y = y;
    self.center = tempCenter;
}

//  不移动中心－设置width
- (void)setWidth_DonotMoveCenter:(CGFloat)width
{
    CGPoint tempCenter = self.center;
    [self setWidth:width];
    self.center = tempCenter;
}

//  不移动中心－设置height
- (void)setHeight_DonotMoveCenter:(CGFloat)height
{
    CGPoint tempCenter = self.center;
    [self setHeight:height];
    self.center = tempCenter;
}

//  不移动中心－设置height
- (void)setSize_DonotMoveCenter:(CGSize)size
{
    CGPoint tempCenter = self.center;
    [self setSize:size];
    self.center = tempCenter;
}

//  不移动某一侧 siztToFit
- (void)sizeToFit_DonotMoveSide:(kDIRECTION)dir centerRemain:(BOOL)centerRemain
{
    switch (dir) {
        case kDIR_LEFT:
        {
            CGFloat tempX = CGRectGetMinX(self.frame);
            CGFloat tempCenterY = self.center.y;
            [self sizeToFit];
            [self setX:tempX];
            if (centerRemain) {
                [self setCenterY:tempCenterY];
            }
        }
            break;
            
        case kDIR_RIGHT:
        {
            CGFloat tempX = CGRectGetMaxX(self.frame);
            CGFloat tempCenterY = self.center.y;
            [self sizeToFit];
            [self setMaxX:tempX];
            if (centerRemain) {
                [self setCenterY:tempCenterY];
            }
        }
            break;
            
        case kDIR_UP:
        {
            CGFloat tempY = CGRectGetMinY(self.frame);
            CGFloat tempCenterX = self.center.x;
            [self sizeToFit];
            [self setY:tempY];
            if (centerRemain) {
                [self setCenterX:tempCenterX];
            }
        }
            break;
            
        case kDIR_DOWN:
        {
            CGFloat tempY = CGRectGetMaxY(self.frame);
            CGFloat tempCenterX = self.center.x;
            [self sizeToFit];
            [self setMaxY:tempY];
            if (centerRemain) {
                [self setCenterX:tempCenterX];
            }
        }
            break;
            
        default:
            break;
    }
}




#pragma mark 设置布局方法

/**
 *  和父类view剧中
 *
 *  当前view和父类view的 X轴／Y轴／中心点 对其
 */
- (void)setCenterToParentViewWithAxis:(kAXIS)axis
{
    UIView *parentView = self.superview;
    switch (axis) {
        case kAXIS_X:
            self.center = CGPointMake(parentView.width/2, self.center.y);
            break;
            
        case kAXIS_Y:
            self.center = CGPointMake(self.center.x, parentView.height/2);
            break;
            
        case kAXIS_X_Y:
            self.center = CGPointMake(parentView.width/2, parentView.height/2);
            break;
            
        default:
            break;
    }
}


/**
 *  和指定的view剧中
 *
 *  当前view和指定view的 X轴／Y轴／中心点 对其
 */
- (void)setCenterToView:(UIView *)destinationView withAxis:(kAXIS)axis
{
    if (!destinationView) {
        NSLog(@"!!! setCenterWithAxis: 目标view为nil");
        return;
    }
    
    if (![self.superview isEqual:destinationView.superview]) {
        NSLog(@"!!! setCenterWithAxis: 目标view和当前view不处于同一个父类view之下");
        return;
    }
    
    switch (axis) {
        case kAXIS_X:
            self.center = CGPointMake(self.center.x, destinationView.center.y);
            break;
            
        case kAXIS_Y:
            self.center = CGPointMake(destinationView.center.x, self.center.y);
            break;
            
        case kAXIS_X_Y:
            self.center = CGPointMake(destinationView.center.x, destinationView.center.y);
            break;
            
        default:
            break;
    }
}


/**
 *  view与view的相对位置
 *
 *  direction:          方位
 *  destinationView:    目标view
 *  parentRelation:     是否为父子类关系
 *  distance:           距离
 *  center:             是否对应居中
 *
 *  此方法用于设置view与view之间的相对位置
 *  self与destinationView非父子类关系时: 可以设置self相对于destinationView的 上／下／左／右 的边距
 *  self与destinationView是父子类关系时: 可以设置self相对于父类view的 上／下／左／右 的间距
 *  注：parentRelation==YES时，destinationView可以设为nil。
 */
- (void)setRelativeLayoutWithDirection:(kDIRECTION)direction destinationView:(UIView *)destinationView parentRelation:(BOOL)parentRelation distance:(CGFloat)distance center:(BOOL)center
{
    CGRect tempRect = self.frame;
    
    /**
     *  在父类view中
     *
     *  self与destinationView 是是是是是 父子类关系
     *  大方框为destinationView，大方框为self的父类view
     *
     *     ----------     ----------     ----------     ----------
     *    |   self   |   |          |   |          |   |          |
     *    |          |   |          |   |          |   |          |
     *    |          |   |          |   |self      |   |      self|
     *    |          |   |          |   |          |   |          |
     *    |          |   |   self   |   |          |   |          |
     *     ----------     ----------     ----------     ----------
     *
     *
     *  关系： up             down          left           right
     */
    if (parentRelation) {
        if (!destinationView) {
            destinationView = [self superview];
        }
        
        switch (direction) {
                
                //上边距
            case kDIR_UP:{
                tempRect.origin.y = distance;
                self.frame = tempRect;
                if (center) {
                    [self setCenterToParentViewWithAxis:kAXIS_X];
                }
            }
                break;
                
                //下边距
            case kDIR_DOWN:{
                tempRect.origin.y = CGRectGetHeight(destinationView.frame) - CGRectGetHeight(self.frame) - distance;
                self.frame = tempRect;
                if (center) {
                    [self setCenterToParentViewWithAxis:kAXIS_X];
                }
            }
                break;
                
                //左边距
            case kDIR_LEFT:{
                tempRect.origin.x = distance;
                self.frame = tempRect;
                if (center) {
                    [self setCenterToParentViewWithAxis:kAXIS_Y];
                }
            }
                break;
                
                //右边距
            case kDIR_RIGHT:{
                tempRect.origin.x = CGRectGetWidth(destinationView.frame) - CGRectGetWidth(self.frame) - distance;
                self.frame = tempRect;
                if (center) {
                    [self setCenterToParentViewWithAxis:kAXIS_Y];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    /*
     *  不在父类view中，其他view
     *
     *  self与destinationView 非非非非 父子类关系
     *  大方框为destinationView和self所共有的父类view
     *
     *     ----------     ----------     ----------     ----------
     *    |   self   |   |   dest   |   |          |   |          |
     *    |          |   |          |   |          |   |          |
     *    |          |   |          |   |self  dest|   |dest  self|
     *    |          |   |          |   |          |   |          |
     *    |   dest   |   |   self   |   |          |   |          |
     *     ----------     ----------     ----------     ----------
     *
     *
     *  关系： up             down          left            right
     */
    else{
        switch (direction) {
            case kDIR_UP:
                tempRect.origin.y = CGRectGetMinY(destinationView.frame) - distance - CGRectGetHeight(self.frame);
                self.frame = tempRect;
                if (center) {
                    [self setCenterToView:destinationView withAxis:kAXIS_Y];
                }
                break;
                
            case kDIR_DOWN:
                tempRect.origin.y = CGRectGetMaxY(destinationView.frame) + distance;
                self.frame = tempRect;
                if (center) {
                    [self setCenterToView:destinationView withAxis:kAXIS_Y];
                }
                break;
                
            case kDIR_LEFT:
                tempRect.origin.x = CGRectGetMinX(destinationView.frame) - distance - CGRectGetWidth(self.frame);
                self.frame = tempRect;
                if (center) {
                    [self setCenterToView:destinationView withAxis:kAXIS_X];
                }
                break;
                
            case kDIR_RIGHT:
                tempRect.origin.x = CGRectGetMaxX(destinationView.frame) + distance;
                self.frame = tempRect;
                if (center) {
                    [self setCenterToView:destinationView withAxis:kAXIS_X];
                }
                break;
                
            default:
                break;
        }
    }
}



/**
 *  view与view的相对位置
 *
 *  带sizeToFit
 */
- (void)setRelativeLayoutWithDirection:(kDIRECTION)direction destinationView:(UIView *)destinationView parentRelation:(BOOL)parentRelation distance:(CGFloat)distance center:(BOOL)center sizeToFit:(BOOL)sizeToFit
{
    if (sizeToFit) {
        [self sizeToFit];
    }
    
    [self setRelativeLayoutWithDirection:direction destinationView:destinationView parentRelation:parentRelation distance:direction center:center];
}








#pragma mark Bear根据子view自动布局-scrollView
/*
 viewArray:         装有子类view的数组
 parentView:        父类的view
 offStart:          起始点和边框的距离
 offEnd:            结束点和边框的距离
 center: 是否和父类的view剧中对其（YES：剧中对其，NO：不剧中对齐）
 layoutAxis:   是否水平自动布局（YES：水平方向自动布局，NO：垂直方向自动布局）
 offDistanceEqualViewDistance 边距和view之间的距离是否相等
 */
+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray parentScrollView:(UIScrollView *)parentScrollView offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd center:(BOOL)center layoutAxis:(kLAYOUT_AXIS)layoutAxis
{
    int widthAllSubView = 0;  //所有子view的宽总和
    
    if (layoutAxis == kLAYOUT_AXIS_X) {
        
        /*
         水平方向自动布局
         */
        //获取所有子类view的宽度总和
        for (UIView *tempSubView in viewArray) {
            widthAllSubView += tempSubView.frame.size.width;
        }
        
        if (parentScrollView.contentSize.width - widthAllSubView >= offStart + offEnd) {
            /*
             可以使用宽度自动布局
             */
            CGFloat deltaX = (parentScrollView.contentSize.width - widthAllSubView - offStart - offEnd)/([viewArray count] - 1);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                CGRect tempFrame = tempSubView.frame;
                tempFrame.origin.x = tempX;
                tempSubView.frame = tempFrame;
                
                if (center) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(tempSubView.center.x, parentScrollView.contentSize.height/2);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + CGRectGetWidth(tempSubView.bounds) + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view宽总和:%d\noffStart:%f\noffStart:%f\n父类view宽总和:%f\n=======================",(unsigned long)[viewArray count], widthAllSubView, offStart, offEnd, parentScrollView.contentSize.width);
        }
    }else{
        
        /*
         垂直方向自动布局
         */
        //获取所有子类view的高度总和
        for (UIView *tempSubView in viewArray) {
            widthAllSubView += tempSubView.frame.size.height;
        }
        
        if (parentScrollView.contentSize.height - widthAllSubView >= offStart + offEnd) {
            /*
             可以使用高度自动布局
             */
            CGFloat deltaX = (parentScrollView.contentSize.height - widthAllSubView - offStart - offEnd)/([viewArray count] - 1);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                CGRect tempFrame = tempSubView.frame;
                tempFrame.origin.y = tempX;
                tempSubView.frame = tempFrame;
                
                if (center) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(parentScrollView.contentSize.width/2, tempSubView.center.y);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + CGRectGetHeight(tempSubView.bounds) + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view高总和:%d\noffStart:%f\noffStart:%f\n父类view高总和:%f\n=======================",(unsigned long)[viewArray count], widthAllSubView, offStart, offEnd, parentScrollView.contentSize.height);
        }
    }
}




//  验证subView数组的父类view是否一致
+ (BOOL)validateParentViewConsistentOfArray:(NSMutableArray *)viewArray
{
    UIView *parentView = [viewArray[0] superview];
    for (UIView *tempSubView in viewArray) {
        if (![parentView isEqual:[tempSubView superview]]) {
            NSLog(@"!!! 父类view不同，无法自动布局");
            return NO;
        }
    }
    
    return YES;
}

+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center
{
    [self BearAutoLayViewArray:viewArray
                    layoutAxis:layoutAxis
                        center:center
                      offStart:0
                        offEnd:0
                   gapDistance:0
                superSizeToFit:NO];
}


/**
 *  根据子view自动布局
 *
 *  viewArray:      装有子类view的数组
 *  offStart:       起始点和边框的距离
 *  offEnd:         结束点和边框的距离
 *  center:         是否和父类的view居中对其（水平方向布局 则 垂直方向居中；垂直方向布局 则 水平方向居中）
 *  layoutAxis:     布局轴向（kLAYOUT_AXIS_X：水平方向自动布局，kLAYOUT_AXIS_Y：垂直方向自动布局）
 */
+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd
{
    
    [self BearAutoLayViewArray:viewArray
                    layoutAxis:layoutAxis
                        center:center
                      offStart:offStart
                        offEnd:offEnd
                   gapDistance:0
                superSizeToFit:NO];
    
    
    
    
    
    int widthAllSubView = 0;  //所有子view的宽总和
    
    UIView *parentView = [viewArray[0] superview];
    for (UIView *tempSubView in viewArray) {
        if (![parentView isEqual:[tempSubView superview]]) {
            NSLog(@"!!! 父类view不同，无法自动布局");
            return;
        }
    }
    
    if (layoutAxis == kLAYOUT_AXIS_X) {
        
        /*
         水平方向自动布局
         */
        //获取所有子类view的宽度总和
        for (UIView *tempSubView in viewArray) {
            widthAllSubView += tempSubView.width;
        }
        
        if (parentView.width - widthAllSubView >= offStart + offEnd) {
            /*
             可以使用宽度自动布局
             */
            
            CGFloat deltaX = (parentView.width - widthAllSubView - offStart - offEnd)/([viewArray count] - 1);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                [tempSubView setX:tempX];
                
                if (center) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(tempSubView.center.x, parentView.height/2);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + tempSubView.width + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view宽总和:%d\noffStart:%f\noffStart:%f\n父类view宽总和:%f\n=======================",(unsigned long)[viewArray count], widthAllSubView, offStart, offEnd, parentView.width);
        }
    }else{
        
        /*
         垂直方向自动布局
         */
        //获取所有子类view的高度总和
        for (UIView *tempSubView in viewArray) {
            widthAllSubView += tempSubView.height;
        }
        
        if (CGRectGetHeight(parentView.bounds) - widthAllSubView >= offStart + offEnd) {
            /*
             可以使用高度自动布局
             */
            CGFloat deltaX = (parentView.height - widthAllSubView - offStart - offEnd)/([viewArray count] - 1);//子view的x间距
            CGFloat tempX = offStart;//用于存储子view临时的X起点
            
            for (int i = 0; i < [viewArray count]; i++) {
                UIView *tempSubView = viewArray[i];
                
                //给子view重新设定x起点
                [tempSubView setY:tempX];
                
                if (center) {
                    //竖直方向相对于父类view剧中
                    tempSubView.center = CGPointMake(parentView.width/2, tempSubView.center.y);
                }
                //tempX加上当前子view的width和deltaX
                tempX = tempX + tempSubView.height + deltaX;
            }
        }else{
            
            /*
             无法使用自动布局
             */
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view高总和:%d\noffStart:%f\noffStart:%f\n父类view高总和:%f\n=======================",(unsigned long)[viewArray count], widthAllSubView, offStart, offEnd, parentView.height);
        }
    }
}



+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center gapDistance:(CGFloat)gapDistance
{
    
    UIView *parentView = [viewArray[0] superview];
    for (UIView *tempView in viewArray) {
        if (![parentView isEqual:[tempView superview]]) {
            NSLog(@"!!! 父类view不同，无法自动布局");
            return;
        }
    }
    
    CGFloat offStart    = 0;
    CGFloat offEnd      = 0;
    
    if (layoutAxis == kLAYOUT_AXIS_X) {
        CGFloat widthTotal = 0;
        for (UIView *tempView in viewArray) {
            widthTotal += CGRectGetWidth(tempView.frame);
        }
        offStart = (CGRectGetWidth(parentView.frame) - widthTotal - ([viewArray count] - 1) * gapDistance)/2;
        offEnd = offStart;
    }
    else{
        CGFloat heightTotal = 0;
        for (UIView *tempView in viewArray) {
            heightTotal += CGRectGetHeight(tempView.frame);
        }
        offStart = (CGRectGetHeight(parentView.frame) - heightTotal - ([viewArray count] - 1) * gapDistance)/2;
        offEnd = offStart;
    }
    
    [self BearAutoLayViewArray:viewArray
                    layoutAxis:layoutAxis
                        center:center
                      offStart:offStart
                        offEnd:offEnd
                   gapDistance:gapDistance
                superSizeToFit:NO];
}



+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd gapDistance:(CGFloat)gapDistance
{
    [self BearAutoLayViewArray:viewArray
                    layoutAxis:layoutAxis
                        center:center
                      offStart:offStart
                        offEnd:offEnd
                   gapDistance:gapDistance
                superSizeToFit:YES];
}



+ (void)BearAutoLayViewArray:(NSMutableArray *)viewArray layoutAxis:(kLAYOUT_AXIS)layoutAxis center:(BOOL)center offStart:(CGFloat)offStart offEnd:(CGFloat)offEnd gapDistance:(CGFloat)gapDistance superSizeToFit:(BOOL)superSizeToFit
{
    int widthAllSubView = 0;  //所有子view的宽总和
    
    UIView *parentView = [viewArray[0] superview];
    for (UIView *tempSubView in viewArray) {
        if (![parentView isEqual:[tempSubView superview]]) {
            NSLog(@"!!! 父类view不同，无法自动布局");
            return;
        }
    }
    
    //  水平方向自动布局
    if (layoutAxis == kLAYOUT_AXIS_X) {
        
        for (UIView *tempSubView in viewArray) {
            widthAllSubView += tempSubView.width;
        }
        CGFloat needWidth = offStart + offEnd + widthAllSubView + ([viewArray count] - 1) * gapDistance;
        
        if (superSizeToFit == YES) {
            [parentView setWidth:needWidth];
        }
        if (parentView.width < needWidth) {
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view宽总和:%d\noffStart:%f\noffStart:%f\n父类view宽总和:%f\n=======================",(unsigned long)[viewArray count], widthAllSubView, offStart, offEnd, parentView.width);
        }
        
        CGFloat deltaX = (parentView.width - widthAllSubView - offStart - offEnd)/([viewArray count] - 1);//子view的x间距
        CGFloat tempX = offStart;//用于存储子view临时的X起点
        
        for (int i = 0; i < [viewArray count]; i++) {
            
            UIView *tempSubView = viewArray[i];
            [tempSubView setX:tempX];
            tempX += tempSubView.width + deltaX;
            
            if (center) {
                tempSubView.center = CGPointMake(tempSubView.center.x, parentView.height/2);
            }
        }
    }
    
    //  垂直方向自动布局
    else{
        
        //获取所有子类view的高度总和
        for (UIView *tempSubView in viewArray) {
            widthAllSubView += tempSubView.height;
        }
        CGFloat needHeight = offStart + offEnd + widthAllSubView + ([viewArray count] - 1) * gapDistance;
        
        if (superSizeToFit == YES) {
            [parentView setWidth:needHeight];
        }
        if (parentView.height < needHeight) {
            NSLog(@"\n=======================\n宽度超出，无法自动布局。\n子类view个数:%lu\n子类view高总和:%d\noffStart:%f\noffStart:%f\n父类view高总和:%f\n=======================",(unsigned long)[viewArray count], widthAllSubView, offStart, offEnd, parentView.height);
        }
        
        
        CGFloat deltaX = (parentView.height - widthAllSubView - offStart - offEnd)/([viewArray count] - 1);//子view的x间距
        CGFloat tempX = offStart;//用于存储子view临时的X起点
        
        for (int i = 0; i < [viewArray count]; i++) {
            
            UIView *tempSubView = viewArray[i];
            [tempSubView setY:tempX];
            tempX += tempSubView.height + deltaX;
            
            if (center) {
                //竖直方向相对于父类view剧中
                tempSubView.center = CGPointMake(parentView.width/2, tempSubView.center.y);
            }
        }
    }
}

@end
