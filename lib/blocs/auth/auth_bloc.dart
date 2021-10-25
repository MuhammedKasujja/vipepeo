import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vipepeo_app/data/repo.dart';
import 'package:vipepeo_app/models/models.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _repo = Repository();
  AuthBloc()
      : super(const AuthState(
          status: AppStatus.init,
          success: false,
        )) {
    on<Login>((event, emit) async {
      emit(state.load());
      try {
        var res =
            await _repo.login(email: event.email, password: event.password);
        emit(state.loaded(message: res.message, data: res.data));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<Register>((event, emit) async {
      emit(state.load());
      try {
        var res = await _repo.register(
          email: event.email,
          password: event.password,
          city: event.city,
          name: event.name,
          country: event.country,
        );
        emit(state.loaded());
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddChild>((event, emit) async {
      emit(state.load());
      try {
        var res = await _repo.addChild(
          firstname: event.firstname,
          lastname: event.lastname,
          dob: event.dob,
          gender: event.gender,
          conditions: event.conditions,
        );
        emit(state.loaded(message: res.message, success: res.success));
        if (res.success) add(GetUserProfile());
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<AddProfession>((event, emit) async {
      emit(state.load());
      try {
        final res = await _repo.addProfession();
        emit(state.loaded(
          message: res.message,
          success: res.success,
        ));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<Logout>((event, emit) async {
      emit(state.load());
      try {
        await _repo.logout();
        emit(state.init());
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
    on<GetUserProfile>((event, emit) async {
      emit(state.load());
      try {
        var user = await _repo.getUserProfile();
        emit(state.loaded(data: user));
      } catch (error) {
        emit(state.failure(error: error.toString()));
      }
    });
  }
}
