import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/view/otp_screen.dart';
import 'package:ystfamily/src/features/profile/view/edit_profile_screen.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) async {
      switch (next) {
        case AsyncLoading():
          return;

        case AsyncError(:final error):
          String message = "Silahkan coba lagi";
          if (error is ApiException) {
            message = (error).message;
          }
          if (message.toLowerCase() == "unauthorized" || message.toLowerCase() == "relogin") {
            void logout() {
              const LoginRoute().go(context);
            }

            logout();

            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          return;
      }
    });

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            VCard.horizontal(
              backgroundColor: VColor.appbarBackground.withOpacity(0.7),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        VCircleImage(
                          url: user.value?.profilePicture,
                        ),
                        const Gap(12),
                        Text(
                          (user.value?.nama ?? "-").toUpperCase(),
                          style: const TextStyle(
                            color: VColor.primaryTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          (user.value?.email ?? "-").toLowerCase(),
                          style: const TextStyle(
                            color: VColor.primaryTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          (user.value?.gender ?? "-"),
                          style: const TextStyle(
                            color: VColor.primaryTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          (user.value?.phoneNumber ?? "-").toUpperCase(),
                          style: const TextStyle(
                            color: VColor.primaryTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1,
                            color: VColor.primaryTextColor.withOpacity(0.5),
                            style: BorderStyle.solid,
                          ),
                        ),
                        onPressed: () {
                          const EditProfileRoute().push(context);
                        },
                        child: const Text("Edit")),
                  )
                ],
              ),
            ),
            const Gap(16),
            VCard.horizontal(
              backgroundColor: VColor.appbarBackground.withOpacity(0.7),
              onTap: () {
                const ChangePasswordRoute().push(context);
              },
              child: const Center(
                child: Text(
                  "Ganti Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(16),
            VCard.horizontal(
              backgroundColor: VColor.darkBrown,
              onTap: () async {
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
                  ref.read(authProvider.notifier).logout();
                }
              },
              child: const Center(
                child: Text(
                  "Keluar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
