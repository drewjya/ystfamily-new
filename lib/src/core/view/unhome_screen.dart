// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/home/home.dart';

class UnhomeScreen extends HookConsumerWidget {
  const UnhomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: VColor.appbarBackground,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: VColor.appbarBackground,
          foregroundColor: VColor.darkBrown,
          centerTitle: true,
          title: Image.asset("assets/logo.png", width: 60),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              const Expanded(
                  child: Column(
                children: [
                  CarouselHome(),
                  CabangSection(),
                  TreatmentSection(),
                ],
              )),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(bottom: 32),
                child: Row(
                  children: [
                    const Gap(12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VColor.appbarBackground,
                        ),
                        onPressed: () {
                          const RegisterRoute().push(context);
                        },
                        child: const Center(child: Text("Sign Up")),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: VColor.darkBrown,
                            foregroundColor: VColor.backgroundColor),
                        onPressed: () {
                          const LoginRoute().push(context);
                        },
                        child: const Center(child: Text("Log In")),
                      ),
                    ),
                    const Gap(12),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
