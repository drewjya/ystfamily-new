import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/provider/change_provider.dart';

class ChangePasswordScreen extends HookConsumerWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final oldPassword = useTextEditingController();
    final newPassword = useTextEditingController();
    final confirmNewPassword = useTextEditingController();
    final isSecureOld = useState(true);
    final isSecureNew = useState(true);
    final isSecureConfirm = useState(true);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final dialogShown = useState(false);
    ref.listen(changePasswordProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data.isNotEmpty) {
            ref.invalidate(authProvider);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (dialogShown.value) {
              dialogShown.value = false;
              Navigator.pop(context);
            }
            Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganti Password"),
        backgroundColor: VColor.primaryBackground,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  controller: oldPassword,
                  obscureText: isSecureOld.value,
                  decoration: inputStyle.copyWith(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isSecureOld.value = !isSecureOld.value;
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isSecureOld.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  validator: (value) {
                    return value == null || value.isEmpty ? "Password tidak boleh kosong" : null;
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: newPassword,
                  obscureText: isSecureNew.value,
                  decoration: inputStyle.copyWith(
                    labelText: "Password Baru",
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isSecureNew.value = !isSecureNew.value;
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isSecureNew.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password Baru tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: confirmNewPassword,
                  obscureText: isSecureConfirm.value,
                  decoration: inputStyle.copyWith(
                    labelText: "Konfirmasi Password Baru",
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        isSecureConfirm.value = !isSecureConfirm.value;
                      },
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: isSecureConfirm.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Kata kunci tidak boleh kosong";
                    if (value != newPassword.text) {
                      return "Kata kunci tidak sama";
                    }
                    return null;
                  },
                ),
                const Gap(24),
                VCard.horizontal(
                  onTap: () {
                    //     ref.watch(authProvider.select((value) => value.isLoading))
                    // ? null
                    // :
                    if (formKey.currentState?.validate() ?? false) {
                      ref.read(changePasswordProvider.notifier).changePassword(oldPassword: oldPassword.text, newPassword: newPassword.text);
                    }
                    // const OTPRoute(email: "a@gmail.com").push(context);
                  },
                  child: const Center(
                    child: Text(
                      "Buat",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
