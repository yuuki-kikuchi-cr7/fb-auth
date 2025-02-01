import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/content/profile_page/profile_provider.dart';
import 'package:fb_auth_riverpod/pages/widgets/custom_loader.dart';
import 'package:fb_auth_riverpod/repositories/auth/auth_repository_provider.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(delayedProfileProvider); // UIDを渡してプロフィールを取得

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await ref.read(authRepositoryProvider).signout();
              } on CustomError catch (e) {
                if (!context.mounted) return;
                errorDialog(context, e);
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification notification) {
          notification.disallowIndicator(); // RefreshIndicator のマークを非表示にする
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(profileProvider); // プルダウン時にデータをリフレッシュ
            await Future.delayed(const Duration(seconds: 2)); // ローディングの演出
          },
          child: profileState.when(
            data: (appUser) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome ${appUser.name}",
                          style: const TextStyle(fontSize: 24.0),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          "Your Profile",
                          style: TextStyle(fontSize: 24.0),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "email: ${appUser.email}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "id: ${appUser.id}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              GoRouter.of(context)
                                  .goNamed(RouteNames.changePassword);
                            },
                            child: const Text("Change Password"))
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (e, str) {
              final error = e as CustomError;

              return Center(
                child: Text(
                  "code: ${error.code}\nplugin: ${error.plugin}\nmessage: ${error.message}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              );
            },
            loading: () => const CustomLoader(),
          ),
        ),
      ),
    );
  }
}
