//
//  upImage.m
//  upImages
//
//  Created by 张君泽 on 16/5/25.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "upImage.h"
#define DWide 30
#define DHight 30
@implementation upImage

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:delete];
        self.deleteBtn = delete;
        self.userInteractionEnabled = YES;
    }
    return self;
}
- (void)layoutSubviews{
    CGFloat x = CGRectGetMaxX(self.bounds) - DWide;
    UIButton *delete = [self.subviews lastObject];
    delete.frame = CGRectMake(x, 0, DWide, DHight);
}

@end
