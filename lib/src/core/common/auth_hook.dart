import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';

void useAuthHook({
  required WidgetRef ref,
  required BuildContext context,
}) {
  final isLoading = useState(false);
  useEffect(() {
    Future.microtask(() => ref.invalidate(authProvider));
    return null;
  }, []);
  ref.listen(authProvider, (previous, next) async {
    next.when(
      data: (data) {
        if (isLoading.value) {
          isLoading.value = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      error: (e, stackTrace) {
        final error = errorRoot(e);
        if (error.toLowerCase() == "unauthorized" ||
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

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      },
      loading: () {
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
      },
    );
  });
}

void useAuthHookV({
  required WidgetRef ref,
  required BuildContext context,
}) {
  final isLoading = useState(false);
  useEffect(() {
    Future.microtask(() => ref.invalidate(authProvider));
    return null;
  }, []);
  ref.listen(authProvider, (previous, next) async {
    next.when(
      data: (data) {
        if (isLoading.value) {
          isLoading.value = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      error: (e, stackTrace) {
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
      },
    );
  });
}
