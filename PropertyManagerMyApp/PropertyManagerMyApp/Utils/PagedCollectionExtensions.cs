using Microsoft.OData.ProxyExtensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace SuiteLevelWebApp
{
    public static class PagedCollectionExtensions
    {
        //Extension methods for the IPagedCollection interfaces returned
        //by the Microsoft.Graph.GraphService

        //The GraphServiceExtension methods use these extension methods 
        //to interact with the IPagedCollection interfaces returned by the
        //Microsoft.Graph.GraphService
        public static async Task<TElement[]> GetAllAsnyc<TElement>(
            this IPagedCollection<TElement> pagedCollection)
        {
            var list = new List<TElement>();

            var collection = pagedCollection;
            while (true)
            {
                list.AddRange(collection.CurrentPage);
                if (!collection.MorePagesAvailable) break;
                collection = await collection.GetNextPageAsync();
            }
            return list.ToArray();
        }
    }
}