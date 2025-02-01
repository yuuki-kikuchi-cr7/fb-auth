// @riverpod
// FutureOr<AppUser> profile(ProfileRef ref,String uid) {
//   ref.onDispose((){
//     print("[dispose]");
//   });
//   return ref.watch(profileRepositoryProvider).getProfile(uid: uid);
// }

// final delayedProfileProvider = FutureProvider<AppUser>((ref) async {
//   // 1秒間待機
//   await Future.delayed(const Duration(seconds: 2));

//   final uid = fbAuth.currentUser!.uid;
//   final profile = await ref.watch(profileProvider(uid).future);
//   return profile;
// });
