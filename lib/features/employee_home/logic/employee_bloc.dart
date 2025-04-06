import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/employee.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  EmployeesBloc() : super(EmployeesEmpty()) {
    on<EmployeesFetchEvent>(
        (event, emit) async => await _fetchCategoricalEmployees(event, emit));

    on<AddEmployeeEvent>((event, emit) {});

    on<DeleteEmployeeEvent>((event, emit) {});

    on<UpdateEmployeeEvent>((event, emit) {});
  }

  _fetchCategoricalEmployees(EmployeesFetchEvent ev, Emitter emit) async {
    await Future.delayed(const Duration(seconds: 2));

    emit(EmployeesEmpty());
  }
}
