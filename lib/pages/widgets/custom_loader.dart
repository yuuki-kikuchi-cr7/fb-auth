import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        color: Colors.transparent, // 背景を完全に透明にする
        child: LoadingIndicator(
          indicatorType: Indicator.lineScale,
          colors: [Theme.of(context).colorScheme.primary], // テーマの色を使用
          strokeWidth: 5,
          backgroundColor: Colors.transparent, // 完全に背景を透明にする
          pathBackgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}