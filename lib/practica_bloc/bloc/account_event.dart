part of 'account_bloc.dart';

sealed class AccountEvent {
  const AccountEvent();
}

//Por cada evento, se crea una nueva clase
class AddCashAmount extends AccountEvent {
  final Transactions transaction;
  const AddCashAmount(this.transaction);
}

class AddTransaction extends AccountEvent {
  final Transactions transaction;
  const AddTransaction(this.transaction);
}

//Se agregara la practica para el miercoles
//Debe funcionar
