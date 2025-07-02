// ignore: constant_identifier_names
const ACCESS_TOKEN_KEY = 'accessToken';
// ignore: constant_identifier_names
const REFRESH_TOKEN_KEY = 'refreshToken';

String formatToYMD(DateTime dateTime) {
  return '${dateTime.year}년 ${dateTime.month.toString().padLeft(2, '0')}월 ${dateTime.day.toString().padLeft(2, '0')}일';
}
