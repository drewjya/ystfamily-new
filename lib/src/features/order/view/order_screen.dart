// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

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

class OrderScreen extends StatefulHookConsumerWidget {
  final String branchName;
  const OrderScreen({super.key, required this.branchName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen>
    with TickerProviderStateMixin {
  final overlayKey = GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;

  late TextEditingController therapistController;
  OverlayEntry? _overlayEntry;
  OverlayState? overlay;
  late FocusNode therapistFocus;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation =
        CurveTween(curve: Curves.fastOutSlowIn).animate(animationController!);
    therapistController = TextEditingController();
    therapistFocus = FocusNode();
    therapistFocus.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    log("LISTENER ");
    if (therapistFocus.hasFocus) {
      _showOverlay(context);
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay(BuildContext context) {
    overlay = Overlay.of(context);
    _removeOverlay();
    final renderBox =
        overlayKey.currentContext?.findRenderObject() as RenderBox?;

    final position = renderBox?.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: (position?.dy ?? 20) + 50,
        left: 10,
        right: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Material(
            elevation: 4.0,
            child: ValueListenableBuilder(
                valueListenable: therapistController,
                builder: (context, value, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    color: VColor.cardBackground,
                    height: 200,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(10, (index) => Text("$index AYAm")),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
    overlay?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    therapistFocus.removeListener(_handleFocusChange);
    therapistFocus.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cabang = ref.watch(selectedCabangProvider);

    final selectedTreatment = useState<Map<int, Treatment>>({});
    final selectedAdditional = useState<Map<int, AdditionalTreatment>>({});

    final selectedTherapistGender = useState<Gender?>(null);

    final selectedTherapist = useState<Therapist?>(null);

    final jamTerapi = useState<String?>(null);
    final selectedDate = useState<DateTime?>(null);

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

    return GestureDetector(
      onTap: () {
        log("LOSE FOCUS");

        therapistFocus.unfocus();
        _removeOverlay();
      },
      child: DefaultTextStyle(
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
              if (cabang != null)
                CabangCard(
                  start: true,
                  cabang: cabang,
                  isSelected: true,
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
                      backgroundColor:
                          VColor.primaryBackground.withOpacity(0.5),
                      onSelected: (value) {
                        selectedTherapistGender.value = element;
                        if (cabang != null &&
                            selectedTherapistGender.value != null &&
                            selectedDate.value != null) {
                          final params = TherapistType(
                              cabangId: cabang.cabangId,
                              tanggal: selectedDate.value!.yearMonthDate(),
                              gender: selectedTherapistGender.value!.nama);
                          ref
                              .read(therapistProvider.notifier)
                              .load(arg: params);
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
                  final now = DateTime.now();
                  final date = await showDatePicker(
                      context: context,
                      initialDate: now.add(const Duration(days: 1)),
                      firstDate: now.add(const Duration(days: 1)),
                      lastDate: now.add(const Duration(days: 30)));
                  if (date != null) {
                    selectedDate.value = date;
                  }
                  if (cabang != null &&
                      selectedTherapistGender.value != null &&
                      selectedDate.value != null) {
                    final params = TherapistType(
                        cabangId: cabang.cabangId,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih Therapist (Optional)",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  TextField(
                    controller: therapistController,
                    focusNode: therapistFocus,
                    key: overlayKey,
                    onChanged: (value) {
                      _showOverlay(context);
                    },
                    decoration: inputStyle.copyWith(
                      contentPadding: const EdgeInsets.all(12),
                      fillColor: VColor.cardBackground,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: VColor.cardBackground,
                        ),
                      ),
                      hintText: 'Nama Therapist',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: VColor.darkBrown,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: VColor.cardBackground,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Jam Terapi",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  TherapistTimeSlotWidget(
                    therapist: null,
                    cabang: cabang!,
                    onSelected: (time) {
                      jamTerapi.value = time;
                    },
                    onRemoved: () {
                      jamTerapi.value = null;
                    },
                  ),
                  const Gap(4),
                  const Text(
                    "Treatment",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  MultiSelectDropDown(
                    onOptionSelected: (options) {
                      selectedTreatment.value = {};
                      selectedTreatment.value = {
                        for (var e in options)
                          (e.value as Treatment).treatmentId:
                              e.value as Treatment
                      };
                    },
                    maxItems: 2,
                    options: []
                        .map((e) => ValueItem(label: e.nama, value: e))
                        .toList(),
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                    inputDecoration: BoxDecoration(
                      color: VColor.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dropdownHeight: 200,
                    dropdownBackgroundColor: VColor.cardBackground,
                    optionsBackgroundColor: VColor.cardBackground,
                    hint: "Pilih Treatment",
                    optionTextStyle: const TextStyle(fontSize: 16),
                    hintStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                  const Text(
                    "Additional Treatment (Optional)",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  MultiSelectDropDown(
                    onOptionSelected: (options) {
                      selectedAdditional.value = {};
                      selectedAdditional.value = {
                        for (var e in options)
                          (e.value as AdditionalTreatment)
                                  .additionalTreatmentId:
                              e.value as AdditionalTreatment
                      };
                    },
                    maxItems: 2,
                    options: []
                        .map((e) => ValueItem(label: e.nama, value: e))
                        .toList(),
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                    inputDecoration: BoxDecoration(
                      color: VColor.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dropdownHeight: 200,
                    dropdownBackgroundColor: VColor.cardBackground,
                    optionsBackgroundColor: VColor.cardBackground,
                    hint: "Pilih Additional Treatment",
                    optionTextStyle: const TextStyle(fontSize: 16),
                    hintStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                  const Gap(8),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              VCard.horizontal(
                backgroundColor: jamTerapi.value != null ? null : Colors.grey,
                onTap: jamTerapi.value != null
                    ? () async {
                        final submit = await showDialog(
                          context: context,
                          builder: (context) {
                            return SubmitOrderDialog(
                              selectedAdditional: selectedAdditional.value,
                              cabang: cabang,
                              selectedTherapist: selectedTherapist.value!,
                              jamTerapi: jamTerapi.value!,
                              selectedDate: selectedDate.value!,
                              selectedTreatment: selectedTreatment.value,
                            );
                          },
                        );
                        if (submit) {
                          final trD = selectedTreatment.value.values
                              .mapIndexed((index, e) =>
                                  OrderDetailDTO.treatment(
                                      treatmentId: e.treatmentId,
                                      happyHour: happyHour(
                                              date: selectedDate.value!,
                                              therapist:
                                                  selectedTherapist.value!,
                                              selectedHour: jamTerapi.value!,
                                              previousTreatment: index == 0
                                                  ? null
                                                  : selectedTreatment
                                                      .value.values
                                                      .elementAt(index - 1)) &&
                                          e.happyHourPrice != null))
                              .toList();
                          final adD = selectedAdditional.value.values
                              .map((e) => OrderDetailDTO.additional(
                                  additionalTreatmentId:
                                      e.additionalTreatmentId))
                              .toList();
                          final selectedDTO = OrderDto(
                            genderTherapist:
                                selectedTherapistGender.value!.nama == "male",
                            cabangId: cabang.cabangId,
                            therapistId:
                                selectedTherapist.value!.therapistId ?? -1,
                            orderStartTime: jamTerapi.value!,
                            orderDate: selectedDate.value!.toUtc(),
                            treatments: [...trD, ...adD],
                          );

                          ref
                              .read(orderProvider.notifier)
                              .postOrder(body: selectedDTO);
                        }
                      }
                    : null,
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: jamTerapi.value != null ? null : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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

addZero(int number) {
  return number < 10 ? '0$number' : '$number';
}

List<String> generateList() {
  return List.generate(
      ((22 - 8) ~/ 2), (index) => '${addZero(((index * 2) + 8))}:00:00');
}

class TherapistTimeSlotWidget extends StatelessWidget {
  const TherapistTimeSlotWidget({
    Key? key,
    this.therapist,
    required this.cabang,
    required this.onRemoved,
    required this.onSelected,
  }) : super(key: key);

  final Therapist? therapist;
  final Cabang cabang;
  final VoidCallback onRemoved;
  final void Function(String time) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultiSelectDropDown(
          onOptionSelected: (options) {
            log("$options");
            if (options.isNotEmpty) {
              onSelected(options.last.value as String);
            } else {
              onRemoved();
            }
          },
          options: therapist != null
              ? therapist!.availableTimeSlots.reversed
                  .map((e) => ValueItem(label: e, value: e))
                  .toList()
              : generateList()
                  .map((e) => ValueItem(
                        label: e,
                        value: e,
                      ))
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
