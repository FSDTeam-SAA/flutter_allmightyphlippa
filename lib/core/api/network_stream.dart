import 'package:dartz/dartz.dart';
import '../common/models/network_failure.dart';
import '../common/models/network_success.dart';

typedef NetworkStream<T> = Stream<Either<NetworkFailure, NetworkSuccess<T>>>;
