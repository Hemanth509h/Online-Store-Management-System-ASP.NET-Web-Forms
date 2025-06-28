using MongoDB.Bson;
using MongoDB.Driver;
using Scrypt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.IO; 



namespace store
{
    public partial class admin : System.Web.UI.Page
    {
        // MongoDB setup
        private static MongoClient client = new MongoClient("mongodb+srv://phemanthkumar746:htnameh509h@data.psr09.mongodb.net/?retryWrites=true&w=majority&appName=Data");
        private static IMongoDatabase database = client.GetDatabase("myLoginDatabase");
        private static IMongoCollection<BsonDocument> orders = database.GetCollection<BsonDocument>("Orders");
        private static IMongoCollection<BsonDocument> usersCollection = database.GetCollection<BsonDocument>("users");


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

        [WebMethod(EnableSession = true)]
       public static string GetUser(string role)
{
            var usersList = new List<Dictionary<string, object>>();
            var filter = Builders<BsonDocument>.Filter.Eq("role", role);
            var users = usersCollection.Find(filter).ToList();

            foreach (var user in users)
    {
        var dict = new Dictionary<string, object>();
        foreach (var element in user.Elements)
        {
            dict[element.Name] = element.Value.ToString();
        }
        usersList.Add(dict);
    }

    var json = new JavaScriptSerializer().Serialize(new { users = usersList });
    return json;
}

        [WebMethod(EnableSession = true)]
        public static void Deleteuser(string userId)
        {
            var filter = Builders<BsonDocument>.Filter.Eq("_id", ObjectId.Parse(userId));
            usersCollection.DeleteOne(filter); // FIXED: previously was 'orders'
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

        [WebMethod(EnableSession = true)]
        public static void UpdateOrderStatus(string orderId, string status)
        {
            var filter = Builders<BsonDocument>.Filter.Eq("_id", ObjectId.Parse(orderId));
            var update = Builders<BsonDocument>.Update.Set("status", status);
            orders.UpdateOne(filter, update);
        }

        [WebMethod(EnableSession = true)]
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

        [WebMethod(EnableSession = true)]
        public static string GetDashboardStats()
        {
            var stats = new Dictionary<string, object>();

            // Get user stats
            var totalUsers = usersCollection.CountDocuments(Builders<BsonDocument>.Filter.Empty);
            var customerCount = usersCollection.CountDocuments(Builders<BsonDocument>.Filter.Eq("role", "customer"));
            var distributorCount = usersCollection.CountDocuments(Builders<BsonDocument>.Filter.Eq("role", "distributor"));

            // Get order stats
            var allOrders = orders.Find(_ => true).ToList();
            var totalOrders = allOrders.Count;
            double totalRevenue = 0;

            var statusCount = new Dictionary<string, int>();

            foreach (var order in allOrders)
            {
                // Count revenue
                if (order.Contains("totalPrice"))
                {
                    double price;
                    if (double.TryParse(order["totalPrice"].ToString(), out price))
                        totalRevenue += price;
                }

                // Count statuses
                string status = order.Contains("status") ? order["status"].ToString() : "Unknown";
                if (!statusCount.ContainsKey(status))
                    statusCount[status] = 0;
                statusCount[status]++;
            }

            stats["totalUsers"] = totalUsers;
            stats["customers"] = customerCount;
            stats["distributors"] = distributorCount;
            stats["totalOrders"] = totalOrders;
            stats["totalRevenue"] = totalRevenue;
            stats["ordersByStatus"] = statusCount;

            return new JavaScriptSerializer().Serialize(stats);
        }


        [WebMethod(EnableSession = true)]
        public static string AddUser(Dictionary<string, object> userData)
        {
            var response = new Dictionary<string, object>();

            if (userData == null || !userData.ContainsKey("role") || string.IsNullOrWhiteSpace(userData["role"]?.ToString()))
            {
                response["success"] = false;
                response["message"] = "Role is required.";
                return new JavaScriptSerializer().Serialize(response);
            }

            string role = userData["role"].ToString();
            var document = new BsonDocument();

            try
            {
                // Get raw password first
                string rawPassword = userData.ContainsKey("password") ? userData["password"]?.ToString() ?? "" : "";

                // Hash it using Scrypt
                var encoder = new ScryptEncoder(16384, 8, 1);
                string hashedPassword = encoder.Encode(rawPassword);
                
                document["role"] = role;
                document["email"] = userData.ContainsKey("email") ? userData["email"]?.ToString() ?? "" : "";
                string password = userData.ContainsKey("password") ? userData["password"]?.ToString() ?? "" : "";
                document["password"] = hashedPassword;


                if (role == "distributor")
                {
                    document["distributorname"] = userData.ContainsKey("distributorname") ? userData["distributorname"]?.ToString() ?? "" : "";
                    document["username"] = userData.ContainsKey("username") ? userData["username"]?.ToString() ?? "" : "";
                    document["pincode"] = userData.ContainsKey("pincode") ? userData["pincode"]?.ToString() ?? "" : "";
                }
                else if (role == "customer")
                {
                    document["fullname"] = userData.ContainsKey("fullname") ? userData["fullname"]?.ToString() ?? "" : "";
                    document["username"] = userData.ContainsKey("username") ? userData["username"]?.ToString() ?? "" : "";
                }
                else if (role == "admin")
                {
                    document["username"] = userData.ContainsKey("username") ? userData["username"]?.ToString() ?? "" : "";
                }
                else
                {
                    response["success"] = false;
                    response["message"] = "Invalid role specified.";
                    return new JavaScriptSerializer().Serialize(response);
                }

                usersCollection.InsertOne(document);

                response["success"] = "success";
                response["message"] = "User added successfully.";
            }
            catch (Exception ex)
            {
                response["success"] = false;
                response["message"] = "Error: " + ex.Message;
            }

            return new JavaScriptSerializer().Serialize(response);
        }




      

    }

}
