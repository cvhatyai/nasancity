final String _base_url = "https://www.nasancity.go.th/";
final String _base_url_api = "https://www.nasancity.go.th/app_api_v1";

final String _base_url_pity = "https://www.nasancity.go.th/";
final String _base_url_api_pity = "https://www.nasancity.go.th/app_api_v1_pity";

class Info {
  String baseUrl = _base_url;
  String baseUrlPity = _base_url_pity;

  String facebook_live = _base_url + 'facebook_live';
  //pity
  String newsList = _base_url_api + '/newsList';
  String faqList = _base_url_api + '/faqList';
  String newsDetail = _base_url_api + '/newsDetail';
  String galleryList = _base_url_api + '/galleryList';
  String galleryDetail = _base_url_api + '/galleryDetail';
  String videoList = _base_url_api + '/videoList';
  String videoDetail = _base_url_api + '/videoDetail'; //Hit
  String ebookList = _base_url_api + '/ebookList';
  String ebookDetail = _base_url_api + '/ebookDetail'; //Hit
  String contactCity = _base_url_api + '/contactCity';
  String checkAppVersion = _base_url_api + '/checkAppVersion';
  String contactusAdd = _base_url_api + '/contactusAdd';
  String contactusList = _base_url_api + '/contactusList';
  String informList = _base_url_api + '/informList';
  String informDetail = _base_url_api + '/informDetail';
  String updateUserFullname = _base_url_api + '/updateUserFullname';
  String siteDetail = _base_url_api + '/siteDetail';
  String travelList = _base_url_api + '/travelList';
  String travelDetail = _base_url_api + '/travelDetail';
  String restList = _base_url_api + '/restList';
  String restDetail = _base_url_api + '/restDetail';
  String eatList = _base_url_api + '/eatList';
  String eatDetail = _base_url_api + '/eatDetail';
  String shopList = _base_url_api + '/shopList';
  String shopDetail = _base_url_api + '/shopDetail';
  String callCateList = _base_url_api + '/callCateList';
  String callList = _base_url_api + '/callList';
  String callDetail = _base_url_api + '/callDetail';
  String callEdit = _base_url_api + '/insertEditDetail';
  String serviceGuideCateList = _base_url_api + '/serviceGuideCateList';
  String serviceGuideList = _base_url_api + '/serviceGuideList';
  String serviceGuideDetail = _base_url_api + '/serviceGuideDetail';
  String newsDocumentList = _base_url_api + '/newsDocumentList';
  String newsDocumentDetail = _base_url_api + '/newsDocumentDetail';
  String cateList = _base_url_api + '/cateList'; //แสดงหมวดส่ง cmd ไป
  String cateSubList = _base_url_api + '/cateSubList'; //แสดงหมวดส่ง cmd ไป
  String cateAllList = _base_url_api + '/cateAllList'; //แสดงหมวดส่ง cmd ไป
  String serviceDescription = _base_url_api + '/serviceDescription';
  String serviceSubject = _base_url_api + '/serviceSubject';
  String eventsList = _base_url_api + '/eventsList';
  String eventsDetail = _base_url_api + '/eventsDetail';
  String cateInformList = _base_url_api + '/cateInformList';
  String cateInformStatusList = _base_url_api + '/cateInformStatusList';
  String informAdd = _base_url_api + '/informAdd';
  String informUpdate = _base_url_api + '/informUpdate';
  String pollVote = _base_url_api + '/pollVote';

  String userLogin = _base_url_api + '/userLogin';
  String checkCitizenID = _base_url_api + '/checkCitizenID';
  String updateCitizenID = _base_url_api + '/updateCitizenID';
  String checkHavePhone = _base_url_api + '/checkHavePhone';
  String changePassword = _base_url_api + '/changePassword';
  String changePhone = _base_url_api + '/changePhone';
  String setOtp = _base_url_api + '/setOtp';
  String checkOtp = _base_url_api + '/checkOtp';
  String changePasswordOtp = _base_url_api + '/changePasswordOtp';
  String userRegistAdd = _base_url_api + '/userRegistAdd';
  String checkUserPhone = _base_url_api + '/checkUserPhone';
  String messageList = _base_url_api + '/messageList';
  String bannerList = _base_url_api + '/bannerList';
  String linkProvinceList = _base_url_api + '/linkProvinceList';
  String notiList = _base_url_api + '/notiList';
  String informFinishList = _base_url_api + '/informFinishList';
  String commentAdd = _base_url_api + '/commentAdd';
  String commentList = _base_url_api + '/commentList';
  String addLove = _base_url_api + '/addLove';
  String removeLove = _base_url_api + '/removeLove';
  String checkHasUser = _base_url_api + '/checkHasUser';
  String checkConnectedUser = _base_url_api + '/checkConnectedUser';
  String cancelContectUser = _base_url_api + '/cancelContectUser';

  String nearMe = _base_url_api + '/nearMe';

  String weatherApi = 'https://api.cityvariety.com/weather/json.php?id=1156046';
  String weatherListApi =
      'https://api.cityvariety.com/weather/json.php?type=forecast&fnList=tempList&id=1156046';

  String cateListPity = _base_url_api_pity + '/cateListPity';
  String insertMarketAndProduct =
      _base_url_api_pity + '/insertMarketAndProduct';
  String getShopDetail = _base_url_api_pity + '/getShopDetail';
  String marketList = _base_url_api_pity + '/marketList';
  String marketDetail = _base_url_api_pity + '/marketDetail';

  String contentPrivacyPolicy = _base_url_api + '/contentPrivacyPolicy';
  String getAcceptPrivacyPolicy = _base_url_api + '/getAcceptPrivacyPolicy';
  String setAcceptPrivacyPolicy = _base_url_api + '/setAcceptPrivacyPolicy';

  Info() : super();
}
