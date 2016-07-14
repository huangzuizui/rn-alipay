#import "Order.h"

@implementation Order

- (NSString *)description {
  NSMutableString * discription = [NSMutableString string];
  if (self.partner) {
    [discription appendFormat:@"partner=\"%@\"", self.partner];
  }
  
  if (self.sellerID) {
    [discription appendFormat:@"&seller_id=\"%@\"", self.sellerID];
  }
  if (self.outTradeNO) {
    [discription appendFormat:@"&out_trade_no=\"%@\"", self.outTradeNO];
  }
  if (self.subject) {
    [discription appendFormat:@"&subject=\"%@\"", self.subject];
  }
  
  if (self.body) {
    [discription appendFormat:@"&body=\"%@\"", self.body];
  }
  if (self.totalFee) {
    [discription appendFormat:@"&total_fee=\"%@\"", self.totalFee];
  }
  if (self.notifyURL) {
    [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
  }
  
  if (self.service) {
    [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
  }
  if (self.paymentType) {
    [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
  }
  
  if (self.inputCharset) {
    [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
  }
  if (self.itBPay) {
    [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
  }
  if (self.showURL) {
    [discription appendFormat:@"&show_url=\"%@\"",self.showURL];//m.alipay.com
  }
  if (self.appID) {
    [discription appendFormat:@"&app_id=\"%@\"",self.appID];
  }
  for (NSString * key in [self.outContext allKeys]) {
    [discription appendFormat:@"&%@=\"%@\"", key, [self.outContext objectForKey:key]];
  }
  return discription;
}


@end
