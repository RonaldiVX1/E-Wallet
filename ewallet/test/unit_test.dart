import 'package:ewallet/models/sign_in_form_model.dart';
import 'package:ewallet/models/sign_up_form_model.dart';
import 'package:ewallet/models/topup_form_model.dart';
import 'package:ewallet/models/transfer_form_model.dart';
import 'package:ewallet/models/user_edit_form_model.dart';
import 'package:ewallet/models/user_model.dart';
import 'package:ewallet/services/auth_service.dart';
import 'package:ewallet/services/transaction_service.dart';
import 'package:ewallet/services/wallet_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockImagePicker extends Mock implements ImagePicker {}

@GenerateMocks([http.Client])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late AuthService authService;
  late TransactionService transactionService;
  late WalletService walletService;

  String imageTest = 'data:image/png;base64,/inigambar';

  /* my account
  praktikum@praktikum.com
  12345678
  ---------------------------
  my_wallet@unittest.com
  12345678
  ----------------------------
  edit_profile@unittest.com
  12345678

  */

  String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYndhYmFuay5teS5pZFwvYXBpXC9sb2dpbiIsImlhdCI6MTY5ODY2ODQ2MywiZXhwIjoxNjk4NjcyMDYzLCJuYmYiOjE2OTg2Njg0NjMsImp0aSI6IjExdm1nRWNYQWRHMXVKQkQiLCJzdWIiOjEzMTIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.frFiGCtrLcjtr75EZd9QG06BkdUcmBMXfdO-HxcPbpQ';

  String tokenEditProfile =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYndhYmFuay5teS5pZFwvYXBpXC9sb2dpbiIsImlhdCI6MTY5ODY2ODYxOCwiZXhwIjoxNjk4NjcyMjE4LCJuYmYiOjE2OTg2Njg2MTgsImp0aSI6IkRNMEdWUURtc1A5YlFaMTIiLCJzdWIiOjEzMzIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.z7qtwHIcagCqZ-U9uCQScH_Izdsqw4sHSWXnVNjT0Mc';

  setUp(() {
    authService = AuthService();
    transactionService = TransactionService();
    walletService = WalletService();
  });

  var expectedErrorNull = "type \'Null\' is not a subtype of type \'String\' in type cast";

  group('Login', () {
    test('when login Email is null and return failed', () async {
      const expectedResult = '{email: [The email field is required.]}';

      final signInModel = SignInFormModel(email: '', password: '12345678');

      try {
        await authService.testLogin(signInModel);
        // If no error is thrown, fail the test
        fail('Expected an error, but none was thrown.');
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when login Password is null and return failed', () async {
      const expectedResult = '{password: [The password field is required.]}';

      final signInModel = SignInFormModel(email: 'praktikum@praktikum.com', password: '');

      try {
        await authService.testLogin(signInModel);
        // If no error is thrown, fail the test
        fail('Expected an error, but none was thrown.');
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when Login data is valid and return success', () async {
      final signInModel = SignInFormModel(email: 'praktikum@praktikum.com', password: '12345678');

      final userModel = await authService.testLogin(signInModel);
      expect(userModel, isNotNull);
      expect(userModel, isA<UserModel>());
    });

    test('when Login data is invalid and return failed', () async {
      const expectedResult = 'Login credentials are invalid';

      final signInModel = SignInFormModel(email: 'praktikum@praktikum.com', password: '11111111');

      try {
        await authService.testLoginInvalidData(signInModel);
        // If no error is thrown, fail the test
        fail('Expected an error, but none was thrown.');
      } catch (error) {
        expect(error, expectedResult);
      }
    });
  });

  group('Register', () {
    test('when Register data valid and return success', () async {
      final signUp = SignUpFormModel(
        name: "test",
        email: 'edit_profile16@unittest.com',
        password: '12345678',
        pin: '111111',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      final user = await authService.testRegister(signUp);
      expect(user, isA<UserModel>());
    });

    test('when Register data invalid and return failed', () async {
      const expectedResult = 'Email already taken';

      final signUp = SignUpFormModel(
        name: "test",
        email: 'unit_test@percobaanke1.com',
        password: '12345678',
        pin: '111111',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      try {
        await authService.register(signUp);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when Register username is null and return failed', () async {
      const expectedResult = '{name: [The name field is required.]}';

      final signUp = SignUpFormModel(
        name: "",
        email: 'unit_test@unittest.com',
        password: '12345678',
        pin: '111111',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when Register email is null and return failed', () async {
      const expectedResult = '{email: [The email field is required.]}';

      final signUp = SignUpFormModel(
        name: "unitTest",
        email: '',
        password: '12345678',
        pin: '111111',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when Register password is null and return failed', () async {
      const expectedResult = '{password: [The password field is required.]}';

      final signUp = SignUpFormModel(
        name: "unitTest",
        email: 'unit_test@unittest.com',
        password: '',
        pin: '111111',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when Register pin is null and return failed', () async {
      const expectedResult = '{pin: [The pin field is required.]}';

      final signUp = SignUpFormModel(
        name: "unitTest",
        email: 'unit_test@unittest.com',
        password: '12345678',
        pin: '',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when Register profilePicture is null and return failed', () async {
      final signUp = SignUpFormModel(
        name: "unitTest",
        email: 'unit_test@unittest.com',
        password: '12345678',
        pin: '111111',
        profilePicture: null,
        ktp: imageTest,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedErrorNull);
      }
    });

    test('when Register ktp is null and return failed', () async {
      final signUp = SignUpFormModel(
        name: "unitTest",
        email: 'unit_test@unittest@gmail.com',
        password: '12345678',
        pin: '111111',
        profilePicture: imageTest,
        ktp: null,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedErrorNull);
      }
    });

    test('when Register password is less than 6 and return failed', () async {
      const expectedResult = '{password: [The password must be at least 6 characters.]}';

      final signUp = SignUpFormModel(
        name: "unitTest",
        email: 'unit_test@unittest.com',
        password: '12345',
        pin: '111111',
        profilePicture: imageTest,
        ktp: imageTest,
      );

      try {
        await authService.testRegister(signUp);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });
  });

  group('Top up', () {
    test("when Top up data is valid must return success", () async {
      final body = TopupFormModel(amount: "15000", pin: "111111", paymentMethodCode: "bri_va");

      try {
        await transactionService.testTopUp(body, token);
      } catch (error) {
        // expect(error, expectedResult);
      }
    });

    test("when Top up data is invalid must return failed", () async {
      final body = TopupFormModel(amount: "15000", pin: "1111", paymentMethodCode: "bri_va");
      final expectedResult = {
        'pin': ['The pin must be 6 digits.']
      };

      try {
        await transactionService.testTopUp(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });

    test("when Top up amount is less than 100000 must return failed", () async {
      final body = TopupFormModel(amount: "200", pin: "111111", paymentMethodCode: "bri_va");
      final expectedResult = {
        'amount': ['The amount must be at least 10000.']
      };

      try {
        await transactionService.testTopUp(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });

    test("when Top up pin is invalid must return failed", () async {
      final body = TopupFormModel(amount: "15000", pin: "000000", paymentMethodCode: "bri_va");
      const expectedResult = 'Your PIN is wrong';

      try {
        await transactionService.testTopUpWrongPin(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });
  });

  group('Transfer', () {
    test("when Transfer data is valid must return success", () async {
      const expectedResult = 'Transfer Success';

      final body = TransferFormModel(amount: '15000', pin: '111111', sendTo: 'target_transfer@unittest.com');

      final transferResponse = await transactionService.testTransfer(body, token);

      expect(transferResponse, expectedResult);
    });

    test("when Transfer data is invalid must return failed", () async {
      final body = TransferFormModel(amount: '15000', pin: '1111', sendTo: 'target_transfer@unittest.com');
      final expectedResult = {
        'pin': ['The pin must be 6 digits.']
      };

      try {
        await transactionService.testTransfer(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });

    test("when Transfer user is not found must return failed", () async {
      final body = TransferFormModel(amount: '20000', pin: '111111', sendTo: 'target_transfer2@unittest.com');
      const expectedResult = 'User receiver not found';

      try {
        await transactionService.testTransferWrongPin(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });

    test("when Transfer amount is less than 1000 must return failed", () async {
      final body = TransferFormModel(amount: '200', pin: '111111', sendTo: 'target_transfer@unittest.com');
      final expectedResult = {
        'amount': ['The amount must be at least 1000.']
      };

      try {
        await transactionService.testTransfer(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });

    test("when Top up pin is invalid must return failed", () async {
      final body = TransferFormModel(amount: '20000', pin: '000000', sendTo: 'target_transfer@unittest.com');
      const expectedResult = 'Your PIN is wrong';

      try {
        await transactionService.testTransferWrongPin(body, token);
      } catch (error) {
        expect(error, expectedResult);
      }
    });
  });

  group('edit profile', () {
    test('when edit profile data is valid must return success', () async {
      const expectedResult = 'Updated';

      final data = UserEditFormModel(username: 'newname', name: 'my_new_name', email: 'edit_profile@unittest.com', password: '12345678', pin: '111111');

      final response = await authService.testUpdateUser(data, tokenEditProfile);

      expect(response, expectedResult);
    });

    test('when edit profile data is null must return success', () async {
      final data = UserEditFormModel(username: null, name: null, email: null, password: null, pin: null);

      try {
        await authService.testUpdateUser(data, tokenEditProfile);
      } catch (error) {
        expect(error.toString(), expectedErrorNull);
      }
    });

    test('when edit profile pin is invalid must return failed', () async {
      final data = UserEditFormModel(
        username: 'newname111',
        name: 'my_new_name',
        email: 'edit_profile@unittest.com',
        password: '12345678',
        pin: null,
      );

      try {
        await authService.testUpdateUser(data, tokenEditProfile);
      } catch (error) {
        expect(error.toString(), expectedErrorNull);
      }
    });

    test('when edit profile data is invalid must return failed', () async {
      const expectedResult = 'Username already taken';

      final data = UserEditFormModel(
        username: 'editprofiletest',
        name: 'my_new_name',
        email: 'edit_profile@unittest@aaaa.com',
        password: '12345678',
        pin: '111111',
      );

      try {
        await authService.testUpdateUser(data, tokenEditProfile);
      } catch (error) {
        expect(error, expectedResult);
      }
    });
  });

  group('edit pin', () {
    test('when edit pin data is valid must return success', () async {
      const expectedResult = 'Pin updated';

      final response = await walletService.testUpdatePin('111111', '111111', tokenEditProfile);

      expect(response, expectedResult);
    });

    test('when edit pin data is null must return success', () async {
      const expectedResult = '{previous_pin: [The previous pin field is required.], new_pin: [The new pin field is required.]}';

      try {
        await walletService.testUpdatePin('', '', tokenEditProfile);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when edit pin, pin is invalid must return failed', () async {
      const expectedResult = 'Your Old Pin is Wrong';

      try {
        await walletService.testUpdatePinWrongData('000000', '111111', tokenEditProfile);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });

    test('when edit pin, pin is less than 6 must return failed', () async {
      const expectedResult = '{new_pin: [The new pin must be 6 digits.]}';

      try {
        await walletService.testUpdatePin('000000', '12345', tokenEditProfile);
      } catch (error) {
        expect(error.toString(), expectedResult);
      }
    });
  });
}
