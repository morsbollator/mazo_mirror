import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sizer/sizer.dart';
import 'package:test_cam/navigation.dart';

class TestAnimation extends StatefulWidget {
  final String link;
  const TestAnimation({required this.link,Key? key}) : super(key: key);
  @override
  State<TestAnimation> createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late Animation<double> _translateAnimation;
  late Animation<double> _rotateAnimation;
  bool finish =false;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _translateAnimation = Tween<double>(
      begin: 100.h,
      end: 50.h / 2-250,
    ).animate(_controller);

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 6, // Number of rotations
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOut, // Use a custom easing curve
      ),
    );

    _controller.forward();
    _controller2.forward();
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller2.stop();

        setState(() {
          finish = true;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: (){
          navPop();
        },
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _translateAnimation.value),
                child: AnimatedBuilder(
                    animation: _controller2,
                    builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY((_rotateAnimation.value)*3.14159),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.shade300.withOpacity(0.6),
                              blurRadius: 5,spreadRadius: 1,
                              blurStyle: BlurStyle.outer,),
                            ],
                          ),
                          // Add your card content here
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: finish?1:0,
                              child: PrettyQr(
                                image: AssetImage('assets/logo.png'),
                                size: 200,
                                data: widget.link,
                                roundEdges: true,
                                // elementColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
