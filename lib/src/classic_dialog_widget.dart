import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog_updated/flutter_animated_dialog.dart';

///Single selection callback of list dialog
typedef OnSingleSelectionCallback = void Function(int selectedIndex);

///Multiple selection callback of list dialog
typedef OnMultiSelectionCallback = void Function(List<int> selectedIndexes);

///
///created time: 2019-07-31 09:35
///author linzhiliang
///version 1.0
///since
///file name: classic_dialog_widget.dart
///description: General dialog
///

@immutable
class ClassicGeneralDialogWidget extends StatelessWidget {
  final String titleText;
  final String contentText;
  final String negativeText;
  final String positiveText;
  final TextStyle? negativeTextStyle;
  final TextStyle? positiveTextStyle;
  final VoidCallback onNegativeClick;
  final VoidCallback onPositiveClick;
  final List<Widget>? actions;

  const ClassicGeneralDialogWidget({
    required this.titleText,
    required this.contentText,
    this.negativeText = "Cancel",
    this.positiveText = "OK",
    this.negativeTextStyle,
    this.positiveTextStyle,
    required this.onNegativeClick,
    required this.onPositiveClick,
    this.actions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: actions ??
          [
            TextButton(
              onPressed: onNegativeClick,
              style: TextButton.styleFrom(
                textStyle: negativeTextStyle ??
                    TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              child: Text(negativeText),
            ),
            TextButton(
              onPressed: onPositiveClick,
              style: TextButton.styleFrom(
                textStyle: positiveTextStyle ??
                    TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              child: Text(positiveText),
            ),
          ],
    );
  }
}

///List type
enum ListType {
  ///Single
  single,

  ///Single select
  singleSelect,

  ///Multiple select
  multiSelect,
}

///
///created time: 2019-08-01 08:59
///author linzhiliang
///version 1.0
///since
///file name: classic_dialog_widget.dart
///description: Classic dialog with list content
///
class ClassicListDialogWidget<T> extends StatefulWidget {
  ///Title text of the dialog
  final String titleText;

  ///Data of the list
  final List<T> dataList;

  ///Custom list item widget
  final Widget? listItem;

  ///Click callback of default list item
  final VoidCallback? onListItemClick;

  ///List type
  final ListType listType;

  ///Where to place control relative to the text
  final ListTileControlAffinity controlAffinity;

  ///The active color of radio or checkbox
  final Color? activeColor;

  ///Selected indexes when [listType] is [ListType.multiSelect]
  final List<int>? selectedIndexes;

  ///Selected index when [listType] is [ListType.singleSelect]
  final int? selectedIndex;

  ///Text of negative button, the left button at the bottom of dialog
  final String? negativeText;

  ///Text of positive button, the right button at the bottom of dialog
  final String? positiveText;

  ///Click callback of negative button
  final VoidCallback? onNegativeClick;

  ///Click callback of positive button
  final VoidCallback? onPositiveClick;

  ///Actions at the bottom of dialog, when this is set, [negativeText] [positiveText] [onNegativeClick] [onPositiveClick] will not work.
  final List<Widget>? actions;

  const ClassicListDialogWidget({
    required this.titleText,
    required this.dataList,
    this.listItem,
    this.onListItemClick,
    this.listType = ListType.single,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.activeColor,
    this.selectedIndexes,
    this.selectedIndex,
    this.actions,
    this.negativeText,
    this.positiveText,
    this.onNegativeClick,
    this.onPositiveClick,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ClassicListDialogWidgetState<T>();
}

class ClassicListDialogWidgetState<T>
    extends State<ClassicListDialogWidget<T>> {
  late int selectedIndex;
  late List<bool> valueList;
  List<int> selectedIndexes = [];

  @override
  void initState() {
    super.initState();
    valueList = List.generate(widget.dataList.length, (index) {
      return widget.selectedIndexes?.contains(index) ?? false;
    });
    selectedIndex = widget.selectedIndex ?? -1;
    selectedIndexes = widget.selectedIndexes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;
    if (widget.dataList.isNotEmpty) {
      contentWidget = ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (widget.listItem == null) {
            switch (widget.listType) {
              case ListType.single:
                return ListTile(
                  title: Text(
                    widget.dataList[index].toString(),
                    style: Theme.of(context).dialogTheme.contentTextStyle,
                  ),
                  onTap: widget.onListItemClick ??
                      () {
                        Navigator.of(context).pop(index);
                      },
                );
              case ListType.singleSelect:
                return RadioListTile<int>(
                  controlAffinity: widget.controlAffinity,
                  title: Text(
                    widget.dataList[index].toString(),
                    style: Theme.of(context).dialogTheme.contentTextStyle,
                  ),
                  activeColor:
                      widget.activeColor ?? Theme.of(context).primaryColor,
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value ?? -1;
                    });
                  },
                );
              case ListType.multiSelect:
                return CheckboxListTile(
                  controlAffinity: widget.controlAffinity,
                  selected: valueList[index],
                  value: valueList[index],
                  title: Text(
                    widget.dataList[index].toString(),
                    style: Theme.of(context).dialogTheme.contentTextStyle,
                  ),
                  onChanged: (value) {
                    setState(() {
                      valueList[index] = value ?? false;
                    });
                  },
                  activeColor:
                      widget.activeColor ?? Theme.of(context).primaryColor,
                );
              default:
                return ListTile(
                  title: Text(
                    widget.dataList[index].toString(),
                    style: Theme.of(context).dialogTheme.contentTextStyle,
                  ),
                  onTap: widget.onListItemClick ??
                      () {
                        Navigator.of(context).pop(index);
                      },
                );
            }
          } else {
            return widget.listItem!;
          }
        },
        itemCount: widget.dataList.length,
      );
    } else {
      contentWidget = const SizedBox.shrink();
    }

    return CustomDialogWidget(
      title: Text(
        widget.titleText,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: const EdgeInsets.all(0.0),
      content: contentWidget,
      actions: widget.actions ??
          [
            if (widget.onNegativeClick != null)
              TextButton(
                onPressed: widget.onNegativeClick,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).splashColor,
                ),
                child: Text(
                  widget.negativeText ?? 'cancel',
                  style: TextStyle(
                    color: Theme.of(context).buttonTheme.colorScheme?.secondary,
                    fontSize: Theme.of(context)
                        .textButtonTheme
                        .style
                        ?.textStyle
                        ?.resolve({})?.fontSize,
                  ),
                ),
              ),
            TextButton(
              onPressed: widget.onPositiveClick ??
                  () {
                    switch (widget.listType) {
                      case ListType.single:
                        Navigator.of(context).pop();
                        break;
                      case ListType.singleSelect:
                        Navigator.of(context).pop(selectedIndex);
                        break;
                      case ListType.multiSelect:
                        selectedIndexes = [];
                        for (int i = 0; i < valueList.length; i++) {
                          if (valueList[i]) {
                            selectedIndexes.add(i);
                          }
                        }
                        Navigator.of(context).pop(selectedIndexes);
                        break;
                    }
                  },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                widget.positiveText ?? 'confirm',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Theme.of(context)
                      .textButtonTheme
                      .style
                      ?.textStyle
                      ?.resolve({})?.fontSize,
                ),
              ),
            ),
          ],
      elevation: 0.0,
      shape: Theme.of(context).dialogTheme.shape ?? RoundedRectangleBorder(),
    );
  }
}
