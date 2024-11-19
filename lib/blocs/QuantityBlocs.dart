import 'dart:async';

class QuantityBloc {
  int _quantity = 1;
  final _quantityController = StreamController<int>.broadcast();
  Stream<int> get quantityStream => _quantityController.stream;
  QuantityBloc(){
     _quantityController.sink.add(_quantity);
  }

  void increment() {
    if(_quantity <10){
    _quantity++;
    _quantityController.sink.add(_quantity);
    }
  }
  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      _quantityController.sink.add(_quantity);
    }
  }
  int getQuantity(){
    return _quantity;
  }
  void setQuantity(int newQuantity){
    _quantity = newQuantity;
  }
  void dispose() {
    _quantityController.close();
  }
}
