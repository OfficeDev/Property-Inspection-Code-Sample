//
//  EKNOneNoteService.c
//  
//
//  Created by Tyler Lu on 9/1/15.
//
//
#include "EKNOneNoteService.h"


@implementation EKNOneNoteService

-(void)getPagesWithCallBack: (MSGraphServiceGroup *)group  incidentId:(NSString*)incidentId callback:(void (^)(NSString * notBookUrl, NSArray *pages, MSOrcError *error))callback
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [standardUserDefaults objectForKey:@"clientId"];
    NSURL *redirectUri = [NSURL URLWithString:[standardUserDefaults objectForKey:@"redirectUriString"]];
   // NSString *demoSiteServiceResourceId = [standardUserDefaults objectForKey:@"demoSiteServiceResourceId"];
    NSString *graphResourceId = [standardUserDefaults objectForKey:@"graphResourceId"];
    
    NSString *graphResourceUrl = [standardUserDefaults objectForKey:@"graphResourceUrl"];
    
    ADAuthenticationError *error;
    ADAuthenticationContext* context = [ADAuthenticationContext authenticationContextWithAuthority:[standardUserDefaults objectForKey:@"authority"] error:&error];
    if (!context) { return; }

    
    
    
    ADALDependencyResolver *resolver = [[ADALDependencyResolver alloc] initWithContext:context resourceId:graphResourceId clientId: clientId redirectUri:redirectUri];
    MSGraphServiceClient *client = [[MSGraphServiceClient alloc] initWithUrl:[graphResourceUrl stringByAppendingString:clientId] dependencyResolver:resolver];
    NSString *groupNotebookName =  [group.displayName stringByAppendingString:@" Notebook"];
    
    MSOneNoteApiNotebookCollectionFetcher *oneNoteApiNotebookCollectionFetcher = [[[MSOneNoteApiNotebookCollectionFetcher alloc] initWithUrl:[NSString stringWithFormat:@"/groups/%@/notes/notebooks",group._id] parent:client] filter:[NSString stringWithFormat:@"name eq '%@'", groupNotebookName]];
    
    [oneNoteApiNotebookCollectionFetcher readWithCallback:^(NSArray * onenotebookCollection, MSOrcError *error){
        MSOneNoteApiNotebook *noteNoteApiNoteBook = onenotebookCollection.firstObject;
        
        
        MSOneNoteApiSectionCollectionFetcher *sectionsFetcher = [[[[MSOneNoteApiSectionCollectionFetcher alloc] initWithUrl:[NSString stringWithFormat:@"/groups/%@/notes/sections",group._id] parent:client] filter:[NSString stringWithFormat:@"name eq '%@'", group.displayName]] top:1];
        [sectionsFetcher readWithCallback:^(NSArray *sections, MSOrcError *error) {
            MSOneNoteApiSection *section = sections.firstObject;
            MSOneNoteApiPageCollectionFetcher *pageCollectionFetcher =[[[sectionsFetcher getById:section._id] pages] filter:[NSString stringWithFormat:@"title eq 'Incident[%@]'",incidentId]];
            [pageCollectionFetcher readWithCallback:^(NSArray *pages, MSOrcError *error) {
                callback( noteNoteApiNoteBook.links.oneNoteWebUrl.href ,pages, error);
            }];
        }];
        
    }];
    
    

}

@end

