
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../login/presentation/cubit/login_cubit.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(Constants.currentEmployee!.fullName),
              accountEmail: Text(Constants.currentEmployee!.username)),
          ListTile(
            title: const Text("الموظفون"),
            trailing: const Icon(Icons.people),
            onTap: () {
              Navigator.popAndPushNamed(context, Routes.employeesRoute);
            },
          ),
          const Divider(),

          ListTile(
            title: const Text("المجموعات"),
            trailing: const Icon(Icons.group_add),
            onTap: () {
              Navigator.popAndPushNamed(context, Routes.teamsRoute);
            },
          ),
          const Divider(),

          BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LogoutError) {
                Constants.showToast(msg: "LogoutError: " + state.msg);
              }

              if (state is EndLogout) {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.initialRoute, (route) => false);
              }
            },
            builder: (context, state) {
              final cubit = LoginCubit.get(context);
              return ListTile(
                title: const Text("خروج"),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  cubit.logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
