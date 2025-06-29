import 'package:test_quest/util/model/response_model.dart';
import 'package:test_quest/util/result.dart';

typedef ApiResult<T> = Result<ResponseModel<T>>;
typedef FutureApiResult<T> = Future<Result<ResponseModel<T>>>;
