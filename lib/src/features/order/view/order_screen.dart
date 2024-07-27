// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/common/auth_hook.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/history/provider/history_provider.dart';
import 'package:ystfamily/src/features/home/home.dart';
import 'package:ystfamily/src/features/order/model/order_dto.dart';
import 'package:ystfamily/src/features/order/model/preview_order.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';
import 'package:ystfamily/src/features/order/model/treatment_model.dart';
import 'package:ystfamily/src/features/order/order.dart';
import 'package:ystfamily/src/features/order/provider/order_provider.dart';
import 'package:ystfamily/src/features/order/provider/therapist_detail_provider.dart';
import 'package:ystfamily/src/features/order/provider/therapist_provider.dart';
import 'package:ystfamily/src/features/order/provider/timeslot_provider.dart';
import 'package:ystfamily/src/features/order/provider/treatment_cabang_provider.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

final isLoadingProvider = StateProvider<bool?>((ref) {
  return;
});

class OrderScreen extends StatefulHookConsumerWidget {
  final String branchName;
  const OrderScreen({super.key, required this.branchName});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    useAuthHook(ref: ref, context: context);
    final cabang = ref.watch(selectedCabangProvider);
    final selectedTreatment = useState<Set<TreatmentCabang>>({});
    final selectedAdditional = useState<Set<TreatmentCabang>>({});
    final selectedTherapistGender = useState<Gender?>(null);
    final selectGuestGender = useState<Gender?>(null);
    final selectedTherapist = useState<Therapist?>(null);
    final jamTerapi = useState<String?>(null);
    final selectedDate = useState<DateTime?>(null);

    final isShown = useMemoized(
        () =>
            selectedDate.value != null &&
            selectedTherapistGender.value != null &&
            selectGuestGender.value != null,
        [
          selectedDate.value,
          selectedTherapistGender.value,
          selectGuestGender.value
        ]);

    ref.listen(orderProvider, (previous, next) {
      final isLoading = ref.watch(isLoadingProvider) ?? false;
      next.when(
        data: (data) {
          if (data.isEmpty) {
            return;
          }
          if (data.isNotEmpty) {
            if (isLoading) {
              ref.read(isLoadingProvider.notifier).update((state) => false);
              Navigator.pop(context);
            }
            ref.invalidate(orderStatusProvider);
            ref.invalidate(historyProvider);

            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog.adaptive(
                title: const Text("Notifikasi"),
                content: Text.rich(
                  TextSpan(
                    text:
                        "Order Anda Berhasil Dibuat. Mohon untuk datang tepat waktu pada pukul ",
                    style: const TextStyle(),
                    children: [
                      TextSpan(
                          text:
                              "${jamTerapi.value}, ${selectedDate.value?.getDate()}",
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            );
          }
        },
        error: (error, stackTrace) {
          if (isLoading) {
            ref.read(isLoadingProvider.notifier).update((state) => false);
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        },
        loading: () {
          ref.read(isLoadingProvider.notifier).update((state) => true);
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

    final format = DateFormat("yyyy-MM-dd");

    final therapistDetail = ref
        .watch(therapistDetailProvider(selectedTherapist.value?.id))
        .asData
        ?.value;
    final selectedTreatmentTherapist = therapistDetail?.therapistTreatment;
    final treatmentData =
        ref.watch(treatmentCabangProvider(cabang!.id)).asData?.value;

    final treatmentCabang = selectedTreatmentTherapist != null
        ? (treatmentData?.where((element) =>
                selectedTreatmentTherapist.contains(element.treatment)) ??
            [])
        : treatmentData;
    final timeslots = ref.watch(timeslotProvider(TimeSlotParam(
        cabangId: cabang.id,
        tanggal: format.format(selectedDate.value ?? DateTime.now()),
        therapistId: selectedTherapist.value?.id)));

    useEffect(() {
      jamTerapi.value = null;
      selectedAdditional.value = {};
      selectedTreatment.value = {};
      selectedTherapist.value = null;
      if (selectedTherapistGender.value != null) {
        Future.microtask(() => ref.read(therapistProvider.notifier).load(
              cabangId: cabang.id,
              gender: selectedTherapistGender.value!,
              name: "",
            ));
      } else {
        Future.microtask(() => ref.invalidate(therapistProvider));
      }
      return;
    }, [selectedTherapistGender.value]);

    useEffect(() {
      jamTerapi.value = null;
      selectedAdditional.value = {};
      selectedTreatment.value = {};
      return;
    }, [selectedTherapist.value]);

    useEffect(() {
      selectedAdditional.value = {};
      selectedTreatment.value = {};
      jamTerapi.value = null;
      selectedTherapist.value = null;
      return;
    }, [selectedDate.value]);

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
            CabangCard(
              start: true,
              cabang: cabang,
              isSelected: true,
            ),
            const Text(
              "Jenis Kelamin Therapist",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ...Gender.values.mapIndexed((index, element) {
                return Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 8.0 : 0),
                  child: ChoiceChip.elevated(
                    label: Text(element.value),
                    selectedColor: VColor.appbarBackground.withOpacity(.7),
                    selected: selectedTherapistGender.value == element,
                    backgroundColor: VColor.primaryBackground.withOpacity(0.5),
                    onSelected: (value) {
                      final val = element;
                      if (selectGuestGender.value != null &&
                          val != selectGuestGender.value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Gender Therapist dan Tamu Harus sama"),
                          ),
                        );
                      } else {
                        selectedTherapistGender.value = element;
                      }
                    },
                  ),
                );
              }),
              const Spacer(),
              if (selectedTherapistGender.value != null)
                IconButton(
                  onPressed: () {
                    selectGuestGender.value = null;
                    selectedTherapistGender.value = null;
                  },
                  icon: const Icon(Icons.replay_outlined),
                ),
            ]),
            const Text(
              "Jenis Kelamin Tamu",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...Gender.values.mapIndexed((index, element) {
                  return Padding(
                    padding: EdgeInsets.only(right: index == 0 ? 8.0 : 0),
                    child: ChoiceChip.elevated(
                      label: Text(element.value),
                      selectedColor: VColor.appbarBackground.withOpacity(.7),
                      selected: selectGuestGender.value == element,
                      backgroundColor:
                          VColor.primaryBackground.withOpacity(0.5),
                      onSelected: (value) {
                        final val = element;
                        if (selectedTherapistGender.value != null &&
                            val != selectedTherapistGender.value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Gender Therapist dan Tamu Harus sama"),
                            ),
                          );
                        } else {
                          selectGuestGender.value = val;
                        }
                      },
                    ),
                  );
                }),
                const Spacer(),
                if (selectGuestGender.value != null)
                  IconButton(
                    onPressed: () {
                      selectGuestGender.value = null;
                      selectedTherapistGender.value = null;
                    },
                    icon: const Icon(Icons.replay_outlined),
                  ),
              ],
            ),
            const Gap(12),
            VCard.horizontal(
              backgroundColor: VColor.appbarBackground.withOpacity(.7),
              onTap: () async {
                final now = DateTime.now();
                final date = await showDatePicker(
                    context: context,
                    initialDate:
                        selectedDate.value ?? now.add(const Duration(days: 1)),
                    firstDate: now.add(const Duration(days: 1)),
                    lastDate: now.add(const Duration(days: 30)));
                if (date != null) {
                  selectedDate.value = date;
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
            if (isShown)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih Therapist (Opsional)",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  SelectTherapist(
                    cabangId: cabang.id,
                    onSelected: (data) {
                      selectedTherapist.value = data;
                      return data;
                    },
                    onRemove: (data) {
                      selectedTherapist.value = null;
                      return null;
                    },
                    selected: selectedTherapist.value,
                    onSearch: (query) {
                      ref.read(therapistProvider.notifier).load(
                          cabangId: cabang.id,
                          gender: selectedTherapistGender.value!,
                          name: query);
                    },
                  ),
                  const Text(
                    "Jam Treatment",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  MultiSelectWidget(
                    data: timeslots.asData?.value?.timeSlot ?? <String>[],
                    displayed: () => jamTerapi.value,
                    labelText: "Pilih Jam Treatment",
                    maxSelected: 1,
                    icon: const Icon(Icons.access_time),
                    iconDropdown: const Icon(Icons.access_time),
                    onDisplay: (value) => value,
                    onRemove: (value) {
                      jamTerapi.value = null;
                      return [];
                    },
                    onSelect: (value) {
                      jamTerapi.value = value;
                      return [jamTerapi.value ?? ""];
                    },
                    selected: [jamTerapi.value ?? ""],
                  ),
                  const Gap(4),
                  const Text(
                    "Treatment",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  MultiSelectWidget<TreatmentCabang>(
                    isSearchable: true,
                    data: (treatmentCabang ?? <TreatmentCabang>[])
                        .where(
                            (element) => !element.treatment.category.optional)
                        .map((e) => e)
                        .toList(),
                    displayed: () => selectedTreatment.value.isEmpty
                        ? null
                        : selectedTreatment.value
                            .map((value) =>
                                "${value.treatment.nama} (${value.treatment.category.nama})")
                            .join(", "),
                    labelText: "Pilih Treatment",
                    maxSelected: 2,
                    onDisplay: (value) =>
                        "${value.treatment.nama} (${value.treatment.category.nama})",
                    onRemove: (value) {
                      selectedTreatment.value = {
                        ...selectedTreatment.value.where((element) =>
                            element.treatment.id != value.treatment.id)
                      };
                      return selectedTreatment.value.toList();
                    },
                    onSelect: (value) {
                      selectedTreatment.value = {
                        ...selectedTreatment.value,
                        value,
                      };
                      return selectedTreatment.value.toList();
                    },
                    selected: selectedTreatment.value.toList(),
                  ),
                  const Gap(4),
                  const Text(
                    "Treatment Tambahan (Opsional)",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  MultiSelectWidget<TreatmentCabang>(
                    isSearchable: true,
                    data: (treatmentCabang ?? <TreatmentCabang>[])
                        .where((element) => element.treatment.category.optional)
                        .map((e) => e)
                        .toList(),
                    displayed: () => selectedAdditional.value.isEmpty
                        ? null
                        : selectedAdditional.value
                            .map((e) => e.treatment.nama)
                            .join(", "),
                    labelText: "Pilih Treatment Tambahan (Opsional)",
                    maxSelected: 2,
                    onDisplay: (value) => value.treatment.nama,
                    onRemove: (value) {
                      selectedAdditional.value = {
                        ...selectedAdditional.value.where((element) =>
                            element.treatment.id != value.treatment.id)
                      };
                      return selectedAdditional.value.toList();
                    },
                    onSelect: (value) {
                      selectedAdditional.value = {
                        ...selectedAdditional.value,
                        value,
                      };

                      return selectedAdditional.value.toList();
                    },
                    selected: selectedAdditional.value.toList(),
                  ),
                  const Gap(8),
                ],
              ),
            const Gap(12),
            VCard.horizontal(
              backgroundColor: jamTerapi.value != null &&
                      selectedTreatment.value.isNotEmpty &&
                      selectedDate.value != null &&
                      selectedTherapistGender.value != null &&
                      selectGuestGender.value != null
                  ? null
                  : Colors.grey,
              onTap: jamTerapi.value != null
                  ? () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      final format = DateFormat("yyyy-MM-dd");
                      final dto = OrderDto(
                          cabangId: cabang.id,
                          guestGender: selectGuestGender.value!.nama,
                          orderDate: format.format(selectedDate.value!),
                          orderTime: jamTerapi.value!,
                          therapistGender: selectedTherapistGender.value!.nama,
                          treatmentDetail: {
                            ...selectedTreatment.value,
                            ...selectedAdditional.value,
                          }.map((e) => e.treatment.id).toList(),
                          therapistId: selectedTherapist.value?.id);
                      final previewValue = ref
                          .read(orderRepositoryProvider)
                          .previewOrder(order: dto);
                      previewValue.then((value) {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                          ),
                          builder: (context) {
                            return PreviewOrderWidget(
                              preview: value,
                              dto: dto,
                              therapist: selectedTherapist.value,
                            );
                          },
                        );
                        return null;
                      }).onError((error, stackTrace) {
                        Navigator.pop(context);
                        log("$error");
                        String message = "Silahkan coba lagi";
                        if (error is ApiException) {
                          message = (error).message;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                          ),
                        );
                      });
                    }
                  : null,
              child: Center(
                child: Text(
                  'Kirim',
                  style: TextStyle(
                    color: jamTerapi.value != null &&
                            selectedTreatment.value.isNotEmpty &&
                            selectedDate.value != null &&
                            selectedTherapistGender.value != null &&
                            selectGuestGender.value != null
                        ? VColor.darkBrown
                        : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          children: [
            const Text(
              "PREVIEW",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: VColor.primaryTextColor,
              ),
            ),
            const Gap(24),
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

class RowItem extends StatelessWidget {
  final String title;
  final String? value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  const RowItem({
    super.key,
    required this.title,
    this.value,
    this.titleStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 2,
            child: Text(
              title,
              style: titleStyle,
              maxLines: 2,
            )),
        Expanded(
          child: Text(
            value ?? "-",
            textAlign: TextAlign.end,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}

class SelectTherapist extends StatefulWidget {
  const SelectTherapist({
    super.key,
    required this.cabangId,
    required this.onSearch,
    required this.onRemove,
    required this.onSelected,
    required this.selected,
  });

  final int cabangId;
  final Therapist? selected;
  final Therapist? Function(Therapist data) onSelected;
  final Therapist? Function(Therapist data) onRemove;
  final void Function(String) onSearch;

  @override
  State<SelectTherapist> createState() => _SelectTherapistState();
}

class _SelectTherapistState extends State<SelectTherapist> {
  Therapist? currSelected;
  @override
  Widget build(BuildContext context) {
    return VCard.horizontal(
      backgroundColor: VColor.cardBackground,
      onTap: () async {
        String errorText = "";
        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Consumer(builder: (context, ref, child) {
                return StatefulBuilder(builder: (context, setState2) {
                  final therapists = ref.watch(therapistProvider);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Pilih Therapist (Opsional)",
                            style: TextStyle(
                              fontSize: 18,
                              color: VColor.primaryTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Gap(12),
                        if (errorText.isNotEmpty) ...{
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              errorText,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const Gap(4),
                        },
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8),
                          child: TextField(
                            onChanged: (value) async {
                              widget.onSearch(value);
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
                              hintText: 'Cari...',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: VColor.cardBackground,
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
                        ),
                        const Gap(6),
                        Expanded(
                            child: therapists.when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.length,
                              physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemBuilder: (context, index) {
                                final isSelected =
                                    data[index].id == widget.selected?.id;
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? VColor.chipBackground
                                        : null,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (isSelected) {
                                      setState2(() {
                                        currSelected =
                                            widget.onRemove(data[index]);
                                        errorText = "";
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      currSelected =
                                          widget.onRemove(data[index]);
                                      currSelected =
                                          widget.onSelected(data[index]);
                                      errorText = "";
                                      Navigator.pop(context);
                                      return;
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          data[index].nama,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: VColor.primaryTextColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          error: (error, stackTrace) => Center(
                            child: Text("$error"),
                          ),
                          loading: () => const LoadingWidget(),
                        )),
                      ],
                    ),
                  );
                });
              }),
            );
          },
        );
        setState(() {});
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.selected?.nama ?? "Pilih Therapist (Opsional)",
              style: const TextStyle(
                fontSize: 16,
                color: VColor.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectWidget<T> extends StatefulWidget {
  const MultiSelectWidget({
    super.key,
    required this.data,
    required this.onSelect,
    required this.labelText,
    this.icon,
    this.iconDropdown,
    required this.onDisplay,
    required this.maxSelected,
    required this.onRemove,
    required this.displayed,
    required this.selected,
    this.onSearch,
    this.isSearchable = false,
  });

  final List<T> selected;
  final List<T> data;
  final Future<List<T>> Function(String query)? onSearch;
  final String labelText;
  final Widget? icon;
  final String Function(T value) onDisplay;
  final Widget? iconDropdown;
  final int maxSelected;
  final List<T> Function(T value) onRemove;
  final List<T> Function(T value) onSelect;
  final String? Function() displayed;
  final bool isSearchable;

  @override
  State<MultiSelectWidget<T>> createState() => _MultiSelectWidgetState<T>();
}

class _MultiSelectWidgetState<T> extends State<MultiSelectWidget<T>> {
  List<T> currSelected = [];
  @override
  void initState() {
    currSelected = widget.selected;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant MultiSelectWidget<T> oldWidget) {
    currSelected = widget.selected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return VCard.horizontal(
      backgroundColor: VColor.cardBackground,
      onTap: () async {
        String searched = "";
        String errorText = "";
        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: StatefulBuilder(builder: (context, setState2) {
                List<T> searchData = widget.data;
                if (widget.isSearchable && widget.onSearch == null) {
                  searchData = widget.data
                      .where((element) => widget
                          .onDisplay(element)
                          .toLowerCase()
                          .contains(searched.toLowerCase()))
                      .toList();
                }
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  height: MediaQuery.sizeOf(context).height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          widget.labelText,
                          style: const TextStyle(
                            fontSize: 18,
                            color: VColor.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Gap(12),
                      if (errorText.isNotEmpty) ...{
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            errorText,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const Gap(4),
                      },
                      if (widget.isSearchable) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8),
                          child: TextField(
                            onChanged: (value) async {
                              setState2(() {
                                searched = value;
                              });
                              if (widget.onSearch == null) {
                                return;
                              }
                              setState2(() async {
                                searchData = await widget.onSearch!(value);
                              });
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
                              hintText: 'Cari...',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: VColor.cardBackground,
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
                        ),
                        const Gap(6),
                      ],
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemCount: searchData.length,
                          itemBuilder: (context, index) {
                            log("$currSelected");
                            final isSelected =
                                currSelected.contains(searchData[index]);
                            return TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    isSelected ? VColor.chipBackground : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (isSelected) {
                                  setState2(() {
                                    currSelected =
                                        widget.onRemove(searchData[index]);
                                    log("$currSelected");
                                    errorText = "";
                                  });
                                  if (widget.maxSelected == 1) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  setState2(() {
                                    if (widget.maxSelected == 1) {
                                      currSelected = widget
                                          .onRemove(widget.selected.first);
                                      currSelected =
                                          widget.onSelect(searchData[index]);
                                      errorText = "";
                                      Navigator.pop(context);
                                      return;
                                    }
                                    if (widget.maxSelected >
                                        currSelected.length) {
                                      currSelected =
                                          widget.onSelect(searchData[index]);
                                      errorText = "";
                                    } else {
                                      errorText =
                                          "Maksimal ${widget.maxSelected} item";
                                    }
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  if (widget.iconDropdown != null) ...[
                                    widget.iconDropdown!,
                                    const Gap(8),
                                  ],
                                  Expanded(
                                    child: Text(
                                      widget.onDisplay(searchData[index]),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: VColor.primaryTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        );
        setState(() {});
      },
      child: Row(
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const Gap(8),
          ],
          Expanded(
            child: Text(
              widget.displayed() ?? widget.labelText,
              style: const TextStyle(
                fontSize: 16,
                color: VColor.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            ),
          ),
        ],
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
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
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
