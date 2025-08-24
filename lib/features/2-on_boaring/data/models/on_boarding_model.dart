import 'package:flutter/material.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String subTitle;
  final String description;
  final Color backGroundColor;
  final bool rtl;
  OnBoardingModel( {
    required this.image,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.backGroundColor,
    required this.rtl
  });
}
