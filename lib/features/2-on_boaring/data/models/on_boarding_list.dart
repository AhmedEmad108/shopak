import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/features/2-on_boaring/data/models/on_boarding_model.dart';
import 'package:shopak/generated/l10n.dart';

List<OnBoardingModel> onBoardingList = [
  OnBoardingModel(
    image: Assets.imagesLogoPng,
    backGroundColor: AppColor.background1Color,
    title: S.current.welcome_to_shopak,
    subTitle: S.current.start_shopping,
    description: S.current.from_electronics_to_fashion,
  ),
  OnBoardingModel(
    image: Assets.imagesSearchPng,
    backGroundColor: AppColor.background2Color,
    title: S.current.browse_shop,
    subTitle: S.current.explore_products,
    description: S.current.pick_suits,
  ),
  OnBoardingModel(
    image: Assets.imagesDelivery,
    backGroundColor: AppColor.background3Color,
    title: S.current.order_delivered,
    subTitle: S.current.order_quickly,
    description: S.current.with_shopak,
  ),
];
