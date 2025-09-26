# 🧪 TestQuest (개발 중)

**TestQuest**는 게임의 CBT, OBT, 알파 테스트 정보를 한눈에 확인하고 공유할 수 있는 커뮤니티 기반 Flutter 앱입니다.

---

## 📱 앱 미리보기

<details>
<summary>🌙 다크 테마 (클릭하여 펼치기)</summary>

| 스플래시 | 로그인 |
|---------|--------|
| <img src="assets/screenshots/test_quest_splash_screen_dark_theme.gif" width="300"/> | <img src="assets/screenshots/test_quest_login_dark_theme.png" width="300"/> |

| 회원가입 1 | 회원가입 2 |
|-----------|-----------|
| <img src="assets/screenshots/test_quest_signup_dark_theme.png" width="300"/> | <img src="assets/screenshots/test_quest_signup_2_dark_theme.png" width="300"/> |

| 캘린더 | 캘린더 업로드 |
|--------|-------------|
| <img src="assets/screenshots/test_quest_calendar_dark_theme.png" width="300"/> | <img src="assets/screenshots/test_quest_calendar_upload_dark.gif" width="300"/> |

| 커뮤니티 | 마이페이지 |
|---------|-----------|
| <img src="assets/screenshots/test_quest_community_dark.gif" width="300"/> | <img src="assets/screenshots/test_quest_mypage_dark.png" width="300"/> |

| 설정 | 프로필 수정 |
|------|-----------|
| <img src="assets/screenshots/test_quest_settings_dark.png" width="300"/> | <img src="assets/screenshots/test_quest_profile_edit_dark.png" width="300"/> |

| 일정 관리 | 글쓰기 |
|---------|-------|
| <img src="assets/screenshots/test_quest_schedule_dark.gif" width="300"/> | <img src="assets/screenshots/test_quest_write_dark.gif" width="300"/> |

| 글쓰기 2 | 글 상세보기 |
|---------|-----------|
| <img src="assets/screenshots/test_quest_write_2_dark.gif" width="300"/> | <img src="assets/screenshots/test_quest_detail_dark.png" width="300"/> |

</details>

<details>
<summary>☀️ 라이트 테마 (클릭하여 펼치기)</summary>

| 스플래시 | 로그인 |
|---------|--------|
| <img src="assets/screenshots/test_quest_splash_screen_light_theme.gif" width="300"/> | <img src="assets/screenshots/test_quest_login_light_theme.png" width="300"/> |

| 회원가입 1 | 회원가입 2 |
|-----------|-----------|
| <img src="assets/screenshots/test_quest_signup_light_theme.png" width="300"/> | <img src="assets/screenshots/test_quest_signup_2_light_theme.png" width="300"/> |

| 캘린더 | 캘린더 업로드 |
|--------|-------------|
| <img src="assets/screenshots/test_quest_calendar_light_theme.png" width="300"/> | <img src="assets/screenshots/test_quest_calendar_upload_light.gif" width="300"/> |

| 커뮤니티 | 마이페이지 |
|---------|-----------|
| <img src="assets/screenshots/test_quest_community_light.gif" width="300"/> | <img src="assets/screenshots/test_quest_mypage_light.png" width="300"/> |

| 설정 | 프로필 수정 |
|------|-----------|
| <img src="assets/screenshots/test_quest_settings_light.png" width="300"/> | <img src="assets/screenshots/test_quest_profile_edit_light.png" width="300"/> |

| 일정 관리 | 글쓰기 |
|---------|-------|
| <img src="assets/screenshots/test_quest_schedule_light.gif" width="300"/> | <img src="assets/screenshots/test_quest_write_light.gif" width="300"/> |

| 글쓰기 2 | 글 상세보기 |
|---------|-----------|
| <img src="assets/screenshots/test_quest_write_2_light.gif" width="300"/> | <img src="assets/screenshots/test_quest_detail_light.png" width="300"/> |

</details>

## 🚀 주요 기능

- 📅 게임 테스트 일정 모아보기 
- 🔍 CBT/OBT 정보 검색 및 필터링 
- 🗣 유저 간 커뮤니티 
- 🧭 알림 및 푸시 기능 

---

## 🛠 사용 기술

| 기술         | 설명                             |
|--------------|----------------------------------|
| Flutter 3.0+ | 크로스 플랫폼 UI 프레임워크            |
| Dart 3.0+    | 타입 안정성과 성능이 강화된 언어         |
| Riverpod 3.x | 상태 관리                          |
| Drift        | 로컬 DB                           |
| Freezed      | 불변 데이터 모델,                    |
| Dio          | HTTP 통신                         |
| json_serializable | JSON 직렬화 자동화             |
---

## 📦 프로젝트 구조

```
lib
 ├── auth            # 사용자의 권한 확인
 ├── common          # 공통 위젯, 설정
 ├── community       # 게시판 글 관련 화면 및 로직
 ├── mypage          # 사용자 프로필 관련 화면 및 로직
 ├── schedule        # 테스트 일정 관련 화면 및 로직
 ├── settings        # 설정 화면 및 로직
 ├── theme           # 테마 및 컬러
 ├── user            # 로그인/회원가입
 ├── util            # dio 및 알림, 권한 service모음 
 └── main.dart           # 앱 진입점
```

---


## 👨‍💻 개발자

APP - 최준현  
BackEnd - [강찬혁](https://github.com/ChanHyeokKang99)