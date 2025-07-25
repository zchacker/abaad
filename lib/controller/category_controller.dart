import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/body/filter_body.dart';
import 'package:abaad/data/model/response/category_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/facilities_model.dart';
import 'package:abaad/data/repository/category_repo.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  List<CategoryModel>? _categoryList;

  List<FacilitiesModel>? _facilitiesList = [];
  List<OtherAdvantages>? _advanList = [];
  List<CategoryModel>? _subCategoryList = [];
  List<Estate>? _categoryRestList = [];
  List<Property>? _propertiesRestList = [];
  final List<Estate> _searchEstList = [];
  List<bool>? _interestSelectedList = [];
  List<bool>? _advanSelectedList = [];
  int _subCategoryIndex = 0;
  final int _filterIndex = 0;
  List<Estate>? _categoryProductList = [];
  EstateModel? _estateModel;
  Estate? _estate;

  List<FilterBody>? _filterList;

  bool _isLoading = false;
  int? _pageSize;
  int? _estPageSize;
  bool _isSearching = false;
  final String _type = 'all';
  bool _isEstates = false;
  final String _searchText = '';
  final int _offset = 1;
  final String _nameCityIndex = "";


  List<CategoryModel>? get categoryList => _categoryList;
  List<FacilitiesModel>? get facilitiesList => _facilitiesList;
  List<OtherAdvantages>? get advanList => _advanList;
  List<Estate>? get categoryRestList => _categoryRestList;
  List<Estate> get searchEstList => _searchEstList;
  List<bool>? get interestSelectedList => _interestSelectedList;
  List<bool>? get advanSelectedList => _advanSelectedList;
  bool get isLoading => _isLoading;
  int? get pageSize => _pageSize;
  int? get esttPageSize => _estPageSize;
  bool get isSearching => _isSearching;
  String get type => _type;
  bool get isRestaurant => _isEstates;
  String get searchText => _searchText;
  List<Property>? get proRestListp => _propertiesRestList;
  int get offset => _offset;
  int get subCategoryIndex => _subCategoryIndex;
  List<Estate>? get categoryProductList => _categoryProductList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  int get filterIndex => _filterIndex;

  List<FilterBody>? get filterList => _filterList;

  String get nameCityIndex => _nameCityIndex;
  EstateModel? get estateModel => _estateModel;
  Estate? get estate => _estate;




  List<OtherAdvantages> advanLists = []; // Assuming you have a list of OtherAdvantages
  List<bool> advanSelectedLists = []; // Initial

  Future<void> getCategoryList(bool reload) async {

    if(reload) {
      Response response = await categoryRepo.getCategoryList();
      if (response.statusCode == 200) {

        _categoryList = [];
        // _interestSelectedList = [];
        response.body.forEach((category) {
          _categoryList?.add(CategoryModel.fromJson(category));
          _isLoading=false;
          // _interestSelectedList.add(false);

        });
      } else {
        ApiChecker.checkApi(response, showToaster: true);
      }
      update();
    }
  }



  Future<void> getFacilitiesList(bool reload) async {

    if(reload) {
      Response response = await categoryRepo.getFacilities();
      if (response.statusCode == 200) {

        _facilitiesList = [];
        _interestSelectedList = [];
        response.body.forEach((category) {
          _facilitiesList?.add(FacilitiesModel.fromJson(category));
          _interestSelectedList?.add(false);

        });
      } else {
        ApiChecker.checkApi(response, showToaster: true);
      }
      update();
    }
  }

  Future<void> getAdvantages(bool reload) async {

    if(reload) {
      Response response = await categoryRepo.getAdvantages();
      if (response.statusCode == 200) {

        _advanList = [];
        _advanSelectedList = [];
        response.body.forEach((category) {
          _advanList?.add(OtherAdvantages.fromJson(category));
          _advanSelectedList?.add(false);
        });
      } else {
        ApiChecker.checkApi(response, showToaster: true);
      }
      update();
    }
  }





  void getPropertiesList(int categoryID) async {

    Response response = await categoryRepo.getProperties(categoryID);
    if (response.statusCode == 200) {

      // _propertiesRestList.add(Property.fromJson(response.body));
      // //print("musa abdalll ${response.body}");
      // _isLoading = false;


      _propertiesRestList = [];
      // _interestSelectedList = [];
      response.body.forEach((category) {
        _propertiesRestList?.add(Property.fromJson(category));
        // _interestSelectedList.add(false);

      });

    } else {
      ApiChecker.checkApi(response, showToaster: true);
    }
    update();
  }




  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void addInterestSelection(int index) {
    _interestSelectedList?[index] = !_interestSelectedList![index];
    update();
  }


  void addAdvantSelection(int index) {
    _advanSelectedList?[index] = !_advanSelectedList![index];
    update();
  }


  void updateAdvantSelection(int index) {
    _advanSelectedList?[index] = !_advanSelectedList![index];
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isEstates = isRestaurant;
    update();
  }


  void getSubCategoryList(String categoryID) async {
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    _subCategoryIndex = 0;
    _subCategoryList = null;
    _categoryProductList = null;
    Response response = await categoryRepo.getCategoryList();
    if (response.statusCode == 200) {
      _isLoading = false;
      _subCategoryList= [];
      _subCategoryList?.add(CategoryModel(id: int.parse(categoryID),nameAr: 'الكل', name: '', slug: '', position: '', statusHome: '', image: '', createdAt: '', updatedAt: ''));
      _isLoading=false;
      response.body.forEach((category) => _subCategoryList?.add(CategoryModel.fromJson(category)));
      getCategoryProductList(0,categoryID, 0 ,'0',"0","0","0","1",0,0,"");
    } else {
      ApiChecker.checkApi(response, showToaster: true);
    }
  }

  void setSubCategoryIndex(int index ,int zoneId) {
    _subCategoryIndex = index;
    getCategoryProductList(zoneId,_subCategoryList![index].id.toString(),  0,'0',"0","0","0","1",0,0,"");
    update();

  }

  // void setFilterIndex(int zoneId, int index,String cityName,String districts,int  space,int ar_path,int sv) {
  //
  //
  //   getCategoryProductList(zoneId,index.toString(),0,cityName ?? "0",districts ?? "0",space.toString() ?? "0","0","1",ar_path,sv);
  //   //   update();
  //
  // }

  void setFilterIndex(
      int zoneId,
      int index,
      String cityName,
      String districts,
      int space,
      int arPath,
      int sv,
      String type // أضف هذا المعامل
      ) {
    getCategoryProductList(
        zoneId,
        index.toString(),
        0,
        cityName ?? "0",
        districts ?? "0",
        space.toString() ?? "0",
        "0",
        "1",
        arPath,
        sv,
        type // تمرير النوع هنا
    );
  }


  void getCategoryProductList(int zoneId,String categoryID,int userId,String city,String districts, String space,String typeAdd,String offset,int arPath,int sv,String type) async {
    if(offset == '1') {
      _categoryProductList = null;

      _isSearching = false;
    }
    Response response = await categoryRepo.getCategoryProductList(zoneId,categoryID,userId,city,districts,space,typeAdd, offset,arPath,sv,type);

    //print("-----------------------------------tt$type");
    if (response.statusCode == 200) {
      if (offset == '1') {
        _categoryProductList = [];
        //_estateModel = null;

      }
      _isLoading=false;
      _categoryProductList?.addAll(EstateModel.fromJson(response.body).estates as Iterable<Estate>);
      _pageSize = EstateModel.fromJson(response.body).totalSize;
      _estateModel = EstateModel.fromJson(response.body);
      // Get.find<EstateController>() .getCategoryList(response.body);
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response, showToaster: true);
    }
    update();
  }



  String getNameCityIndex() {
    return _nameCityIndex;
  }



// Method to toggle the selection of an advantage

}