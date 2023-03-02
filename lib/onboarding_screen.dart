import 'package:ez_xpert/screen/auth/login/login_screen.dart';
import 'package:ez_xpert/utilities/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 225),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 14.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1B2072) : const Color(0xFFC4C4C4),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    // height: 450.0,
                    child: PageView(
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: const AssetImage(
                                    'assets/onboarding0.png',
                                  ),
                                  height: 300.0,
                                  width:
                                      MediaQuery.of(context).size.width * .86,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              const Center(
                                widthFactor: 1,
                                child: Text(
                                  'Automated timesheet, which uses data from GPS and Dispatch to track the time spent on projects or tasks without any click.',
                                  style: onBoardingTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: const AssetImage(
                                    'assets/onboarding1.png',
                                  ),
                                  height: 300.0,
                                  width:
                                      MediaQuery.of(context).size.width * .86,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              const Center(
                                widthFactor: 1,
                                child: Text(
                                  'Assign right person who will be available after hours who can quickly respond to any incidents and emergency situations.',
                                  style: onBoardingTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: const AssetImage(
                                    'assets/onboarding4.png',
                                  ),
                                  height: 300.0,
                                  width:
                                      MediaQuery.of(context).size.width * .86,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              const Center(
                                widthFactor: 1,
                                child: Text(
                                  'Centralized space where all information related to a company as well as its products or services can be Shared and organised, which helps the team to enhance knowledge.',
                                  style: onBoardingTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: const AssetImage(
                                    'assets/onboarding3.png',
                                  ),
                                  height: 300.0,
                                  width:
                                      MediaQuery.of(context).size.width * .86,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Request leave in just a few clicks, directly from were you are and know approval/rejection status',
                                        style: onBoardingTextStyle,
                                      ),
                                      TextSpan(
                                        text: ' ...and more',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w400,
                                          height: 1.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _currentPage != _numPages - 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                alignment: Alignment.centerRight,
                                child: Text('Skip',
                                    style: onBoardingButtonStyle.copyWith(
                                        color: const Color(0xffA7A7A7))),
                              ),
                            )
                          : const Text(''),
                      _currentPage != _numPages - 1
                          ? Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: GestureDetector(
                                    onTap: () {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 40,
                                          right: 40,
                                          top: 10,
                                          bottom: 10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xff1B2072),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      ),
                                      child: Text('Next',
                                          style: onBoardingButtonStyle.copyWith(
                                            color: Colors.white,
                                          )),
                                    )),
                              ),
                            )
                          : const Text(''),
                      _currentPage == _numPages - 1
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                padding: const EdgeInsets.only(
                                    top: 14, bottom: 14, left: 35, right: 35),
                                decoration: const BoxDecoration(
                                  color: Color(0xff1B2072),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text('Start!',
                                    style: onBoardingButtonStyle.copyWith(
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
