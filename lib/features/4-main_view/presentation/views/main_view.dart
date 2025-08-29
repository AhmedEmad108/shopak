import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/backend_endpoint.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/core/widgets/custom_image_picker.dart';
import 'package:shopak/core/widgets/custom_listtile.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/4-main_view/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:shopak/features/5-profile/presentation/views/profile_view.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/admin_panel_view.dart';
import 'package:shopak/generated/l10n.dart';

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
      AdminPanel2(),
      if (user.role == 'admin') AdminPanelView(),
      const ProfileView(),
    ][selectedIndex];
  }
}

class AdminPanel2 extends StatelessWidget {
  const AdminPanel2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: S.of(context).admin_panel),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomListTile(
                title: S.of(context).manage_users,
                icon: Icons.admin_panel_settings_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed(UsersPage.routeName);
                  // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
                },
              ),
              CustomListTile(
                title: S.of(context).manage_sellers,
                icon: Icons.admin_panel_settings_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UsersTablePage(),
                    ),
                  );
                  // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
                },
              ),
              CustomListTile(
                title: S.of(context).sellers_requests,
                icon: Icons.store_outlined,
                onTap: () {
                  // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsersTablePage extends StatefulWidget {
  const UsersTablePage({super.key});

  @override
  State<UsersTablePage> createState() => _UsersTablePageState();
}

class _UsersTablePageState extends State<UsersTablePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📋 المستخدمين")),
      body: Column(
        children: [
          // مربع البحث
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "ابحث بالاسم أو البريد",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),

          // جدول البيانات
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection(BackendEndpoint.userData)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("❌ حصل خطأ"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // تحويل الداتا إلى UserModel
                final users =
                    snapshot.data!.docs
                        .map(
                          (doc) => UserEntity.fromMap(
                            doc.data() as Map<String, dynamic>,
                          ),
                        )
                        .where(
                          (user) =>
                              user.name.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ) ||
                              user.email.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ),
                        )
                        .toList();

                return DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  fixedLeftColumns: 4, // يثبت عمود الإجراءات
                  columns: const [
                    DataColumn2(label: Text("الاسم"), size: ColumnSize.L),
                    DataColumn2(label: Text("البريد"), size: ColumnSize.L),
                    DataColumn2(label: Text("الحالة"), size: ColumnSize.S),
                    DataColumn2(label: Text("الإجراءات"), fixedWidth: 120),
                  ],
                  rows: List<DataRow>.generate(users.length, (index) {
                    final user = users[index];
                    return DataRow(
                      cells: [
                        DataCell(Text(user.name)),
                        DataCell(Text(user.email)),
                        DataCell(
                          Text(
                            user.isActive ? "نشط ✅" : "غير نشط ❌",
                            style: TextStyle(
                              color: user.isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // تفتح صفحة التفاصيل
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  user.isActive ? Icons.lock_open : Icons.lock,
                                  color:
                                      user.isActive ? Colors.green : Colors.red,
                                ),
                                onPressed: () {
                                  // تحديث الحالة في Firebase
                                  FirebaseFirestore.instance
                                      .collection(BackendEndpoint.userData)
                                      .doc(user.uId)
                                      .update({"isActive": !user.isActive});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  static const String routeName = '/usersPage';

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection(
      BackendEndpoint.userData,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("قائمة المستخدمين (Admin)")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Column(
          children: [
            CustomTextField(
              controller: TextEditingController(text: searchQuery),
              hintText: "ابحث بالاسم او البريد",
              labels: "ابحث بالاسم او البريد",
              keyboardType: TextInputType.text,
              prefixIcon: Icon(Icons.search),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usersRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("حصل خطأ في تحميل البيانات"),
                    );
                  }

                  final users =
                      snapshot.data!.docs
                          .map(
                            (doc) => UserEntity.fromMap(
                              doc.data() as Map<String, dynamic>,
                            ),
                          )
                          .where(
                            (user) =>
                                user.name.toLowerCase().contains(
                                  searchQuery.toLowerCase(),
                                ) ||
                                user.email.toLowerCase().contains(
                                  searchQuery.toLowerCase(),
                                ),
                          )
                          .toList();

                  if (users.isEmpty) {
                    return const Center(child: Text("لا يوجد مستخدمين بعد"));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserDetailsPage(user: user),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: AppColor.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                              CustomImagePicker(
                                onFileChanged: (_) {},
                                radius: 50,
                                urlImage: user.image,
                                show: false,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      user.isActive ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.isActive ? "نشط ✅" : "غير نشط ❌",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  // return ListView.builder(
                  //   itemCount: users.length,
                  //   itemBuilder: (context, index) {
                  //     final user = users[index];

                  //     return Card(
                  //       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  //       child: ListTile(
                  //         leading: CircleAvatar(
                  //           backgroundImage:
                  //               user.image.isNotEmpty ? NetworkImage(user.image) : null,
                  //           child: user.image.isEmpty ? const Icon(Icons.person) : null,
                  //         ),
                  //         title: Text(user.name),
                  //         subtitle: Text(user.email),
                  //         trailing: Icon(
                  //           user.isActive ? Icons.check_circle : Icons.block,
                  //           color: user.isActive ? Colors.green : Colors.red,
                  //         ),
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (_) => UserDetailsPage(user: user),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     );
                  //   },
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  final UserEntity user;

  const UserDetailsPage({super.key, required this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late bool isActive;
  late String role;

  @override
  void initState() {
    super.initState();
    isActive = widget.user.isActive;
    role = widget.user.role;
  }

  Future<void> _updateActiveStatus(bool value) async {
    await FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .doc(widget.user.uId)
        .update({'isActive': value, 'updatedAt': DateTime.now()});
    setState(() {
      isActive = value;
    });
  }

  Future<void> _toggleRole() async {
    final newRole = role == "admin" ? "user" : "admin";
    await FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .doc(widget.user.uId)
        .update({'role': newRole, 'updatedAt': DateTime.now()});
    setState(() {
      role = newRole;
    });
  }

  Future<void> _deleteUser() async {
    await FirebaseFirestore.instance
        .collection(BackendEndpoint.userData)
        .doc(widget.user.uId)
        .delete();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تم حذف المستخدم بنجاح ✅")));
    }
  }

  TableRow buildRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(title: Text("بيانات ${user.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // صورة البروفايل
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundImage:
                    user.image.isNotEmpty ? NetworkImage(user.image) : null,
                child:
                    user.image.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
              ),
            ),
            const SizedBox(height: 20),

            // جدول البيانات الأساسية
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                children: [
                  buildRow("📛 الاسم", user.name),
                  buildRow("📧 البريد", user.email),
                  buildRow("📱 الهاتف", user.phone),
                  buildRow("🎭 الدور", role),
                  buildRow(
                    "✅ البريد مفعل",
                    user.isEmailVerified ? "نعم" : "لا",
                  ),
                  buildRow("📅 تاريخ الإنشاء", user.createdAt.toString()),
                  buildRow("🕑 آخر تسجيل دخول", user.lastLogin.toString()),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // جدول العناوين (لو فيه)
            if (user.address?.isNotEmpty ?? false) ...[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "📍 العناوين",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: user.address?.length ?? 0,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            index == user.primaryIndex
                                ? Icons.home
                                : Icons.location_on,
                            color:
                                index == user.primaryIndex
                                    ? Colors.green
                                    : Colors.blueGrey,
                          ),
                          title: Text(user.address?[index] ?? ""),
                          subtitle:
                              index == user.primaryIndex
                                  ? const Text("العنوان الأساسي")
                                  : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // سويتش التفعيل/التعطيل
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text(
                  "الحالة (Active)",
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Switch(
                  value: isActive,
                  onChanged: (value) => _updateActiveStatus(value),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // الأزرار (تغيير الدور + حذف)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleRole,
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(
                      role == "admin"
                          ? "تغيير إلى مستخدم عادي"
                          : "تغيير إلى أدمن",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _deleteUser,
                    icon: const Icon(Icons.delete),
                    label: const Text("حذف المستخدم"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
