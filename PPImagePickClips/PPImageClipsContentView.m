//
//  PPImageClipsContentView.m
//  PPImagePickClips
//
//  Created by Young on 2020/2/25.
//  Copyright © 2020 Young. All rights reserved.
//

#import "PPImageClipsContentView.h"


#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface PPImageClipsContentView ()
<UIScrollViewDelegate>

@property (nonatomic, strong) CAShapeLayer   *maskLayer;/**< */
@property (nonatomic, strong) UIView   *captureView;/**< 照相图*/

@property (nonatomic, strong) UIScrollView   *scrollView;/**< */
@property (nonatomic, strong) UIImageView   *imageView;/**<   */
@property (nonatomic, strong) UIImage   *originImage;/**< 原图*/

@end

@implementation PPImageClipsContentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsSize = CGSizeMake(ScreenWidth, ScreenWidth / 3 * 4);
        self.captureView = [[UIView alloc] initWithFrame:CGRectMake(0, [self topMargin], self.clipsSize.width, self.clipsSize.height)];
        [self addSubview:self.captureView];
        [self.captureView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    if (!self.maskLayer) {
        CAShapeLayer *mask = [CAShapeLayer layer];
        self.maskLayer = mask;
        [self.layer addSublayer:mask];
        mask.frame = self.bounds;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, self.bounds);
        CGPathAddRect(path, nil, CGRectMake(0, [self topMargin], self.clipsSize.width, self.clipsSize.height));
        [mask setFillRule:kCAFillRuleEvenOdd];
        [mask setPath:path];
        [mask setFillColor:[[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor]];
        CGPathRelease(path);
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, [self topMargin], self.clipsSize.width, self.clipsSize.height);
        layer.borderColor = RGBHex(0x9D62FF).CGColor;
        layer.borderWidth = 2;
        [mask addSublayer:layer];
    }
}

- (CGFloat)topMargin {
    return (self.bounds.size.height - self.clipsSize.height) / 2;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.clipsSize.width, self.clipsSize.height)];
        _scrollView.delegate = self;
        _scrollView.layer.masksToBounds = NO;
        
        _scrollView.minimumZoomScale = 1.f;
        _scrollView.maximumZoomScale = 10.f;
        _scrollView.zoomScale = 1.f;
        
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.contentInset = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)setOriginImage:(UIImage *)originImage {
    if (!originImage) return;
    self.originImage = originImage;
    self.imageView.image = originImage;
    self.imageView.frame = CGRectMake(0, 0, [self imageViewOriginSize].width, [self imageViewOriginSize].height);
    self.scrollView.contentSize = [self imageViewOriginSize];
    self.imageView.center = self.scrollView.center;
}

- (UIImage *)captureImage {
    UIGraphicsBeginImageContextWithOptions(self.clipsSize, NO, [UIScreen mainScreen].scale);
    [self.captureView.layer drawInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (CGSize)imageViewOriginSize {
    if (self.clipsSize.width / self.originImage.size.width > self.clipsSize.height / self.originImage.size.height) {
        return CGSizeMake(self.clipsSize.width, (CGFloat)((self.originImage.size.height / self.originImage.size.width) * self.clipsSize.width)); //宽
    }
    else {
        return CGSizeMake((CGFloat)((self.originImage.size.width / self.originImage.size.height) * self.clipsSize.height), self.clipsSize.height);  //高
    }
}

#pragma mark - UIScrollViewDelegate

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isMoving) {
        self.isMoving(YES);
    }
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isMoving) {
        self.isMoving(decelerate);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isMoving) {
        self.isMoving(NO);
    }
}
// return a view that will be scaled. if delegate returns nil, nothing happens
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if (self.isMoving) {
        self.isMoving(YES);
    }
}
// scale between minimum and maximum. called after any 'bounce' animations
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    [self.scrollView setZoomScale:scale animated:NO];
    if (self.isMoving) {
        self.isMoving(NO);
    }
}
@end
