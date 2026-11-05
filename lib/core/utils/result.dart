class Result<T> {
  const Result.success(this.value) : error = null;
  const Result.failure(this.error) : value = null;

  final T? value;
  final String? error;

  bool get isSuccess => error == null;
}
