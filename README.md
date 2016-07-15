# rn-alipay
react-native 支付宝手机支付模块

# 安装
##iOS
1. `npm install rn-alipay --save`
2. 在XCode中右击项目的 `Libraries` 文件夹 ➜ `Add Files to`
3. 进入 `node_modules` ➜ `rn-alipay` ➜ `ios` ➜ 选择 `RNAlipay.xcodeproj`
4. 展开`RNAlipay.xcodeproj`➜ `Products`➜ 添加 `libRNAlipay.a` 到`Build Phases -> Link Binary With Libraries`
5. 在`Build Phases`选项卡的`Link Binary With Libraries`中，点击“+”号增加以下依赖：<img title="iOS" src="https://github.com/huangzuizui/rn-alipay/blob/master/assets/1.jpg">
6. 将`RNAlipay.xcodeproj`下`AlipaySDK.framework`、`libssl.a`、`libcrypto.a`文件拖入复制到项目文件夹下：<img title="iOS" src="https://github.com/huangzuizui/rn-alipay/blob/master/assets/0.jpg">
7. 编译运行

##Android
* `npm install rn-alipay --save`
```java
// file: android/settings.gradle
...
include ':rn-alipay'  // <- add
project(':rn-alipay').projectDir = new File(settingsDir, '../node_modules/rn-alipay/android')  // <- add
```

```java
// file: android/app/build.gradle
...
dependencies {
		...
		compile project(':rn-alipay')  // <- add
}
```
* 注册模块
* 对于 react-native 版本低于 0.19.0 (use cat ./node_modules/react-native/package.json | grep version)
```java
// file: MainActivity.java
import com.alipay.RNAlipayPackage;  // <- import

public class MainActivity extends Activity implements DefaultHardwareBackBtnHandler {

  ...

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    mReactRootView = new ReactRootView(this);

    mReactInstanceManager = ReactInstanceManager.builder()
      .setApplication(getApplication())
      .setBundleAssetName("index.android.bundle")
      .setJSMainModuleName("index.android")
      .addPackage(new MainReactPackage())
      .addPackage(new RNAlipayPackage(this))      // <- add package
      .setUseDeveloperSupport(BuildConfig.DEBUG)
      .setInitialLifecycleState(LifecycleState.RESUMED)
      .build();

    mReactRootView.startReactApplication(mReactInstanceManager, "ExampleRN", null);

    setContentView(mReactRootView);
  }

  ...

}
```
* 对于 react-native 0.19.0及以上版本
```java
// file: MainActivity.java
	...
import com.alipay.RNAlipayPackage;//<- import package

public class MainActivity extends ReactActivity {

   /**
   * A list of packages used by the app. If the app uses additional views
   * or modules besides the default ones, add more packages here.
   */
    @Override
    protected List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
            new MainReactPackage(), //<- Add comma
            new RNAlipayPackage(this) //<- Add package
        );
    }
...
}
```
* 安卓部分实现参考https://github.com/szq4119/react-native-alipay

##使用说明
1. 导入模块
```javascript
const Alipay = require('rn-alipay');
```
2. 基本使用
```javascript
const privateKey = 'MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAN0yqPkLXlnhM+2H/57aHsYHaHXazr9pFQun907TMvmbR04wHChVsKVgGUF1hC0FN9hfeYT5v2SXg1WJSg2tSgk7F29SpsF0I36oSLCIszxdu7ClO7c22mxEVuCjmYpJdqb6XweAZzv4Is661jXP4PdrCTHRdVTU5zR9xUByiLSVAgMBAAECgYEAhznORRonHylm9oKaygEsqQGkYdBXbnsOS6busLi6xA+iovEUdbAVIrTCG9t854z2HAgaISoRUKyztJoOtJfI1wJaQU+XL+U3JIh4jmNx/k5UzJijfvfpT7Cv3ueMtqyAGBJrkLvXjiS7O5ylaCGuB0Qz711bWGkRrVoosPM3N6ECQQD8hVQUgnHEVHZYtvFqfcoq2g/onPbSqyjdrRu35a7PvgDAZx69Mr/XggGNTgT3jJn7+2XmiGkHM1fd1Ob/3uAdAkEA4D7aE3ZgXG/PQqlm3VbE/+4MvNl8xhjqOkByBOY2ZFfWKhlRziLEPSSAh16xEJ79WgY9iti+guLRAMravGrs2QJBAOmKWYeaWKNNxiIoF7/4VDgrcpkcSf3uRB44UjFSn8kLnWBUPo6WV+x1FQBdjqRviZ4NFGIP+KqrJnFHzNgJhVUCQFzCAukMDV4PLfeQJSmna8PFz2UKva8fvTutTryyEYu+PauaX5laDjyQbc4RIEMU0Q29CRX3BA8WDYg7YPGRdTkCQQCG+pjU2FB17ZLuKRlKEdtXNV6zQFTmFc1TKhlsDTtCkWs/xwkoCfZKstuV3Uc5J4BNJDkQOGm38pDRPcUDUh2/';
const data = {
    privateKey,
    partner: '2088302277569230',
    seller: '12312341234',
    outTradeNO: '1231231231231', //订单ID（由商家自行制定）
    subject: '测试商品标题', //商品标题
    body: '测试产品描述', //商品描述
    totalFee: '1', //商品价格
    notifyURL: 'http://www.baidu.com"', //回调URL
    service: 'mobile.securitypay.pay',
    paymentType: '1',
    inputCharset: 'utf-8',
    itBPay: '30m',
    showURL: 'm.alipay.com',
    appSchemeIOS: 'testapp20', //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
};
Alipay.pay(data).then((msg) => {
    console.log(msg);
}, (e) => {
    console.log(e);
});
```
##参考支付宝文档
* [支付宝开放平台移动支付文档](https://doc.open.alipay.com/doc2/detail.htm?spm=a219a.7629140.0.0.OuUIpb&treeId=59&articleId=103563&docType=1)

##Demo
[https://github.com/huangzuizui/rn-alipay-demo](https://github.com/huangzuizui/rn-alipay-demo)
