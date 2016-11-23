//
//  MutiPeerConnectivity.m
//  GameKit简单使用
//
//  Created by 哲 on 16/11/23.
//  Copyright © 2016年 XSZ. All rights reserved.
//

#import "MutiPeerConnectivity.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

//注册一个广告 告诉别人 我的设备是可以被发现的

#define SERVICE_TYPE @"xmg"
@interface MutiPeerConnectivity ()<MCBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MCSessionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
//保存会话
@property(nonatomic,strong)MCSession *m_session;
@property(nonatomic,strong)MCAdvertiserAssistant *assistant;
//当前链接到的设备
@property(nonatomic,strong)MCPeerID *perId;
@end

@implementation MutiPeerConnectivity

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化会话
    NSString *displayName =[UIDevice currentDevice].name;
    MCPeerID *peerID =[[MCPeerID alloc]initWithDisplayName:displayName];
    self.m_session = [[MCSession alloc]initWithPeer:peerID];
    self.m_session.delegate = self;
}













- (IBAction)sendFile:(UIButton *)sender {
    MCBrowserViewController *browser =[[MCBrowserViewController alloc]initWithServiceType:SERVICE_TYPE session:self.m_session];
    browser.delegate =self;
    [self presentViewController:browser animated:YES completion:nil];
    
    
    
}
- (IBAction)selectFile:(UIButton *)sender {
    
    
    UIImagePickerController *imagePick =[[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    imagePick.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePick animated:YES completion:nil];

    
    
    
}
- (IBAction)sendOtherFile:(UIButton *)sender {
    if (!self.showImg.image) return;
        
//    发送数据
    
    [self.m_session sendData:UIImagePNGRepresentation(self.showImg.image) toPeers:@[self.perId] withMode:MCSessionSendDataUnreliable error:nil];
    
}
//设置设备可被发现
- (IBAction)find:(UISwitch *)sender {
    UISwitch *s =(UISwitch *)sender;
    if (s.isOn) {
        //注册广告 可能一个app 发送了多个广告 所以需要给广告绑定唯一标示
        self.assistant = [[MCAdvertiserAssistant alloc]initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:self.m_session];
        [self.assistant start];
    }
    
    
}
#pragma mark - 扫码设备的代理方法
//连接成功
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
//退出连接
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    
}
//连接哪个设备
-(BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    self.perId =peerID;
    return YES;
}


#pragma mark - imageDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.showImg.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -会话的代理方法
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showImg.image = [UIImage imageWithData:data];
    });
}
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
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
