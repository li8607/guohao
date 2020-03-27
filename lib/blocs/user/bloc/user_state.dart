part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoginInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoginSuccess extends UserState {
  final User user;

  UserLoginSuccess({@required this.user});

  @override
  List<Object> get props => [user];

  UserLoginSuccess copyWith({User user}) {
    return UserLoginSuccess(user: user ?? this.user);
  }
}

class UserLoginFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserRegisterFailure extends UserState {
  final String message;

  UserRegisterFailure({this.message});

  @override
  List<Object> get props => [];
}

class UserRegisterInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserRegisterSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserNicknameUpdateSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserNicknameUpdateFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserNicknameUpdateInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserSignUpdateSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserSignUpdateFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserSignUpdateInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordUpdateSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordUpdateFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordUpdateInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordFromEmailResetInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordFromEmailResetSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordFromEmailResetFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordFromPhoneResetInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordFromPhoneResetSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordFromPhoneResetFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordResetPhoneCodeSendInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordResetPhoneCodeSendSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserPasswordResetPhoneCodeSendFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserLogoutInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserLogoutSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserLogoutFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserAvatarUpdateInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserAvatarUpdateSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserAvatarUpdateFailure extends UserState {
  @override
  List<Object> get props => [];
}

class UserLeverUpdateInProgress extends UserState {
  @override
  List<Object> get props => [];
}

class UserLeverUpdateSuccess extends UserState {
  @override
  List<Object> get props => [];
}

class UserLeverUpdateFailure extends UserState {
  @override
  List<Object> get props => [];
}
