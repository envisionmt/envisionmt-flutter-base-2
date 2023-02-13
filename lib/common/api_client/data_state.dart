abstract class DataState<T> {
  const DataState({this.data, this.message});

  final T? data;
  final String? message;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T? data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(String message, [int? code])
      : statusCode = code,
        super(message: message);
  final int? statusCode;
}

extension ExtendedList<DataState> on List<DataState> {
  bool isSuccess() {
    return every((DataState element) => element is DataSuccess);
  }
}

extension ExtendedDataState<DataState> on DataState {
  bool isSuccess() => this is DataSuccess;
}
