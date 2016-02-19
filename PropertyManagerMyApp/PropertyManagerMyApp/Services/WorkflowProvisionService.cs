using Microsoft.SharePoint.Client;
using Microsoft.SharePoint.Client.WorkflowServices;
using System;
using System.Collections.Generic;

namespace SuiteLevelWebApp.Services
{
    [Flags]
    public enum WorkflowSubscritpionEventType
    {
        None = 0,
        ItemAdded = 1,
        ItemUpdated = 2,
        ItemDeleted = 4
    }

    public class WorkflowProvisionService
    {
        private WorkflowServicesManager workflowServicesManager;

        public ClientContext ClientContext { get; private set; }

        public WorkflowProvisionService(ClientContext clientContext)
        {
            this.ClientContext = clientContext;
            this.workflowServicesManager = new WorkflowServicesManager(ClientContext, ClientContext.Web);
        }

        public Guid SaveDefinitionAndPublish(string name, string translatedWorkflows)
        {
            var definition = new WorkflowDefinition(ClientContext)
            {
                DisplayName = name,
                Xaml = translatedWorkflows
            };

            var deploymentService = workflowServicesManager.GetWorkflowDeploymentService();
            var result = deploymentService.SaveDefinition(definition);
            ClientContext.ExecuteQuery();

            deploymentService.PublishDefinition(result.Value);
            ClientContext.ExecuteQuery();

            return result.Value;
        }

        public void DeleteDefinitions(string definitionName)
        {
            var deploymentService = workflowServicesManager.GetWorkflowDeploymentService();
            var definitions = deploymentService.EnumerateDefinitions(false);

            ClientContext.Load(definitions);
            ClientContext.ExecuteQuery();

            foreach (var definition in definitions)
            {
                if (definition.DisplayName == definitionName)
                    deploymentService.DeleteDefinition(definition.Id);
            }
            ClientContext.ExecuteQuery();
        }

        public Guid Subscribe(string name, Guid definitionId, Guid targetListId, WorkflowSubscritpionEventType eventTypes, Guid taskListId, Guid historyListId)
        {
            var eventTypesList = new List<string>();
            foreach (WorkflowSubscritpionEventType type in Enum.GetValues(typeof(WorkflowSubscritpionEventType)))
            {
                if ((type & eventTypes) > 0)
                    eventTypesList.Add(type.ToString());
            }

            var subscription = new WorkflowSubscription(ClientContext)
            {
                Name = name,
                Enabled = true,
                DefinitionId = definitionId,
                EventSourceId = targetListId,
                EventTypes = eventTypesList.ToArray()
            };

            subscription.SetProperty("TaskListId", taskListId.ToString());
            subscription.SetProperty("HistoryListId", historyListId.ToString());

            var subscriptionService = workflowServicesManager.GetWorkflowSubscriptionService();
            var result = subscriptionService.PublishSubscriptionForList(subscription, targetListId);

            ClientContext.ExecuteQuery();
            return result.Value;
        }

        public void Unsubscribe(Guid listId, string subscriptionName)
        {
            var subscriptionService = workflowServicesManager.GetWorkflowSubscriptionService();
            var subscriptions = subscriptionService.EnumerateSubscriptionsByList(listId);

            ClientContext.Load(subscriptions);
            ClientContext.ExecuteQuery();

            foreach (var subscription in subscriptions)
            {
                if (subscription.Name == subscriptionName)
                    subscriptionService.DeleteSubscription(subscription.Id);
            }
            ClientContext.ExecuteQuery();
        }

        public Guid CreateTaskList(string name, string description = "")
        {
            var parameters = new ListCreationInformation
            {
                Title = name,
                TemplateType = (int)ListTemplateType.TasksWithTimelineAndHierarchy,
                Description = description
            };
            var list = ClientContext.Web.Lists.Add(parameters);

            ClientContext.Load(list, i => i.Id);
            ClientContext.ExecuteQuery();

            var contentType = ClientContext.Web.ContentTypes.GetById("0x0108003365C4474CAE8C42BCE396314E88E51F");
            list.ContentTypes.AddExistingContentType(contentType);
            ClientContext.ExecuteQuery();

            return list.Id;
        }

        public Guid CreateHistoryList(string name, string description = "")
        {
            var parameters = new ListCreationInformation
            {
                Title = name,
                TemplateType = (int)ListTemplateType.WorkflowHistory,
                Description = description
            };
            var list = ClientContext.Web.Lists.Add(parameters);
            ClientContext.Load(list, i => i.Id);
            ClientContext.ExecuteQuery();

            return list.Id;
        }

        public void DeleteList(string name)
        {
            var list = ClientContext.Web.Lists.GetByTitle(name);
            list.DeleteObject();
            try
            {
                ClientContext.ExecuteQuery();
            }
            catch { }
        }
    }
}