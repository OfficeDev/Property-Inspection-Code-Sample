using Microsoft.Activities.Design.ExpressionTranslation;
using System;
using System.IO;
using System.Text;
using System.Xaml;
using System.Xml;

namespace SuiteLevelWebApp.Utils
{
    public class WorkflowUtil
    {
        public static string TranslateWorkflow(string originalWorkflow)
        {
            using (var inputWorkflowReader = new StringReader(originalWorkflow))
            using (var xamlReader = new XamlXmlReader(inputWorkflowReader))
            {
                var result = ExpressionTranslator.Translate(xamlReader);
                if (result.Errors.Count > 0)
                {
                    var message = CreateErrorMessage(result);
                    throw new ApplicationException(message);
                }
                else
                    return CreateXamlString(result.Output);
            }
        }

        private static string CreateXamlString(XamlReader reader)
        {
            var stringBuilder = new StringBuilder();
            var xmlWriterSettings = new XmlWriterSettings { Indent = true, OmitXmlDeclaration = true };

            using (var xmlWriter = XmlWriter.Create(stringBuilder, xmlWriterSettings))
            using (var writer = new XamlXmlWriter(xmlWriter, reader.SchemaContext))
                XamlServices.Transform(reader, writer);

            return stringBuilder.ToString();
        }

        private static string CreateErrorMessage(TranslationResults result)
        {
            var stringBuilder = new StringBuilder();
            stringBuilder.AppendFormat("Error: Failed to translate workflow with {0} errors", result.Errors.Count);
            foreach (var error in result.Errors)
                stringBuilder.AppendFormat("\n Expression: {0}, Message: {1}", error.ExpressionText, error.Message);
            return stringBuilder.ToString();
        }
    }
}