//
//  UPImageS.m
//  upImages
//
//  Created by 张君泽 on 16/5/25.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "UPImageS.h"
#import "upImage.h"
#import "UIView+Extension.h"
#define PhotoWH 120
#define Space 10
#define macCol(count) ((count == 4)?2:3)
@implementation UPImageS

- (UIButton *)photoButton {
    if (!_photoButton) {
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton addTarget:self action:@selector(clickeP:) forControlEvents:UIControlEventTouchUpInside];
        _photoButton.contentMode = UIViewContentModeCenter;
        [_photoButton setImage:[UIImage imageNamed:@"cap_p"] forState:UIControlStateNormal];
    }
    return _photoButton;
}
- (UIButton *)voiceButton {
    if (!_voiceButton) {
        self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton addTarget:self action:@selector(clickV:) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.contentMode = UIViewContentModeCenter;
        [_voiceButton setImage:[UIImage imageNamed:@"cap_d"] forState:UIControlStateNormal];

    }
    return _voiceButton;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}
- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    NSUInteger photosCount = photos.count;
    for (int i = 0; i < photosCount; i ++) {
        upImage *imageV = [[upImage alloc] init];
        imageV.image = photos[i];
        [imageV.deleteBtn addTarget:self action:@selector(clickTheDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageV];
    }
    if (self.photoButton.hidden == NO) {
        [self addSubview:self.photoButton];
    }
    if (self.voiceButton.hidden == NO) {
        [self addSubview:self.voiceButton];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //设置图片和按钮的位置
    NSUInteger photosCount = self.subviews.count;
//    if (self.photoButton.hidden) {
//        photosCount --;
//    }
//    if (self.voiceButton.hidden) {
//        photosCount --;
//    }
    int maxCol = macCol(photosCount);
    for (int i = 0; i < photosCount; i ++) {
        int col = i % maxCol;
        int row = i /maxCol;
        if ([self.subviews[i] isKindOfClass:[upImage class]]) {
            upImage *imageV = self.subviews[i];
            imageV.num = i;
            imageV.x = col *(PhotoWH + Space) + Space;
            imageV.y = row *(PhotoWH + Space) + Space;
            imageV.width = PhotoWH;
            imageV.height = PhotoWH;
        }else if ([self.subviews[i] isKindOfClass:[UIButton class]]){
            if (self.subviews[i].tag != 666) {
            UIButton *button = self.subviews[i];
            button.backgroundColor = [UIColor redColor];
            button.x = col *(PhotoWH + Space) +Space;
            button.y = row *(PhotoWH + Space) + Space;
            button.width = PhotoWH;
            button.height = PhotoWH;
            }
        }
    }
   
}
+ (CGSize)sizeWithCount:(NSUInteger)count{
    //最多列数
    int maxCols = macCol(count);
    //列数
    NSUInteger cols = (count >= maxCols) ?maxCols:count;
    CGFloat photosVW = cols *PhotoWH + (cols + 1) *Space;
    //行数
    NSUInteger rows = (count + maxCols - 1)/maxCols;
    CGFloat photosVH = rows *PhotoWH + (rows + 1) *Space;
    
    return CGSizeMake(photosVW, photosVH);
}
+ (UPImageS *)initWithPhotoArray:(NSArray *)photoArray count:(NSUInteger)count point:(CGPoint)point{
    UPImageS *upimageVS = [[UPImageS alloc] init];
    //暂时不写
    return upimageVS;
}
#pragma mark click
- (void)clickeP:(UIButton *)sender{
    NSLog(@"点击拍照按钮");
    if ([self.delegate respondsToSelector:@selector(clickThePhotoButton:)]) {
        [self.delegate clickThePhotoButton:sender];
    }
}
- (void)clickV:(UIButton *)sender{
    NSLog(@"点击录音按钮");
    if ([self.delegate respondsToSelector:@selector(clickTheVoiceButton:)]) {
        [self.delegate clickTheVoiceButton:sender];
    }
}
- (void)clickTheDeleteBtn:(UIButton *)sender{
    NSLog(@"s-%zd",sender.superview.superview.subviews.count);
    if ([self.delegate respondsToSelector:@selector(clickTheDeleteBtn:)]) {
        [self.delegate clickTheDeleteBtn:sender];
    }
}
@end
