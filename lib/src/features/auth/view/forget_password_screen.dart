import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/forget_password.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  const ForgetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final dialogShown = useState(false);
    ref.listen(forgetPasswordProvider, (previous, next) {
      next.when(
        data: (data) {
          final sc = ScaffoldMessenger.of(context);
          final nv = Navigator.of(context);
          sc.removeCurrentSnackBar();

          if (dialogShown.value) {
            dialogShown.value = false;
            nv.pop();
          }
          OtpForgetPasswordRoute(emailController.text).push(context);
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
        title: const Text("Lupa Password"),
        backgroundColor: VColor.primaryBackground,
        foregroundColor: VColor.primaryTextColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: inputStyle.copyWith(labelText: "Email", hintText: "contoh@contoh.com"),
              ),
              const Gap(24),
              VCard.horizontal(
                child: const Center(
                  child: Text(
                    "Kirim",
                  ),
                ),
                onTap: () {
                  ref.read(forgetPasswordProvider.notifier).requestForgetPassword(email: emailController.text);
                  // const OTPRoute().push(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
