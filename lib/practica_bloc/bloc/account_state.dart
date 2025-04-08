part of 'account_bloc.dart';

class AccountState extends Equatable {
  final double balance;
  final List<Transactions> transactions;

  const AccountState({this.balance = 0, this.transactions = const []});
  @override
  List<Object> get props => [balance, transactions];

  AccountState copyWith({double? balance, List<Transactions>? transactions}) =>
      AccountState(
        transactions: transactions ?? this.transactions,
        balance: balance ?? this.balance,
      );
}
