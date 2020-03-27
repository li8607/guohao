import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:guohao/repositorys/lever/lever.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:guohao/repositorys/user/user.dart';
import 'package:guohao/repositorys/user/user_repository.dart';
import 'package:guohao/tools/LcUtil.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository});

  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is UserLogined) {
      yield* _mapUserLoginedToState(event);
    } else if (event is UserChecked) {
      yield* _mapUserCheckedToState(event);
    } else if (event is UserRegistered) {
      yield* _mapUserRegisteredToState(event);
    } else if (event is UserNicknameUpdated) {
      yield* _mapUserNicknameUpdatedToState(event);
    } else if (event is UserSignUpdated) {
      yield* _mapUserSignUpdatedToState(event);
    } else if (event is UserPasswordUpdated) {
      yield* _mapUserPasswordUpdatedToState(event);
    } else if (event is UserPasswordFromEmailReseted) {
      yield* _mapUserPasswordFromEmailResetedToState(event);
    } else if (event is UserPasswordFromPhoneReseted) {
      yield* _mapUserPasswordFromPhoneResetedToState(event);
    } else if (event is UserPasswordResetPhoneCodeSended) {
      yield* _mapUserPasswordResetPhoneCodeSendedToState(event);
    } else if (event is UserLogouted) {
      yield* _mapUserLogoutedToState(event);
    } else if (event is UserAvatarUpdated) {
      yield* _mapUserAvatarUpdatedToState(event);
    } else if (event is UserLeverUpdated) {
      yield* _mapUserLeverUpdatedToState(event);
    }
  }

  Stream<UserState> _mapUserLeverUpdatedToState(UserLeverUpdated event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      User user;
      try {
        yield UserLeverUpdateInProgress();
        Future.delayed(Duration(milliseconds: 300));
        user = await userRepository.updateLever(event.lever.objectId);
        yield UserLeverUpdateSuccess();
      } catch (e) {
        yield UserLeverUpdateFailure();
      }
      yield currentState.copyWith(user: user);
    }
  }

  Stream<UserState> _mapUserAvatarUpdatedToState(
      UserAvatarUpdated event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      User user;
      try {
        yield UserAvatarUpdateInProgress();
        Future.delayed(Duration(milliseconds: 300));
        user = await userRepository.updateAvatar(event.avatar);
        yield UserAvatarUpdateSuccess();
      } catch (e) {
        yield UserAvatarUpdateFailure();
      }
      yield currentState.copyWith(user: user);
    }
  }

  Stream<UserState> _mapUserLogoutedToState(UserLogouted event) async* {
    try {
      yield UserLogoutInProgress();
      await Future.delayed(Duration(milliseconds: 300));
      await userRepository.logout();
      yield UserLogoutSuccess();
      yield UserInitial();
    } catch (e) {
      yield UserLogoutFailure();
    }
  }

  Stream<UserState> _mapUserPasswordResetPhoneCodeSendedToState(
      UserPasswordResetPhoneCodeSended event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      try {
        yield UserPasswordResetPhoneCodeSendInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await userRepository.sendPhoneCode();
        yield UserPasswordResetPhoneCodeSendSuccess();
      } catch (e) {
        yield UserPasswordResetPhoneCodeSendFailure();
      }
      yield currentState.copyWith();
    }
  }

  Stream<UserState> _mapUserPasswordFromPhoneResetedToState(
      UserPasswordFromPhoneReseted event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      try {
        if (event.newPassword1 != event.newPassword2) {
          throw ArgumentError();
        }
        yield UserPasswordFromPhoneResetInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await userRepository.passwordResetFromPhone(
            event.code, event.newPassword1);
        yield UserPasswordFromPhoneResetSuccess();
      } catch (e) {
        yield UserPasswordFromPhoneResetFailure();
      }
      yield currentState.copyWith();
    }
  }

  Stream<UserState> _mapUserPasswordFromEmailResetedToState(
      UserPasswordFromEmailReseted event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      try {
        yield UserPasswordFromEmailResetInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        await userRepository.passwordResetFromEmail();
        yield UserPasswordFromEmailResetSuccess();
      } catch (e) {
        yield UserPasswordFromEmailResetFailure();
      }
      yield currentState.copyWith();
    }
  }

  Stream<UserState> _mapUserPasswordUpdatedToState(
      UserPasswordUpdated event) async* {
    if (state is UserLoginSuccess) {
      User user;
      var currentState = state as UserLoginSuccess;
      try {
        if (event.newPassword2 != event.newPassword2) {
          throw ArgumentError();
        }
        yield UserPasswordUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        user = await userRepository.resetPasswordFromEmail(
            event.oldPassword, event.newPassword1);
        yield UserPasswordUpdateSuccess();
      } catch (e) {
        yield UserPasswordUpdateFailure();
      }
      yield currentState.copyWith(user: user);
    }
  }

  Stream<UserState> _mapUserSignUpdatedToState(UserSignUpdated event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      User user;
      try {
        yield UserSignUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        user = await userRepository.updateSign(event.sign);
        yield UserSignUpdateSuccess();
      } catch (e) {
        yield UserSignUpdateFailure();
      }
      yield currentState.copyWith(user: user);
    }
  }

  Stream<UserState> _mapUserNicknameUpdatedToState(
      UserNicknameUpdated event) async* {
    if (state is UserLoginSuccess) {
      var currentState = state as UserLoginSuccess;
      User user;
      try {
        yield UserNicknameUpdateInProgress();
        await Future.delayed(Duration(milliseconds: 300));
        user = await userRepository.updateNickname(event.nickname);
        yield UserNicknameUpdateSuccess();
      } catch (e) {
        yield UserNicknameUpdateFailure();
      }
      yield currentState.copyWith(user: user);
    }
  }

  Stream<UserState> _mapUserRegisteredToState(UserRegistered event) async* {
    try {
      yield UserRegisterInProgress();
      await Future.delayed(Duration(milliseconds: 300));
      User user = await userRepository.register(
          event.username, event.password, event.email);
      yield UserRegisterSuccess();
      yield UserLoginSuccess(user: user);
    } catch (e) {
      String message;
      if (e is LCException) {
        message = LcUtil.getErrorMessage(e.code);
      } else {
        message = '注册失败';
      }
      yield UserRegisterFailure(message: message);
    }
  }

  Stream<UserState> _mapUserCheckedToState(UserChecked event) async* {
    try {
      yield UserLoginInProgress();
      await Future.delayed(Duration(milliseconds: 300));
      User user = await userRepository.loginMe();
      yield UserLoginSuccess(user: user);
    } catch (e) {
      yield UserLoginFailure();
    }
  }

  Stream<UserState> _mapUserLoginedToState(UserLogined event) async* {
    try {
      yield UserLoginInProgress();
      await Future.delayed(Duration(milliseconds: 1500));
      User user = await userRepository.login(event.username, event.password);
      yield UserLoginSuccess(user: user);
    } catch (e) {
      yield UserLoginFailure();
    }
  }
}
