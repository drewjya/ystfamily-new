import 'package:collection/collection.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/history/view/history_page.dart';
import 'package:ystfamily/src/features/order/order.dart';

class PreviewOrderWidget extends ConsumerWidget {
  final OrderPreviewModel preview;
  final Therapist? therapist;
  final OrderDto dto;

  const PreviewOrderWidget({
    super.key,
    this.therapist,
    required this.dto,
    required this.preview,
  });

  @override
  Widget build(BuildContext context, ref) {
    const style = TextStyle(
        fontWeight: FontWeight.w600, fontSize: 14.5, color: Colors.black);
    const titleStyle = TextStyle(
      fontSize: 19,
      color: VColor.darkBrown,
      fontWeight: FontWeight.w500,
    );
    const valueStyle = TextStyle(
      fontSize: 18,
      color: VColor.darkBrown,
      fontWeight: FontWeight.w400,
    );
    return Container(
      decoration: BoxDecoration(
        color: VColor.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: DefaultTextStyle(
        style: style,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "PREVIEW",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: VColor.primaryTextColor,
                ),
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VColor.chipBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "Mohon periksa kembali detail reservasi anda!!",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: VColor.primaryTextColor,
                ),
              ),
            ),
            const Gap(12),
            RowItem(
              title: "Cabang",
              titleStyle: titleStyle,
              value: ref.read(selectedCabangProvider)?.nama,
              valueStyle: valueStyle,
            ),
            const Gap(13),
            RowItem(
              title: "Tanggal Treatment",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
              value: preview.orderTime.date,
            ),
            const Gap(13),
            RowItem(
              title: "Jam Treatment",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
              value: preview.orderTime.getHour,
            ),
            const Gap(13),
            RowItem(
              title: "Durasi Treatment",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
              value: "${preview.durasi} Menit",
            ),
            const Gap(13),
            RowItem(
              title: "Therapist",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
              value:
                  "${therapist != null ? therapist!.nama : ""} (${preview.therapistGender.gender})",
            ),
            const Gap(13),
            RowItem(
              title: "Tamu",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
              value: preview.guestGender.gender,
            ),
            const Gap(13),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: preview.orderDetails
                      .mapIndexed((index, item) {
                        return [
                          RowItem(
                            title: item.nama,
                            value: formatCurrency.format(item.price),
                            titleStyle: titleStyle.copyWith(fontSize: 17),
                            valueStyle: valueStyle.copyWith(fontSize: 16),
                          ),
                          if (index != preview.orderDetails.length - 1)
                            const Gap(13),
                        ];
                      })
                      .flattened
                      .toList(),
                ),
              ),
            ),
            const Gap(13),
            RowItem(
              title: "Harga Total",
              titleStyle: titleStyle,
              valueStyle: valueStyle,
              value: formatCurrency.format(preview.totalPrice),
            ),
            const Gap(12),
            VCard.horizontal(
              onTap: () {
                Navigator.pop(context);
                ref.read(orderProvider.notifier).postOrder(body: dto);
              },
              backgroundColor: VColor.chipBackground,
              child: const Center(
                  child: Text(
                "Submit",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
