import 'package:app_camara/practica_bloc/models/transactions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountState()) {
    on<AddCashAmount>((event, emit) {
      emit(
        state.copyWith(
          transactions: [...state.transactions, event.transaction],
        ),
      );
    });
  }
}
