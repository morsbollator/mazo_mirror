import 'package:flutter/material.dart';
import 'package:mazo/image_provider.dart';
import 'package:mazo/navigation.dart';
import 'package:mazo/order_provider.dart';
import 'package:mazo/select_gender.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // await DesktopWindow.setWindowSize(Size(350,623));
    Provider.of<OrderProvider>(context,listen: false).getOrder();
    Provider.of<ImgProvider>(context,listen: false).loadLinks();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await windowManager.ensureInitialized();
      // await WindowManager.instance.setSize(Size(350*2, 623*2));
      await WindowManager.instance.setFullScreen(true);
      await windowManager.setAsFrameless();
      // FlutterSoundRecordPlatform.instance = MyFlutterSoundRecordPlatform();
      // FlutterSoundRecordPlatform.instance ;
      // await windowManager.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: (){
          navP(SelectGender());
        },
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/home.gif'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
