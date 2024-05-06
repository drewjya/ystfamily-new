// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/history/provider/history_provider.dart';
import 'package:ystfamily/src/features/history/repository/history_repository.dart';
import 'package:ystfamily/src/features/history/widgets/history_card.dart';

final formatCurrency =
    NumberFormat.simpleCurrency(locale: "id_ID", decimalDigits: 0);

class HistoryPage extends HookConsumerWidget {
  const HistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                    itemBuilder: (context, index) {
                      final e = OrderStatus.values[index];
                      return ChoiceChip(
                        label: Text(e.value.toTitle),
                        selected: ref.watch(orderStatusProvider) == e,
                        onSelected: ref.watch(historyProvider
                                .select((value) => value.isLoading))
                            ? null
                            : (value) {
                                ref.read(orderStatusProvider.notifier).update(
                                      (state) => e,
                                    );
                              },
                      );
                    },
                    itemCount: OrderStatus.values.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              Expanded(
                child: ref.watch(historyProvider).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text("Belum Ada Riwayat"),
                      );
                    }
                    return ListView.separated(
                      itemCount: data.length + 1,
                      padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16)
                          .copyWith(top: 4),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          return const SizedBox(
                            height: 48,
                            width: 8,
                          );
                        }
                        return HistoryCard(
                          history: data[index],
                          onTap: () {
                            DetailHistoryRoute(id: data[index].id)
                                .push(context);
                          },
                        );
                      },
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(child: Text("$error"));
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          )),
    );
  }
}

class MonthYearPicker extends StatefulWidget {
  const MonthYearPicker({Key? key}) : super(key: key);

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late int monthSelected;
  late int yearSelected;

  @override
  void initState() {
    monthSelected = DateTime.now().month;
    yearSelected = DateTime.now().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2025),
      onDateChanged: (value) {},
    );
  }
}
