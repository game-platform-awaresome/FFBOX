//
//  DriveInfoCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/12.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "DriveInfoCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"

#import "FFDriveModel.h"

@interface DriveInfoCell () <XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageVIew;

@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *ImageContentView;

@property (weak, nonatomic) IBOutlet UIButton *FavorButton;

@property (weak, nonatomic) IBOutlet UIButton *unFavorButton;

@property (weak, nonatomic) IBOutlet UIButton *sharedButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

//@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@property (nonatomic, strong) NSString *dynamicsID;

@end



@implementation DriveInfoCell {
    CGFloat imageContentViewWidth;
    CGFloat imageviewWidth;
    CellButtonType buttonType;
    BOOL delegateCallBack;
    BOOL isNoonButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //icon
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderColor = [[UIColor orangeColor] CGColor];
    self.iconImageView.layer.borderWidth = 3;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.ImageContentView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 200);
    self.rowHeight = 78;

    imageContentViewWidth = kSCREEN_WIDTH - 32;

    [self addRespondsToButton:self.sharedButton];
    [self addRespondsToButton:self.commentButton];

    [self.FavorButton setTintColor:[UIColor grayColor]];
    [self.unFavorButton setTintColor:[UIColor grayColor]];
    [self.sharedButton setTintColor:[UIColor grayColor]];
    [self.commentButton setTintColor:[UIColor grayColor]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToIcon)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:tap];

}

- (void)respondsToIcon {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DriveInfoCell:didClickIconWithUid:)]) {
        NSString *uid = [NSString stringWithFormat:@"%@",self.dict[@"dynamics"][@"uid"]];
        if (uid.length > 0) {
            [self.delegate DriveInfoCell:self didClickIconWithUid:uid];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - button add target
- (void)addRespondsToButton:(UIButton *)button {
    [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)removeRespondsToButton:(UIButton *)button {
    [button removeTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
}


#pragma mark - responds
- (void)respondsToButton:(UIButton *)sender {
    if (sender == self.FavorButton) {
        isNoonButton ? (buttonType = noonButton) : (buttonType = likeButton);
    } else if (sender == self.unFavorButton) {
        isNoonButton ? (buttonType = noonButton) : (buttonType = dislikeButton);
    } else if (sender == self.sharedButton) {
        buttonType = sharedButton;
    } else if (sender == self.commentButton) {
        buttonType = commentButoon;
    }

    [self delegateCallBackWithType:buttonType];

}

- (void)delegateCallBackWithType:(CellButtonType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DriveInfoCell:didClickButtonWithType:)]) {
        [self.delegate DriveInfoCell:self didClickButtonWithType:type];
    }
}

#pragma mark - set
- (void)setDict:(NSDictionary *)dict {

    if (dict) {
        _dict = dict;
    } else {
        return;
    }

    //icon
    [self setIconImageWith:dict[@"user"][@"icon_url"]];
    //nick name
    [self setNickNameWith:dict[@"user"][@"nick_name"]];
    //sex
    [self setSexWith:dict[@"user"][@"sex"]];
    //sex
    [self setVipWith:dict[@"user"][@"sex"]];
    //time label
    [self setTimeWith:dict[@"dynamics"][@"create_time"]];
    //content
    [self setcontentWith:dict[@"dynamics"][@"content"]];
    //images
    id array = dict[@"dynamics"][@"imgs"];
    if (array == nil || ![array isKindOfClass:[NSArray class]]) {
        array = [NSArray array];
    }
    [self setImagesWith:array];

    //like
    [self setLikeWith:dict[@"dynamics"][@"likes"]];
    //unlie
    [self setUnLikeWith:dict[@"dynamics"][@"dislike"]];
    //shared
    [self setSharedWith:dict[@"dynamics"][@"share"]];
    //comment
    [self setCommentWith:dict[@"dynamics"][@"comment"]];
    //dynamics id
    [self setDynamicsID:dict[@"dynamics"][@"id"]];

    //operate
    [self setOperateWith:dict[@"user"][@"operate"]];
}

- (void)setIconImageWith:(NSString *)url {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

- (void)setNickNameWith:(NSString *)Str {
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",Str];
    [self.nickNameLabel sizeToFit];
}

- (void)setSexWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] && str!= nil && str.boolValue) {
        self.vipImageView.hidden = NO;
    } else {
        self.vipImageView.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexImageVIew.hidden = NO;
        if (str.integerValue == 1) {
            self.sexImageVIew.image = [UIImage imageNamed:@"Community_Sex_Male"];
        } else {
            self.sexImageVIew.image = [UIImage imageNamed:@"Community_Sex_Female"];
        }
    } else {
        self.sexImageVIew.hidden = YES;
    }
}

- (void)setTimeWith:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:str.integerValue];
    NSString *timeString = [formatter stringFromDate:date];
    self.timeLabel.text  = timeString;
}

- (void)setcontentWith:(NSString *)content {
    self.contentLabel.text = [NSString stringWithFormat:@"%@",content];
    [self.contentLabel sizeToFit];
    self.rowHeight += CGRectGetMaxY(self.contentLabel.frame);
}

- (void)setImagesWith:(NSArray *)images {
    CGFloat imageContentHeight;
    syLog(@"images === %@",images);
    if (images != nil && images.count != 0) {
        switch (images.count) {
            case 1: {
                imageviewWidth = imageContentViewWidth / 3;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 2: {
                imageviewWidth = imageContentViewWidth / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 3: {
                imageviewWidth = imageContentViewWidth / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 4: {
                imageviewWidth = imageContentViewWidth / 3 - 5;
                imageContentHeight = imageviewWidth * 2 + 5;
                break;
            }

            default: {
//                imageviewWidth = imageContentViewWidth / 2 - 5;
                imageContentHeight = 2;
            }
                break;
        }
    } else {
        imageContentHeight = 2;
    }
    [self setImageViewWith:images];

    self.imageHeight.constant = imageContentHeight;
}

- (void)setImageViewWith:(NSArray *)images {
    if (_imageViews != nil) {
        for (UIImageView *view in _imageViews) {
            [view removeFromSuperview];
        }
    }

    _imageViews = [NSMutableArray arrayWithCapacity:images.count];
    _images = [NSMutableArray arrayWithCapacity:images.count];
    if (images.count > 0) {
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = idx + 10086;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];

            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage new] options:(SDWebImageHighPriority) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

                if (image != nil) {
                    [_images addObject:image];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                        [[[SDWebImageManager sharedManager] imageCache]storeImage:image forKey:obj completion:nil];

                    });
                }

            }];

            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            CGFloat y = 0;
            CGFloat x = 2.5 + (imageviewWidth + 5) * idx;
            if (images.count == 4 && idx < 2) {
                y = 0;
                x = 2.5 + (imageviewWidth + 5) * idx;
            } else if (images.count == 4 && idx >= 2) {
                y = imageviewWidth + 5;
                x = 2.5 + (imageviewWidth + 5) * (idx - 2);
            } else {

            }

            imageView.frame = CGRectMake(x, y, imageviewWidth, imageviewWidth);
            [_imageViews addObject:imageView];
            [self.ImageContentView addSubview:imageView];
        }];
    }

}

- (void)clickImage:(UITapGestureRecognizer *)sender {
    syLog(@"点击图片");

    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:self.images currentImageIndex:sender.view.tag - 10086];
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式

    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
//    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:@"删除" otherButtonTitles:@"发送给朋友",@"保存图片",@"收藏",@"投诉",nil];

}

- (void)setDynamicsID:(NSString *)dynamicsID {
    NSString *string = [NSString stringWithFormat:@"%@",dynamicsID];
    (string.length > 0) ? (_dynamicsID = string) : (_dynamicsID = nil);
}

- (void)setLikeWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.FavorButton setTitle:[NSString stringWithFormat:@"  %@赞",str] forState:(UIControlStateNormal)];
    }
}

- (void)setUnLikeWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.unFavorButton setTitle:[NSString stringWithFormat:@"  %@踩",str] forState:(UIControlStateNormal)];
    }
}

- (void)setSharedWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.sharedButton setTitle:[NSString stringWithFormat:@"  %@分享",str] forState:(UIControlStateNormal)];
    }
}

- (void)setCommentWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"  %@评论",str] forState:(UIControlStateNormal)];
    }
}

- (void)setOperateWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string != nil && string.length != 0) {
        syLog(@"operate string === %@",str);
        switch (string.integerValue) {
            case 0: {
                [self removeLikeButtonAndeDisLikeButtonSelect];
                self.unFavorButton.tintColor = [UIColor redColor];
                self.FavorButton.tintColor = [UIColor grayColor];
                isNoonButton = YES;
            }
                break;
            case 1: {
                [self removeLikeButtonAndeDisLikeButtonSelect];
                self.unFavorButton.tintColor = [UIColor grayColor];
                self.FavorButton.tintColor = [UIColor redColor];
                isNoonButton = YES;
            }
                break;
            case 2: {
                [self addRespondsToButton:self.FavorButton];
                [self addRespondsToButton:self.unFavorButton];
                self.unFavorButton.tintColor = [UIColor grayColor];
                self.FavorButton.tintColor = [UIColor grayColor];
                isNoonButton = NO;
            }
                break;

            default: {
                [self canNotRespondsToLikeButtonAndDislikeButton];
            }
                break;
        }
    } else {
        [self canNotRespondsToLikeButtonAndDislikeButton];
    }
}

- (void)canNotRespondsToLikeButtonAndDislikeButton {
    [self removeLikeButtonAndeDisLikeButtonSelect];
    self.unFavorButton.tintColor = [UIColor grayColor];
    self.FavorButton.tintColor = [UIColor grayColor];
    isNoonButton = YES;
}

- (void)removeLikeButtonAndeDisLikeButtonSelect {
    [self removeRespondsToButton:self.FavorButton];
    [self removeRespondsToButton:self.unFavorButton];
}


#pragma mark - getter








@end






