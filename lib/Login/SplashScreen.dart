import 'package:flutter/material.dart';
import 'package:pi2025/Login/hi.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _textAnimation;
  late Animation<Offset> _containerAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _textAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _containerAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_controller);

    _textFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_controller);

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _animation = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(-1.5, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        _textAnimation = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(-1.5, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        _containerAnimation = Tween<Offset>(
          begin: Offset(0.0, 0.0),
          end: Offset(-1.5, 0.0),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        _fadeAnimation = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        _textFadeAnimation = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

        _controller.forward();
      });

      Future.delayed(Duration(milliseconds: 700), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => hi()),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _textFadeAnimation,
            child: SlideTransition(
              position: _textAnimation,
              child: Text(
                'Bienvenidos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: SlideTransition(
              position: _containerAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.7),
                      Colors.blue.shade900.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(5),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _animation,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset('assets/images/splash.jpeg', height: 100),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}