//
//  ViewController.m
//  upImages
//  upImages
//  Created by 张君泽 on 16/5/25.


#import "ViewController.h"
#import <Photos/Photos.h>
#import "UPImageS.h"
#import "upImage.h"
#import "UIView+Extension.h"
@interface ViewController ()<UPImageSDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)UPImageS *upImageVS;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)UIView *lowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建图片数组
    _array = [NSMutableArray new];
    for (int i = 1; i < 6; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [_array addObject:image];
    }
    _lowView = [[UIView alloc] init];
    [self creatImageVS];
    [self.view addSubview:_lowView];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark UPImageSDelegate
- (void)clickThePhotoButton:(UIButton *)button {
    NSLog(@"控制器响应拍照");
    //调用相机
    [self canUseCamera];
}
- (void)clickTheVoiceButton:(UIButton *)button{
    NSLog(@"控制器响应录音");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            _lowView.height += 30;
            _upImageVS.y += 30;
            NSLog(@"%@ --%@",NSStringFromCGRect(_lowView.frame),NSStringFromCGRect(_upImageVS.frame));
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(clickThePlayVBtn:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, _lowView.width, 30);
            button.backgroundColor = [UIColor yellowColor];
            [_lowView addSubview:button];
            _lowView.backgroundColor = [UIColor lightGrayColor];
            
        }];
    });
}
- (void)clickTheDeleteBtn:(UIButton *)button{
    NSLog(@"控制器响应删除按钮");
//    [button.superview removeFromSuperview];
    NSLog(@"--%zd",button.superview.superview.subviews.count);
    upImage *imageV = (upImage *)button.superview;
    NSLog(@"%d",imageV.num);
    [_upImageVS removeFromSuperview];
    [_array removeObjectAtIndex:imageV.num];
    [self creatImageVS];
//    _upImageVS.photos = _array;
    
}
//创建视图
- (void)creatImageVS{
    _upImageVS = [[UPImageS alloc] init];
    _upImageVS.delegate = self;
    _upImageVS.photos = _array;
    CGSize size = [UPImageS sizeWithCount:_array.count + 2];
    _lowView.frame = CGRectMake(0, 30, size.width, size.height);
    _upImageVS.frame = _lowView.bounds;
    [_lowView addSubview:_upImageVS];
}
- (void)clickThePlayVBtn:(UIButton *)btn{
    NSLog(@"播放音频");
    [self fetchPhotosFromPhotoAlbum];
}
//调用相机
- (void)canUseCamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [_array addObject:image];
    [_upImageVS removeFromSuperview];
    
    [self creatImageVS];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消图片选择/取消拍照");
}
- (void)fetchPhotosFromPhotoAlbum{
//    NSLog(@"准备扫描图片库,等待访问信号");
//    dispatch_semaphore_t sem = dispatch_semaphore_create(20);
//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//     NSLog(@"------ 扫描设置中(锁定扫描库)");
    NSMutableArray *tempUrlListArray = [NSMutableArray new];
    //得到所有图片
    // 获取所有资源的集合，并按资源的创建时间排序
    ///获取资源时的参数

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    ///表示一系列的资源的集合,也可以是相册的集合
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    ///控制加载图片时的一系列的参数
    PHImageRequestOptions *operation = [[PHImageRequestOptions alloc] init];
    operation.synchronous = YES;
    operation.resizeMode = PHImageRequestOptionsResizeModeFast;
    int i = 0;
    for (id obj in assetsFetchResults) {
        i ++;
        PHAsset *asset = obj;
        if ([asset.localIdentifier isKindOfClass:[NSString class]]) {
            NSLog(@"-%@",asset.localIdentifier);
            [tempUrlListArray addObject:asset.localIdentifier];
        }
    }
    NSLog(@"%d",i);
    //一下获取照片
    CGFloat scale = [UIScreen mainScreen].scale;
    NSLog(@"%f",scale);
    CGSize targetSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * scale, CGRectGetHeight([UIScreen mainScreen].bounds) * scale);
    for (NSString *imagestr in tempUrlListArray) {
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    [manager startCachingImagesForAssets:assets targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil];
    
    PHFetchResult *saveAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[imagestr] options:nil];
    [saveAsset enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [assets addObject:obj];
        }
        [manager requestImageForAsset:obj targetSize:targetSize contentMode:PHImageContentModeDefault options:operation resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"-zzzzzzzz--%@",result);
            [_upImageVS removeFromSuperview];
            [self.array addObject:result];
            [self creatImageVS];
            
        }];
    }];
    
    
    }
}
@end
