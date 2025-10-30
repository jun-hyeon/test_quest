# Firestore 컬렉션 구조

## `users` 컬렉션

문서 ID: Firebase Auth UID

```json
{
  "userId": "string (Firebase Auth UID)",
  "name": "string (사용자 이름)",
  "nickname": "string (닉네임)",
  "profileImg": "string? (프로필 이미지 URL)",
  "email": "string (이메일)",
  "createdAt": "timestamp (생성일)",
  "updatedAt": "timestamp? (수정일)"
}
```

## `posts` 컬렉션

문서 ID: UUID v4

```json
{
  "id": "string (게시글 ID)",
  "title": "string (제목)",
  "userId": "string (작성자 UID)",
  "nickname": "string (작성자 닉네임)",
  "description": "string (설명)",
  "platform": "string (pc|mobile|console)",
  "type": "string (cbt|obt|alpha|beta)",
  "views": "number (조회수)",
  "thumbnailUrl": "string? (썸네일 이미지 URL)",
  "linkUrl": "string (링크 URL)",
  "startDate": "timestamp (시작일)",
  "endDate": "timestamp (종료일)",
  "createdAt": "timestamp (생성일)",
  "updatedAt": "timestamp? (수정일)",
  "recruitStatus": "string (모집중|모집마감)"
}
```

## Firebase Storage 구조

```
users/
  {userId}/
    profile_{uuid}.jpg (프로필 이미지)

posts/
  {postId}/
    image_{uuid}.jpg (게시글 이미지)
```

## 인덱스 설정

### `posts` 컬렉션 인덱스

1. **복합 인덱스**: `createdAt` (desc) + `title` (asc)
2. **복합 인덱스**: `userId` (asc) + `createdAt` (desc)
3. **단일 인덱스**: `platform` (asc)
4. **단일 인덱스**: `type` (asc)
5. **단일 인덱스**: `recruitStatus` (asc)

### `users` 컬렉션 인덱스

1. **단일 인덱스**: `email` (asc)
2. **단일 인덱스**: `nickname` (asc)
