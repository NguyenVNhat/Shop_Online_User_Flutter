import 'package:flutter_user_github/data/repository/Chart_repo.dart';
import 'package:flutter_user_github/models/Model/ChartModel.dart';
import 'package:flutter_user_github/models/Model/Messagemodel.dart';
import 'package:get/get.dart';

class ChartController extends GetxController implements GetxService {
  final ChartRepo chartRepo;
  var IsLogin = false.obs;
  ChartController({
    required this.chartRepo,
  });

  // **************************************************************************** Khai báo biến

  // * load dữ liệu danh sách người nhắn tin
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //* load tin nhắn
  bool _isLoadingMessage = false;
  bool get getisLoadingMessage => _isLoadingMessage;

  // * danh sách người nhắn tin
  List<UserChart> listUser = [];
  List<UserChart> get getlistuser => listUser;

  // * danh sách tin nhắn với người dùng
  List<Usermessage> listUsermesage = [];
  List<Usermessage> get getlistusermesage => listUsermesage;

  // * tên của cuộc hội thoại
  String chartname = "Chart time";
  String get getchartname => chartname;

  // * người nhận tin nhắn
  int _idreceiver = 0;
  int get getidreceiver => _idreceiver;

  // * hiện tin nhắn với người dùng
  bool _isShow = true;
  bool get isShow => _isShow;

   // * Hết khai báo biến ------------------------------------------------------------------------


  // **************************************************************************** Khai báo hàm

  Future<void> getall() async{
      Response response = await chartRepo.getChart();
      if(response.statusCode == 200){
          var data = response.body;
           listUser = [];
          listUser.addAll(Chartmodel.fromJson(data).getlistuser ?? []);
      }
      update();
  }

  Future<void> getlistmessage(int idreceiver) async{
      _isLoadingMessage = true;
      Response response = await chartRepo.getlistChart(idreceiver);
      if(response.statusCode == 200){
          var data = response.body;
          listUsermesage = [];
          listUsermesage.addAll(Messagemodel.fromJson(data).getlistmessage ?? []);
          _idreceiver = idreceiver;
      }
     _isLoadingMessage = false;
      update();
  }

  Future<void> senImage(int idsender,int idreceiver,String image) async{
    Response response = await chartRepo.sendImage(idsender, idreceiver, image);
    if(response.statusCode == 200){
      print("Save image successfully");
    }
    else{
      print("Save image failed");
    }
  }

  void ChangeShow() {
    _isShow = !_isShow;
    update();
  }
  
  void updatechartname(String newvalue){
    chartname = newvalue;
    update();
  }

  

}
