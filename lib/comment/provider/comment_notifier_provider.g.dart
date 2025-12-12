// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommentNotifier)
const commentProvider = CommentNotifierProvider._();

final class CommentNotifierProvider
    extends $AsyncNotifierProvider<CommentNotifier, void> {
  const CommentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentNotifierHash();

  @$internal
  @override
  CommentNotifier create() => CommentNotifier();
}

String _$commentNotifierHash() => r'9be9bc623e79579341febef627bd89796afd7ab9';

abstract class _$CommentNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
