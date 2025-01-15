import 'package:fb_auth_riverpod/repositories/auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_provider.g.dart';

@riverpod
class ChangePassword extends _$ChangePassword {
  @override
  FutureOr<void> build() {}

  Future<void> changePassword(String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).changePassword(password),
    );
  }
}
