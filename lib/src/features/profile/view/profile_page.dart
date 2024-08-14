import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/provider/delete_account.dart';
import 'package:ystfamily/src/features/auth/view/otp_screen.dart';
import 'package:ystfamily/src/features/profile/view/edit_profile_screen.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    useAuthHook(ref: ref, context: context);
    final isLoading = useState(false);
    ref.listen(deleteAccountProvider, (previous, next) {
      next.when(data: (data) {
        if (isLoading.value) {
          isLoading.value = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
        if (data) {
          ref.read(authProvider.notifier).logout();
        }
      }, error: (e, stackTrace) {
        if (isLoading.value) {
          isLoading.value = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
        final error = errorRoot(e);
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }, loading: () {
        isLoading.value = true;
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
      });
    });
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(authProvider);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                            url: user.value?.picture == null
                                ? null
                                : "$image${user.value?.picture}",
                          ),
                          const Gap(12),
                          Text(
                            (user.value?.name ?? "-").toUpperCase(),
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
                backgroundColor: Colors.red.shade900,
                onTap: () async {
                  final a = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      title: const Text("Hapus Akun?"),
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
                  await Future.delayed(const Duration(milliseconds: 300));
                  if (a) {
                    ref
                        .read(deleteAccountProvider.notifier)
                        .requestDeleteAccount();
                  }
                },
                child: const Center(
                  child: Text(
                    "Hapus Akun",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const Gap(10),
              VCard.horizontal(
                backgroundColor: VColor.darkBrown,
                onTap: () async {
                  final a = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      title: const Text("Log Out?"),
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
                    "Log Out",
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
      ),
    );
  }
}
