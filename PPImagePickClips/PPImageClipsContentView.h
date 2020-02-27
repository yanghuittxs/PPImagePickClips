//
//  PPImageClipsContentView.h
//  PPImagePickClips
//
//  Created by Young on 2020/2/25.
//  Copyright © 2020 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPImageClipsContentView : UIView
@property (nonatomic, assign) CGSize   clipsSize;/**< 裁剪尺寸*/
@property (nonatomic, copy) void(^isMoving)(BOOL ismove);/**< 正在形变或平移中回调*/


- (void)setOriginImage:(UIImage *)originImage;

- (UIImage *)captureImage;
@end

NS_ASSUME_NONNULL_END
