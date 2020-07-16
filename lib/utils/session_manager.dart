import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenome/models/User.dart';
import 'date_utils.dart';

enum Login_Status { NEW_USER, LOGGED_IN, LOGGED_OUT }

const String DateFormat = 'yyyy-MM-dd';

class SessionManager {
  static final String KEY_LOGGEDIN = 'logged_in';
  static final String KEY_EMAIL = 'key_email';
  static final String KEY_IMAGE = 'key_image';
  static final String KEY_TELLUSNAME = 'key_tellus_name';
  static final String KEY_USER_ID = 'key_user_id';
  static final String KEY_DATE = 'key_date';
  static final String KEY_GENDER = 'key_gender';
  static final String KEY_DESCRIPTION = 'key_description';
  static final String KEY_FULLNAME = 'key_full_name';
  static final String KEY_WEBSITE = 'key_website';
  static final String KEY_OTHERLINK = 'key_otherlink';
  static final String KEY_PROFESSIONAL = 'key_professional';
  static final String KEY_PERMISSION = 'key_permission';
  static final String KEY_MEDIAHEIGHT = 'key_mediaheight';
  static final String KEY_MEDIAWIDTH = 'key_mediawidth';
  
  static SharedPreferences _sharedPrefs;

  static void initialize(SharedPreferences sharedPreferences) {
    _sharedPrefs = sharedPreferences;
  }

  static Login_Status isLogged() {
    var loggedIn = _sharedPrefs.getString(KEY_LOGGEDIN) ?? false;

    if (loggedIn == 'true') {
      return Login_Status.LOGGED_IN;
    } else {
      return Login_Status.LOGGED_OUT;
    }
  }

  static void saveUserInfoToLocal(User userInfo) {
    SessionManager.setUserId(userInfo.uid);
    SessionManager.setTellUsName(userInfo.tellusname);
    SessionManager.setEmail(userInfo.email);
    SessionManager.setImage(userInfo.image);
    SessionManager.setDescription(userInfo.description);
    SessionManager.setFullname(userInfo.fullname);
    SessionManager.setGender(userInfo.gender);
    SessionManager.setDate(userInfo.birthday);
    SessionManager.setWebsite(userInfo.website);
    SessionManager.setOtherlink(userInfo.otherlink);
    SessionManager.setProfessional(userInfo.professional);
    SessionManager.setPermission(userInfo.permission);
  }

  static bool isLoggin(){
    if(getUserId().isNotEmpty) return true;
    return false;
  }

  static String getUserId() {
    return _sharedPrefs.getString(KEY_USER_ID) ?? '';
  }

  static void setUserId(String userId) {
    _sharedPrefs.setString(KEY_USER_ID, userId);
  }

  static void hasLoggedIn() {
    _sharedPrefs.setString(KEY_LOGGEDIN, 'true');
  }

  static void hasLoggedOut() {
    _sharedPrefs.setString(KEY_LOGGEDIN, 'false');
    handleClearAllSettging();
  }

  static void handleClearAllSettging() {
    setUserId(null);
    setTellUsName('');
    setEmail('');
    setImage('');
    setDate('');
    setDescription('');
    setFullname('');
    setWebsite('');
    setOtherlink('');
    setProfessional('');
  }

  static String getTellUsName() {
    return _sharedPrefs.getString(KEY_TELLUSNAME) ?? '';
  }

  static void setTellUsName(String username) {
    _sharedPrefs.setString(KEY_TELLUSNAME, username);
  }

  static String getEmail() {
    return _sharedPrefs.getString(KEY_EMAIL) ?? '';
  }

  static void setEmail(String email) {
    _sharedPrefs.setString(KEY_EMAIL, email);
  }

  static String getImage() {
    return _sharedPrefs.getString(KEY_IMAGE) ?? '';
  }

  static void setImage(String image) {
    _sharedPrefs.setString(KEY_IMAGE, image);
  }

  static String getDescription() {
    return _sharedPrefs.getString(KEY_DESCRIPTION) ?? '';
  }

  static void setDescription(String description) {
    _sharedPrefs.setString(KEY_DESCRIPTION, description);
  }

  static String getFullname() {
    return _sharedPrefs.getString(KEY_FULLNAME) ?? '';
  }

  static void setFullname(String fullname) {
    _sharedPrefs.setString(KEY_FULLNAME, fullname);
  }

  static String getProfessional() {
    return _sharedPrefs.getString(KEY_PROFESSIONAL) ?? '';
  }

  static void setProfessional(String professional){
    _sharedPrefs.setString(KEY_PROFESSIONAL, professional);
  }
  
  static String getPermission() {
    return _sharedPrefs.getString(KEY_PERMISSION) ?? '';
  }

  static void setPermission(String permission){
    _sharedPrefs.setString(KEY_PERMISSION, permission);
  }

  static Gender getGender() {
    var genderString = _sharedPrefs.getString(KEY_GENDER) ?? '';
    if (genderString == 'male') {
      return Gender.MALE;
    } else if (genderString == 'female') {
      return Gender.FEMALE;
    } else {
      return Gender.MALE;
    }
  }

  static void setGender(Gender gender) {
    var genderString = 'male';
    if (gender == Gender.FEMALE) {
      genderString = 'female';
    }
    _sharedPrefs.setString(KEY_GENDER, genderString);
  }

  static String getWebsite() {
    return _sharedPrefs.getString(KEY_WEBSITE) ?? '';
  }

  static void setWebsite(String website) {
    _sharedPrefs.setString(KEY_WEBSITE, website);
  }

  static String getOtherlink() {
    return _sharedPrefs.getString(KEY_OTHERLINK) ?? '';
  }

  static void setOtherlink(String otherlink) {
    _sharedPrefs.setString(KEY_OTHERLINK, otherlink);
  }

  static String getDate() {
    return _sharedPrefs.getString(KEY_DATE) ??
        DateUtils.getTimeStringWithFormat(
            dateTime: DateTime.now(), format: DateFormat);
  }

  static void setDate(String date) {
    _sharedPrefs.setString(KEY_DATE, date);
  }

  static double getMediaHeight() {
    return _sharedPrefs.getDouble(KEY_MEDIAHEIGHT) ?? 450.0;
  }

  static void setMediaHeight(double height) {
    _sharedPrefs.setDouble(KEY_MEDIAHEIGHT, height);
  }

  static double getMediaWidth() {
    return _sharedPrefs.getDouble(KEY_MEDIAWIDTH) ?? 150.0;
  }

  static void setMediaWidth(double height) {
    _sharedPrefs.setDouble(KEY_MEDIAWIDTH, height);
  }
}
