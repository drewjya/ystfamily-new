import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/home/home.dart';
import 'package:ystfamily/src/features/order/order.dart';

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
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
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
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                      itemBuilder: (context, index) {
                                        final isSelected = data[index].id ==
                                            widget.selected?.id;
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: isSelected
                                                ? VColor.chipBackground
                                                : null,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (isSelected) {
                                              setState2(() {
                                                currSelected = widget
                                                    .onRemove(data[index]);
                                                errorText = "";
                                              });
                                              Navigator.pop(context);
                                            } else {
                                              currSelected =
                                                  widget.onRemove(data[index]);
                                              currSelected = widget
                                                  .onSelected(data[index]);
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
                                                    color:
                                                        VColor.primaryTextColor,
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
            ),
          ),
          if (widget.selected != null)
            IconButton(
              onPressed: () {
                widget.onRemove.call(widget.selected!);
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
