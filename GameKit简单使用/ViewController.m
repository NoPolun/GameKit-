//
//  ViewController.m
//  GameKit简单使用
//
//  Created by 哲 on 16/11/23.
//  Copyright © 2016年 XSZ. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>
#import "MutiPeerConnectivity.h"
@interface ViewController ()<GKPeerPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *showImg;
//保存当前会话的属性
@property(nonatomic,strong)GKSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 按钮的点击
- (IBAction)connect:(id)sender {
    
    //创建蓝牙选择器，现在已经放弃，iOS7之前
    GKPeerPickerController *picker = [[GKPeerPickerController alloc]init];
    picker.delegate = self;
    [picker show];
    
    
    
}

- (IBAction)selectImage:(id)sender {
    
    
    UIImagePickerController *imagePick =[[UIImagePickerController alloc]init];
    imagePick.delegate = self;
    imagePick.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePick animated:YES completion:nil];
    
}
- (IBAction)sendImage:(id)sender {
    if (self.showImg.image) {
        //图片转换
        NSData *data =UIImagePNGRepresentation(self.showImg.image);
        [self.session sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:nil];
        NSLog(@"session = %@",self.session);
    }
  
    
}
//连接蓝牙的方式 附近 在线
-(void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type
{
    NSLog(@"%s %d type = %ld %@",__func__,__LINE__,type,picker);
}
//连接会话的方式 附近 在线
-(GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    return nil;
}

//连接成功 peerID连接成功的设备ID session 当前会话 只需要般从当前会话 即可进行数据传递
-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    //隐藏选择器
    [picker dismiss];
    //接收数据的回调 必须设置否则无法接收数据
    [session setDataReceiveHandler:self withContext:nil];
    
    
    
    //保存会话
    self.session = session;
}
-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    if (!data) return;
        //转换图片
    UIImage *img =[UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showImg.image = img;
    });

    
}

//退出
-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
   
}
#pragma mark - imageDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.showImg.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - delegate




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextViewController:(UIButton *)sender {
    MutiPeerConnectivity *tivity =[[MutiPeerConnectivity alloc]init];
    [self presentViewController:tivity animated:YES completion:nil];
}

@end
