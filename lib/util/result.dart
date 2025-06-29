sealed class Result<T> {
  const Result();

  factory Result.success(T data) => Success(data);
  factory Result.failure(String error) => Failure(error);
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success{data: $data}';
}

final class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);

  @override
  String toString() => 'Failure{error: $error}';
}
