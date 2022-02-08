//
//  ViewController.m
//  OpenSourceArm
//
//  Created by LOBOT on 2017/9/12.
//  Copyright © 2017年 LOBOT. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothView.h"
#import "LHCenterBle.h"
#import "Toast.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,BluetoothProtocal,LHCenterBleProtocol>
@property(nonatomic,strong)LHCenterBle *centerBle;
@property (nonatomic,assign)NSInteger connectedIndex;
@property (nonatomic,strong)BluetoothView *bluetoothView;
@property (nonatomic,strong) NSMutableArray *discoverPeripherals;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect ww = [[UIScreen mainScreen] bounds];
    _width = ww.size.width;
    _height = ww.size.height;
    [self centerBle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bluetoothView];
}


- (BluetoothView *)bluetoothView
{
    if(_bluetoothView == nil)
    {
        _bluetoothView = [[[NSBundle mainBundle] loadNibNamed:@"BluetoothView" owner:nil options:nil] lastObject];
        _bluetoothView.frame = CGRectMake(_width/6, _height/3, _width/1.5, _height/3);
        _bluetoothView.delegate = self;
    }
    _bluetoothView.bluetoothTable.dataSource = self;
    _bluetoothView.bluetoothTable.delegate = self;
    [_bluetoothView initViews];
    return _bluetoothView;
}

- (NSMutableArray *)discoverPeripherals
{
    if(_discoverPeripherals == nil)
    {
        _discoverPeripherals = [NSMutableArray array];
    }
    return _discoverPeripherals;
}

- (LHCenterBle *)centerBle
{
    if(_centerBle == nil)
    {
        _centerBle = [LHCenterBle shareInstance];
    }
    _centerBle.delegate = self;
    return _centerBle;
}
#pragma mark - 实现按钮功能

- (IBAction)bluetoothClick
{
    if(!_centerBle.isReady)
    {
        UIAlertController *alertOpenBluetooh = [UIAlertController alertControllerWithTitle:nil message:@"请先打开蓝牙" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alertOpenBluetooh addAction:actionOK];
        
        [self presentViewController:alertOpenBluetooh animated:YES completion:nil];
    }
    else
    {
        [self.view addSubview:self.bluetoothView];
        if(!_centerBle.connect)
        {
            _bluetoothView.okBtn.enabled = YES;
            [_centerBle startScan];
            [self.discoverPeripherals removeAllObjects];
        }
        else
        {
            _bluetoothView.okBtn.enabled = NO;
        }
        [self.bluetoothView.bluetoothTable reloadData];
    }

}

- (IBAction)setClick
{
    
}


- (IBAction)actionGroupClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_centerBle actionCmdSend:btn.tag];
}

#pragma mark - 实现UITableView dataSource和delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.discoverPeripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"bluetooth";
   
   UITableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:cellID];
   if(currentCell == nil)
   {
       currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
   }
   NSDictionary *dict = _discoverPeripherals[indexPath.row];
   MPPeripheral *peripheral = dict[_centerBle.peripheralTag];
   currentCell.textLabel.text = peripheral.name;
   NSString *macAddr = dict[_centerBle.macAddrTag];
   if(macAddr == nil)
   {
       currentCell.detailTextLabel.text = nil;
   }
   else
       currentCell.detailTextLabel.text = macAddr;
   
   if(peripheral.state == CBPeripheralStateConnected)
   {
       currentCell.textLabel.textColor = [UIColor greenColor];
   }
   else{
       currentCell.textLabel.textColor = [UIColor blackColor];
   }
   return currentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath//选中后连接蓝牙 或发送舞蹈指令
{
    if(!_centerBle.connect)//未连接直接尝试连接蓝牙
    {
        [_centerBle connectSelectDevice:indexPath.row];
        [self.bluetoothView removeFromSuperview];
    }

    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPPeripheral *peripheral = self.discoverPeripherals[indexPath.row][_centerBle.peripheralTag];
    if(peripheral.state == CBPeripheralStateConnected)
    {
        return YES;
    }
    else{
        return NO;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPPeripheral *peripheral = self.discoverPeripherals[indexPath.row][_centerBle.peripheralTag];
    if(peripheral.state == CBPeripheralStateConnected)
    {
        return @"断开连接";
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
    MPPeripheral *peripheral = self.discoverPeripherals[indexPath.row][_centerBle.peripheralTag];
    if(peripheral.state == CBPeripheralStateConnected)//断开连接
    {
        [_centerBle LH_dismissConnect];
        [self.bluetoothView.bluetoothTable reloadData];
    }
}


#pragma mark 实现BluetoothProtocal
- (void)cancelSerach
{
    [self.bluetoothView removeFromSuperview];
}

- (void)research
{
    [self.discoverPeripherals removeAllObjects];
    [_centerBle startScan];
    [self.bluetoothView.bluetoothTable reloadData];
}

#pragma mark 实现LHCenterBleProtocol
- (void)discoverPeripheral
{
    NSLog(@"view发现设备");
    [self.discoverPeripherals removeAllObjects];
    [self.discoverPeripherals addObjectsFromArray:_centerBle.peripheralArray];
    [self.bluetoothView.bluetoothTable reloadData];
}

- (void)connectSuccess:(NSInteger)index
{
    [[Toast makeText:@"蓝牙已连接"] showWithType:ShortTime];
    _connectedIndex = index;
    _bluetoothView.okBtn.enabled = NO;
    [_bluetoothBtn setBackgroundImage:[UIImage imageNamed:@"bluetooth_connected"] forState:UIControlStateNormal];
}
- (void)disConnect
{
    NSLog(@"view失去连接");
    [[Toast makeText:@"蓝牙失去连接"] showWithType:ShortTime];
    _bluetoothView.okBtn.enabled = NO;
    [_bluetoothBtn setBackgroundImage:[UIImage imageNamed:@"bluetooth_disconnected"] forState:UIControlStateNormal];

}
- (void)connectFail
{
    [[Toast makeText:@"蓝牙连接失败"] showWithType:ShortTime];
    [self.discoverPeripherals removeObjectAtIndex:_connectedIndex];
    [self.bluetoothView.bluetoothTable reloadData];
    _bluetoothView.okBtn.enabled = NO;
    [_bluetoothBtn setBackgroundImage:[UIImage imageNamed:@"bluetooth_disconnected"] forState:UIControlStateNormal];
}
- (void)getMacAddr
{
    NSLog(@"读出mac地址");
    [self.bluetoothView.bluetoothTable reloadData];
}

@end
