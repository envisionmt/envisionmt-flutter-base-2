import '../../../entities/pagination.dart';

class LoadMoreModel<T> extends Pagination<T> {
  LoadMoreModel({
    List<T>? data,
    bool? isEnd,
  }) : super(
          data: data,
          isEnd: isEnd ?? true,
        );
}
