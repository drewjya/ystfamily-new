import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/cabang.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/profile/view/edit_profile_screen.dart';

class CabangCard extends ConsumerWidget {
  final bool start;
  final Cabang cabang;
  final bool isSelected;
  final void Function(Cabang cabang)? onTap;
  const CabangCard({
    Key? key,
    this.onTap,
    required this.start,
    required this.cabang,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: start ? 12 : 0,
      ),
      child: VCard.horizontal(
        onTap: onTap != null
            ? () {
                ref
                    .read(selectedCabangProvider.notifier)
                    .update((state) => state = cabang);
                onTap?.call(cabang);
              }
            : null,
        backgroundColor: isSelected
            ? VColor.chipBackground
            : VColor.appbarBackground.withOpacity(0.7),
        child: Row(
          children: [
            VCircleImage(
              url: cabang.profilePicture,
              radius: 35,
            ),
            const Gap(8),
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(
                  color: VColor.darkBrown,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cabang.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      cabang.alamat,
                      maxLines: 2,
                    ),
                    const Gap(3),
                    Text(
                      cabang.phoneNumber,
                      maxLines: 2,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
