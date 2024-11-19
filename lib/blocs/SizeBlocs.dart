import 'dart:async';

class Sizeblocs {
  int _size = 1;
  final _sizeController = StreamController<int>.broadcast();
  Stream<int> get sizeStream => _sizeController.stream;
  SizeBloc() {
    _sizeController.sink.add(_size);
  }

  void setSizeStr(String newsize) {
    if (newsize == "M")
      _sizeController.sink.add(1);
    else if (newsize == "L")
      _sizeController.sink.add(2);
    else if (newsize == "XL") _sizeController.sink.add(3);
  }

  void setSize(int newsize) {
    _sizeController.sink.add(newsize);
    _size = newsize;
  }

  int getSize() {
    return _size;
  }

  int getNewPrice(int price) {
    return price + (_size - 1) * 10000;
  }

  void dispose() {
    _sizeController.close();
  }
}
