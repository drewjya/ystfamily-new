import 'package:ystfamily/src/core/core.dart';

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
