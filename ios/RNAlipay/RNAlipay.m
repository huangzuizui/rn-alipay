#import "RNAlipay.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation RNAlipay

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(pay, options:(NSDictionary *)options
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = [options objectForKey:@"partner"];
    NSString *seller = [options objectForKey:@"seller"];
    NSString *privateKey = [options objectForKey:@"privateKey"];
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        NSError *error = nil;
        reject(@"错误", @"缺少partner或者seller或者私钥。", error);
        
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.sellerID = seller;
    order.outTradeNO = [options objectForKey:@"outTradeNO"]; //订单ID（由商家自行制定）
    order.subject = [options objectForKey:@"subject"]; //商品标题
    order.body = [options objectForKey:@"body"]; //商品描述
    
    float totalFee = [[options objectForKey:@"totalFee"] floatValue];
    order.totalFee = [NSString stringWithFormat:@"%0.2f", totalFee]; //商品价格
    order.notifyURL =  [options objectForKey:@"notifyURL"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    
    order.itBPay = [options objectForKey:@"itBPay"];
    order.showURL = [options objectForKey:@"showURL"];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = [options objectForKey:@"appSchemeIOS"];
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@", orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"orderString = %@", orderString);
        
        //resolve(@"支付成功!");
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            NSLog(@"orderString = %@", @"支付成功啦啦啦啦！");
            resolve(@"支付成功!");
        }];
        return;
    }
    
    NSError *error = nil;
    reject(@"支付失败", @"参数错误", error);
    
//    if (str) {
//        resolve(str);
//    } else {
//        NSError *error = nil;
//        reject(@"no_events", @"There were no events", error);
//    }
}

@end