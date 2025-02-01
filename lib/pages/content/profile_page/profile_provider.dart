import 'package:fb_auth_riverpod/constants/firebase_constants.dart';
import 'package:fb_auth_riverpod/models/app_user.dart';
import 'package:fb_auth_riverpod/repositories/profile/profile_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
FutureOr<AppUser> profile(ProfileRef ref,String uid) {
  ref.onDispose((){
    print("[dispose]");
  });
  return ref.watch(profileRepositoryProvider).getProfile(uid: uid);
}

final delayedProfileProvider = FutureProvider<AppUser>((ref) async {
  // 2秒間待機
  await Future.delayed(const Duration(seconds: 2));

  final uid = fbAuth.currentUser!.uid;
  final profile = await ref.watch(profileProvider(uid).future);
  return profile;
});

final profileRefreshingProvider = StateProvider<bool>((ref) => false);

