import 'dart:collection';

import 'package:flutter/material.dart';

class MyDropdownBtn extends StatefulWidget {
  final List<String> items;
  final int idx;
  final ValueChanged<String> onTap;
  const MyDropdownBtn({
    super.key,
    required this.onTap,
    required this.items,
    required this.idx,
  });

  @override
  State<MyDropdownBtn> createState() => _MyDropdownBtnState();
}

class _MyDropdownBtnState extends State<MyDropdownBtn> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<String>> menuEntries =
        UnmodifiableListView<DropdownMenuEntry<String>>(
          widget.items.map<DropdownMenuEntry<String>>(
            (String name) =>
                DropdownMenuEntry<String>(value: name, label: name),
          ),
        );
    return DropdownMenu<String>(
      initialSelection: widget.items[widget.idx],
      onSelected: (String? value) {
        setState(() {
          widget.onTap(value!);
        });
      },
      dropdownMenuEntries: menuEntries,
    );
  }
}
