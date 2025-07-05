using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace store
{
    public partial class distributor : System.Web.UI.Page
    {
        // MongoDB setup
        private static MongoClient client = new MongoClient("mongodb+srv://phemanthkumar746:htnameh509h@data.psr09.mongodb.net/?retryWrites=true&w=majority&appName=Data");
        private static IMongoDatabase database = client.GetDatabase("myLoginDatabase");
        private static IMongoCollection<BsonDocument> orders = database.GetCollection<BsonDocument>("Orders");

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        [WebMethod(EnableSession = true)]
        public static string GetOrders()
        {
            var ordersList = new List<Dictionary<string, object>>();
            var docs = orders.Find(_ => true).ToList();

            foreach (var doc in docs)
            {
                var order = new Dictionary<string, object>();
                foreach (var el in doc.Elements)
                {
                    if (el.Name == "_id")
                        order[el.Name] = el.Value.ToString();
                    else
                        order[el.Name] = BsonValueToDotNet(el.Value);
                }
                ordersList.Add(order);
            }

            var json = new JavaScriptSerializer().Serialize(new { orders = ordersList });
            return json;
        }
        [WebMethod]
        public static string TodayOrders()
        {
            var today = DateTime.UtcNow.Date; // UTC today date at midnight

            var ordersList = new List<Dictionary<string, object>>();
            var docs = orders.Find(_ => true).ToList();

            foreach (var doc in docs)
            {
                var orderDateValue = doc.GetValue("orderDate", null);
                if (orderDateValue != null)
                {
                    DateTime orderDate;

                    // Try parsing the ISO8601 string with timezone info
                    if (DateTime.TryParse(orderDateValue.ToString(), out orderDate))
                    {
                        // Compare only the date part (ignore time)
                        if (orderDate.Date == today)
                        {
                            var order = new Dictionary<string, object>();
                            foreach (var el in doc.Elements)
                            {
                                if (el.Name == "_id")
                                    order[el.Name] = el.Value.ToString();
                                else
                                    order[el.Name] = BsonValueToDotNet(el.Value);
                            }
                            ordersList.Add(order);
                        }
                    }
                }
            }

            var json = new JavaScriptSerializer().Serialize(new { orders = ordersList });
            return json;
        }

        [WebMethod]
        public static void UpdateOrderStatus(string orderId, string status)
        {
            var filter = Builders<BsonDocument>.Filter.Eq("_id", ObjectId.Parse(orderId));
            var update = Builders<BsonDocument>.Update.Set("status", status);
            orders.UpdateOne(filter, update);
        }

        [WebMethod]
        public static void DeleteOrder(string orderId)
        {
            var filter = Builders<BsonDocument>.Filter.Eq("_id", ObjectId.Parse(orderId));
            orders.DeleteOne(filter);
        }

        // Helper method to convert BsonValue to native .NET types for serialization
        private static object BsonValueToDotNet(BsonValue val)
        {
            if (val == null || val.IsBsonNull) return null;

            if (val.IsString) return val.AsString;
            if (val.IsInt32) return val.AsInt32;
            if (val.IsInt64) return val.AsInt64;
            if (val.IsDouble) return val.AsDouble;
            if (val.IsBoolean) return val.AsBoolean;
            if (val.IsValidDateTime) return val.ToUniversalTime().ToString("o"); // ISO 8601 format string
            if (val.IsBsonArray) return val.AsBsonArray.Select(BsonValueToDotNet).ToList();
            if (val.IsBsonDocument)
            {
                // Convert document recursively to Dictionary<string, object>
                var dict = new Dictionary<string, object>();
                foreach (var element in val.AsBsonDocument.Elements)
                {
                    dict[element.Name] = BsonValueToDotNet(element.Value);
                }
                return dict;
            }

            // fallback
            return val.ToString();
        }
    }
}