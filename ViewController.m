//
//  ViewController.m
//  FileAccess_iCloud_QQ_Wechat
//
//  Created by Hao on 2017/7/28.
//  Copyright © 2017年 zzh. All rights reserved.
//

#import "ViewController.h"
#import "iCloudManager.h"

@interface ViewController () <UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)fileAccessFromQQ:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"] options:@{} completionHandler:nil];
    }
}

- (IBAction)fileAccessFromWechat:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"] options:@{} completionHandler:nil];
    }
}

- (IBAction)fileAccessFromiCloud:(id)sender {
    [self presentDocumentPicker];
}

- (void)presentDocumentPicker {
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes
                                                                                                                          inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    
    if ([iCloudManager iCloudEnable]) {
        [iCloudManager downloadWithDocumentURL:url callBack:^(id obj) {
            NSData *data = obj;
            
            //写入沙盒Documents
             NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
            [data writeToFile:path atomically:YES];
        }];
    }
}

@end
