import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/content/home/home_provider.dart';
import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = fbAuth.currentUser!.uid;
    final profileState = ref.watch(profileProvider(uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
          IconButton(
            onPressed: () {
              ref.invalidate(profileProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: profileState.when(
        data: (appUser) {
          return Center(
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
                      GoRouter.of(context).goNamed(RouteNames.changePassword);
                    },
                    child: const Text("Change Password"))
              ],
            ),
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
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
