//
//  LHCenterBle.h
//  XArm
//
//  Created by LOBOT on 17/6/22.
//  Copyright © 2017年 LOBOT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPBluetoothKit.h"
//#import "ActionData.h"

@protocol LHCenterBleProtocol <NSObject>
@required
- (void)discoverPeripheral;
- (void)connectSuccess:(NSInteger)index;
- (void)disConnect;
- (void)connectFail;
- (void)getMacAddr;
@end

@interface LHCenterBle : NSObject
@property(nonatomic,readonly)BOOL isReady;
@property (nonatomic,assign) id<LHCenterBleProtocol> delegate;
@property(nonatomic,strong)NSMutableArray *peripheralArray;
@property(nonatomic,copy)NSString *peripheralTag;
@property(nonatomic,copy)NSString *RSSITag;
@property(nonatomic,copy)NSString *macAddrTag;
@property(nonatomic,assign)BOOL connect;

- (void)LH_WriteData:(NSData *)data;
- (void)LH_dismissConnect;
- (void)startScan;
- (void)stopScan;
- (void)connectSelectDevice:(NSInteger)index;
- (void)actionCmdSend:(NSInteger)actionNum;
- (void)stopCmdSendWithControlMode;
- (void)sendData:(NSData *)data delayTime:(double)delayTime;
+ (instancetype)shareInstance;
@end
