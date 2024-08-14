import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/cabang.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/profile/view/edit_profile_screen.dart';

class CustomizeCabang extends ConsumerWidget {
  final bool start;
  final Cabang cabang;
  final bool isSelected;
  final void Function(Cabang cabang)? onTap;
  const CustomizeCabang({
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
        border: Border.all(
          color: VColor.chipBackground,
          strokeAlign: BorderSide.strokeAlignInside,
          width: 1,
        ),
        backgroundColor: Colors.white,
        child: Row(
          children: [
            VCircleImage(
              url: cabang.picture == null ? null : '$image${cabang.picture}',
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
