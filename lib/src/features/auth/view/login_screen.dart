// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/model/dto/login_dto.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogShown = useState(false);

    ref.listen(authProvider, (previous, next) async {
      switch (next) {
        case AsyncLoading():
          dialogShown.value = true;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          return;
        case AsyncData(:final value):
          final sc = ScaffoldMessenger.of(context);
          final nv = Navigator.of(context);
          sc.removeCurrentSnackBar();
          log("$value");
          if (dialogShown.value) {
            dialogShown.value = false;
            nv.pop();
          }
          if (value.isConfirmed) {
            const HomePageRoute().go(context);
          } else {
            const OTPRoute().push(context);
          }

          return;
        case AsyncError(:final error):
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          if (dialogShown.value) {
            dialogShown.value = false;
            Navigator.pop(context);
          }
          String message = "Silahkan coba lagi";
          if (error is ApiException) {
            message = (error).message;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          return;
      }
    });
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isSecure = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masuk",
            style: TextStyle(
              color: VColor.primaryTextColor,
            )),
        backgroundColor: VColor.primaryBackground,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: inputStyle.copyWith(
                      labelText: "Email",
                      hintText: "contoh@contoh.com",
                      prefixIcon: const Icon(
                        Icons.email,
                      ),
                    ),
                  ),
                  const Gap(12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: isSecure.value,
                    decoration: inputStyle.copyWith(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                          onPressed: () {
                            isSecure.value = !isSecure.value;
                          },
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: isSecure.value
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          )),
                    ),
                  ),
                  const Gap(24),
                  VCard.horizontal(
                    backgroundColor: VColor.primaryBackground,
                    onTap: ref.watch(
                            authProvider.select((value) => value.isLoading))
                        ? null
                        : () {
                            ref.read(authProvider.notifier).login(
                                  params: LoginDTO(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          },
                    child: const Center(
                      child: Text(
                        "Masuk",
                      ),
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          const ForgetPasswordRoute().push(context);
                        },
                        child: const Text(
                          "Lupa Kata Sandi?",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  TextButton(
                    onPressed: () {
                      const RegisterRoute().replace(context);
                    },
                    child: const Text.rich(
                      TextSpan(
                        // text: "Belum Punya Akun? ",

                        children: [
                          TextSpan(
                            text: "Belum punya akun? ",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          TextSpan(
                            text: "Daftar",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
