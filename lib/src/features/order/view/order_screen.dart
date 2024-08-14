// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/history/provider/history_provider.dart';
import 'package:ystfamily/src/features/home/home.dart';
import 'package:ystfamily/src/features/order/order.dart';
import 'package:ystfamily/src/features/order/widget/select_therapist.dart';

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
    final user = ref.watch(authProvider).valueOrNull;

    useAuthHook(ref: ref, context: context);
    final cabang = ref.watch(selectedCabangProvider);
    final selectedTreatment = useState<Set<TreatmentCabang>>({});
    final selectedAdditional = useState<Set<TreatmentCabang>>({});
    final selectedTherapistGender = useState<Gender?>(null);
    final selectGuestGender = useState<Gender?>(null);
    final selectedTherapist = useState<Therapist?>(null);
    final jamTerapi = useState<String?>(null);
    final selectedDate = useState<DateTime?>(null);
    final waController = useTextEditingController();
    final sameWithProfile = useState(false);

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
                  icon: const Icon(Icons.close),
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
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const Gap(12),
            TextFormField(
              controller: waController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: inputStyle.copyWith(
                labelText: "No. Telp (WA)",
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                } else {
                  return null;
                }
              },
            ),
            const Gap(12),
            CheckboxListTile(
              value: sameWithProfile.value,
              onChanged: (value) {
                sameWithProfile.value = value ?? false;
                if (sameWithProfile.value) {
                  waController.text = user?.phoneNumber ?? "";
                }
              },
              title: const Text("Sama dengan akun"),
            ),
            const Gap(12),
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
                    onReset: () {
                      jamTerapi.value = null;
                      return [];
                    },
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
                      log("${jamTerapi.value}");
                      return jamTerapi.value != null ? [jamTerapi.value!] : [];
                    },
                    selected: jamTerapi.value != null ? [jamTerapi.value!] : [],
                  ),
                  const Gap(4),
                  const Text(
                    "Treatment",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  MultiSelectWidget<TreatmentCabang>(
                    isSearchable: true,
                    onReset: () {
                      selectedTreatment.value = {};
                      return [];
                    },
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
                            element.treatment.id != value?.treatment.id)
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
                    onReset: () {
                      selectedAdditional.value = {};
                      return [];
                    },
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
                            element.treatment.id != value?.treatment.id)
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
