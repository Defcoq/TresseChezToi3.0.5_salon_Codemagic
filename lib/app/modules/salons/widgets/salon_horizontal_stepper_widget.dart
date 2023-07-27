import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../widgets/salons_step_widget.dart';


class SalonsHorizontalStepperWidget extends StatelessWidget {
  const SalonsHorizontalStepperWidget({
    Key? key,
    this.steps,
    this.padding,
  }) : super(key: key);

  final List<SalonsStepWidget>? steps;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: List.generate(steps!.length, (index) {
          if (index < steps!.length - 1)
            return Expanded(
              child: Row(children: [
                steps!.elementAt(index),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      thickness: 3,
                      color: Get.theme.focusColor.withOpacity(0.4),
                    ),
                  ),
                ),
              ]),
            );
          else
            return steps!.elementAt(index);
        }),
      ),
    );
  }
}
