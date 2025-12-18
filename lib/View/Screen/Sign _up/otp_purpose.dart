enum OtpPurpose {
  emailVerify,
  phoneVerify,
  loginOtp,
  passwordReset,
  numberChange,
  biometricEnable,
}

extension OtpPurposeX on OtpPurpose {
  String get value {
    switch (this) {
      case OtpPurpose.emailVerify:
        return "email_verify";
      case OtpPurpose.phoneVerify:
        return "phone_verify";
      case OtpPurpose.loginOtp:
        return "login_otp";
      case OtpPurpose.passwordReset:
        return "password_reset";
      case OtpPurpose.numberChange:
        return "number_change";
      case OtpPurpose.biometricEnable:
        return "biometric_enable";
    }
  }
}
