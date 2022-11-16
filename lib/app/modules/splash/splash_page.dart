import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../common/utils/common_util.dart';
import '../../../common/utils/object_util.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  SplashController controller = Get.find<SplashController>();

  @override
  void initState() {
    super.initState();
    _checkPermission();
    //页面跳转 注册观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    //注销观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && isGoSetting) {
      _checkPermission();
      isGoSetting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          CommonUtils.getImageByName("img_mn_01.jpg"),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _checkPermission({PermissionStatus? status}) async {
    Permission permission = Permission.storage;

    if (ObjectUtil.isEmpty(status)) {
      status = await permission.status;
    }
    if (status!.isGranted) {
    } else if (status.isDenied) {
      showPermissionAlert(_list[0], rightStr: "同意", onConfirm: () {
        requestPermission(permission);
      });
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      showPermissionAlert(_list[1], rightStr: "去设置中心", onConfirm: () {
        openAppSettings();
        isGoSetting = true;
      });
    } else {
      showPermissionAlert(_list[0], rightStr: "同意", onConfirm: () {
        requestPermission(permission);
      });
    }
  }

  final List<String> _list = [
    "为您更好的体验应用,所以需要获取您手机的文件存储权限,以保存您的一些偏好设置",
    "您已拒绝权限,请在设置中心中同意App的权限请求",
    "您以拒绝权限,所以无法保存您的一些偏好设置,将无法使用App",
    "其它错误",
  ];

  //是否去设置中心
  bool isGoSetting = false;

  void showPermissionAlert(String message, {String rightStr = "同意", Function? onConfirm}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext cxt) {
          return CupertinoAlertDialog(
            title: const Text("温馨提示"),
            content: Container(padding: const EdgeInsets.all(12), child: Text(message)),
            actions: [
              CupertinoDialogAction(
                child: const Text("退出应用"),
                onPressed: () {
                  _closeApp();
                },
              ),
              CupertinoDialogAction(
                child: Text(rightStr),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
            ],
          );
        });
  }

  void requestPermission(Permission permission) async {
    //发起权限申请
    PermissionStatus status = await permission.request();
    _checkPermission(status: status);
  }

  void _closeApp() {
    //退出应用
    SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }
}
