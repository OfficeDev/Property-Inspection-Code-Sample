using Newtonsoft.Json.Linq;
using SuiteLevelWebApp.Utils;
using System;
using System.Drawing;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.IO;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Web.Mvc;
using SuiteLevelWebApp.Models;
using Microsoft.Graph;

namespace SuiteLevelWebApp.Services
{
    public class ExcelService
    {
        private static async Task<DriveItem> GetFileObjectAsync(string groupId, string excelName, string accessToken)
        {

            GraphServiceClient client = await AuthenticationHelper.GetGraphServiceAsync(AADAppSettings.GraphResourceUrl);
            var queryfiles = await client.Groups[groupId].Drive.Root.Children.Request().Select("id,webUrl").Filter(string.Format("name eq '{0}'", excelName)).Top(1).GetAsync();
            if(queryfiles.CurrentPage != null && queryfiles.CurrentPage.Count>0)
            {
                return queryfiles.CurrentPage[0];
            }
            return null;
        }

        public static async Task<PropertyExcelWorkbook> GetPropertyExcelWorkbooksAsync(string groupId)
        {
            var propertyExcelWorkbook = new PropertyExcelWorkbook();
            var accessToken =await AuthenticationHelper.GetGraphAccessTokenAsync();
            DriveItem fileDriveItem = await GetFileObjectAsync(groupId, "Property-Costs.xlsx", accessToken); 
            if(fileDriveItem != null)
            {
                propertyExcelWorkbook.fileId = fileDriveItem.Id;
                propertyExcelWorkbook.webUrl = fileDriveItem.WebUrl;

                var excelEndPoint = string.Format("{0}/groups/{1}/drive/items/{2}/workbook/worksheets('Summary')/tables('SummaryData')/Rows", AADAppSettings.GraphBetaResourceUrl, groupId, propertyExcelWorkbook.fileId);
                using (var client = new HttpClient())
                {
                    client.DefaultRequestHeaders.Accept.Clear();
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
                    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                    HttpResponseMessage response = await client.GetAsync(excelEndPoint);
                    if (response.IsSuccessStatusCode)
                    {
                        var excelWorkbookItems = new List<PropertyExcelWorkbookItem>();
                        string resultString = await response.Content.ReadAsStringAsync();
                        var jObject = JObject.Parse(resultString);

                        foreach (var item in jObject["value"].Children())
                        {
                            var row = item["values"][0];
                            excelWorkbookItems.Add(new PropertyExcelWorkbookItem
                            {
                                title = row[0].ToString(),
                                total = String.Format("{0:C}", Convert.ToDecimal(row[1].ToString()))
                            });
                        }
                        propertyExcelWorkbook.propertyExcelWorkbookItems = excelWorkbookItems.ToArray();
                    }
                }
            }
            
            return propertyExcelWorkbook;
        }

        public static async Task<byte[]> GetPropertyExcelWorkbookChartImageAsync(string groupId, string fileId, string chartTitle)
        {
            byte[] imageBinary= new byte[] { };
            string accessToken = await AuthenticationHelper.GetGraphAccessTokenAsync();
            string chartName = chartTitle.ToLower().StartsWith("inspection") ? "Chart 3" : "Chart 4";
            var excelEndPoint = string.Format("{0}/groups/{1}/drive/items/{2}/workbook/worksheets('Summary')/charts('{3}')/Image(width=0,height=0,fittingMode='fit')", AADAppSettings.GraphBetaResourceUrl, groupId, fileId, chartName);

            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

                HttpResponseMessage response = await client.GetAsync(excelEndPoint);
                if (response.IsSuccessStatusCode)
                {
                    string resultString = await response.Content.ReadAsStringAsync();
                    var jObject = JObject.Parse(resultString);
                    Bitmap imageBitmap = StringToBitmap(jObject["value"].ToString());
                    ImageConverter converter = new ImageConverter();
                    imageBinary = (byte[])converter.ConvertTo(imageBitmap, typeof(byte[]));
                }
            }
            return imageBinary;
        }
        private static Bitmap StringToBitmap(string base64ImageString)
        {
            Bitmap bmpReturn = null;
            byte[] byteBuffer = Convert.FromBase64String(base64ImageString);
            MemoryStream memoryStream = new MemoryStream(byteBuffer);
            memoryStream.Position = 0;
            bmpReturn = (Bitmap)Bitmap.FromStream(memoryStream);
            memoryStream.Close();
            memoryStream = null;
            byteBuffer = null;
            return bmpReturn;
        }
    }
}