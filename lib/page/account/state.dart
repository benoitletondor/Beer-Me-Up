import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

class AccountState extends Union2Impl<AccountStateLoading, AccountStateAccount> {

  static final Doublet<AccountStateLoading, AccountStateAccount> factory
    = const Doublet<AccountStateLoading, AccountStateAccount>();

  AccountState._(Union2<AccountStateLoading, AccountStateAccount> union) : super(union);

  factory AccountState.loading() => AccountState._(factory.first(AccountStateLoading()));
  factory AccountState.account(String email, String name) => AccountState._(factory.second(AccountStateAccount(email, name)));
}

class AccountStateLoading extends State {}

class AccountStateAccount extends State {
  final String email;
  final String name;

  AccountStateAccount(this.email, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is AccountStateAccount &&
        runtimeType == other.runtimeType &&
        email == other.email &&
        name == other.name;

  @override
  int get hashCode =>
      super.hashCode ^
      email.hashCode ^
      name.hashCode;
}