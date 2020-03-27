part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserLogined extends UserEvent {
  final String username;
  final String password;

  UserLogined({this.username, this.password});

  @override
  List<Object> get props => [];
}

class UserChecked extends UserEvent {
  @override
  List<Object> get props => [];
}

class UserRegistered extends UserEvent {
  final String username;
  final String password;
  final String email;

  UserRegistered({this.username, this.password, this.email});

  @override
  List<Object> get props => [];
}

class UserNicknameUpdated extends UserEvent {
  final String nickname;
  UserNicknameUpdated({this.nickname});

  @override
  List<Object> get props => [nickname];
}

class UserSignUpdated extends UserEvent {
  final String sign;
  UserSignUpdated({this.sign});

  @override
  List<Object> get props => [sign];
}

class UserPasswordUpdated extends UserEvent {
  final String oldPassword;
  final String newPassword1;
  final String newPassword2;

  UserPasswordUpdated({this.oldPassword, this.newPassword1, this.newPassword2});

  @override
  List<Object> get props => [oldPassword, newPassword1, newPassword2];
}

class UserPasswordFromEmailReseted extends UserEvent {
  UserPasswordFromEmailReseted();

  @override
  List<Object> get props => [];
}

class UserPasswordResetPhoneCodeSended extends UserEvent {
  UserPasswordResetPhoneCodeSended();

  @override
  List<Object> get props => [];
}

class UserPasswordFromPhoneReseted extends UserEvent {
  final String code;
  final String newPassword1;
  final String newPassword2;
  UserPasswordFromPhoneReseted(
      {this.code, this.newPassword1, this.newPassword2});

  @override
  List<Object> get props => [code, newPassword1, newPassword2];
}

class UserLogouted extends UserEvent {
  UserLogouted();

  @override
  List<Object> get props => [];
}

class UserAvatarUpdated extends UserEvent {
  final File avatar;

  UserAvatarUpdated({this.avatar});

  @override
  List<Object> get props => [avatar];
}

class UserLeverUpdated extends UserEvent {
  final Lever lever;

  UserLeverUpdated({this.lever});

  @override
  List<Object> get props => [lever];
}
