//
//  BlueToothViewController.m
//  GameKit简单使用
//
//  Created by 哲 on 16/11/23.
//  Copyright © 2016年 XSZ. All rights reserved.
//

#import "BlueToothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface BlueToothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
//中心管家
@property(nonatomic,strong)CBCentralManager *mgr;
//保存扫描到的外部设备
@property(nonatomic,strong)CBPeripheral *peripheral;
@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    //建立中心管家
    self.mgr =[[CBCentralManager alloc]initWithDelegate:self queue:nil];
    
    
}
#pragma mark - 中心管家代理
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //在开机状态下扫描外部设备
    if (central.state == CBManagerStatePoweredOn) {
        //扫描外部设备的哪些服务
        [self.mgr scanForPeripheralsWithServices:nil options:nil];
    }
}
//发现外部设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    self.peripheral = peripheral;
    self.peripheral.delegate =self;
    [self.mgr connectPeripheral:peripheral options:nil];
}
//连接外设成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.peripheral discoverServices:nil];
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
