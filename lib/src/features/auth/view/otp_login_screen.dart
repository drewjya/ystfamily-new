import 'package:ystfamily/src/core/core.dart';

import 'otp_screen.dart';

class OTPLoginScreen extends HookConsumerWidget {
  const OTPLoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Masuk",
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                    ),
                  ),
                  const Gap(24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OTPScreen(),
                          ));
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
                        onPressed: () {},
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
                    onPressed: () {},
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
