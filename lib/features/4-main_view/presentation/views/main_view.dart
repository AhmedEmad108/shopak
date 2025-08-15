import 'package:flutter/material.dart';
import 'package:shopak/features/4-main_view/presentation/views/widgets/custom_bottom_navigation_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const String routeName = '/mainView';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        itemIndex: (int value) {
          selectedIndex = value;
          setState(() {});
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // selectedIndex == 0
            //     ? const CustomAppBarHomeView()
            //     : customAppBar(context, title: 'title'),
            Expanded(child: screens()),
          ],
        ),
      ),
    );
  }

  Widget screens() {
    return [
      // const HomeView(),
      Container(),
      Container(),
      Container(),
      Container(),
      // const ProfieView(),
    ][selectedIndex];
  }
}
