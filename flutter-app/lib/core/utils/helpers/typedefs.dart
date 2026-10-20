import 'package:dartz/dartz.dart';

import '../../base/failure.dart';

typedef Request<T> = Either<DataCRUDFailure, T>;

typedef FutureRequest<T> = Future<Request<T>>;