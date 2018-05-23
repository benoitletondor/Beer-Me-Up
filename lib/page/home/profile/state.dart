import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'model.dart';

class ProfileState extends Union6Impl<
    ProfileStateLoading,
    ProfileStateEmpty,
    ProfileStateLoadNoAllTime,
    ProfileStateLoadNoWeek,
    ProfileStateLoad,
    ProfileStateError> {

  static final Sextet<
      ProfileStateLoading,
      ProfileStateEmpty,
      ProfileStateLoadNoAllTime,
      ProfileStateLoadNoWeek,
      ProfileStateLoad,
      ProfileStateError> factory = Sextet<
      ProfileStateLoading,
      ProfileStateEmpty,
      ProfileStateLoadNoAllTime,
      ProfileStateLoadNoWeek,
      ProfileStateLoad,
      ProfileStateError>();

  ProfileState._(Union6<
      ProfileStateLoading,
      ProfileStateEmpty,
      ProfileStateLoadNoAllTime,
      ProfileStateLoadNoWeek,
      ProfileStateLoad,
      ProfileStateError> union) : super(union);

  factory ProfileState.loading() => ProfileState._(factory.first(ProfileStateLoading()));
  factory ProfileState.empty(bool hasAlreadyCheckedIn) => ProfileState._(factory.second(ProfileStateEmpty(hasAlreadyCheckedIn)));
  factory ProfileState.loadNoAllTime(ProfileData data) => ProfileState._(factory.third(ProfileStateLoadNoAllTime(data)));
  factory ProfileState.loadNoWeek(ProfileData data) => ProfileState._(factory.fourth(ProfileStateLoadNoWeek(data)));
  factory ProfileState.load(ProfileData data) => ProfileState._(factory.fifth(ProfileStateLoad(data)));
  factory ProfileState.error(String error) => ProfileState._(factory.sixth(ProfileStateError(error)));
}

class ProfileStateLoading extends State {}

class ProfileStateLoadNoAllTime extends State {
  final ProfileData profileData;

  ProfileStateLoadNoAllTime(this.profileData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileStateLoadNoAllTime &&
          runtimeType == other.runtimeType &&
          profileData == other.profileData;

  @override
  int get hashCode =>
      super.hashCode ^
      profileData.hashCode;
}

class ProfileStateLoadNoWeek extends State {
  final ProfileData profileData;

  ProfileStateLoadNoWeek(this.profileData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileStateLoadNoWeek &&
              runtimeType == other.runtimeType &&
              profileData == other.profileData;

  @override
  int get hashCode =>
      super.hashCode ^
      profileData.hashCode;
}

class ProfileStateLoad extends State {
  final ProfileData profileData;

  ProfileStateLoad(this.profileData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileStateLoad &&
          runtimeType == other.runtimeType &&
          profileData == other.profileData;

  @override
  int get hashCode =>
      super.hashCode ^
      profileData.hashCode;
}

class ProfileStateEmpty extends State {
  final bool hasAlreadyCheckedIn;

  ProfileStateEmpty(this.hasAlreadyCheckedIn);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProfileStateEmpty &&
          runtimeType == other.runtimeType &&
          hasAlreadyCheckedIn == other.hasAlreadyCheckedIn;

  @override
  int get hashCode =>
      super.hashCode ^
      hasAlreadyCheckedIn.hashCode;
}

class ProfileStateError extends State {
  final String error;

  ProfileStateError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is ProfileStateError &&
        runtimeType == other.runtimeType &&
        error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      error.hashCode;

}