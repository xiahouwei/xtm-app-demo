#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AMapFoundationKit/AMapUtility.h>

@interface AppDelegate ()

/**  */
@property (nonatomic,strong) FlutterEngine *flutterEngine;
/**  */
@property (nonatomic,strong) FlutterResult currentResult;
/** */
@property (nonatomic,strong) FlutterMethodChannel *fChannel;
/** 计算时间间隔用 */
//@property (nonatomic,strong) NSDate *lastDate;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initFlutterEngine];
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //warning: 需要重写当前方法，gtsdk的接管系统方法就会生效，否则会影响回执
    //保持空实现
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
//    if ([urlComponents.scheme isEqualToString:@"xiaotiema"]) {
//        NSString *param = [urlComponents.query componentsSeparatedByString:@"="].lastObject;
//        [self.fChannel invokeMethod:@"nativeCallFlutterToShareReserve" arguments:param result:^(id  _Nullable result) {
//            
//        }];
//    }
    
    return YES;
}

- (void)initFlutterEngine {
    // 1.获取FlutterViewController(是应用程序的默认Controller)
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    // 2.获取MethodChannel(方法通道)
    FlutterMethodChannel* fChannel = [FlutterMethodChannel methodChannelWithName:@"connectNativeChannel" binaryMessenger:controller.binaryMessenger];
    self.fChannel = fChannel;
      [fChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
          self.currentResult = result;
          if ([call.method isEqualToString:@"SystemNavigator.pop"]) { // 退出app
              exit(0);
          }
      }];
}

@end
