import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Login_Status { NEW_USER, LOGGED_IN, LOGGED_OUT }

class AppModel extends Model {
  final SharedPreferences _sharedPrefs;

  static final String KEY_LOGGEDIN = 'logged_in';
  static final String KEY_PASSWORD = 'key_password';
  static final String KEY_AGE = 'key_age';
  static final String KEY_GENDER = 'key_gender';
  static final String KEY_EMAIL = 'key_email';
  static final String KEY_USERNAME = 'key_user_name';

  AppModel(this._sharedPrefs);

  // Determine The User Loging Status
  Login_Status isLogged() {
    var loggedIn = _sharedPrefs.getString(KEY_LOGGEDIN) ?? '';

    if (loggedIn == 'true') {
      return Login_Status.LOGGED_IN;
    } else if (loggedIn == 'false') {
      return Login_Status.LOGGED_OUT;
    } else if (loggedIn == '') {
      return Login_Status.NEW_USER;
    } else {
      return Login_Status.NEW_USER;
    }
  }

  void showLoadingDialog() {}
}
