# 🧪 TestQuest

**TestQuest**는 게임의 CBT, OBT, 알파 테스트 정보를 한눈에 확인하고 공유할 수 있는 커뮤니티 기반 Flutter 앱입니다.

---

## 🚀 주요 기능

- 📅 게임 테스트 일정 모아보기
- 🔍 CBT/OBT 정보 검색 및 필터링
- 🗣 유저 간 커뮤니티/댓글 기능 (추후 예정)
- 🧭 알림 및 푸시 기능 (예정)

---

## 🛠 사용 기술

| 기술         | 설명                             |
|--------------|----------------------------------|
| Flutter 3.0+ | 크로스 플랫폼 UI 프레임워크            |
| Dart 3.0+    | 타입 안정성과 성능이 강화된 언어         |
| Riverpod 2.x | 상태 관리                          |
| Drift        | 로컬 DB                           |
| Freezed      | 불변 데이터 모델,                    |
| Dio          | HTTP 통신                         |
| json_serializable | JSON 직렬화 자동화             |
| Drift | 저장소                                    |
---

## 📦 프로젝트 구조

```
lib/
 ├── auth/               # 로그인/회원가입
 ├── common/               # 공통 위젯, 설정
 ├── schedule/           # 테스트 일정 관련 로직
 ├── util/               # dio 및 알림, 권한, 
 ├── db/                 # Drift DB 관리
 └── main.dart           # 앱 진입점
```

---

## ▶️ 실행 방법

```bash
# 의존성 설치
flutter pub get

# build_runner로 코드 생성
flutter pub run build_runner build --delete-conflicting-outputs

# 앱 실행
flutter run
```

---

## 📌 환경 파일 (.env)

`.env` 파일은 Git에 포함되지 않습니다. 다음 형식으로 프로젝트 루트에 생성하세요:

```env
BASE_URL=https://your-api.com
```

---

## 📝 라이선스

이 프로젝트는 [Apache 2.0 License](LICENSE)를 따릅니다.

---

## 👨‍💻 개발자

APP - 최준현  
BackEnd - 강찬혁
