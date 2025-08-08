import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/features/2-on_boaring/presentation/views/on_boarding_view.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_in_view.dart';
import 'package:shopak/generated/l10n.dart';
import 'package:svg_flutter/svg.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> {
  @override
  void initState() {
    excuteNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.imagesLogoSvg, height: 250, fit: BoxFit.fill),
          Text(
            S.of(context).shopak,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void excuteNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      bool isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
      var isLoggedIn = false;
      // FirebaseAuth.instance.currentUser != null;
      if (isOnBoardingViewSeen) {
        if (isLoggedIn) {
          
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInView.routeName,
            (route) => false,
          );
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          OnBoardingView.routeName,
          (route) => false,
        );
      }
      // var emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }
}
