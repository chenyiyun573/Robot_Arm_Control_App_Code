//
//  BluetoothView.h
//  Robot Control
//
//  Created by LOBOT on 2017/7/24.
//  Copyright © 2017年 LOBOT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BluetoothProtocal <NSObject>
@required
- (void)cancelSerach;

- (void)research;

@end

@interface BluetoothView : UIView
@property (weak, nonatomic) IBOutlet UITableView *bluetoothTable;
@property (nonatomic,assign)id<BluetoothProtocal> delegate;
- (void)initViews;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@end
