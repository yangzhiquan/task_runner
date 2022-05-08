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
  runner.add(10).then((value) => debugPrint('-----批次A执行完毕'));
  runner.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9]).then((value) {
    debugPrint('-----批次B执行完毕');
  });
  runner.add(99).then((value) => debugPrint('-----批次C执行完毕'));
```

