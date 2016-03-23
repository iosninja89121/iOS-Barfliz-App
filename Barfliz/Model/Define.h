//
//  Define.h
//  WuChu
//
//  Created by Luokey on 10/7/14.
//  Copyright (c) 2014 Luokey. All rights reserved.
//

#ifndef WuChu_Define_h
#define WuChu_Define_h

#define main_storyboard                 @"Main"
#define mainTab_scene                   @"MainTabScene"
#define pushScene                       @"PushScene"
#define mainPushScene                   @"MainPushScene"
#define mainNav_scene                   @"MainNavCtrlScene"
#define mainCalendarScene               @"TotalCalendarScene"
#define welcome_scene                   @"WelcomeScene"
#define another_profile_scene           @"AnotherProfileScene"

//#define kYelpConsumerKey               @"vxKwwcR_NMQ7WaEiQBK_CA"
//#define kYelpConsumerSecret            @"33QCvh5bIF5jIHR5klQr7RtBDhQ"
//#define kYelpToken                     @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
//#define kYelpTokenSecret               @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";




#define  pClassFriend         @"Friend"
#define  keyMyUsername        @"myUsername"
#define  keyOtherUser         @"otherUser"
#define  keyOtherUsername     @"otherUsername"
#define  keyPhoto             @"photo"
#define  keyEmail             @"email"
#define  keyPhone             @"phone"
#define  keyBio               @"bio"
#define  keyFavoirte          @"favorite"
#define  keyLocation          @"location"
#define  kpFacebookID         @"facebookID"
#define  kpFacebookToken      @"facebookToken"
#define  kpTwitter            @"twitter"
#define  kpInstagram          @"instagram"
#define  kpPrivacy            @"privacy"
#define  kpRealUsername       @"realUsername"



#define KACCESS_TOKEN @”access_token”
#define KAUTHURL @"https://api.instagram.com/oauth/authorize/"
#define kAPIURl @"https://api.instagram.com/v1/users/"
#define KCLIENTID @"704ccf65c14f4abeb44dfc7cfc11140b"
#define KCLIENTSERCRET @"ef4b71447bee4eaa890448c980087ac1"
#define kREDIRECTURI @"http://barfliz.com/"

//twitter
#define kTwitter_app_Key                     @"ixdVcKd3KBKiwqxbfTOwIN9K8"
#define kTwitter_app_Secret                  @"YXUQNWO3DmYh54b9x0ODy9ZDrki76f1j5GL9fdVpcY4EhimI2p"

// TCWeiboSDK Params
#define WiressSDKDemoAppKey         @"801363575"
#define WiressSDKDemoAppSecret      @"353ebde3424715fddd5ac52b9f0b0505"
#define REDIRECTURI                 @"http://www.dev.wuchubuzai.com/oauth/qq"


// WuChuBuZai XMPP Server
#define ChatHostName                @"54.254.90.12"
#define ChatDomainName              @"chat.wuchubuzai.com"
#define ChatHostPort                5222



#define Documents_Folder                [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define Datas_Folder                    [Documents_Folder stringByAppendingPathComponent:@"datas"]
#define Users_Folder                    [Documents_Folder stringByAppendingPathComponent:@"users"]
#define Photos_Folder                   [Users_Folder stringByAppendingPathComponent:@"photos"]

#define ProfilePhoto_Name               @"me.png"

///signup url
#define SIGN_UP_NOTIFICATION        @"signup"


#define SERVER_URL                  @"http://dev.api.wuchubuzai.com"

#define SIGN_UP_URL                 [SERVER_URL stringByAppendingPathComponent:@"accounts"]
#define MOBILE_URL                  [SERVER_URL stringByAppendingPathComponent:@"mobile"]

#define FACEBOOK_FRIENDS_URL        [SERVER_URL stringByAppendingPathComponent:@"sns_facebook"]
#define TENCENT_FRIENDS_URL         [SERVER_URL stringByAppendingPathComponent:@"sns_qq"]

#define XMPP_CHAT_URL               @"http://www.dev.wuchubuzai.com/http-bind/"


#define ServiceName_Facebook        @"facebook"
#define ServiceName_Tencent         @"qq"

#define ServiceMethod_Add_Social_Account            @"add_social_account"
#define ServiceMethod_LoadMobileUsersList           @"loadMobileUsersList"
#define ServiceMethod_LoadMobileVQuizResults        @"loadMobileVQuizResults"
#define ServiceMethod_GetMobileUser                 @"getMobileUser"
#define ServiceMethod_LoadMobileProfilePhoto        @"loadMobileProfilePhoto"

//user account
#define WuChu_UserID                @"WuChu_UserID"
#define WuChu_RestKey               @"WuChu_RestKey"

//#define kXMPPmyJID                  @"kXMPPmyJID"
//#define kXMPPmyPassword             @"kXMPPmyPassword"
#define WuChu_XMPP_UserName         @"WuChu_XMPP_UserName"
#define WuChu_XMPP_Password         @"WuChu_XMPP_Password"

#define Gender_Male                 @"Male"
#define Gender_Female               @"Female"


#define Language_zh_CHS             @"zh-CHS"
#define Language_zh_CHT             @"zh-CHT"

#define Language_zh_Hans            @"zh-Hans"
#define Language_zh_Hant            @"zh-Hant"
#define Language_zh_HK              @"zh-HK"


//xmpp accounts


#define Notice_Color                [UIColor colorWithRed:39/255.f green:148/255.f blue:193/255.f alpha:1.f]
#define InfoWrapperBorder_Color     [UIColor colorWithRed:219/255.f green:219/255.f blue:219/255.f alpha:1.f]

#define ScrollView_Margin_4         4.f


#define DateTimeFormat_WuChu        @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define DateTimeFormat_ChatMessage  @"yyyy-MM-dd HH:mm:ss 'Z'"
#define DateTimeFormat_ChatMessage  @"yyyy-MM-dd HH:mm:ss 'Z'"
#define DateTimeFormat_Contacts     @"yyyy-MM-dd HH:mm"


// Notification Keys
#define kWCUserlistDownloaded       @"WCUserlistDownloaded"

// Keys

#define key_service                 @"service"
#define key_service_method          @"service_method"
#define key_remote_id               @"remote_id"
#define key_access_token            @"access_token"
#define key_service_name            @"service_name"
#define key_service_full_name       @"service_full_name"
#define key_service_first_name      @"service_first_name"
#define key_service_middle_name     @"service_middle_name"
#define key_service_last_name       @"service_last_name"
#define key_service_user_details    @"service_user_details"
#define key_oauth_token_info        @"oauth_token_info"
#define key_oauth_token             @"oauth_token"
#define key_oauth_token_secret      @"oauth_token_secret"
#define key_photo                   @"photo"

#define key_Uid                     @"Uid"
#define key_id                      @"id"
#define key_rest_key                @"rest_key"
#define key_locale                  @"locale"

#define key_name                    @"name"
#define key_nick                    @"nick"
#define key_first_name              @"first_name"
#define key_middle_name             @"middle_name"
#define key_last_name               @"last_name"
#define key_gender                  @"gender"
#define key_hometown                @"hometown"
#define key_url                     @"url"


#define key_data                    @"data"
#define key_info                    @"info"

#define key_users                   @"users"
#define key_no_of_users             @"no_of_users"

#define key_format                  @"format"
#define key_pageflag                @"pageflag"
#define key_reqnum                  @"reqnum"
#define key_type                    @"type"
#define key_contenttype             @"contenttype"

#define key_error                   @"error"
#define key_error_code              @"error_code"
#define key_exception               @"exception"
#define key_wuchubuzai_api          @"wuchubuzai_api"


#define key_oAuthType               @"oAuthType"

#define key_xmppUsername            @"xmppUsername"
#define key_xmppPassword            @"xmppPassword"


#define key_age                     @"age"
#define key_nickname                @"nickname"
#define key_percentage              @"percentage"
#define key_presence                @"presence"
#define key_vquiz                   @"vquiz"
#define key_location                @"location"
#define key_location_date           @"location_date"
#define key_latitude                @"latitude"
#define key_longitude               @"longitude"

// Social - Facebook infos
#define key_facebook_connections    @"facebook_connections"
#define key_facebook_photos         @"facebook_photos"
// Social - Twitter infos
#define key_twitter_connections     @"twitter_connections"
#define key_twitter_followings      @"twitter_followings"
#define key_twitter_tweets          @"twitter_tweets"
// Social - Google infos
#define key_google_connections      @"google_connections"
// Social - LinkdIn infos
#define key_linkedin_connections    @"linkedin_connections"
#define key_linkedin_groups         @"linkedin_groups"
// Social - QQ infos
#define key_qq_connections          @"qq_connections"
#define key_qq_followings           @"qq_followings"
#define key_qq_tweets               @"qq_tweets"
// Social - RenRen infos
#define key_renren_connections      @"renren_connections"
// Social - Weibo infos
#define key_weibo_connections       @"weibo_connections"
#define key_weibo_followers         @"weibo_followers"
#define key_weibo_tweets            @"weibo_tweets"

// Profile image info
#define key_profile_image           @"profile_image"
#define key_profile_large           @"profile_large"
#define key_profile_medium1         @"profile_medium1"
#define key_profile_medium2         @"profile_medium2"
#define key_profile_small           @"profile_small"
#define key_profile_smallThumb1     @"profile_smallThumb1"
#define key_profile_smallThumb2     @"profile_smallThumb2"
#define key_profile_smallThumb3     @"profile_smallThumb3"
#define key_profile_thumb           @"profile_thumb"
#define key_profile_xlarge          @"profile_xlarge"

// Residence City infos
#define key_residence_city          @"residence_city"
#define key_residence_city_de       @"residence_city_de"
#define key_residence_city_en       @"residence_city_en"
#define key_residence_city_es       @"residence_city_es"
#define key_residence_city_fr       @"residence_city_fr"
#define key_residence_city_ja       @"residence_city_ja"
#define key_residence_city_ko       @"residence_city_ko"
#define key_residence_city_pt       @"residence_city_pt"
#define key_residence_city_ru       @"residence_city_ru"
#define key_residence_city_zh_CHS   @"residence_city_zh-CHS"
#define key_residence_city_zh_CHT   @"residence_city_zh-CHT"

#define Unavailable                 @"unavailable"
#define Default                     @"default"

#define key_counters                @"counters"
#define key_default_username        @"default_username"
#define key_email_validated         @"email_validated"
#define key_invited                 @"invited"
#define key_invitations             @"invitations"
#define key_last_login              @"last_login"
#define key_points                  @"points"
#define key_remote_service          @"remote_service"
#define key_success                 @"success"
#define key_success_code            @"success_code"

// vquiz infos
#define key_lifestyle               @"lifestyle"
#define key_likes                   @"likes"

#define key_question                @"question"
#define key_answer_count            @"answer_count"
#define key_categories              @"categories"
#define key_status                  @"status"
#define key_subject                 @"subject"
#define key_subject_en              @"subject_en"
#define key_subject_zh_CHS          @"subject_zh-CHS"
#define key_subject_zh_CHT          @"subject_zh-CHT"
#define key_t                       @"t"
#define key_uid                     @"uid"

#define key_answer                  @"answer"
#define key_answer_prefix           @"answer_"
#define key_image                   @"image"
#define key_md5sum                  @"md5sum"
#define key_questionId              @"questionId"
#define key_tags                    @"tags"


typedef enum PhotoPickerType {
    PhotoPickerType_Camera = 0,
    PhotoPickerType_PhotoGallery
} PhotoPickerType;


typedef enum WCUserStatus {
    kWCUserStatusOffline = 0,
    kWCUserStatusAway = 1,
    kWCUserStatusAvailable = 2
} WCUserStatus;

typedef enum WCChatState {
    kWCChatStateUnknown = 0,
    kWCChatStateActive = 1,
    kWCChatStateComposing = 2,
    kWCChatStatePaused = 3,
    kWCChatStateInactive = 4,
    kWCChatStateGone =5
} WCChatState;

// Keys for XMPP Stream

#define kWCProtocolLoginSuccess                     @"LoginSuccessNotification"
#define kWCProtocolLoginFail                        @"LoginFailedNotification"
#define kWCBuddyListUpdate                          @"BuddyListUpdateNotification"
#define kWCProtocolLogout                           @"LogoutNotification"
#define kWCMessageReceived                          @"MessageReceivedNotification"
#define kWCMessageReceiptResonseReceived            @"MessageReceiptResponseNotification"
#define kWCStatusUpdate                             @"StatusUpdatedNotification"
#define kWCProtocolDiconnect                        @"DisconnectedNotification"
#define kWCSendMessage                              @"SendMessageNotification"

#define kWCProtocolTypeXMPP                         @"xmpp"

#define kWCNotificationAccountNameKey               @"kWCNotificationAccountNameKey"
#define kWCNotificationUserNameKey                  @"kWCNotificationUserNameKey"
#define kWCNotificationProtocolKey                  @"kWCNotificationProtocolKey"

#define kWCXMPPAccountAllowSelfSignedSSLKey         @"kWCXMPPAccountAllowSelfSignedSSLKey"
#define kWCXMPPAccountSendDeliveryReceiptsKey       @"kWCXMPPAccountSendDeliveryReceiptsKey"
#define kWCXMPPAccountSendTypingNotificationsKey    @"kWCXMPPAccountSendTypingNotificationsKey"
#define kWCXMPPAccountAllowSSLHostNameMismatch      @"kWCXMPPAccountAllowSSLHostNameMismatch"
#define kWCXMPPAccountPortNumber                    @"kWCXMPPAccountPortNumber"

#define kWCXMPPResource                             @"wuchubuzai"

#define kWCFeedbackEmail                            @"support@chatsecure.org"

#define kWCChatStatePausedTimeout                   5
#define kWCChatStateInactiveTimeout                 120


#define MESSAGE_PROCESSED_NOTIFICATION              @"MessageProcessedNotification"
#define kWCEncryptionStateNotification              @"kWCEncryptionStateNotification"

#define key_received_message                        @"received_message"


#define CoreDataEntity_Messages                     @"Messages"

#define CoreDataAttribute_user                      @"user"
#define CoreDataAttribute_user_id                   @"user_id"
#define CoreDataAttribute_user_photo                @"user_photo"
#define CoreDataAttribute_message                   @"message"
#define CoreDataAttribute_is_received               @"is_received"
#define CoreDataAttribute_from_date                 @"from_date"
#define CoreDataAttribute_to_date                   @"to_date"


#endif
