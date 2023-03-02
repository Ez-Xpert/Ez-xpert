import 'package:flutter/material.dart';

class VacationCard extends StatelessWidget {
  // final Color color;
  final String head;
  final String val;
  const VacationCard({
    Key? key,
    // required this.color,
    required this.head,
    required this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      // height: 85,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            head,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            val,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
