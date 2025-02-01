import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/signin/signin_provider.dart';
import 'package:fb_auth_riverpod/pages/widgets/buttons.dart';
import 'package:fb_auth_riverpod/pages/widgets/custom_loader.dart';
import 'package:fb_auth_riverpod/pages/widgets/form_fields.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 初回だけローディングを適用
    if (ref.read(firstLoadProvider)) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          ref.read(firstLoadProvider.notifier).state =
              false; // 初回のロードが終わったらfalseにする
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(signinProvider.notifier).signin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      signinProvider,
      (prev, next) {
        next.whenOrNull(
          error: (error, stackTrace) =>
              errorDialog(context, error as CustomError),
        );
      },
    );

    final signinState = ref.watch(signinProvider);
    final isFirstLoad = ref.watch(firstLoadProvider);

    // **初回の遷移時のみローディングを表示**
    if (isFirstLoad) {
      return const Scaffold(
        body: CustomLoader(),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // const FlutterLogo(
                  //   size: 150,
                  // ),
                  const SizedBox(height: 20.0),
                  EmailFormField(emailController: _emailController),
                  const SizedBox(height: 20.0),
                  PasswordFormField(
                    passwordController: _passwordController,
                    labelText: 'Password',
                  ),
                  const SizedBox(height: 20.0),
                  CustomFilledButton(
                    onPressed: signinState.maybeWhen(
                      loading: () => null,
                      orElse: () => _submit,
                    ),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    child: Text(
                      signinState.maybeWhen(
                        loading: () => 'Submitting...',
                        orElse: () => 'Sign In',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Not a member? '),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomTextButton(
                        onPressed: signinState.maybeWhen(
                          loading: () => null,
                          orElse: () =>
                              () => context.goNamed(RouteNames.signup),
                        ),
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        child: const Text('Sign Up!'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextButton(
                    onPressed: signinState.maybeWhen(
                      loading: () => null,
                      orElse: () =>
                          () => context.goNamed(RouteNames.resetPassword),
                    ),
                    foregroundColor: const Color.fromARGB(255, 179, 80, 73),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    child: const Text('Forgot Password?'),
                  )
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
