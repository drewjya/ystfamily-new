import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/model/dto/register_dto.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';

enum Gender {
  laki("Laki-laki", 'male'),
  perempuan("Perempuan", 'female');

  final String value;
  final String nama;
  const Gender(this.value, this.nama);
}

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final phoneNumber = useTextEditingController();
    final namaController = useTextEditingController();
    final selectedValue = useState<Gender?>(null);
    final dialogShown = useState(false);
    final isSecure = useState(true);
    final isCopySecure = useState(true);

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

          if (dialogShown.value) {
            dialogShown.value = false;
            nv.pop();
          }
          if (value.verified) {
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

    final formKey = useMemoized(
      () => GlobalKey<FormState>(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar"),
        backgroundColor: VColor.appbarBackground,
        foregroundColor: VColor.darkBrown,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return value != null && value.isNotEmpty ? null : "Email tidak valid";
                    },
                    decoration: inputStyle.copyWith(
                      labelText: "Email",
                      hintText: "contoh@contoh.com",
                    ),
                  ),
                  const Gap(12),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "No. Telp tidak valid";
                      }
                      if (value.length < 10) {
                        return "No. Telp tidak valid";
                      }
                      final regex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,9}$');
                      if (!regex.hasMatch(value)) {
                        return "No. Telp tidak valid";
                      }
                      return null;
                    },
                    controller: phoneNumber,
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    decoration: inputStyle.copyWith(
                      labelText: "No. Telp",
                    ),
                  ),
                  const Gap(12),
                  TextFormField(
                    controller: namaController,
                    decoration: inputStyle.copyWith(
                      labelText: "Nama Lengkap",
                    ),
                    validator: (value) {
                      return value != null && value.isNotEmpty ? null : "Nama tidak boleh kosong";
                    },
                  ),
                  const Gap(12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Jenis Kelamin"),
                      const Gap(8),
                      ChoiceChip.elevated(
                        label: Text(Gender.laki.value),
                        selected: selectedValue.value == Gender.laki,
                        onSelected: (value) {
                          selectedValue.value = Gender.laki;
                        },
                      ),
                      const Gap(8),
                      ChoiceChip.elevated(
                        label: Text(Gender.perempuan.value),
                        selected: selectedValue.value == Gender.perempuan,
                        onSelected: (value) {
                          selectedValue.value = Gender.perempuan;
                        },
                      ),
                    ],
                  ),
                  const Gap(12),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputStyle.copyWith(
                      labelText: "Kata Kunci",
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
                          )),
                    ),
                    obscureText: isSecure.value,
                    validator: (value) {
                      return value != null && value.isNotEmpty ? null : "Kata kunci tidak boleh kosong";
                    },
                  ),
                  const Gap(12),
                  TextFormField(
                    controller: confirmPassword,
                    obscureText: isCopySecure.value,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputStyle.copyWith(
                      labelText: "Konfirmasi Kata Kunci",
                      suffixIcon: IconButton(
                          onPressed: () {
                            isCopySecure.value = !isCopySecure.value;
                          },
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: isCopySecure.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                          )),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Kata kunci tidak boleh kosong";
                      if (value != passwordController.text) {
                        return "Kata kunci tidak sama";
                      }
                      return null;
                    },
                  ),
                  const Gap(24),
                  VCard.horizontal(
                    onTap: ref.watch(authProvider.select((value) => value.isLoading))
                        ? null
                        : () {
                            if (selectedValue.value == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Silahkan pilih jenis kelamin"),
                                ),
                              );
                              return;
                            }
                            if (formKey.currentState?.validate() ?? false) {
                              ref.read(authProvider.notifier).register(
                                    registerDTO: RegisterDTO(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: namaController.text,
                                      phoneNumber: phoneNumber.value.text.isEmpty ? null : phoneNumber.value.text,
                                      gender: selectedValue.value!.value,
                                    ),
                                  );
                            }
                            // const OTPRoute(email: "a@gmail.com").push(context);
                          },
                    child: const Center(
                      child: Text(
                        "Buat",
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final contains = context.router.contains(LoginRoute.routeName);
                      if (contains) {
                        const LoginRoute().go(context);
                      } else {
                        const LoginRoute().push(context);
                      }
                    },
                    child: const Text.rich(
                      TextSpan(
                        // text: "Belum Punya Akun? ",

                        children: [
                          TextSpan(
                            text: "Sudah punya akun? ",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          TextSpan(
                            text: "Masuk",
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
            ),
          ),
        ),
      ),
    );
  }
}
