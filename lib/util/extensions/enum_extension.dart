import 'package:test_quest/community/model/test_post.dart';

extension TestTypeExtension on TestType {
  String toPostString() {
    return switch (this) {
      TestType.cbt => 'cbt',
      TestType.obt => 'obt',
      TestType.alpha => 'alpha',
      TestType.beta => 'beta',
      TestType.unknown => 'unknown',
    };
  }
}

extension TestPlatformExtension on TestPlatform {
  String toPostString() {
    return switch (this) {
      TestPlatform.console => 'console',
      TestPlatform.mobile => 'mobile',
      TestPlatform.pc => 'pc',
      TestPlatform.unknown => 'unknown',
    };
  }
}
