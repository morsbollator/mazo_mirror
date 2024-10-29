import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/home.dart';
import 'package:test_cam/navigation.dart';
import 'package:test_cam/var.dart';

class RandomView extends StatefulWidget {
  const RandomView({Key? key}) : super(key: key);

  @override
  State<RandomView> createState() => _RandomViewState();
}

class _RandomViewState extends State<RandomView> {
  List<String> list = [
    'يا $name خليك ديما عارف ان ربنا ديما بيكتب الأحسن حتي لو انته مش شايف ده دلوقتي',
    'يا $name خليكي ديما عارفه ان ربنا ديما بيكتب الأحسن حتي لو احنا مش شايفين ده دلوقتي',
    'اوعي تيأس / تيأسي كل أللي جاي خير',
    'مش عيب انك ت overthink بس العيب انك تنسي انك ياما فكرت و برضه اتحلت لوحدها ريح نفسك و بالك شويه',
    'اوعي تخسر حد قريب منك ألي موقف اي كان ايه علشان العمر مفهوش كتير علشان كل شويه تعمل صاحب او صاحبه',
    'من كام سنه اكيد كنت بتتمني حجات و دلوقتي الحجات دي اكيد في منها حصل ، فحاول تكمل ديما و لو مفيش حد قالك انو فخور بيك. فأحنا فخورين بيك',
    'كان الزم يحصل أللي مكنش نفسك يحصل علشان يغير فيك للأحسن و علشان تتعلم حاجات مكنتش تعرفها ، هتروق بس فوقلها ها 😂',
    'التوهه ألي انته فيها هتعدي ربك مش بينسي حد 😘',
    'طالما ربنا لسه مديك العمر يبقي صدقني لسه في خير كتير شايلهولك اصبر انته بس',
    'متحاولش تقدر ألي مبيقدركش انته مش ناقص وجع دماغ',
    'انت ناعي هم النهارده ليه هو ربنا قصر معاك امبارح ،سبها علي هللا هتتحل'
  ];
  int random = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    random = Random().nextInt(list.length-1);
    Future.delayed(Duration(seconds: 5)).then((val){
      if(mounted){
        navPRRU(Home());
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(name,style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.white,),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/random.gif'),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        child: Center(
          child: SizedBox(
            width: 90.w,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(list[random],
                  speed: Duration(milliseconds: 30)),
                ],

                totalRepeatCount: 1,
                onTap: () {
                  print("Tap Event");
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
