import 'package:sealed_unions/sealed_unions.dart';

class AccountState extends Union1Impl<AccountStateAccount> {

  static final Singlet<AccountStateAccount> factory
    = const Singlet<AccountStateAccount>();

  AccountState._(Union1<AccountStateAccount> union) : super(union);

  factory AccountState.account() => new AccountState._(factory.first(new AccountStateAccount()));
}

class AccountStateAccount {}