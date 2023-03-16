abstract class DialNumberPageEvent {}

class InitEvent extends DialNumberPageEvent {}

class NumberChanged extends DialNumberPageEvent {

  final String number;

  NumberChanged(this.number);

}

///刷新
class RefreshEvent extends DialNumberPageEvent {}
