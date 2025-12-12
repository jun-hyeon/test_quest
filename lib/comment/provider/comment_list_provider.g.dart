// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(commentList)
const commentListProvider = CommentListFamily._();

final class CommentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CommentModel>>,
          List<CommentModel>,
          Stream<List<CommentModel>>
        >
    with
        $FutureModifier<List<CommentModel>>,
        $StreamProvider<List<CommentModel>> {
  const CommentListProvider._({
    required CommentListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'commentListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentListHash();

  @override
  String toString() {
    return r'commentListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CommentModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CommentModel>> create(Ref ref) {
    final argument = this.argument as String;
    return commentList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentListHash() => r'76af81a3fd6a0f88b63a9d3b7d50773a992cd073';

final class CommentListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CommentModel>>, String> {
  const CommentListFamily._()
    : super(
        retry: null,
        name: r'commentListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentListProvider call(String postId) =>
      CommentListProvider._(argument: postId, from: this);

  @override
  String toString() => r'commentListProvider';
}
