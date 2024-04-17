// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/otp_provider.dart';
import 'package:ystfamily/src/features/auth/view/otp_screen.dart';

class OTPConfirmationPasswordScreen extends HookConsumerWidget {
  final String email;
  const OTPConfirmationPasswordScreen({
    super.key,
    required this.email,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.invalidate(verifyOtpProvider));
      return;
    }, []);
    final dialogShown = useState(false);

    ref.listen(verifyOtpProvider, (previous, next) {
      next.when(
        data: (value) {
          if (value.isNotEmpty) {
            final sc = ScaffoldMessenger.of(context);
            final nv = Navigator.of(context);
            sc.removeCurrentSnackBar();

            if (dialogShown.value) {
              dialogShown.value = false;
              nv.pop();
            }
            const LoginRoute().go(context);
          }
        },
        error: (error, stackTrace) {
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
        },
        loading: () {
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
        },
      );
    });

    // final data = ref.watch(otpProvider);

    final otpVal = useState("");
    final isSecure = useState(true);
    final passwordController = useTextEditingController();
    final formKey = useMemoized(
      () => GlobalKey<FormState>(),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        final a = await showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text("Kembali?"),
            content: const Text("Apakah anda yakin"),
            actions: [
              ActionButton(
                isFilled: false,
                onPressed: () {
                  Navigator.pop(context, true);
                },
                text: "Ya",
              ),
              ActionButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                text: "Tidak",
              )
            ],
          ),
        );
        if (a) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Lupa Password",
            style: TextStyle(
              color: VColor.primaryTextColor,
            ),
          ),
          backgroundColor: VColor.primaryBackground,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Masukkan Kode Verifikasi",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Kode verifikasi telah dikirimkan melalui",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Email ke - ",
                          children: [
                            TextSpan(
                              text: email,
                              style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle()).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      OtpTextField(
                        numberOfFields: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: const TextInputType.numberWithOptions(),
                        onCodeChanged: (value) {},
                        onSubmit: (value) {
                          otpVal.value = value;
                        },
                      ),
                    ],
                  ),
                  const Gap(24),

                  TextFormField(
                    controller: passwordController,
                    obscureText: isSecure.value,
                    decoration: inputStyle.copyWith(
                      labelText: "Password Baru",
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
                          child: isSecure.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        ),
                      ),
                    ),
                    validator: (value) {
                      return value != null && value.isNotEmpty ? null : "Kata kunci tidak boleh kosong";
                    },
                  ),

                  const Gap(24),
                  ElevatedButton(
                    child: const Center(
                      child: Text(
                        "Kirim",
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        if (otpVal.value.length == 6) {
                          ref.read(verifyOtpProvider.notifier).postConfirmChangePassword(otp: otpVal.value, email: email, newPassword: passwordController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Kode OTP harus 6 digit"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  // const Gap(8),
                  // ElevatedButton(
                  //   onPressed: data > 0
                  //       ? null
                  //       : () {
                  //           ref.read(otpLengthProvider.notifier).setDate();
                  //         },
                  //   child: Center(
                  //     child: Text(
                  //       data > 0 ? "$data" : "Kirim ulang kode verifikasi",
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
