import 'package:ystfamily/src/core/core.dart';

void authDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return const _AuthDialog();
    },
  );
}

class _AuthDialog extends StatelessWidget {
  const _AuthDialog();

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontSize: 24,
      color: VColor.darkBrown,
      fontWeight: FontWeight.w500,
    );
    const valueStyle = TextStyle(
      fontSize: 14,
      color: VColor.darkBrown,
      fontWeight: FontWeight.w400,
    );
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            20,
          ),
        ),
      ),
      padding: const EdgeInsets.all(18).copyWith(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Silahkan Login terlebih dahulu",
            style: titleStyle,
          ),
          const Gap(8),
          const Text(
            "Untuk bisa mengakses semua fitur yang kami sediakan silahkan login terlebih dahulu",
            style: valueStyle,
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VColor.appbarBackground,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    const RegisterRoute().push(context);
                  },
                  child: const Text("Sign Up"),
                ),
              ),
              const Gap(14),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: VColor.darkBrown,
                      foregroundColor: VColor.backgroundColor),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    const LoginRoute().push(context);
                  },
                  child: const Text("Log In"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
