import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';
part 'user_info.g.dart';

@freezed
abstract class UserInfo with _$UserInfo {
  factory UserInfo({
    required String uid,
    required String name,
    required String nickname,
    required String? profileUrl,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}

/// Firebase Auth User를 UserInfo로 변환하는 확장 메서드
extension FirebaseUserExtension on User {
  UserInfo toUserInfo({
    required String name,
    required String nickname,
  }) {
    return UserInfo(
      uid: uid,
      name: name,
      nickname: nickname,
      profileUrl: photoURL,
    );
  }
}
