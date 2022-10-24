class FutureListener<T> {
  final void Function(T? result) onSuccess;
  final void Function(dynamic error) onError;
  final void Function(bool showWait)? onWait;

  FutureListener({
    required this.onSuccess,
    required this.onError,
    this.onWait,
  });
}