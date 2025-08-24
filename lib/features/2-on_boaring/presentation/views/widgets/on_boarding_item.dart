import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/widgets/rtl_imagr.dart';
import 'package:shopak/features/2-on_boaring/data/models/on_boarding_list.dart';
import 'package:shopak/features/2-on_boaring/data/models/on_boarding_model.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_in_view.dart';
import 'package:shopak/generated/l10n.dart';
import 'package:svg_flutter/svg.dart';

class OnBoardingItem extends StatelessWidget {
  const OnBoardingItem({
    super.key,
    required this.onBoardingModel,
    required this.currentPage,
  });
  final OnBoardingModel onBoardingModel;
  final dynamic currentPage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  Assets.imagesBackgroudImage,
                  color: onBoardingModel.backGroundColor,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: -15,
                left: 0,
                right: 0,
                child: RtlImage(
                  path: onBoardingModel.image,
                  rtl: onBoardingModel.rtl,
                  height: 200,
                ),
              ),

              Visibility(
                visible: currentPage != onBoardingList.length - 1,
                child: PositionedDirectional(
                  end: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 32,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Prefs.setBool(kIsOnBoardingViewSeen, true);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          SignInView.routeName,
                          (route) => false,
                        );
                      },
                      child: Text(
                        S.of(context).skip,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColor.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Column(
            children: [
              Text(
                onBoardingModel.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Text(
                onBoardingModel.subTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                onBoardingModel.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColor.grey2.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
