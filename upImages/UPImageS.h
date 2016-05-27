//
//  UPImageS.h
//  upImages
//
//  Created by 张君泽 on 16/5/25.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UPImageSDelegate <NSObject>

@optional
-(void)clickThePhotoButton:(UIButton *)button;
-(void)clickTheVoiceButton:(UIButton *)button;
- (void)clickTheDeleteBtn:(UIButton *)button;
@end

@interface UPImageS : UIView
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, strong)UIButton *photoButton;
@property (nonatomic, strong)UIButton *voiceButton;
@property (nonatomic, weak)id<UPImageSDelegate> delegate;
+ (CGSize)sizeWithCount:(NSUInteger)count;
+(UPImageS *)initWithPhotoArray:(NSArray *)photoArray count:(NSUInteger)count point:(CGPoint)point;
@end
