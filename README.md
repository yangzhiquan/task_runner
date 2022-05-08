# task_runner
dart异步任务执行器

1. 定义输入，输出值与执行函数

```dart
/// 输入int，输出String
Future<String> testFunc(int num) {
  return Future.delayed(const Duration(seconds: 1), () => '>>$num');
}
```

2. 创建对应类型的TaskRunner
```dart
final TaskRunner<int, String> runner = TaskRunner<int, String>(testFunc);
```

3. 添加结果监听，添加输入值
```dart
  /// 监听输出结果
  runner.listen((res) {
    debugPrint('输出结果 $res');
  });
  
  /// 输入数值.
  runner.add(0).then((value) => debugPrint('-----批次A执行完毕'));
  runner.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9]).then((value) {
    debugPrint('-----批次B执行完毕');
  });
  runner.add(99).then((value) => debugPrint('-----批次C执行完毕'));
```

输出
```
flutter: 输出结果 >>0
flutter: -----批次A执行完毕
flutter: 输出结果 >>1
flutter: 输出结果 >>2
flutter: 输出结果 >>3
flutter: 输出结果 >>4
flutter: 输出结果 >>5
flutter: 输出结果 >>6
flutter: 输出结果 >>7
flutter: 输出结果 >>8
flutter: 输出结果 >>9
flutter: -----批次B执行完毕
flutter: 输出结果 >>99
flutter: -----批次C执行完毕
```