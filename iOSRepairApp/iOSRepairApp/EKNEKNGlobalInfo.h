//
//  EKNEKNGlobalInfo.h
//  EdKeyNote
//
//  Created by canviz on 9/24/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKNListItem.h"
typedef NS_ENUM(NSInteger, RepairSubViewsTag){
    LeftPanelViewTag =50,
    LpsIncidentmenuTableViewTag,
    LpsPropertyDetailTableViewTag,
    LpsContactOwnerTableViewTag,
    LpsContactOfficeTableViewTag,
    LpsBottomViewTag,
    LpbsInspectionDetailTableViewTag,
    LpbsFinalizeBtnTag,
    
    MiddlePanelViewTag = 100,
    MpsIncidentsListTableViewTag,
    
    RightPanelViewTag =200,
    
    RpsIncidentDetailViewTag,
    RpidsRoomTitleLblTag,
    RpidsSeparatorLblTag,
    RpidsIncidentTypeLblTag,
    RpidsDispatcherCommentsBtnTag,
    RpidsDispatcherCommentsTag,
    RpidsInspectorCommentsBtnTag,
    RpidsInspectorCommentsCollectionTag,
    RpidsInspectorCommentsTag,
    RpidsAddCommentsBtnTag,
    RpidsAddCommentsCammeraBtnTag,
    RpidsAddCommentsCollectionTag,
    RpidsAddCommentsTag,
    RpidsAddCommentsDoneBtnTag,
    
    RpsOneNoteViewTag,
    RpsConversationViewTag,
    RpsPropertyMembersViewTag,
    RpsPropertyFilesViewTag,
    RpsRecentDocumentViewTag,
    
    AlertTransparentViewTag,
    
};
typedef NS_ENUM(NSInteger, IncidentMenuIndex){
    IncidentDetailsMenu=0,
    PropertyMembersMenu,
    ConversationsMenu,
    RecentDocumentsMenu,
    NotesMenu,
    ProperyFilesMenu,
    EmailDispatcherMenu,
    
};
typedef NS_ENUM(NSInteger, DocumentType){
    WordType=0,
    ExcelType,
    PPTType
};
@interface EKNEKNGlobalInfo : UIViewController

+(NSString *)converUTCStringFromDate:(NSDate *)date;
+(NSString *)converLocalStringFromDate:(NSDate *)date;
+(NSString *)converStringToDateString:(NSString *)stringDate;
+(BOOL)isBlankString:(NSString *)string;
+(CGSize)getSizeFromStringWithFont:(NSString *)string font:(UIFont *)font;
+(NSString *)getString:(NSString *)string;
+(BOOL)requestSuccess:(NSURLResponse *)response;

+(NSString *)getSiteUrl;
+(NSString *)createFileName:(NSString *)fileExtension;
+(void)openUrl:(NSString *)url;
+(NSDictionary*)parseResponseDataToDic:(NSData *)data;
+(NSArray*)parseResponseDataToArray:(NSData *)data;

+(NSString *)getGraphBetaResourceUrl;
+(NSString *)getGraphResourceUrl;
+(NSString *)getAuthority;
+(NSString *)getDemoSiteServiceResourceId;
+(NSString *)getOutlookResourceId;
@end


@protocol IncidentSubViewActionDelegate;

@protocol IncidentSubViewActionDelegate
- (void)showLoading;
- (void)hideLoading;
- (void)showLargePhoto:(UIImage *)image;
-(void)showSuccessMessage:(NSString *)message;
-(void)showErrorMessage:(NSString *)message;
-(void)showHintAlertView:(NSString *)title message:(NSString *)message;

-(void)setGroupData:(NSMutableDictionary *)data key:(NSString *)key groupId:(NSString *)groupId;
- (EKNListItem *)getSelectIncidentListItem;
- (void)presentViewController:(UIViewController *)viewControllerToPresent;
@end

