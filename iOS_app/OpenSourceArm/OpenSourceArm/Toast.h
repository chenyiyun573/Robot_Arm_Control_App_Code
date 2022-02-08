//
//  Toast.h
//  LSC-6
//
//  Created by LOBOT on 2017/7/19.
//  Copyright © 2017年 LOBOT. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
enum TimeType
{
    LongTime,
    ShortTime
};

@interface Toast : UIView
{
    UILabel* _label;
    NSString * _text;
    enum TimeType _time;
}
+(Toast *)makeText:(NSString *)text;
-(void)showWithType:(enum TimeType)type;
@end

