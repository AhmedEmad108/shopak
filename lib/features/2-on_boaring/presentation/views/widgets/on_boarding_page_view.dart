import 'package:flutter/material.dart';
import 'package:shopak/features/2-on_boaring/data/models/on_boarding_list.dart';
import 'package:shopak/features/2-on_boaring/presentation/views/widgets/on_boarding_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    required this.currentPage,
  });
  final PageController pageController;
  final dynamic currentPage;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      controller: pageController,
      itemCount: onBoardingList.length,
      itemBuilder: (context, index) {
        return OnBoardingItem(
          onBoardingModel: onBoardingList[index],
          currentPage: currentPage,
        );
      },
    );
  }
}
