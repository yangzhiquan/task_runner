import 'package:flutter/material.dart';
import 'package:task_runner/task_runner.dart';

Future<String> testFunc(int num) {
  return Future.delayed(const Duration(seconds: 1), () => '>>$num');
}

final TaskRunner<int, String> runner = TaskRunner<int, String>(testFunc);

void main() {
  runner.listen((res) {
    debugPrint('输出结果 $res');
  });
  runner.add(10).then((value) => debugPrint('-----批次A执行完毕'));
  runner.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9]).then((value) {
    debugPrint('-----批次B执行完毕');
  });
  runner.add(99).then((value) => debugPrint('-----批次C执行完毕'));
}
