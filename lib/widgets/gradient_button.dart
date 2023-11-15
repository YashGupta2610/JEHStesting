import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  GradientButton(this.label);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      // margin: EdgeInsets.symmetric(
      //   horizontal: 20,
      // ),
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        // width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Colors.pink,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0, 1],
            )),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
