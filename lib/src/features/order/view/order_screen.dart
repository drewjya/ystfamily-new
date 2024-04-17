// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/history/provider/history_provider.dart';
import 'package:ystfamily/src/features/history/view/history_page.dart';
import 'package:ystfamily/src/features/home/home.dart';
import 'package:ystfamily/src/features/order/model/order_dto.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';
import 'package:ystfamily/src/features/order/provider/order_provider.dart';
import 'package:ystfamily/src/features/order/provider/therapist_provider.dart';

class OrderScreen extends HookConsumerWidget {
  final String? tipe;
  final String? branchName;
  const OrderScreen({super.key, this.tipe, this.branchName});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cabang = useState<Cabang?>(null);
    final currentTreatment = useState<String?>(null);
    final selectedTreatment = useState<Map<int, Treatment>>({});
    final selectedAdditional = useState<Map<int, AdditionalTreatment>>({});

    final selectedTherapistGender = useState<Gender?>(null);
    final listController = useState(<ExpansionTileController>[]);
    final selectedTherapist = useState<Therapist?>(null);
    final jamController = useTextEditingController();
    final jamTerapi = useState<String?>(null);
    final selectedDate = useState<DateTime?>(null);
    final isVisible = cabang.value != null &&
        selectedDate.value != null &&
        selectedTherapistGender.value != null;

    useEffect(
      () {
        listController.value =
            List.generate(4, (index) => ExpansionTileController());
        return null;
      },
      [],
    );
    useEffect(() {
      final daa = ref.read(cabangProvider(null)).valueOrNull ?? [];
      cabang.value =
          daa.firstWhereOrNull((element) => element.nama == branchName);
      currentTreatment.value = tipe;
      return null;
    }, []);

    useEffect(() {
      selectedTreatment.value = {};
      jamTerapi.value = null;
      selectedTherapist.value = null;
      return;
    }, [ref.watch(therapistProvider)]);

    useEffect(() {
      selectedTreatment.value = {};
      jamTerapi.value = null;

      return;
    }, [selectedTherapist.value]);
    final isLoading = useState(false);
    ref.listen(orderProvider, (previous, next) {
      next.when(
        data: (data) {
          if (isLoading.value) {
            isLoading.value = false;
            ref.read(filterProvider.notifier).changeFilter(
                filter: FilterHistory.pending, limit: 10, offset: 0);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Order Berhasil")));
            const HistoryPageRoute().go(context);
          }
        },
        error: (error, stackTrace) {
          if (isLoading.value) {
            isLoading.value = false;
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        },
        loading: () {
          isLoading.value = true;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    });

    return DefaultTextStyle(
      style: const TextStyle(
        color: VColor.darkBrown,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order"),
          backgroundColor: VColor.appbarBackground,
          foregroundColor: VColor.darkBrown,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: BodyFormWidget(
          children: [
            const Text("Pilih Cabang"),
            SizedBox(
              height: 100,
              child: Consumer(
                builder: (context, ref, child) {
                  final cabangs = ref.watch(cabangProvider(null));
                  return cabangs.when(
                    data: (data) => CabangSelectorWidget(
                      cabangs: data,
                      onTap: (curr) {
                        cabang.value = curr;
                        if (cabang.value != null &&
                            selectedTherapistGender.value != null &&
                            selectedDate.value != null) {
                          final params = TherapistType(
                              cabangId: cabang.value!.cabangId,
                              tanggal: selectedDate.value!.yearMonthDate(),
                              gender: selectedTherapistGender.value!.nama);
                          ref
                              .read(therapistProvider.notifier)
                              .load(arg: params);
                        }
                      },
                      onSelected: (curr) => cabang.value == curr,
                    ),
                    error: (error, stackTrace) {
                      return Text("$error");
                    },
                    loading: () {
                      return const LoadingWidget();
                    },
                  );
                },
              ),
            ),
            const Text("Jenis Kelamin Therapist"),
            const Gap(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: Gender.values.mapIndexed((index, element) {
                return Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 8.0 : 0),
                  child: ChoiceChip.elevated(
                    label: Text(element.value),
                    selectedColor: VColor.appbarBackground.withOpacity(.7),
                    selected: selectedTherapistGender.value == element,
                    backgroundColor: VColor.primaryBackground.withOpacity(0.5),
                    onSelected: (value) {
                      selectedTherapistGender.value = element;
                      if (cabang.value != null &&
                          selectedTherapistGender.value != null &&
                          selectedDate.value != null) {
                        final params = TherapistType(
                            cabangId: cabang.value!.cabangId,
                            tanggal: selectedDate.value!.yearMonthDate(),
                            gender: selectedTherapistGender.value!.nama);
                        ref.read(therapistProvider.notifier).load(arg: params);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            const Gap(12),
            VCard.horizontal(
              backgroundColor: VColor.appbarBackground.withOpacity(.7),
              onTap: () async {
                final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)));
                if (date != null) {
                  selectedDate.value = date;
                }
                if (cabang.value != null &&
                    selectedTherapistGender.value != null &&
                    selectedDate.value != null) {
                  final params = TherapistType(
                      cabangId: cabang.value!.cabangId,
                      tanggal: selectedDate.value!.yearMonthDate(),
                      gender: selectedTherapistGender.value!.nama);
                  ref.read(therapistProvider.notifier).load(arg: params);
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(selectedDate.value?.getDate() ?? "Pilih Tanggal"),
                  const Spacer(),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
            const Gap(12),
            if (isVisible)
              Consumer(
                builder: (context, ref, child) {
                  final therapistProvie = ref.watch(therapistProvider);
                  return therapistProvie.when(
                    data: (data) => Column(
                      children: data.toList().mapIndexed((index, e) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (selectedTherapist.value == null) {
                                    selectedTherapist.value = e;
                                    return;
                                  }
                                  if (selectedTherapist.value?.kode == e.kode) {
                                    selectedTherapist.value = null;
                                    return;
                                  }

                                  selectedTherapist.value = e;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  color:
                                      VColor.appbarBackground.withOpacity(0.7),
                                  child: Row(
                                    children: [
                                      Text(
                                        e.kode,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: VColor.darkBrown,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      AnimatedRotation(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        turns: selectedTherapist.value?.kode ==
                                                e.kode
                                            ? .50
                                            : 0,
                                        child: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  child: Container(
                                    padding:
                                        selectedTherapist.value?.kode == e.kode
                                            ? const EdgeInsets.all(12)
                                            : null,
                                    decoration: BoxDecoration(
                                      color: VColor.appbarBackground
                                          .withOpacity(0.7),
                                    ),
                                    width: double.infinity,
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: selectedTherapist.value?.kode ==
                                              e.kode
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TherapistTimeSlotWidget(
                                                  therapist: e,
                                                  onSelected: (time) {
                                                    jamTerapi.value = time;
                                                  },
                                                  controller: jamController,
                                                ),
                                                const Gap(4),
                                                const Text(
                                                  "Treatment",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                                MultiSelectDropDown(
                                                  onOptionSelected: (options) {
                                                    selectedTreatment.value =
                                                        {};
                                                    selectedTreatment.value = {
                                                      for (var e in options)
                                                        (e.value as Treatment)
                                                                .treatmentId:
                                                            e.value as Treatment
                                                    };
                                                  },
                                                  maxItems: 2,
                                                  options: e.treatmentData
                                                      .map((e) => ValueItem(
                                                          label: e.nama,
                                                          value: e))
                                                      .toList(),
                                                  selectionType:
                                                      SelectionType.multi,
                                                  chipConfig: const ChipConfig(
                                                      wrapType:
                                                          WrapType.scroll),
                                                  inputDecoration:
                                                      BoxDecoration(
                                                    color:
                                                        VColor.cardBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  dropdownHeight: 200,
                                                  dropdownBackgroundColor:
                                                      VColor.cardBackground,
                                                  optionsBackgroundColor:
                                                      VColor.cardBackground,
                                                  hint: "Pilih Treatment",
                                                  optionTextStyle:
                                                      const TextStyle(
                                                          fontSize: 16),
                                                  hintStyle: const TextStyle(
                                                      fontSize: 16),
                                                  selectedOptionIcon:
                                                      const Icon(
                                                          Icons.check_circle),
                                                ),
                                                const Text(
                                                  "Additional Treatment",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                                MultiSelectDropDown(
                                                  onOptionSelected: (options) {
                                                    selectedAdditional.value =
                                                        {};
                                                    selectedAdditional.value = {
                                                      for (var e in options)
                                                        (e.value
                                                                as AdditionalTreatment)
                                                            .additionalTreatmentId: e
                                                                .value
                                                            as AdditionalTreatment
                                                    };
                                                  },
                                                  maxItems: 2,
                                                  options: e
                                                      .additionalTreatmentData
                                                      .map((e) => ValueItem(
                                                          label: e.nama,
                                                          value: e))
                                                      .toList(),
                                                  selectionType:
                                                      SelectionType.multi,
                                                  chipConfig: const ChipConfig(
                                                      wrapType:
                                                          WrapType.scroll),
                                                  inputDecoration:
                                                      BoxDecoration(
                                                    color:
                                                        VColor.cardBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  dropdownHeight: 200,
                                                  dropdownBackgroundColor:
                                                      VColor.cardBackground,
                                                  optionsBackgroundColor:
                                                      VColor.cardBackground,
                                                  hint:
                                                      "Pilih Additional Treatment",
                                                  optionTextStyle:
                                                      const TextStyle(
                                                          fontSize: 16),
                                                  hintStyle: const TextStyle(
                                                      fontSize: 16),
                                                  selectedOptionIcon:
                                                      const Icon(
                                                          Icons.check_circle),
                                                ),
                                                const Gap(8),
                                                Builder(
                                                  builder: (context) {
                                                    if (jamTerapi.value ==
                                                        null) {
                                                      return const SizedBox();
                                                    }
                                                    final price = totalPrice(
                                                        treatment:
                                                            selectedTreatment,
                                                        additional:
                                                            selectedAdditional,
                                                        therapist: e,
                                                        date: selectedDate,
                                                        hour: jamTerapi);
                                                    final duration = totalDuration(
                                                        treatment:
                                                            selectedTreatment,
                                                        additional:
                                                            selectedAdditional);
                                                    final estimate =
                                                        addIntervalToTime(
                                                            jamTerapi.value ??
                                                                '00:00:00',
                                                            duration);
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(price),
                                                        Text(
                                                            "Duration : $duration Menit"),
                                                        if (jamTerapi.value !=
                                                            null)
                                                          Text(
                                                              "Estimate Done : $estimate"),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    error: (error, stackTrace) => Text("$error"),
                    loading: () => const LoadingWidget(),
                  );
                },
              ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
        floatingActionButton: selectedTreatment.value.isNotEmpty &&
                jamTerapi.value != null
            ? FloatingActionButton(
                onPressed: () async {
                  final submit = await showDialog(
                    context: context,
                    builder: (context) {
                      return SubmitOrderDialog(
                        selectedAdditional: selectedAdditional.value,
                        cabang: cabang.value!,
                        selectedTherapist: selectedTherapist.value!,
                        jamTerapi: jamTerapi.value!,
                        selectedDate: selectedDate.value!,
                        selectedTreatment: selectedTreatment.value,
                      );
                    },
                  );
                  if (submit) {
                    final trD = selectedTreatment.value.values
                        .mapIndexed((index, e) => OrderDetailDTO.treatment(
                            treatmentId: e.treatmentId,
                            happyHour: happyHour(
                                    date: selectedDate.value!,
                                    therapist: selectedTherapist.value!,
                                    selectedHour: jamTerapi.value!,
                                    previousTreatment: index == 0
                                        ? null
                                        : selectedTreatment.value.values
                                            .elementAt(index - 1)) &&
                                e.happyHourPrice != null))
                        .toList();
                    final adD = selectedAdditional.value.values
                        .map((e) => OrderDetailDTO.additional(
                            additionalTreatmentId: e.additionalTreatmentId))
                        .toList();
                    final selectedDTO = OrderDto(
                      genderTherapist:
                          selectedTherapistGender.value!.nama == "male",
                      cabangId: cabang.value!.cabangId,
                      therapistId: selectedTherapist.value!.therapistId ?? -1,
                      orderStartTime: jamTerapi.value!,
                      orderDate: selectedDate.value!.toUtc(),
                      treatments: [...trD, ...adD],
                    );

                    ref
                        .read(orderProvider.notifier)
                        .postOrder(body: selectedDTO);
                  }
                },
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }
}

class SubmitOrderDialog extends HookConsumerWidget {
  const SubmitOrderDialog(
      {super.key,
      required this.cabang,
      required this.selectedTherapist,
      required this.jamTerapi,
      required this.selectedDate,
      required this.selectedTreatment,
      required this.selectedAdditional});

  final Cabang cabang;
  final Therapist selectedTherapist;
  final String jamTerapi;
  final DateTime selectedDate;
  final Map<int, Treatment> selectedTreatment;
  final Map<int, AdditionalTreatment> selectedAdditional;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const style = TextStyle(
        fontWeight: FontWeight.w600, fontSize: 14.5, color: Colors.black);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Summary Order",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: style,
                      child: Row(
                        children: [
                          const Text("Cabang"),
                          Expanded(
                            child: Text(
                              cabang.nama,
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    DefaultTextStyle(
                      style: style,
                      child: Row(
                        children: [
                          const Text("Tanggal Order"),
                          Expanded(
                            child: Text(
                              selectedDate.getDate(),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    DefaultTextStyle(
                      style: style,
                      child: Row(
                        children: [
                          const Text("Waktu Order"),
                          Expanded(
                            child: Text(
                              jamTerapi,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    DefaultTextStyle(
                      style: style,
                      child: Row(
                        children: [
                          const Text("Estimasi Selesai"),
                          Expanded(
                            child: Text(
                              addIntervalToTime(
                                  jamTerapi,
                                  selectedTreatment.values
                                          .map((e) => e.duration)
                                          .sum +
                                      selectedAdditional.values
                                          .map((e) => (e.duration))
                                          .sum),
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(5),
                    DefaultTextStyle(
                      style: style,
                      child: Row(
                        children: [
                          const Text("Therapist"),
                          Expanded(
                            child: Text(
                              selectedTherapist.kode,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(4),
                    const Divider(),
                    const Gap(4),
                    ...selectedTreatment.values.mapIndexed(
                      (i, e) => Row(
                        children: [
                          Expanded(child: Text(e.nama)),
                          Text(happyHour(
                                  therapist: selectedTherapist,
                                  date: selectedDate,
                                  selectedHour: jamTerapi,
                                  previousTreatment: i > 0
                                      ? selectedTreatment.values
                                          .elementAt(i - 1)
                                      : null)
                              ? formatCurrency
                                  .format(e.happyHourPrice ?? e.price)
                              : formatCurrency.format(e.price)),
                        ],
                      ),
                    ),
                    ...selectedAdditional.values.map(
                      (e) => Row(
                        children: [
                          Expanded(child: Text(e.nama)),
                          Text(formatCurrency.format(e.price)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          "Harga Total",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          totalPrice(
                              treatment: useState(selectedTreatment),
                              additional: useState(selectedAdditional),
                              therapist: selectedTherapist,
                              date: useState(selectedDate),
                              hour: useState(jamTerapi)),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: VCard.horizontal(
                    height: 40,
                    backgroundColor: VColor.darkBrown,
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: VCard.horizontal(
                    backgroundColor: Colors.red.shade800,
                    height: 40,
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TherapistTimeSlotWidget extends StatelessWidget {
  const TherapistTimeSlotWidget({
    Key? key,
    required this.therapist,
    this.controller,
    required this.onSelected,
  }) : super(key: key);

  final Therapist therapist;
  final TextEditingController? controller;
  final void Function(String time) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDropDown(
          onOptionSelected: (options) {
            if (options.isNotEmpty) {
              onSelected(options.last.value as String);
            }
          },
          options: therapist.availableTimeSlots.reversed
              .map((e) => ValueItem(label: e, value: e))
              .toList(),
          selectionType: SelectionType.single,
          maxItems: 5,
          chipConfig: const ChipConfig(wrapType: WrapType.scroll),
          inputDecoration: BoxDecoration(
            color: VColor.cardBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          dropdownHeight: 200,
          dropdownBackgroundColor: VColor.cardBackground,
          optionsBackgroundColor: VColor.cardBackground,
          hint: "Pilih Jam Terapi",
          hintFontSize: 16,
          optionTextStyle: const TextStyle(fontSize: 16),
          hintStyle: const TextStyle(fontSize: 16),
          selectedOptionIcon: const Icon(Icons.check_circle),
        ),
      ],
    );
  }
}

class BodyFormWidget extends StatelessWidget {
  final List<Widget> children;
  const BodyFormWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

String addIntervalToTime(String timeString, int intervalInMinutes) {
  // Parse the time string to DateTime
  DateTime time = DateTime.parse("2023-01-01 $timeString");

  // Add the interval in minutes
  time = time.add(Duration(minutes: intervalInMinutes));

  // Format the result back to the time string
  String resultTimeString =
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";

  return resultTimeString;
}

class CabangSelectorWidget extends StatelessWidget {
  final List<Cabang> cabangs;
  final void Function(Cabang cabang) onTap;
  final bool Function(Cabang cabang) onSelected;
  const CabangSelectorWidget({
    Key? key,
    required this.cabangs,
    required this.onTap,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 16,
          );
        },
        itemBuilder: (context, index) {
          final curr = cabangs[index];

          return Center(
            child: VCard.vertical(
              onTap: () => onTap(curr),
              width: 180,
              height: 90,
              backgroundColor: onSelected(curr)
                  ? VColor.chipBackground.withOpacity(0.8)
                  : VColor.appbarBackground.withOpacity(.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    curr.nama,
                  ),
                  Text(curr.alamat),
                ],
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: cabangs.length);
  }
}
