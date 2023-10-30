# 介绍
Umeng Flutter APM SDK 能够全面监控Flutter端线上稳定性和性能的运行情况，洞悉设备运行体感。目前 SDK提供了`dart异常`可分级监控能力，未来还将提供页面性能、API监控等能力
**Flutter SDK运行 依赖APM Native SDK和Native Common SDK集成，并且需提前准备创建应用获取Appkey。**
**⚠️  注意：**

1. 支持iOS和Android平台
2. SDK 暂时仅支持官网提供的Flutter SDK运行环境，定制化Flutter SDK和Flutter Boost框架暂不支持。
3. U-APM Flutter 开发者交流群欢迎加入 
   1. ![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691649050918-2a639ef1-257d-4dc2-b47e-8bfbcd22dd8e.png#clientId=u2f3df1de-28e7-4&from=paste&height=266&id=u681f6cc8&originHeight=632&originWidth=634&originalType=binary&ratio=1&rotation=0&showTitle=false&size=559372&status=done&style=shadow&taskId=ub8eae01b-6826-4b89-8cef-c415d74d52b&title=&width=267)

SDK集成简易架构图
![](https://intranetproxy.alipay.com/skylark/lark/0/2023/jpeg/16356981/1691582722973-ae72fc4c-a479-4922-a7a1-e9349bb699fe.jpeg)

Flutter SDK 运行搭配最低版本下限

| 
- **Android**
   - Common：>= 9.5.3
   - apm：>= 1.9.3
 | 
- **Flutter**
   - Common: >= 1.2.6
   - apm: >= 2.0.1
 |
| --- | --- |
| 
- **iOS**
   - Common：>= 7.3.8
   - apm：>= 1.8.4
 |  |

:::warning
**⚠️ 重要**
Flutter APM和Flutter Common SDK内部已集成了Android和iOS SDK，如果工程类型是Flutter App可以直接跳过步骤三，直接进入Flutter SDK集成步骤
:::
# 步骤一、申请AppKey创建应用
**⚠️  注意**：

1. 如需在已创建的平台（iOS，Android）应用中集成Flutter SDK可忽略此步骤
## 1.1、进入APM后台添加应用
![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691494577389-58e72ba4-6edf-4567-a6f0-84efab59540b.png#clientId=u0c68408d-b9f6-4&from=paste&height=1464&id=u4c5bdadb&originHeight=1464&originWidth=2784&originalType=binary&ratio=1&rotation=0&showTitle=false&size=1769134&status=done&style=shadow&taskId=ua33ea209-8f5d-430e-ac23-0ad8910b3dc&title=&width=2784)
## 1.2、新建应用
![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691494719145-5a616010-ef9a-4814-b8e9-91bf970b10be.png#clientId=u0c68408d-b9f6-4&from=paste&height=1712&id=ua0fe6501&originHeight=1712&originWidth=2470&originalType=binary&ratio=1&rotation=0&showTitle=false&size=1049128&status=done&style=shadow&taskId=u5e2424a5-0313-44a2-a041-b8e93c2bf7c&title=&width=2470)
## 1.3、获取Appkey
![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691494810452-fefa77ba-6b0d-44ed-8b3f-64a6750fa5ff.png#clientId=u0c68408d-b9f6-4&from=paste&height=1328&id=u215d7cde&originHeight=1328&originWidth=2538&originalType=binary&ratio=1&rotation=0&showTitle=false&size=1173597&status=done&style=shadow&taskId=u6cc7d199-c22a-4ce5-8ac7-b7d7e2bf633&title=&width=2538)
# 步骤二、合规声明和初始化时机
为了满足监管的规定通常我们需要在APP中通过《隐私政策》中向用户告知使用友盟SDK。我们可以根据《隐私政策》弹窗或者页面所在架构层来判断调用所在端的Common SDK 初始化方法，因为我们需要在用户同意操作的回调中调用初始化Init Common SDK的方法。
## 2.1 《隐私政策》写在Native端参考如下：
参考：[U-APM 合规指南（iOS）](https://developer.umeng.com/docs/193624/detail/194591)
参考：[U-APM合规指南（Android）](https://developer.umeng.com/docs/193624/detail/194588)
## 2.2 《隐私政策》写在Flutter端参考如下：
**注意：我们提供了可以桥接Native Common SDK能力的Flutter Common SDK，即使《隐私政策》在Flutter端也需要必须先集成Native Common SDK。**
```bash
class _MyAppState extends State {
  @override
  void initState() {
    super.initState();
    // 如合规声明在Flutter端，请在同意操作回调中添加下列调用方法
    UmengCommonSdk.initCommon(
        'androidAppkey', 'iosAppkey', 'Umeng');
    UmengCommonSdk.setPageCollectionModeManual();
  }
}
```
Flutter Common SDK集成参考：[https://developer.umeng.com/docs/119267/detail/174923](https://developer.umeng.com/docs/119267/detail/174923)
合规声明文档参考：[https://developer.umeng.com/docs/193624/detail/194588](https://developer.umeng.com/docs/193624/detail/194588)
# 步骤三、集成Native SDK（Flutter App工程类型跳过此步骤）
:::info
**说明**

1. Flutter应用程序（Application）：这是最常见的Flutter工程类型，用于构建可以在移动设备上运行的应用程序，如Android和iOS。Flutter应用程序可以使用Flutter的UI框架构建用户界面，并且可以与设备功能进行交互，如摄像头、传感器等。
2. Flutter模块（Module）：Flutter模块是一个独立的Flutter工程，可以作为一个子工程嵌入到其他Flutter工程中。模块可以用于构建可重用的UI组件或模块，以便在不同的Flutter应用程序中共享和重用。
:::

**注意：**
🌟 集成Flutter SDK不需要在原生项目中引入原生SDK，如果您的原生项目中的Cocoapods或手动集成依赖库内存在友盟SDK依赖（原生UMCommon、原生UMAPM），需要删掉，否则可能会导致SDK冲突。
```objectivec
// Podfile
target 'UMPlusDemo'do
    // pod 'UMCommon'
    // pod 'UMAPM'
    // pod 'UMDevice'
end
```
## 3.1 iOS
### 3.1.1 SDK集成
U-APM iOS采集开关配置项(UMAPMConfig)说明请参考此文档：[https://developer.umeng.com/docs/193624/detail/291394#h3-v47-jej-ofq](https://developer.umeng.com/docs/193624/detail/291394#h3-v47-jej-ofq)
```objectivec
/** 初始化友盟所有组件产品接口函数
 @param appKey 开发者在友盟官网申请的appkey.
 @param channel 渠道标识，可设置nil表示"App Store".
 */
+(void)initWithAppkey:(NSString*)appkey channel:(NSString*)channel;

/************ 开始集成 ************/
// 在.m文件中加入如下代码
#import <UMCommon/UMCommon.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMAPM/UMLaunch.h>
#import <UMAPM/UMAPMConfig.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //在初始化appkey前调用，防止iOS13及以下同时使用NSURLProtocol和U-APM网络模块冲突。(未使用NSURLProtocol或者先初始化NSURLProtocol，可不调用此函数)
    //[UMCrashConfigure enableNetworkForProtocol:NO];
    UMAPMConfig* config = [UMAPMConfig defaultConfig];
    config.crashAndBlockMonitorEnable = YES;
    config.launchMonitorEnable = YES;
    config.memMonitorEnable = NO;
    config.oomMonitorEnable = NO;
    config.networkEnable = YES;
    [UMCrashConfigure setAPMConfig:config];//必须配置，请注意

	// flutter_module调用及同意隐私政策代码...

    // 务必要在同意隐私政策后初始化
    [UMConfigure initWithAppkey:@"5fd9c8e6498d9e0d4d916130" channel:@"App Store"];
    return YES;
}
```
## 3.2 Android
### 3.2.1 SDK集成
注意：集成Flutter SDK不需要在原生项目中引入原生SDK，如果您的原生项目中的build.gradle存在友盟SDK依赖，需要注释或者删掉，否则可能会导致SDK冲突。
```java
// build.gradle
dependencies {
	/* 删除或注释原生项目有关友盟APM和Common相关的SDK，以下为示例 */
	// implementation 'com.umeng.umsdk:common:9.4.4'
 	// implementation 'com.umeng.umsdk:asms:1.4.1'
 	// implementation 'com.umeng.umsdk:apm:1.5.2'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.9.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
```
#### 预初始化
如果App不能保证在Appcalition.onCreate函数中调用UMConfigure.init初始化函数，则必须在Appcalition.onCreate函数中调用此预初始化函数。对于有延迟初始化SDK需求的开发者(不能在Application.onCreate函数中调用UMConfigure.init初始化函数），必须在Application.onCreate函数中调用UMConfigure.preInit预初始化函数(preInit耗时极少，不会影响冷启动体验)，而后UMConfigure.init函数可以按需延迟调用(可以放到后台线程中延时调用，可以延迟，但还是必须调用)。如果您的App已经是在Application.onCreate函数中调用UMConfigure.init进行初始化，则无需额外调用UMConfigure.preInit预初始化函数。
```java
public static void preInit(Context context,String appkey,String channel)
```
```xml
<!-- 在AndroidManifest.xml中加入如下必须的权限 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```
```java
// 在.java文件中引入原生SDK包
import com.umeng.umcrash.UMCrash;
import com.umeng.commonsdk.UMConfigure;

// 在application.onCreate内配置各模块开关并预初始化SDK
Bundle bundle = new Bundle();
bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_JAVA, true);
bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_NATIVE, true);
bundle.putBoolean(UMCrash.KEY_ENABLE_CRASH_ALL, true);
bundle.putBoolean(UMCrash.KEY_ENABLE_ANR, false);
bundle.putBoolean(UMCrash.KEY_ENABLE_PA, false);
bundle.putBoolean(UMCrash.KEY_ENABLE_LAUNCH, false);
bundle.putBoolean(UMCrash.KEY_ENABLE_MEM, false);
bundle.putBoolean(UMCrash.KEY_ENABLE_H5PAGE, false);
undle.putBoolean(UMCrash.KEY_ENABLE_POWER, false);
UMCrash.initConfig(bundle);
// 开启模块开关，上述模块开关一定要在init前调用。
UMConfigure.preInit(getApplicationContext(), "59892f08310c9307b60023d0", "UMENG", UMConfigure.DEVICE_TYPE_PHONE, "");


/************ 以下代码在纯Flutter项目中无需调用，flutter_module需要调用在预初始化后正式初始化SDK *************/

// 判断是否同意隐私协议，如果用户同意协议直接初始化umsdk，此处代码详情请参考demo https://github.com/umeng/MultiFunctionAndroidDemo
if (sharedPreferencesHelper.getSharedPreference("uminit", "").equals("1")) {
	//友盟正式初始化
    UmInitConfig umInitConfig = new UmInitConfig();
	umInitConfig.UMinit(getApplicationContext());
}
```

### 3.2.3 混淆设置
⚠️ **注意：Android下如果不设置忽略混淆，APM将无法正常运行**
参考：[接入与基础功能-混淆设置](https://developer.umeng.com/docs/193624/detail/194590#h1-u6DF7u6DC6u8BBEu7F6E4)
# 步骤四、对接 Flutter SDK 
APM SDK支持工程Flutter版本范围
```yaml
flutter: ">=2.0.0" // 适用于Flutter SDK 2.0以上版本
```
## 4.1 添加SDK
### 4.1.1 手动集成
在【友盟+】官网下载，选取Flutter【应用性能监控】SDK进行下载。[下载地址](https://devs.umeng.com/)![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691648413555-cb9133a7-45db-4150-8006-dee4edc59cca.png#clientId=u2f3df1de-28e7-4&from=paste&height=942&id=hdPQM&originHeight=942&originWidth=1920&originalType=binary&ratio=1&rotation=0&showTitle=false&size=508896&status=done&style=shadow&taskId=u1aed16e2-c525-4c02-acb4-552415a4462&title=&width=1920)
将下载后的SDK文件夹放进工程中，在pubspec.yaml中利用相对路径进行引用
```bash
name: umeng_apm_sdk_example
description: Demonstrates how to use the umeng_apm_sdk plugin.
version: 1.0.0
publish_to: 'none'

environment:
  sdk: ">=2.12.0 <3.0.0"
  flutter: ">=2.0.0"

dependencies:
  flutter:
    sdk: flutter

  umeng_common_sdk: ^1.2.6
  umeng_apm_sdk:
    path: '<sdk file>'
```
### 4.1.2 自动集成
打开 `pubspec.yaml` ，添加以下依赖:
```
dependencies:
  umeng_apm_sdk: ^2.0.1
	umeng_common_sdk: ^1.2.4

```
## 4.2 初始化 SDK 探针
| **字段** | **含义** | **是否必填** | **类型** | **获取方式** |
| --- | --- | --- | --- | --- |
| name | 应用或模块名称 | 是 | string | pubspec.yaml  => name |
| bver | 应用或模块版本(+构建号) | 是 | string | pubspec.yaml => version |
| projectType | 工程类型 (默认为0)
Flutter App = 0
Flutter Module = 1 | 否 | int | 
 |
| flutterVersion | Flutter SDK 版本 | 否 | string | flutter --version 
![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1690356102045-7653c57d-6cb6-4033-9d71-77e8fe431335.png#clientId=ub3a0838c-e927-4&from=paste&height=272&id=msTF3&originHeight=272&originWidth=1498&originalType=binary&ratio=1&rotation=0&showTitle=false&size=198774&status=done&style=none&taskId=ub50a59d9-69a2-43c6-a543-3522f3e056c&title=&width=1498) |
| engineVersion | 引擎版本 | 否 | string |  |
| enableLog | 是否开启SDK日志打印 (默认关闭) | 否 | bool |  |
| errorFilter | 设置采集的异常黑白名单 | 否 | Map |  |
| initFlutterBinding | ApmWidgetsFlutterBinding的覆写和初始化方法 | 否 | Function |  |
| onError | 抛出异常回调 | 否 | Function |  |

**⚠️  注意**：

1. 确保 **bver **精确到构建号，可以使后台符号表解析能够映射到指定版本
### 4.2.1 初始化 UmengApmSdk
为保证能够捕获全局的异常，我们建议您将应用的 `void main() => runApp(MyApp());` 替换成以下代码
```javascript
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

void main() {
  UmengApmSdk(
    name: '应用或者模块名称',
    
    bver: '您的Flutter应用或模块版本 (比如 1.0.0+1 )',
    
    // 是否开启SDK运行时日志输出
    enableLog: true,
    
    // 您使用的flutter版本，默认为空，为方便定位访问，建议配置
    flutterVersion: '您使用的flutter版本',
    
    engineVersion: '您使用的flutter引擎版本',

    // 过滤异常筛选
    errorFilter: {
      "mode": "match",
      "rules": [RegExp('RangeError')],
    }
  	// 带入继承ApmWidgetsFlutterBinding的覆写和初始化方法, 可用于自定义监听应用生命周期
 		// 确保去掉原有的WidgetsFlutterBinding.ensureInitialized() ，以免出现重复初始化绑定的异常造成无法正常初始化，SDK内部已通过initFlutterBinding入参带入继承的WidgetsFlutterBinding实现初始化操作
    initFlutterBinding: MyApmWidgetsFlutterBinding.ensureInitialized,

  	// 抛出异常事件
    onError: (exception, stack) {
      print(exception);
    },
      
  ).init(appRunner: (observer) 
    return MyApp(observer);
  });
}

class MyApmWidgetsFlutterBinding extends ApmWidgetsFlutterBinding {
  @override
  void handleAppLifecycleStateChanged(AppLifecycleState state) {
    // 添加自己的实现逻辑
    print('AppLifecycleState changed to $state');
    super.handleAppLifecycleStateChanged(state);
  }

  static WidgetsBinding? ensureInitialized() {
    MyApmWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }
}

class MyApp extends StatelessWidget {
  MyApp([this._navigatorObserver]);

  NavigatorObserver? _navigatorObserver;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: "/",
      navigatorObservers: <NavigatorObserver>[
        // 带入ApmNavigatorObserver实例用于路由监听
        _navigatorObserver ?? ApmNavigatorObserver.singleInstance
      ],
    );
  }
}


```
⚠️  **注意：**

1. **确保去掉原有的WidgetsFlutterBinding.ensureInitialized() ，以免出现重复初始化绑定的异常造成无法正常初始化，SDK内部已通过initFlutterBinding入参带入继承的WidgetsFlutterBinding实现初始化操作**
### 4.2.2 注册监听器
我们需要在 `MyApp` 中注册监听器，将`ApmNavigatorObserver.singleInstance` 添加到应用的`navigatorObservers` 列表中
```dart
UmengApmSdk(
    name: '应用或者模块名称',
    ......
  
  ).init(appRunner: (observer) 
    // 入参 ApmNavigatorObserver 实例
    return MyApp(observer);
  });
}

class MyApp extends StatelessWidget {
  MyApp([this._navigatorObserver]);

  NavigatorObserver? _navigatorObserver;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: "/",
      navigatorObservers: <NavigatorObserver>[
        // 带入ApmNavigatorObserver实例用于路由监听
        _navigatorObserver ?? ApmNavigatorObserver.singleInstance
      ],
    );
  }
}

```
⚠️  **注意：**

1. 如果不带入SDK监听器将无法获知页面（PV）入栈退栈行为，`错误率`（Dart异常数/FlutterPV次数）将异常攀升。
### 4.2.3 自定义异常
#### captureException（类型：Function）
| **入参配置** | **含义** | **是否必传** | **类型** |
| --- | --- | --- | --- |
| exception | 异常摘要 | 是 | Exception |
| stack | 异常堆栈 | 否 | String |
| extra | 自定义属性 | 否 | Map<String, dynamic> |

##### 案例一
```dart
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

void main() {
	Isolate isolate = await Isolate.spawn(runIsolate, []);

  // 监听isolate异常
  isolate.addErrorListener(RawReceivePort((pair) {
    var error = pair[0];
    var stacktrace = pair[1];
    // 主动采集isolate异常
    ExceptionTrace.captureException(
        exception: Exception(error),
        stack: stacktrace.toString());
    
  }).sendPort);
}

```
##### 案例二
```dart
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

void main() {
	try {
    List<String> numList = ['1', '2'];
    print(numList[5]);
  } catch (e) {
  
    // 主动捕获上报代码执行异常
    ExceptionTrace.captureException(
        exception: Exception(e), extra: {"user": '123'});
  }
}

```

### 4.2.4 黑白名单设置  ErrorFilter 
用于设置采集的项的黑白名单，可以在黑名单和白名单中选择其一，如果选择白名单的方式，那么只有符合标准的页面会被采集，如果选择的是黑名单的方式，那么符合标准的页面不会被采集
此项非必须参数，用于判断是否过滤日志，包含如下属性

| 属性 | 含义 | 默认 | 类型 |
| --- | --- | --- | --- |
| mode | 匹配模式
当值为ignore，表示黑名单模式，命中规则的不上报 当值为match，表示白名单模式命中规则的上报 | ignore | 枚举值 ignore&#124;match |
| rules | 匹配规则集合，当类型为数组时，表示规则集合,规则之间为或的关系，只要任意一个规则命中，则规则集命中。 | []，该默认值表示黑名单为空，日志全部上报 | Array<string &#124; RegExp > |

```dart
void main() {
  UmengApmSdk(
    name: '应用或者模块名称',
    // 过滤异常筛选
    errorFilter: {
      "mode": "match",
      "rules": [RegExp('RangeError')],
    }
  	....
  ).init(appRunner: (observer) 
    return MyApp(observer);
  });
}
```
# 步骤五、运行验证
恭喜您！至此，您的App已经成功接入了Flutter 监控啦。
接下来，可以运行您的APP，等待1到5分钟左右即可在平台上查看数据了！
因为设备采样率的关系，测试设备并一定会直接命中日志采样，所以我们需要在验证前将测试设备添加白名
单或者将Flutter PV采样率调至100%以确保测试设备可以命中日志采样
⚠️  **提示：**

1. 免费版设备Flutter PV采样率 默认 5% 不可更改
2. 专业版和尊享版 设备Flutter PV采样率 默认 5% 最高可设置100% 可在 开通管理- 修改配置中 更改
3. 支持设置单设备每天上报Dart异常条数的上限，默认20个，专业版最高支持40条/天，尊享版最高支持120条/天

| **运行验证方式** | **使用权限** | **使用场景** | **生效时间** |
| --- | --- | --- | --- |
| 通用采样设备（设备白名单） | 免费版、专业版、尊享版 | 对专门的单个或者多个测试设备进行验证 | 设置后8小时以内生效（可通过更改设备8小时后时间，再次冷启动强制更新缓存，可立即生效） |
| 调整Flutter采样率至100% | 专业版、尊享版 | 付费版应用权限下适合未上架应用对测试设备进行验证，采样率调整会对设置比例下的访问设备生效。 | 设置后8小时以内生效（可通过更改设备8小时后时间，再次冷启动强制更新缓存，可立即生效） |

## 5.1 验证前准备方式一
### 5.1.1 打开设备通用采样设置
**添加白名单设备不受采样率限制，可直接用来测试日志上报情况**
![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691398218262-7bbf8aef-e41f-4020-aac9-b29d5217e671.png#clientId=ua7bd8b63-d698-4&from=paste&height=573&id=u25a657ed&originHeight=1146&originWidth=2756&originalType=binary&ratio=2&rotation=0&showTitle=false&size=614245&status=done&style=shadow&taskId=uf3239f02-d2e3-4af4-af77-5795b571621&title=&width=1378)
### 5.1.2 添加采样设备白名单
脚本获取打印UMID
:::warning
Android ：UMConfigure.getUMIDString(this);
iOS：[UMConfigure umidString]
:::

![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691398262235-d38d9ce1-432a-471b-9bf1-a6c7749eee55.png#clientId=ua7bd8b63-d698-4&from=paste&height=476&id=u2aa59685&originHeight=952&originWidth=2774&originalType=binary&ratio=2&rotation=0&showTitle=false&size=507721&status=done&style=shadow&taskId=ud096b567-4988-4a17-928c-f9097704446&title=&width=1387)
⚠️  **注意：**

1. 设置完成后设备白名单状态更新8小时以内客户端可生效，请提前添加测试设备`umid`

## 5.2 验证前准备方式二
### 5.2.1 调整采样率 
**调整Flutter分析PV采样率至100%**

   1. ![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1691143840445-0ae55971-7ff5-4d15-a8f4-7f14d47f5ae8.png#clientId=u8a80fea7-5354-4&from=paste&height=659&id=u05b29e89&originHeight=1318&originWidth=1423&originalType=binary&ratio=2&rotation=0&showTitle=false&size=157212&status=done&style=shadow&taskId=u78d69286-311d-4a8e-8e1e-f00838cef6f&title=&width=711.5)
# 5.2 验证SDK运行
查看日志面板
![image.png](https://intranetproxy.alipay.com/skylark/lark/0/2023/png/16356981/1692004801365-d39ae235-df36-4b6e-9f56-89bbf3efbad3.png#clientId=u800b4419-5b51-4&from=paste&height=116&id=uc11678d8&originHeight=232&originWidth=1376&originalType=binary&ratio=2&rotation=0&showTitle=false&size=75940&status=done&style=shadow&taskId=u54d175a5-b3ee-44ef-b98f-1f4f799226b&title=&width=688)
# 
