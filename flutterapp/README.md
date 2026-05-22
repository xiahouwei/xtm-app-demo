# flutter_proj

小铁马flutter模板文档

*以下目录中文件在迁移模板的时候需要进行保留

```
flutterapp/
├── android/
├── ios/
├── assets/                     // 静态资源
│   ├── icons                   // 通用模资源
│   │   ├── bottom_bar          // 基座icon
│   │   └── app_icon.png        // app icon
│   └── images                  // 组件资源
│       ├── image               // image组件icon
│       ├── placeholder         // 上传证照背景图
│       └── version_update      // 版本更新组件icon
├── lib/
│   ├── main.dart               // 入口函数
│   ├── app_init/               // 初始化
│   │   └── ui_init.dart        // ui初始化
│   ├── common                  // 通用功能
│   │   └── download_file       // 下载文件功能
│   │   │   └── download_file.dart   
│   │   ├── event_bus               // event_bus
│   │   │   ├── event_bus_type.dart
│   │   │   └── event_bus.dart
│   │   ├── function                // 通用函数
│   │   │   └── auth_mananger.dart  // 登录相关通用函数
│   │   ├── h5_page/                // h5相关
│   │   │   ├── h5_page_manage.dart // h5页面管理
│   │   │   └── h5_url_manage.dart  // h5url管理
│   │   └── ume_kit/                // 调试工具
│   │           └── ume_kit_manage.dart 
│   ├── config/
│   │   ├── api_interface_config    // 接口管理
│   │   │   ├── api_auth.dart       // h5页面管理
│   │   │   ├── api_im.dart         // h5页面管理
│   │   │   ├── api_image.dart      // h5页面管理
│   │   │   └── index.dart          // h5url管理
│   │   └── app_config.dart         // app配置
│   ├── constants/                  // 常量配置
│   │   ├── base
│   │   │   └── bottom_sheet_base.dart  
│   │   ├── common_constant.dart
│   │   ├── image_constants.dart
│   │   └── login_constants.dart
│   ├── device/                     // 设备
│   ├── enum/                       // 枚举
│   ├── models/                     // models
│   │   └── widget                  // 组件 models
│   ├── newtwork/                   // 网络请求相关
│   ├── pages/                      // 业务页面
│   ├── routers/                    // 路由
│   ├── store/                      // 数据仓库
│   ├── theme/                      // 主题
│   ├── utils/                      // 工具类
│   ├── widgets/                    // 项目通用组件
│   ├── xtmdesign_component/        // xtm组件库
│   └── main.dart                   // 入口函数
├── pubspec.yaml
└── README.md

```

