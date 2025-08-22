import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/features/2-on_boaring/data/models/on_boarding_list.dart';
import 'package:shopak/features/2-on_boaring/presentation/views/widgets/on_boarding_page_view.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_in_view.dart';
import 'package:shopak/generated/l10n.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: OnBoardingPageView(
            pageController: pageController,
            currentPage: currentPage,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(onBoardingList.length, (index) {
            bool isActiveOrPassed = index <= currentPage;
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: isActiveOrPassed ? 15 : 13,
              height: isActiveOrPassed ? 15 : 13,
              decoration: BoxDecoration(
                color:
                    isActiveOrPassed
                        ? AppColor.primaryColor
                        : AppColor.primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: CustomButton(
            title:
                currentPage == onBoardingList.length - 1
                    ? S.of(context).start_now
                    : S.of(context).next,
            buttonColor: AppColor.primaryColor,
            textStyle: AppStyle.styleBold24().copyWith(color: AppColor.white),
            onTap: () async {
              if (currentPage != onBoardingList.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                await Prefs.setBool(kIsOnBoardingViewSeen, true);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SignInView.routeName,
                  (route) => false,
                );
              }
            },
          ),
        ),
        const SizedBox(height: 43),
      ],
    );
  }
}