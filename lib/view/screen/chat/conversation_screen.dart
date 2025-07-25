import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/chat_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/conversation_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/date_converter.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/helper/user_type.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_ink_well.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/base/paginated_list_view.dart';
import 'package:abaad/view/screen/search/widget/search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();

      Get.find<ChatController>().getConversationList(1);
      Get.find<UserController>().getUserInfo();
    }

  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      ConversationsModel conversation = chatController.searchConversationModel ?? ConversationsModel(totalSize: 0);
      //conversation = chatController.searchConversationModel;
    
      return Scaffold(
        // floatingActionButton: (chatController.conversationModel != null && !chatController.hasAdmin) ? FloatingActionButton.extended(
        //   label: Text('${'chat_with'.tr} ${AppConstants.APP_NAME}', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.white)),
        //   icon: Icon(Icons.chat, color: Colors.white),
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: () => Get.toNamed(RouteHelper.getChatRoute(notificationBody: NotificationBody(
        //     notificationType: NotificationType.message, adminId: 0,
        //   ),estate_id: 3)),
        // ) : null,
        body:GetBuilder<UserController>(builder: (userController) { return Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Column(children: [

            (Get.find<AuthController>().isLoggedIn()
            && (chatController.conversationModel?.conversations?.isNotEmpty ?? false)) ? Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: SearchField(
              controller: _searchController,
              hint: 'search'.tr,
              suffixIcon: chatController.searchConversationModel != null ? Icons.close : Icons.search,
              onSubmit: (String text) {
                if(_searchController.text.trim().isNotEmpty) {
                  chatController.searchConversation(_searchController.text.trim());
                }else {
                  showCustomSnackBar('write_something'.tr);
                }
              },
              iconPressed: () {
                _searchController.text = '';
                chatController.removeSearchMode();
                            },
            ))) : SizedBox(),
            SizedBox(height: (Get.find<AuthController>().isLoggedIn()
                && (chatController.conversationModel?.conversations?.isNotEmpty ?? false)) ? Dimensions.PADDING_SIZE_SMALL : 0),

            Expanded(child: Get.find<AuthController>().isLoggedIn() ? (conversation.conversations != null)
            ? conversation.conversations!.isNotEmpty ? RefreshIndicator(
              onRefresh: () async {
                await Get.find<ChatController>().getConversationList(1);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: PaginatedListView(
                  scrollController: _scrollController,
                  onPaginate: (int offset) => chatController.getConversationList(offset),
                  totalSize: conversation.totalSize,
                  offset: conversation.offset,
                  enabledPagination: chatController.searchConversationModel == null,
                  productView: ListView.builder(
                    itemCount: conversation.conversations!.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      Userinfo? user;
                      String? type;
                      if(conversation.conversations?[index].senderType == UserType.user.name || conversation.conversations?[index].senderType == UserType.customer.name) {
                        user = conversation.conversations?[index].receiver;
                        type = conversation.conversations?[index].receiverType;
                      }else {
                        user = conversation.conversations?[index].sender;
                        type = conversation.conversations?[index].senderType;
                      }

                      String? baseUrl = '';
                      if(type == UserType.vendor.name) {
                        baseUrl = Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl;
                      }else if(type == UserType.delivery_man.name) {
                        baseUrl = Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl;
                      }else if(type == UserType.admin.name){
                        baseUrl = Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl;
                      }

                      // showCustomSnackBar(UserType.vendor.name);

                      return Container(
                        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),

                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                        ),
                        child: CustomInkWell(
                          onTap: () {


                            //print("-------------------------------------${ conversation.conversations![index].receiver!.name}");
                            Get.toNamed(RouteHelper.getChatRoute(
                              notificationBody: NotificationBody(
                                type: conversation.conversations?[index].senderType,
                                notificationType: NotificationType.message,
                                adminId: type == UserType.admin.name ? 0 : null,
                                restaurantId: type == UserType.vendor.name ? user?.id : null,
                                deliverymanId: type == UserType.delivery_man.name ? user?.id : null,
                              ),
                              conversationID: conversation.conversations?[index].id,
                              index: index,
                              estate_id: 3,
                              estate: conversation.conversations?[index].estate
                            ));
                                                    },
                          highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                          radius: Dimensions.RADIUS_SMALL,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: Row(children: [
                                ClipOval(child: CustomImage(
                                  height: 50, width: 50,
                                  image: 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                                )),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  user != null ? Text(
                                   ((userController.userInfoModel?.name ?? "") == (user.name != null ? (conversation.conversations![index].sender!.name ?? "") : (user.name ?? ""))) as String,
                                    style: robotoMedium
                                  ) : Text('user_deleted'.tr, style: robotoMedium),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    DateConverter.localDateToIsoStringAMPM(DateConverter.dateTimeStringToDate(
                                        conversation.conversations?[index].lastMessageTime ?? "now")),
                                    style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
                                  ),
                                  // Text(
                                  //   '${_type.tr}',
                                  //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                  // ),
                                ])),
                              ]),
                            ),

                            // Positioned(
                            //   right: 5,bottom: 4,
                            //   child: Text(
                            //     DateConverter.localDateToIsoStringAMPM(DateConverter.dateTimeStringToDate(
                            //         _conversation.conversations[index].lastMessageTime)),
                            //     style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
                            //   ),
                            // ),

                            GetBuilder<UserController>(builder: (userController) {
                              return (conversation.conversations![index].lastMessage!.senderId != userController.userInfoModel?.agent!.id
                                  && (conversation.conversations![index].unreadMessageCount ?? 0) > 0) ? Positioned(right: 5,top: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                                  child: Text(
                                    conversation.conversations![index].unreadMessageCount.toString(),
                                    style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                  ),
                                ),
                              ) : SizedBox();
                            }),

                          ]),
                        ),
                      );
                    },
                  ),
                ))),
              ),
            ) : Center(child: Text('no_conversation_found'.tr)) : Center(child: CircularProgressIndicator()) : NotLoggedInScreen()),

          ]),
        );      }),
      );
    });
  }
}
