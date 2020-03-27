class LcUtil {
  static String getErrorMessage(int code) {
    String message = "";
    if (code == 125) {
      message = "电子邮箱地址无效";
    } else if (code == 127) {
      message = "手机号码无效";
    } else {
      message = "未知错误";
    }
    return message;
  }
}
