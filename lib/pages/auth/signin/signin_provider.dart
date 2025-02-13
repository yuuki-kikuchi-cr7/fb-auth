import 'package:fb_auth_riverpod/repositories/auth/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signin_provider.g.dart';

@riverpod
class Signin extends _$Signin {
  @override
  FutureOr<void> build() {}

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signin(email: email, password: password),
    );
  }
}

final firstLoadProvider = StateProvider<bool>((ref) => true);

