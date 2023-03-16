abstract class LoginPageEvent {}

class InitEvent extends LoginPageEvent {}

class LoginNameChanged extends LoginPageEvent {

  final String name;

  LoginNameChanged(this.name);

}

class LoginPasswordChanged extends LoginPageEvent {

  final String password;

  LoginPasswordChanged(this.password);

}

///刷新
class RefreshEvent extends LoginPageEvent {}

///释放
class ResetEvent extends LoginPageEvent {}