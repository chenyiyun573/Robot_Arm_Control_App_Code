//
//  LHCenterBle.m
//  XArm
//
//  Created by LOBOT on 17/6/22.
//  Copyright © 2017年 LOBOT. All rights reserved.
//

#import "LHCenterBle.h"


@interface LHCenterBle ()

@property (nonatomic, strong) MPCentralManager *centralManager;
@property (nonatomic, strong) MPPeripheral *connectedPeripheral;

@property(nonatomic,strong)MPCharacteristic *writeCharacteristic;//写特征
@property(nonatomic,strong)MPCharacteristic *readCharacteristic;//读特征

@property(nonatomic,strong)NSNumber *undefinedNum;

@property(nonatomic,assign)NSUInteger languageType;//00 简体 01 繁体 02 英文
@end

@implementation LHCenterBle

static LHCenterBle *_centerBle;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _connect = NO;
        _centralManager = [[MPCentralManager alloc] initWithQueue:nil];
        [_centralManager setUpdateStateBlock:^(MPCentralManager *centralManager){
            if(centralManager.state == CBCentralManagerStatePoweredOn){
                _isReady = YES;
            }
            else{
                _isReady = NO;
            }}];
    }
    _undefinedNum = [[NSNumber alloc] initWithUnsignedInteger:0x5555];
    _peripheralTag = @"peripheral";
    _RSSITag = @"RSSI";
    _macAddrTag = @"macAddr";
    return self;
}

- (void)getSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if([currentLanguage isEqualToString:@"zh-Hans"])
    {
        _languageType = 0;
    }
    else if([currentLanguage isEqualToString:@"zh-Hant"])
    {
        _languageType = 1;
    }
    else
    {
        _languageType = 2;
    }
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _centerBle = [[super allocWithZone:NULL] init] ;
        //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
        //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
    }) ;
    
    return _centerBle ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [LHCenterBle shareInstance] ;
}

-(id) copyWithZone:(NSZone *)zone
{
    return [LHCenterBle shareInstance] ;//return _instance;
}

-(id) mutablecopyWithZone:(NSZone *)zone
{
    return [LHCenterBle shareInstance] ;
}

- (NSMutableArray *)peripheralArray
{
    if(_peripheralArray == nil)
    {
        _peripheralArray = [NSMutableArray array];
    }
    return _peripheralArray;
}

- (void)scanPeripehrals
{
    if(_centralManager.state == CBCentralManagerStatePoweredOn){
        [_centralManager scanForPeripheralsWithServices:nil options:nil withBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI)
         {
             NSLog(@"%s,line = %d central = %@, peripheral = %@, advertisementData = %@, RSSI = %@",__FUNCTION__,__LINE__,centralManager,peripheral,advertisementData,RSSI);
             
             NSMutableDictionary *dictPeriheral = [NSMutableDictionary dictionary];
             [dictPeriheral setObject:peripheral forKey:_peripheralTag];
             [dictPeriheral setObject:RSSI forKey:_RSSITag];
             if(![self.peripheralArray containsObject:dictPeriheral])//新搜索到的设备加入数组中
             {
                 
                 if(self.peripheralArray.count == 0)
                 {
                     [self.peripheralArray addObject:dictPeriheral];
                 }
                 else//将信号最强的设备排在前面
                 {
                     int cnt = 0;
                     for(NSMutableDictionary *obj in self.peripheralArray)
                     {
                         if([dictPeriheral[_RSSITag] intValue] > [obj[_RSSITag] intValue] && [dictPeriheral[_RSSITag] intValue] < 0)
                         {
                             [self.peripheralArray insertObject:dictPeriheral atIndex:[self.peripheralArray indexOfObject:obj]];
                             
                             break;
                         }
                         cnt++;
                     }
                     if(cnt == self.peripheralArray.count)//信号最弱，排在后面
                     {
                         [self.peripheralArray addObject:dictPeriheral];
                     }
                     
                 }
             }
             [_delegate discoverPeripheral];
         }];
    }
}

- (void)getMacAddress:(MPPeripheral *)mPeripheral andperiPheralIndex:(NSInteger)index;
{
    CBUUID *macServiceUUID = [CBUUID UUIDWithString:@"180A"];
    CBUUID *macCharcteristicUUID = [CBUUID UUIDWithString:@"2A23"];
    [mPeripheral discoverServices:@[macServiceUUID] withBlock:^(MPPeripheral *peripheral, NSError *error) {
        if(peripheral.services.count){
            MPService *service = [peripheral.services objectAtIndex:0];
            [service discoverCharacteristics:@[macCharcteristicUUID] withBlock:^(MPPeripheral *peripheral, MPService *service, NSError *error) {
                for(MPCharacteristic *characteristic in service.characteristics){
                    if([characteristic.UUID isEqual:macCharcteristicUUID]){
                        [characteristic readValueWithBlock:^(MPPeripheral *peripheral, MPCharacteristic *characteristic, NSError *error){
                            NSString *value = [NSString stringWithFormat:@"%@",characteristic.value];
                            NSMutableString *macString = [[NSMutableString alloc] init];
                            [macString appendString:[[value substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
                            [macString appendString:@":"];
                            [macString appendString:[[value substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
                            NSLog(@"macString:%@",macString);
                            [self.peripheralArray[index] setValue:macString forKey:_macAddrTag];
                            [_delegate getMacAddr];
                            [self getWriteAndReadCharacteristic];
                        }];
                    }
                    
                }
                
            }];
        }
    }];
}

- (void)getWriteAndReadCharacteristic
{
    [self.connectedPeripheral discoverServices:nil withBlock:^(MPPeripheral *peripheral, NSError *error) {
        for(MPService *service in peripheral.services)
        {
            [peripheral discoverCharacteristics:nil forService:service withBlock:^(MPPeripheral *peripheral, MPService *service, NSError *error) {
                for(MPCharacteristic *characteristic in service.characteristics)
                {
                    if([characteristic.UUID.UUIDString  isEqualToString:@"291A"])
                    {
                        NSLog(@"readable characteristic");
                        _readCharacteristic = characteristic;
                    }
                    
                    if([characteristic.UUID.UUIDString isEqualToString:@"FFE1"])
                    {
                        NSLog(@"writeable characteristic");
                        _writeCharacteristic = characteristic;
                    }
                }
            }];
        }
    }];
    
}

- (void)LH_Peripheral:(MPPeripheral *)peripheral didWriteData:(NSData *)data ForCharacteristic:(MPCharacteristic *)characteristic
{
    /**
     typedef NS_OPTIONS(NSUInteger, CBCharacteristicProperties) {
     CBCharacteristicPropertyBroadcast												= 0x01,
     CBCharacteristicPropertyRead													= 0x02,
     CBCharacteristicPropertyWriteWithoutResponse									= 0x04,
     CBCharacteristicPropertyWrite													= 0x08,
     CBCharacteristicPropertyNotify													= 0x10,
     CBCharacteristicPropertyIndicate												= 0x20,
     CBCharacteristicPropertyAuthenticatedSignedWrites								= 0x40,
     CBCharacteristicPropertyExtendedProperties										= 0x80,
     CBCharacteristicPropertyNotifyEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)		= 0x100,
     CBCharacteristicPropertyIndicateEncryptionRequired NS_ENUM_AVAILABLE(NA, 6_0)	= 0x200
     };
     */
    NSLog(@"%s,line = %d cha.pro = %lu",__FUNCTION__,__LINE__,(unsigned long)characteristic.properties);
    //    if(characteristic.properties & CBCharacteristicPropertyWrite)//判断该特征是否可写
    //    {
    //    [peripheral writeValue:data forCharacteristic:characteristic
    //                      type:CBCharacteristicWriteWithoutResponse];//通过此响应纪录是否成功写入
    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse withBlock:^(MPPeripheral *peripheral, MPCharacteristic *characteristic, NSError *error) {
        
    }];
    //    }
}



- (void)LH_Peripheral:(MPPeripheral *)peripheral cancelNotifyCharacteristic:(MPCharacteristic *)characteristic
{
    [peripheral setNotifyValue:NO forCharacteristic:characteristic withBlock:^(MPPeripheral *peripheral, MPCharacteristic *characteristic, NSError *error){}];
}


/**************************************提供外部接口函数****************************************/
//外设写数据到特征的方法
- (void)LH_WriteData:(NSData *)data
{
    [self LH_Peripheral:self.connectedPeripheral didWriteData:data ForCharacteristic:_writeCharacteristic];
}

- (void)startScan
{
    
    if(_isReady)
    {
        [self.peripheralArray removeAllObjects];
        [self scanPeripehrals];
    }
}

- (void)stopScan
{
    [_centralManager stopScan];
}



- (void)connectSelectDevice:(NSInteger)index;
{
    __weak typeof(self) weakSelf = self;
    if(self.peripheralArray.count <= index)
        return;
    MPPeripheral *mPeripheral = self.peripheralArray[index][_peripheralTag];
    [_centralManager connectPeripheral:mPeripheral options:nil withSuccessBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral) {
        weakSelf.connectedPeripheral = peripheral;
        [weakSelf getMacAddress:weakSelf.connectedPeripheral andperiPheralIndex:index];
        _connect = YES;
        [_delegate connectSuccess:index];
    } withDisConnectBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral, NSError *error) {
        NSLog(@"disconnectd %@",peripheral.name);
        _connect = NO;
        [_delegate connectFail];
        [self LH_Peripheral:self.connectedPeripheral cancelNotifyCharacteristic:_writeCharacteristic];
    }];
}


- (void)LH_dismissConnect//断开连接
{
    [self.centralManager stopScan];
    [self.centralManager cancelPeripheralConnection:self.connectedPeripheral withBlock:^(MPCentralManager *centralManager, MPPeripheral *peripheral, NSError *error) {
        _connect = NO;
        [_delegate disConnect];
    }];
    [self LH_Peripheral:self.connectedPeripheral cancelNotifyCharacteristic:_writeCharacteristic];
}


#pragma mark 对外开放的发送接口函数

- (void)actionCmdSend:(NSInteger)actionNum
{
    Byte byte[] = {0x55,0x55,0x05,0x06,actionNum & 0xff,0x01,0x00};

    NSData *data = [[NSData alloc]initWithBytes:byte length:sizeof(byte)];
    [self sendData:data delayTime:0.02];
}

- (void)stopCmdSendWithControlMode
{
    Byte byte[] = {0x55,0x55,0x02,0x07};

    NSData *data = [[NSData alloc]initWithBytes:byte length:sizeof(byte)];
    [self sendData:data delayTime:0.02];
}


- (void)sendData:(NSData *)data delayTime:(double)delayTime
{
    double delay = delayTime * NSEC_PER_SEC;
    dispatch_time_t time =dispatch_time(DISPATCH_TIME_NOW,(int64_t)delay);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [_centerBle LH_WriteData:data];
    });
}

@end

