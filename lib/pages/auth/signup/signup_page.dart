import 'package:fb_auth_riverpod/config/router/route_names.dart';
import 'package:fb_auth_riverpod/models/custom_error.dart';
import 'package:fb_auth_riverpod/pages/auth/signup/signup_provider.dart';
import 'package:fb_auth_riverpod/pages/widgets/buttons.dart';
import 'package:fb_auth_riverpod/pages/widgets/form_fields.dart';
import 'package:fb_auth_riverpod/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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

    ref.read(signupProvider.notifier).signup(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      signupProvider,
      (previus, next) {
        next.whenOrNull(
          error: (error, stackTrace) =>
              errorDialog(context, error as CustomError),
        );
      },
    );

    final signupState = ref.watch(signupProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  // const FlutterLogo(
                  //   size: 150,
                  // ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  NameFormField(nameController: _nameController),
                  const SizedBox(
                    height: 20.0,
                  ),
                  EmailFormField(emailController: _emailController),
                  const SizedBox(
                    height: 20.0,
                  ),
                  PasswordFormField(
                    passwordController: _passwordController,
                    labelText: "Password",
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ConfirmPasswordField(
                    passwordController: _passwordController,
                    labelText: "Confirm Password",
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomFilledButton(
                    onPressed: signupState.maybeWhen(
                      loading: () => null,
                      orElse: () => _submit,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    child: Text(
                      signupState.maybeWhen(
                        loading: () => "Submitting...",
                        orElse: () => "Sign UP",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member?"),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomTextButton(
                        onPressed: signupState.maybeWhen(
                          loading: () => null,
                          orElse: () => () =>
                              GoRouter.of(context).pushNamed(RouteNames.signin),
                        ),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        child: const Text("Sign In!"),
                      ),
                    ],
                  ),
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
