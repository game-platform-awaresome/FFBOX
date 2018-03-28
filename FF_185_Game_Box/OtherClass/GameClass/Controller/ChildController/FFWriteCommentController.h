//
//  FFWriteCommentController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendCommentBlock)(NSDictionary *dict, BOOL success);

@interface FFWriteCommentController : UIViewController

@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) SendCommentBlock sendCommentCallBack;

@end
