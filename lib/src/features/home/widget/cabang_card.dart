import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/cabang.dart';
import 'package:ystfamily/src/features/profile/view/edit_profile_screen.dart';

class CabangCard extends StatelessWidget {
  final bool start;
  final Cabang cabang;
  final VoidCallback? onTap;
  const CabangCard({
    Key? key,
    this.onTap,
    required this.start,
    required this.cabang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: start ? 12 : 0,
      ),
      child: VCard.horizontal(
        onTap: onTap,
        backgroundColor: VColor.appbarBackground.withOpacity(0.7),
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
                    ),
                    Text(
                      cabang.alamat,
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.male),
                        Text(
                          "${cabang.totalMaleTherapist}",
                        ),
                        const Icon(Icons.female),
                        Text(
                          "${cabang.totalFemaleTherapist}",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${cabang.totalTreatment}",
                        ),
                        const Icon(
                          VIcons.therapy,
                          size: 16,
                        ),
                      ],
                    ),
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
