import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'model.dart';

class ProfileState extends Union3Impl<
    ProfileStateLoading,
    ProfileStateLoad,
    ProfileStateError> {

  static final Triplet<
      ProfileStateLoading,
      ProfileStateLoad,
      ProfileStateError> factory = const Triplet<
      ProfileStateLoading,
      ProfileStateLoad,
      ProfileStateError>();

  ProfileState._(Union3<
      ProfileStateLoading,
      ProfileStateLoad,
      ProfileStateError> union) : super(union);

  factory ProfileState.loading() => ProfileState._(factory.first(ProfileStateLoading()));
  factory ProfileState.load(ProfileData data) => ProfileState._(factory.second(ProfileStateLoad(data)));
  factory ProfileState.error(String error) => ProfileState._(factory.third(ProfileStateError(error)));
}

class ProfileStateLoading extends State {}

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