using System;
using System.IO;
using System.Xml;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;
using Microsoft.SharePoint.Client;
using Microsoft.Online.SharePoint.TenantAdministration;

namespace SuiteLevelWebApp.Utils
{
    public class CSOMUtil
    {
        /// <summary>
        /// Create Content Type
        /// </summary>
        public static void CreateContentType(ClientContext clientContext, string ContentTypeName, string ContentTypeDescription, string ContentTypeId, string[] filedNames)
        {
            var contentType = CSOMUtil.getContentTypeById(clientContext, ContentTypeId);

            // check if the content type exists
            if (contentType == null)
            {
                ContentTypeCollection contentTypeColl = clientContext.Web.ContentTypes;
                clientContext.Load(contentTypeColl);
                clientContext.ExecuteQuery();

                // Specifies properties that are used as parameters to initialize a new content type.
                ContentTypeCreationInformation contentTypeCreation = new ContentTypeCreationInformation();
                contentTypeCreation.Name = ContentTypeName;
                contentTypeCreation.Description = ContentTypeDescription;
                contentTypeCreation.Group = "Property Manager My App Content Types";
                contentTypeCreation.Id = ContentTypeId;

                //// Add the new content type to the collection
                contentType = contentTypeColl.Add(contentTypeCreation);
                clientContext.Load(contentType);
                clientContext.ExecuteQuery();

                CSOMUtil.BindFieldsToContentType(clientContext, contentType, filedNames);
            }
        }

        /// <summary>
        /// Create Content Type
        /// </summary>
        public static void RemoveContentType(ClientContext clientContext, string ContentTypeId)
        {
            var contentType = CSOMUtil.getContentTypeById(clientContext, ContentTypeId);

            if (contentType != null)
            {
                contentType.DeleteObject();
                clientContext.ExecuteQuery();
            }
        }

        /// <summary>
        /// Create Site Columns using field xml declaration
        /// </summary>
        public static void CreateSiteColumns(ClientContext clientContext, string[] fieldXMLDefinations)
        {
            var fields = clientContext.Web.Fields;

            foreach (string fieldXML in fieldXMLDefinations)
            {
                Regex matchGuid = new Regex("{\\S*}");
                var match = matchGuid.Match(fieldXML);
                if (match.Success)
                {
                    var fieldID = new Guid(match.Value);

                    var field = CSOMUtil.getFieldById(clientContext, fieldID);

                    // Check if the field exists
                    if (field == null)
                    {
                        clientContext.Web.Fields.AddFieldAsXml(fieldXML, true, AddFieldOptions.AddFieldInternalNameHint);
                        clientContext.ExecuteQuery();
                    }
                }
            }
        }

        /// <summary>
        /// Remove Site Columns
        /// </summary>
        public static void RemoveSiteColumns(ClientContext clientContext, string[] fieldXMLDefinations)
        {
            var fields = clientContext.Web.Fields;

            foreach (string fieldXML in fieldXMLDefinations)
            {
                Regex matchGuid = new Regex("{\\S*}");
                var match = matchGuid.Match(fieldXML);
                if (match.Success)
                {
                    var fieldID = new Guid(match.Value);

                    var field = CSOMUtil.getFieldById(clientContext, fieldID);

                    // Check if the field exists
                    // and can be deleted
                    if (field != null && field.CanBeDeleted)
                    {
                        field.DeleteObject();
                        clientContext.ExecuteQuery();
                    }
                }
            }
        }

        /// <summary>
        /// Add existed site columns to
        /// target content type
        /// </summary>
        public static void BindFieldsToContentType(ClientContext clientContext, ContentType contentType, string[] filedNames)
        {
            var fields = clientContext.Web.Fields;

            foreach (string fieldName in filedNames)
            {
                var field = fields.GetByInternalNameOrTitle(fieldName);
                clientContext.Load(field);
                clientContext.ExecuteQuery();

                contentType.FieldLinks.Add(new FieldLinkCreationInformation
                {
                    Field = field
                });
                contentType.Update(true);
                clientContext.ExecuteQuery();
            }
        }

        /// <summary>
        /// Add a list/document library to o365 web
        /// </summary>
        public static void AddSharePointList(ClientContext clientContext, string contentTypeID, string listTitle, string url, int listTemplateType, bool isHideTitle = false)
        {
            Web web = clientContext.Web;

            var contentType = CSOMUtil.getContentTypeById(clientContext, contentTypeID);
            var list = CSOMUtil.getListByTitle(clientContext, listTitle);

            // check if the content type exists
            if (list == null && contentType != null)
            {
                ListCreationInformation creationInfo = new ListCreationInformation();
                creationInfo.Title = listTitle;
                creationInfo.Url = url;
                creationInfo.TemplateType = listTemplateType;
                list = web.Lists.Add(creationInfo);
                list.Update();
                clientContext.ExecuteQuery();

                // insert content type
                var cts = list.ContentTypes;
                list.ContentTypesEnabled = true;
                cts.AddExistingContentType(contentType);
                clientContext.Load(cts);
                clientContext.ExecuteQuery();


                // remove default content type
                var count = cts.Count;
                while (--count >= 0)
                {
                    if (cts[0].Name != "Folder" && cts[0].Name != contentType.Name)
                    {
                        cts[0].DeleteObject();
                    }
                }
                clientContext.ExecuteQuery();


                // add fields to default view
                View defaultView = list.DefaultView;
                clientContext.Load(defaultView, v => v.ViewFields);
                clientContext.Load(contentType, c => c.Fields);
                clientContext.ExecuteQuery();
                if (!defaultView.ViewFields.Contains("ID"))
                {
                    defaultView.ViewFields.Add("ID");
                    defaultView.ViewFields.MoveFieldTo("ID", 0);
                }
                //hide title field in view
                if (isHideTitle == true)
                {
                    defaultView.ViewFields.Remove("LinkTitle");
                }
                foreach (Field field in contentType.Fields)
                {
                    if (!defaultView.ViewFields.Contains(field.Title) && field.Title != "Content Type" && field.Title != "Title")
                    {
                        defaultView.ViewFields.Add(field.Title);
                    }
                }
                defaultView.Update();
                clientContext.ExecuteQuery();

                //hide title field in forms 
                if (isHideTitle == true)
                {
                    var field_title = list.Fields.GetByTitle("Title");
                    clientContext.Load(field_title);
                    clientContext.ExecuteQuery();
                    field_title.Hidden = true;
                    field_title.Update();
                    clientContext.ExecuteQuery();
                }
            }
        }

        /// <summary>
        /// Remove a list/document library in o365 web
        /// </summary>
        public static void RemoveSharePointList(ClientContext clientContext, string listTitle)
        {
            var list = CSOMUtil.getListByTitle(clientContext, listTitle);

            // check if the content type exists
            if (list != null)
            {
                list.DeleteObject();
                clientContext.ExecuteQuery();
            }
        }

        /// <summary>
        /// Bind a lookup field to the target list
        /// </summary>
        public static void BindLookupField(ClientContext clientContext, string sourceListTitle, string lookupFieldName, string lookupDisplayFieldName, string lookupListTitle)
        {
            var sourceList = CSOMUtil.getListByTitle(clientContext, sourceListTitle);
            var lookupList = CSOMUtil.getListByTitle(clientContext, lookupListTitle);

            if (sourceList != null && lookupList != null)
            {
                var fieldColl = sourceList.Fields;
                var q = clientContext.LoadQuery<Field>(fieldColl.Where(n => n.InternalName == lookupFieldName));
                clientContext.ExecuteQuery();

                if (q.Count() > 0)
                {
                    var field = q.FirstOrDefault<Field>() as FieldLookup;

                    field.LookupList = lookupList.Id.ToString();

                    field.LookupField = lookupDisplayFieldName;

                    field.Update();

                    clientContext.ExecuteQuery();
                }
            }
        }

        public static void AddListItems(ClientContext clientContext, string listTitle, XmlDocument sampleData)
        {
            XmlNode items = sampleData.SelectSingleNode("//List[@name='" + listTitle + "']");
            List list = clientContext.Web.Lists.GetByTitle(listTitle);

            //remove list items
            //var d_items = list.GetItems(new CamlQuery());
            //clientContext.Load(d_items);
            //clientContext.ExecuteQuery();

            //var count = d_items.Count;
            //if (count > 0)
            //{
            //    while (count-- > 0)
            //    {
            //        d_items[0].DeleteObject();
            //    }
            //    clientContext.ExecuteQuery();
            //}

            foreach (XmlNode item in items)
            {
                ListItemCreationInformation itemCreateInfo = new ListItemCreationInformation();
                ListItem newItem = list.AddItem(itemCreateInfo);
                foreach (XmlNode column in item.ChildNodes)
                {
                    if (column.Attributes["name"].Value == "Id") continue;
                    if (column.Attributes["Type"] != null && column.Attributes["Type"].Value == "Lookup" && !string.IsNullOrEmpty(column.InnerText))
                    {
                        FieldLookupValue fieldLookupValue = new FieldLookupValue();

                        fieldLookupValue.LookupId = int.Parse(sampleData.SelectSingleNode(
                            string.Format("//List[@name='{0}']/item[{1}]/column[@name='Id']",
                            column.Attributes["Source"].Value,
                            column.InnerText)).InnerText);

                        newItem[column.Attributes["name"].Value] = fieldLookupValue;
                    }
                    else
                    {
                        newItem[column.Attributes["name"].Value] = column.InnerText;
                    }
                }
                newItem.Update();
                clientContext.ExecuteQuery();
                item.SelectSingleNode("./column[@name='Id']").InnerText = newItem.Id.ToString();
            }
        }

        public static void AddDocumentLibItems(ClientContext clientContext, string listTitle, XmlDocument sampleData)
        {
            XmlNode items = sampleData.SelectSingleNode("//List[@name='" + listTitle + "']");
            List list = clientContext.Web.Lists.GetByTitle(listTitle);

            //remove list items
            //var d_items = list.GetItems(new CamlQuery());
            //clientContext.Load(d_items);
            //clientContext.ExecuteQuery();

            //var count = d_items.Count;
            //if (count > 0)
            //{
            //    while (count-- > 0)
            //    {
            //        d_items[0].DeleteObject();
            //    }
            //    clientContext.ExecuteQuery();
            //}

            foreach (XmlNode item in items)
            {
                var filePath = HttpContext.Current.Server.MapPath("../") + item.Attributes["path"].Value;

                using (FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                {
                    try
                    {
                        byte[] bytes = new byte[fs.Length];
                        fs.Read(bytes, 0, bytes.Length);

                        var newfile = new FileCreationInformation();
                        newfile.Url = System.DateTime.Now.Ticks.ToString() + ".jpg";
                        newfile.Overwrite = true;
                        newfile.Content = bytes;
                        Microsoft.SharePoint.Client.File uploadedFile = list.RootFolder.Files.Add(newfile);

                        foreach (XmlNode column in item.ChildNodes)
                        {
                            if (column.Attributes["name"].Value == "Id") continue;
                            if (column.Attributes["Type"] != null && column.Attributes["Type"].Value == "Lookup" && !string.IsNullOrEmpty(column.InnerText))
                            {
                                FieldLookupValue fieldLookupValue = new FieldLookupValue();

                                fieldLookupValue.LookupId = int.Parse(sampleData.SelectSingleNode(
                                    string.Format("//List[@name='{0}']/item[{1}]/column[@name='Id']",
                                    column.Attributes["Source"].Value,
                                    column.InnerText)).InnerText);

                                uploadedFile.ListItemAllFields[column.Attributes["name"].Value] = fieldLookupValue;
                            }
                            else
                            {
                                uploadedFile.ListItemAllFields[column.Attributes["name"].Value] = column.InnerText;
                            }
                        }
                        uploadedFile.ListItemAllFields.Update();
                        clientContext.Load(uploadedFile);
                        clientContext.ExecuteQuery();
                    }
                    catch(Exception el)
                    {
                        el.ToString();
                    }
                } 
            }
        }

        public static string GetSiteCollectionStatusByUrl(ClientContext clientContext, string url)
        {
            var tenant = new Tenant(clientContext);
            var sitePropertiesColl = tenant.GetSiteProperties(0, true);

            var q = clientContext.LoadQuery(sitePropertiesColl.Where(n => n.Url == url));
            clientContext.ExecuteQuery();

            if (q.Count() > 0)
            {
                SiteProperties prop = q.FirstOrDefault() as SiteProperties;
                return prop.Status;
            }
            else
            {
                return "None";
            }
        }

        public static ClientContext GetSiteCollectionContext(ClientContext clientContext, string url)
        {
            var tenant = new Tenant(clientContext);
            var site = tenant.GetSiteByUrl(url);
            clientContext.Load(site);
            clientContext.ExecuteQuery();

            return site.Context as ClientContext;
        }

        public static void CreateSiteCollection(ClientContext clientContext, SiteCreationProperties siteCreationProperties)
        {
            var tenant = new Tenant(clientContext);

            var spoOperation = tenant.CreateSite(siteCreationProperties);

            clientContext.Load(spoOperation);

            clientContext.ExecuteQuery();
        }

        public static List getListByTitle(ClientContext clientContext, string listTitle)
        {
            // Get the list collection for the website
            var listColl = clientContext.Web.Lists;

            var q = clientContext.LoadQuery<List>(listColl.Where(n => n.Title == listTitle));
            clientContext.ExecuteQuery();

            if (q.Count() > 0)
            {
                return q.FirstOrDefault<List>();
            }
            else
            {
                return null;
            }
        }

        public static ContentType getContentTypeById(ClientContext clientContext, string contentTypeId)
        {
            // Get the content type collection for the website
            var contentTypeColl = clientContext.Web.ContentTypes;

            var q = clientContext.LoadQuery<ContentType>(contentTypeColl.Where(n => n.Id.StringValue == contentTypeId));
            clientContext.ExecuteQuery();

            if (q.Count() > 0)
            {
                return q.FirstOrDefault<ContentType>();
            }
            else
            {
                return null;
            }
        }

        public static Field getFieldById(ClientContext clientContext, Guid fieldId)
        {
            // Get the site column collection for the website
            var fieldColl = clientContext.Web.Fields;

            var q = clientContext.LoadQuery<Field>(fieldColl.Where(n => n.Id == fieldId));
            clientContext.ExecuteQuery();

            if (q.Count() > 0)
            {
                return q.FirstOrDefault<Field>();
            }
            else
            {
                return null;
            }
        }

        public static Field getFieldByInternalName(ClientContext clientContext, string fieldName)
        {
            // Get the site column collection for the website
            var fields = clientContext.Web.Fields;

            var q = clientContext.LoadQuery<Field>(fields.Where(n => n.InternalName == fieldName));
            clientContext.ExecuteQuery();

            if (q.Count() > 0)
            {
                return q.FirstOrDefault<Field>();
            }
            else
            {
                return null;
            }
        }
    }
}