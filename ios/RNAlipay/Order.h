#import <Foundation/Foundation.h>

@interface Order : NSObject


/*********************************支付四要素*********************************/

//商户在支付宝签约时，支付宝为商户分配的唯一标识号(以2088开头的16位纯数字)。
@property (nonatomic, copy) NSString *partner;

//卖家支付宝账号对应的支付宝唯一用户号(以2088开头的16位纯数字),订单支付金额将打入该账户,一个partner可以对应多个seller_id。
@property (nonatomic, copy) NSString *sellerID;

//商户网站商品对应的唯一订单号。
@property (nonatomic, copy) NSString *outTradeNO;

//该笔订单的资金总额，单位为RMB(Yuan)。取值范围为[0.01，100000000.00]，精确到小数点后两位。
@property (nonatomic, copy) NSString *totalFee;



/*********************************商品相关*********************************/
//商品的标题/交易标题/订单标题/订单关键字等。
@property (nonatomic, copy) NSString *subject;

//对一笔交易的具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。
@property (nonatomic, copy) NSString *body;



/*********************************其他必传参数*********************************/

//接口名称，固定为mobile.securitypay.pay。
@property (nonatomic, copy) NSString *service;

//商户网站使用的编码格式，固定为utf-8。
@property (nonatomic, copy) NSString *inputCharset;

//支付宝服务器主动通知商户网站里指定的页面http路径。
@property (nonatomic, copy) NSString *notifyURL;



/*********************************可选参数*********************************/

//支付类型，1：商品购买。(不传情况下的默认值)
@property (nonatomic, copy) NSString *paymentType;

//具体区分本地交易的商品类型,1：实物交易; (不传情况下的默认值),0：虚拟交易; (不允许使用信用卡等规则)。
@property (nonatomic, copy) NSString *goodsType;

//支付时是否发起实名校验,F：不发起实名校验; (不传情况下的默认值),T：发起实名校验;(商户业务需要买家实名认证)
@property (nonatomic, copy) NSString *rnCheck;

//标识客户端。
@property (nonatomic, copy) NSString *appID;

//标识客户端来源。参数值内容约定如下：appenv=“system=客户端平台名^version=业务系统版本”
@property (nonatomic, copy) NSString *appenv;

//设置未付款交易的超时时间，一旦超时，该笔交易就会自动被关闭。当用户输入支付密码、点击确认付款后（即创建支付宝交易后）开始计时。取值范围：1m～15d，或者使用绝对时间（示例格式：2014-06-13 16:00:00）。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。该参数数值不接受小数点，如1.5h，可转换为90m。
@property (nonatomic, copy) NSString *itBPay;

//商品地址
@property (nonatomic, copy) NSString *showURL;

//业务扩展参数，支付宝特定的业务需要添加该字段，json格式。 商户接入时和支付宝协商确定。
@property (nonatomic, strong) NSMutableDictionary *outContext;


@end
