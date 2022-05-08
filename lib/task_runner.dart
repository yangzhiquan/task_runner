import 'dart:async';
import 'dart:collection';

class TaskRunner<Input, Output> {
  // 单个批次执行
  final Queue<_TaskCompleter<Input, bool>> _batch = Queue();
  final StreamController<Output> _streamController = StreamController();
  final Future<Output> Function(Input) performer;

  // 单个批次列表的任务并发数
  final int maxConcurrentTasks;
  int _runningNum = 0;

  TaskRunner(this.performer, {this.maxConcurrentTasks = 3});

  /// 单个执行结果回调
  void listen(void Function(Output res) onData) {
    _streamController.stream.listen((event) {
      onData(event);
    });
  }

  Future<bool> add(Input task) => addAll([task]);

  Future<bool> addAll(Iterable<Input> inputs) {
    final queue = Queue<Input>.from(inputs);
    final batch = _TaskCompleter<Input, bool>(queue);
    _batch.add(batch);
    _run();
    return batch.future;
  }

  // 执行批次队列
  void _run() {
    if (_runningNum == 0 && _batch.isNotEmpty) {
      _processBatch(_batch.removeFirst());
    }
  }

  void _processBatch(_TaskCompleter<Input, bool> batch) {
    while (batch.inputs.isNotEmpty && _runningNum < maxConcurrentTasks) {
      ++_runningNum;
      performer(batch.inputs.removeFirst()).then((value) {
        --_runningNum;
        _streamController.add(value);

        if (batch.inputs.isNotEmpty) {
          _processBatch(batch);
        } else if (_runningNum == 0) {
          Future(() => batch.complete(true));
          _run();
        }
      });
    }
  }
}

/// 任务容器 (按批次
class _TaskCompleter<Input, Output> {
  final _completer = Completer<Output>();
  final Queue<Input> inputs;
  _TaskCompleter(this.inputs);

  Future<Output> get future => _completer.future;
  void complete([FutureOr<Output>? value]) => _completer.complete(value);
}
