import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/history/model/history_order.dart';
import 'package:ystfamily/src/features/history/view/history_page.dart';

class HistoryCard extends StatelessWidget {
  final HistoryOrder history;
  final VoidCallback? onTap;
  const HistoryCard({
    Key? key,
    required this.history,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VCard.horizontal(
      onTap: onTap,
      backgroundColor: VColor.appbarBackground.withOpacity(.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  history.orderId,
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: VColor.primaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  history.orderStatus,
                  style: const TextStyle(
                    color: VColor.secondaryBackground,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(
            4,
          ),
          Row(
            children: [
              Text(
                history.cabang,
                style: const TextStyle(
                  color: VColor.primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text("Total : ${formatCurrency.format(history.totalPrice)}"),
            ],
          ),
          const SizedBox(
            height: 12,
            child: Center(child: Divider()),
          ),
          Row(
            children: [
              Text(
                "Booking: ${history.orderTime.toDate?.formatTimePesanan() ?? "-"}",
                style: const TextStyle(
                  color: VColor.primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const Spacer(),
              Text(
                history.createdAt.toDate?.getDate() ?? '-',
                style: const TextStyle(
                  color: VColor.primaryTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const Gap(4),
          Row(
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: Text(
                      history.orderName,
                      style: const TextStyle(
                        color: VColor.primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (history.countOrder > 1) ...[
                    const Gap(1),
                    Text(
                      (history.countOrder > 1
                          ? " +${history.countOrder - 1}"
                          : ""),
                      style: const TextStyle(
                        color: VColor.primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ]
                ],
              ),
              const Spacer(),
              const Text(
                "Detail",
                style: TextStyle(
                  color: VColor.primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
