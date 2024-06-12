// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';
import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/config/theme.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/provider/otp_provider.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool? isFilled;
  const ActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isFilled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIos = Platform.isIOS;
    if (isIos) {
      return CupertinoDialogAction(
        onPressed: onPressed,
        child: Text(text),
      );
    }
    if (isFilled ?? true) {
      return ElevatedButton(onPressed: onPressed, child: Text(text));
    }
    return TextButton(onPressed: onPressed, child: Text(text));
  }
}

class OTPScreen extends HookConsumerWidget {
  const OTPScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    ref.listen(verifyOtpProvider, (previous, next) {
      next.when(
        data: (val) {
          if (isLoading.value) {
            isLoading.value = false;
            Navigator.of(context, rootNavigator: true).pop();
          }
          ref.invalidate(authProvider);
        },
        error: (e, stackTrace) {
          log("$e");
          final error = errorRoot(e);
          if (error.toLowerCase() == "unauthorized" &&
              error.toLowerCase() == "relogin") {
            void logout() {
              const LoginRoute().go(context);
            }

            logout();

            return;
          }
          if (isLoading.value) {
            isLoading.value = false;
            Navigator.of(context, rootNavigator: true).pop();
          }
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error)));
        },
        loading: () {
          isLoading.value = true;

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
    ref.listen(authProvider, (previous, next) {
      next.whenData((value) {
        const HomePageRoute().go(context);
      });
    });

    final data = ref.watch(otpProvider);
    final user = ref.watch(authProvider);
    final otpVal = useState("");

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        log("$didPop");
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
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              child: Ink(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: VColor.secondaryBackground,
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(4)),
                child: Form(
                  child: Column(
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
                              text: user.value?.email ?? "",
                              style: (Theme.of(context).textTheme.bodyMedium ??
                                      const TextStyle())
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Pinput(
                        defaultPinTheme: defaultPinTheme,
                        length: 6,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        onChanged: (value) {
                          otpVal.value = value;
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
                          if (otpVal.value.length == 6) {
                            ref
                                .read(verifyOtpProvider.notifier)
                                .postOTP(otp: otpVal.value);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Kode OTP harus 5 digit"),
                              ),
                            );
                          }
                        },
                      ),
                      const Gap(8),
                      const Text(
                        "Silahkan cek folder spam apabila tidak menemukan email otp",
                        style: TextStyle(fontSize: 10),
                      )
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
        ),
      ),
    );
  }
}
