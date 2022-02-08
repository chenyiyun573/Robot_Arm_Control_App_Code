//
//  BluetoothView.m
//  Robot Control
//
//  Created by LOBOT on 2017/7/24.
//  Copyright © 2017年 LOBOT. All rights reserved.
//

#import "BluetoothView.h"


@interface BluetoothView()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searching;

@end

@implementation BluetoothView

- (void)initViews
{
    _title.text = @"搜索中";
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_okBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
    [_searching startAnimating];
}
- (IBAction)cancel:(id)sender
{
    [_delegate cancelSerach];
}
- (IBAction)okClick:(id)sender
{
    [_delegate research];
}
@end
