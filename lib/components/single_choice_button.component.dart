import 'package:flutter/material.dart';

enum CalculationType {single, double}

class SingleChoiceButton extends StatelessWidget {
  const SingleChoiceButton({super.key, required this.selected, required this.onSelectionChanged});

  final CalculationType selected;
  final void Function(CalculationType) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<CalculationType>(segments: const <ButtonSegment<CalculationType>>[
      ButtonSegment<CalculationType>(value: CalculationType.single, icon: Icon(Icons.done), tooltip: 'Калкулация с една валута'),
      ButtonSegment<CalculationType>(value: CalculationType.double, icon: Icon(Icons.done_all), tooltip: 'Калкулация с две валути'),
    ],  onSelectionChanged: (Set<CalculationType> newSelection) {
      onSelectionChanged(newSelection.first);
    }, selected: <CalculationType>{selected});
  }
}