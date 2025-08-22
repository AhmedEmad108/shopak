import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/4-main_view/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:shopak/features/5-profile/presentation/views/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const String routeName = '/mainView';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;
  UserEntity user = getUser();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          user = state.user;
        } else if (state is GetUserLoading) {
          user = getUser();
        } else if (state is GetUserFailed) {
          return Center(child: Text(state.errMessage));
        }

        return Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(
            userRole: user.role,
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
      },
    );
  }

  Widget screens() {
    return [
      // const HomeView(),
      Container(),
      Container(),
      Container(),
      if (user.role == 'admin') Container(),
      const ProfileView(),
    ][selectedIndex];
  }
}
