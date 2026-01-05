import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_quest/auth/view/login_screen.dart';
import 'package:test_quest/repository/firebase/auth/firebase_auth_repository_impl.dart';
import 'package:test_quest/repository/firebase/user/user_firestore_repository.dart';
import 'package:test_quest/util/service/permission_service.dart';

// Generate Mocks
@GenerateNiceMocks([
  MockSpec<PermissionService>(),
  MockSpec<FirebaseAuthRepositoryImpl>(),
  MockSpec<UserFirestoreRepositoryImpl>(),
])
import 'login_screen_test.mocks.dart';

void main() {
  late MockPermissionService mockPermissionService;
  late MockFirebaseAuthRepositoryImpl mockAuthRepository;
  late MockUserFirestoreRepositoryImpl mockUserRepository;

  setUp(() {
    mockPermissionService = MockPermissionService();
    mockAuthRepository = MockFirebaseAuthRepositoryImpl();
    mockUserRepository = MockUserFirestoreRepositoryImpl();

    // Setup default stubbing
    when(mockPermissionService.requestTrackingPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(mockPermissionService.requestNotificationPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
        
    // AuthNotifier calls authStateChanges on build
    when(mockAuthRepository.authStateChanges())
        .thenAnswer((_) => Stream.value(null));
  });

  testWidgets('Apple Login button is present in LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          permissionProvider.overrideWithValue(mockPermissionService),
          firebaseAuthRepositoryProvider.overrideWithValue(mockAuthRepository),
          userFirestoreRepositoryProvider.overrideWithValue(mockUserRepository),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Google Login Button exists
    expect(find.text('Google 계정으로 로그인'), findsOneWidget);

    // Verify Apple Login Button exists (Our new feature)
    expect(find.text('Apple 계정으로 로그인'), findsOneWidget);
    
    // Verify icon presence
    expect(find.byIcon(Icons.apple), findsOneWidget);
  });
}
