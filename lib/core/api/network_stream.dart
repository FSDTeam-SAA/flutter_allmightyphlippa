import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../common/models/network_failure.dart';
import '../common/models/network_success.dart';
import '../services/connectivity_service.dart';

typedef NetworkStream<T> = Stream<Either<NetworkFailure, NetworkSuccess<T>>>;

extension NetworkStreamHandler<T> on NetworkStream<T> {
  /// Binds the stream to an Rx variable and optionally handles loading and refresh.
  /// returns a future that completes when the remote request is finished.
  Future<void> bind({
    required Rxn<T> rx,
    RxBool? loading,
    bool refreshOnConnect = false,
    FutureOr<void> Function(T)? onSuccess,
    Function(NetworkFailure)? onError,
  }) async {
    final completer = Completer<void>();
    loading?.value = true;

    StreamSubscription? subscription;

    void startListening() {
      subscription?.cancel();
      subscription = listen(
        (result) {
          result.fold(
            (failure) {
              onError?.call(failure);
              if (!completer.isCompleted) completer.complete();
            },
            (success) async {
              rx.value = success.data;
              // Complete only on remote result (not cache)
              if (!success.isFromCache) {
                await onSuccess?.call(success.data);
                if (!completer.isCompleted) completer.complete();
              }
            },
          );

          if (rx.value != null || result.isLeft()) {
            loading?.value = false;
          }
        },
        onDone: () {
          loading?.value = false;
          if (!completer.isCompleted) completer.complete();
        },
        onError: (e) {
          loading?.value = false;
          if (!completer.isCompleted) completer.complete();
        },
      );
    }

    startListening();

    if (refreshOnConnect) {
      ConnectivityService.instance.onReconnected.listen(
        (_) => startListening(),
      );
    }

    // Ensure subscriptions are cleaned up if the stream is ever used in a way that needs it
    // Note: In GetX controllers, you might want to manage these manually or use a worker.
    // For now, these stay active for the life of the binding.

    return completer.future;
  }
}

extension NetworkStreamListHandler<T> on NetworkStream<List<T>> {
  /// Binds a stream of lists to an RxList variable.
  Future<void> bindList({
    required RxList<T> rx,
    RxBool? loading,
    bool refreshOnConnect = false,
    FutureOr<void> Function(List<T>)? onSuccess,
    Function(NetworkFailure)? onError,
  }) async {
    final completer = Completer<void>();
    loading?.value = true;

    StreamSubscription? subscription;

    void startListening() {
      subscription?.cancel();
      subscription = listen(
        (result) {
          result.fold(
            (failure) {
              onError?.call(failure);
              if (!completer.isCompleted) completer.complete();
            },
            (success) async {
              rx.assignAll(success.data);
              // Complete only on remote result (not cache)
              if (!success.isFromCache) {
                await onSuccess?.call(success.data);
                if (!completer.isCompleted) completer.complete();
              }
            },
          );

          if (rx.isNotEmpty || result.isLeft()) {
            loading?.value = false;
          }
        },
        onDone: () {
          loading?.value = false;
          if (!completer.isCompleted) completer.complete();
        },
        onError: (e) {
          loading?.value = false;
          if (!completer.isCompleted) completer.complete();
        },
      );
    }

    startListening();

    if (refreshOnConnect) {
      ConnectivityService.instance.onReconnected.listen(
        (_) => startListening(),
      );
    }

    return completer.future;
  }
}
