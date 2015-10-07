//
//  EKNOneNoteService.c
//  
//
//  Created by Tyler Lu on 9/1/15.
//
//

#import "orc.h"
#import <ADALiOS/ADAuthenticationContext.h>
#import <ADALiOS/ADAuthenticationParameters.h>
#import <ADALiOS/ADAuthenticationSettings.h>
#import <ADALiOS/ADLogger.h>
#import <ADALiOS/ADInstanceDiscovery.h>
#include "EKNOneNoteService.h"


@implementation EKNOneNoteService

-(void)getPagesWithCallBack: (MSGraphGroup *)group propertyName:(NSString*) propertyName incidentId:(int)incidentId callback:(void (^)(NSString * notBookUrl, NSArray *pages, MSOrcError *error))callback
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSString *oneNoteResourceId = [standardUserDefaults objectForKey:@"oneNoteResourceId"];
    NSString *oneNoteResourceUrl = [standardUserDefaults objectForKey:@"oneNoteResourceUrl"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
    NSString *demoSiteServiceResourceId = [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:[standardUserDefaults objectForKey:@"authority"] error:&error];
    if (!context) { return; }
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:oneNoteResourceId clientId: clientId redirectUri:redirectUri];
    MSOneNoteClient *oneNoteClient = [[MSOneNoteClient alloc] initWithUrl:oneNoteResourceUrl dependencyResolver:resolver];
    
    
    NSString *groupNotebookName =  [group.displayName stringByAppendingString:@" Notebook"];
    NSString *groupSiteCollectionUrl =  [NSString stringWithFormat:@"%@/sites/%@", demoSiteServiceResourceId, group.mailNickname];
    
    //MSOneNoteSiteCollectionCollectionOperations *siteCollections = [[MSOneNoteSiteCollectionCollectionOperations alloc] initOperationWithUrl:@"myOrganization/siteCollections/" parent:self.client];
    
    
    NSString *siteMetadataServiceUrl = [NSString stringWithFormat:@"myOrganization/siteCollections/FromUrl(url='%@')",  [groupSiteCollectionUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    MSOrcEntityFetcher *siteMetadataFetcher = [[MSOrcEntityFetcher alloc] initWithUrl:siteMetadataServiceUrl parent:oneNoteClient asClass:[MSOneNoteSiteMetadata class]];
    [siteMetadataFetcher readWithCallback:^(MSOneNoteSiteMetadata *siteMetadata, MSOrcError *error) {
        
        //MSOneNoteSiteFetcher *siteFetcher = [[self.client.myOrganization getSiteCollectionsById:siteMetadata.siteCollectionId] getSitesById:siteMetadata.siteId];

        NSString *siteServiceUrl = [NSString stringWithFormat:@"myOrganization/siteCollections/%@/sites/%@/", siteMetadata.siteCollectionId, siteMetadata.siteId];
        MSOneNoteSiteFetcher *siteFetcher =[[MSOneNoteSiteFetcher alloc] initWithUrl:siteServiceUrl parent:oneNoteClient asClass:[MSOneNoteSite class]];
        
        MSOneNoteNotebookCollectionFetcher *notesCollectionFetcher = [[siteFetcher notes] notebooks];
        
        MSOneNoteNotebookCollectionFetcher *groupNotebookCollectionFetcher = [[notesCollectionFetcher filter: [NSString stringWithFormat:@"name eq '%@'", groupNotebookName]] top:1];
        
        [groupNotebookCollectionFetcher readWithCallback:^(NSArray *notebooks, MSOrcError *error) {
            MSOneNoteNotebook *notebook = notebooks.firstObject;
            
            MSOneNoteNotebookFetcher *notebookFetcher = [notesCollectionFetcher getById:notebook.id];
            MSOneNoteSectionCollectionFetcher *sectionCollectionFetcher = [[[notebookFetcher sections] filter:[NSString stringWithFormat:@"name eq '%@'", propertyName]] top:1];
            [sectionCollectionFetcher readWithCallback:^(NSArray *sections, MSOrcError *error) {
                MSOneNoteSection *section = sections.firstObject;
                
                MSOneNoteSectionFetcher *sectionFetcher = [[[siteFetcher notes] sections] getById:section.id];
                MSOneNotePageCollectionFetcher *pageCollectionFetcher = [[sectionFetcher pages] filter:[NSString stringWithFormat:@"title eq 'Incident[%d]'",incidentId]];
                [pageCollectionFetcher readWithCallback:^(NSArray *pages, MSOrcError *error) {
                    callback( notebook.links.oneNoteWebUrl.href ,pages, error);
                }];
            }];
        }];        
    }];
}

@end
