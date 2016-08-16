package com.alipay;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;


import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.Promise;

import com.alipay.sdk.app.PayTask;

public class RNAlipayModule extends ReactContextBaseJavaModule {
	// 商户PID
	//public static final String PARTNER = "";
	// 商户收款账号
	//public static final String SELLER = "";
	// 商户私钥，pkcs8格式
	//public static final String RSA_PRIVATE = "";
	// 支付宝公钥
	//public static final String RSA_PUBLIC = "";
	//private static final int SDK_PAY_FLAG = 1;
	//private static final int SDK_CHECK_FLAG = 2;

	private final ReactApplicationContext mReactContext;

	public RNAlipayModule(ReactApplicationContext reactContext) {
		super(reactContext);
		mReactContext = reactContext;
  	}
  	
	@Override
  	public String getName() {
    	return "RNAlipay";
  	}

  	@ReactMethod
  	public void pay(ReadableMap options, Promise promise) {

        String privateKey = options.getString("privateKey");
        String partner = options.getString("partner");
        String seller = options.getString("seller");
        String outTradeNO = options.getString("outTradeNO");
        String subject = options.getString("subject");
        String body = options.getString("body");
        String notifyURL = options.getString("notifyURL");

        String totalFee;
        if (options.getType("totalFee") == ReadableType.Number) {
             totalFee = Double.toString(options.getDouble("totalFee"));
        } else {
             totalFee = options.getString("totalFee");
        }

        String itBPay = options.getString("itBPay");
        String showURL = options.getString("showURL");

		if (TextUtils.isEmpty(partner) || TextUtils.isEmpty(privateKey) || TextUtils.isEmpty(seller)) {

		    promise.reject("需要配置PARTNER | RSA_PRIVATE| SELLER");

			return;
		}

		String orderInfo = getOrderInfo(partner, seller, outTradeNO, subject, body, totalFee, itBPay, showURL, notifyURL);

		/**
		 * 特别注意，这里的签名逻辑需要放在服务端，切勿将私钥泄露在代码中！
		 */
		String sign = sign(orderInfo, privateKey);

        try {
            /**
             * 仅需对sign 做URL编码
             */
            sign = URLEncoder.encode(sign, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        /**
         * 完整的符合支付宝参数规范的订单信息
         */
        final String payInfo = orderInfo + "&sign=\"" + sign + "\"&" + getSignType();

        System.out.println(payInfo);

		PayTask alipay = new PayTask(getCurrentActivity());
		String result = alipay.pay(payInfo);
		//cb.invoke(result);
		promise.resolve(result);
    }
  	/**
	 * create the order info. 创建订单信息
	 * 
	 */
	public String getOrderInfo(
	    String partner,
	    String seller,
	    String outTradeNO,
	    String subject,
	    String body,
	    String totalFee,
	    String itBPay,
	    String showURL,
	    String notifyURL
	) {

		// 签约合作者身份ID
		String orderInfo = "partner=" + "\"" + partner + "\"";

		// 签约卖家支付宝账号
		orderInfo += "&seller_id=" + "\"" + seller + "\"";

		// 商户网站唯一订单号
		orderInfo += "&out_trade_no=" + "\"" + outTradeNO + "\"";

		// 商品名称
		orderInfo += "&subject=" + "\"" + subject + "\"";

		// 商品详情
		orderInfo += "&body=" + "\"" + body + "\"";

		// 商品金额
		orderInfo += "&total_fee=" + "\"" + totalFee + "\"";

		// 服务接口名称， 固定值
		orderInfo += "&service=\"mobile.securitypay.pay\"";

		// 支付类型， 固定值
		orderInfo += "&payment_type=\"1\"";

		// 参数编码， 固定值
		orderInfo += "&_input_charset=\"utf-8\"";

		// 设置未付款交易的超时时间
		// 默认30分钟，一旦超时，该笔交易就会自动被关闭。
		// 取值范围：1m～15d。
		// m-分钟，h-小时，d-天，1c-当天（无论交易何时创建，都在0点关闭）。
		// 该参数数值不接受小数点，如1.5h，可转换为90m。
		orderInfo += "&it_b_pay=\"" + itBPay + "\"";

		// extern_token为经过快登授权获取到的alipay_open_id,带上此参数用户将使用授权的账户进行支付
		// orderInfo += "&extern_token=" + "\"" + extern_token + "\"";

		// 支付宝处理完请求后，当前页面跳转到商户指定页面的路径，可空
		orderInfo += "&return_url=\"" + showURL + "\"";

		// 调用银行卡支付，需配置此参数，参与签名， 固定值 （需要签约《无线银行卡快捷支付》才能使用）
		// orderInfo += "&paymethod=\"expressGateway\"";

		orderInfo += "&notify_url=\"" + notifyURL + "\"";

		return orderInfo;
	}

	/**
	 * sign the order info. 对订单信息进行签名
	 * 
	 * @param content
	 *            待签名订单信息
	 */
	public String sign(String content, String rsaPrivate) {
		return SignUtils.sign(content, rsaPrivate);
	}
	/**
	 * get the sign type we use. 获取签名方式
	 * 
	 */
	public String getSignType() {
		return "sign_type=\"RSA\"";
	}
}