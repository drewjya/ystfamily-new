import 'package:ystfamily/src/core/core.dart';

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
    required this.onReset,
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
  final List<T> Function(T? value) onRemove;
  final List<T> Function(T value) onSelect;
  final List<T> Function() onReset;
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
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                                        searchData =
                                            await widget.onSearch!(value);
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
                                    final isSelected = currSelected
                                        .contains(searchData[index]);
                                    return Row(
                                      children: [
                                        const Gap(5),
                                        Expanded(
                                          child: TextButton(
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
                                                  currSelected =
                                                      widget.onRemove(
                                                          searchData[index]);

                                                  errorText = "";
                                                });
                                                if (widget.maxSelected == 1) {
                                                  Navigator.pop(context);
                                                }
                                              } else {
                                                setState2(() {
                                                  if (widget.maxSelected == 1) {
                                                    final isNotEmpty = widget
                                                        .selected.isNotEmpty;
                                                    currSelected = widget
                                                        .onRemove(isNotEmpty
                                                            ? widget
                                                                .selected.first
                                                            : null);
                                                    currSelected =
                                                        widget.onSelect(
                                                            searchData[index]);
                                                    errorText = "";
                                                    Navigator.pop(context);
                                                    return;
                                                  }
                                                  if (widget.maxSelected >
                                                      currSelected.length) {
                                                    currSelected =
                                                        widget.onSelect(
                                                            searchData[index]);
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
                                                if (widget.iconDropdown !=
                                                    null) ...[
                                                  widget.iconDropdown!,
                                                  const Gap(8),
                                                ],
                                                Expanded(
                                                  child: Text(
                                                    widget.onDisplay(
                                                        searchData[index]),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: VColor
                                                          .primaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          IconButton(
                                            onPressed: () {
                                              setState2(() {
                                                currSelected = widget.onRemove(
                                                    searchData[index]);
                                                errorText = "";
                                              });
                                              if (widget.maxSelected == 1) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            icon: const Icon(Icons.close),
                                          ),
                                      ],
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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
              ),
            ),
          ),
          if (widget.selected.isNotEmpty == true)
            IconButton(
              onPressed: () =>
                  setState(() => currSelected = widget.onReset.call()),
              icon: const Icon(Icons.close),
            )
        ],
      ),
    );
  }
}
