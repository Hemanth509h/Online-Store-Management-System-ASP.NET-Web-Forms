using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Driver;
using Scrypt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace store
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        // MongoDB connection string
        private static string connectionString = "mongodb+srv://phemanthkumar746:htnameh509h@data.psr09.mongodb.net/?retryWrites=true&w=majority&appName=Data";

        [WebMethod(EnableSession = true)]
        public static string Register()
        {
            var serializer = new JavaScriptSerializer();

            try
            {
                HttpContext context = HttpContext.Current;
                context.Request.InputStream.Position = 0;

                using (var reader = new System.IO.StreamReader(context.Request.InputStream))
                {
                    string json = reader.ReadToEnd();
                    var data = serializer.Deserialize<Dictionary<string, string>>(json);

                    string fullname = data.ContainsKey("registerfullname") ? data["registerfullname"] : null;
                    string username = data.ContainsKey("registerUsername") ? data["registerUsername"].Trim() : null;
                    string email = data.ContainsKey("registerEmail") ? data["registerEmail"].Trim() : null;
                    string password1 = data.ContainsKey("password1") ? data["password1"] : null;
                    string password2 = data.ContainsKey("password2") ? data["password2"] : null;
                    string role = data.ContainsKey("role") ? data["role"] : null;

                    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email) ||
                        string.IsNullOrEmpty(password1) || string.IsNullOrEmpty(password2))
                    {
                        return serializer.Serialize(new { status = "error", message = "All fields are required." });
                    }

                    if (password1 != password2)
                    {
                        return serializer.Serialize(new { status = "error", message = "Passwords do not match!" });
                    }

                    var client = new MongoClient(connectionString);
                    var database = client.GetDatabase("myLoginDatabase");
                    var usersCollection = database.GetCollection<BsonDocument>("users");

                    // Check if username or email already exists
                    var filter = Builders<BsonDocument>.Filter.Or(
                        Builders<BsonDocument>.Filter.Eq("username", username),
                        Builders<BsonDocument>.Filter.Eq("email", email)
                    );

                    var existingUser = usersCollection.Find(filter).FirstOrDefault();
                    if (existingUser != null)
                    {
                        return serializer.Serialize(new { status = "error", message = "Username or email already exists!" });
                    }

                    // Hash password with scrypt — use positional parameters: cpuCost, blockSize, parallelization
                    var encoder = new ScryptEncoder(16384, 8, 1);
                    string hashedPassword = encoder.Encode(password1);

                    var newUser = new BsonDocument
                    {
                        {"fullname",fullname },
                        { "username", username },
                        { "email", email },
                        { "password", hashedPassword },
                        {"role",role }
                    };

                    usersCollection.InsertOne(newUser);

                    return serializer.Serialize(new { status = "success", message = "Registration successful!" });
                }
            }
            catch (Exception ex)
            {
                return serializer.Serialize(new { status = "error", message = "An error occurred: " + ex.Message });
            }
        }

        [WebMethod(EnableSession = true)]
        public static string Login()
        {
            var serializer = new JavaScriptSerializer();

            try
            {
                HttpContext context = HttpContext.Current;
                context.Request.InputStream.Position = 0;

                using (var reader = new System.IO.StreamReader(context.Request.InputStream))
                {
                    string json = reader.ReadToEnd();
                    var data = serializer.Deserialize<Dictionary<string, string>>(json);

                    string loginIdentifier = data.ContainsKey("useroremailin") ? data["useroremailin"].Trim() : null;
                    string password = data.ContainsKey("passin") ? data["passin"] : null;
                    string role = data.ContainsKey("role") ? data["role"] : null;
                    string pincode = data.ContainsKey("pincode") ? data["pincode"] : null;

                    if (string.IsNullOrEmpty(loginIdentifier) || string.IsNullOrEmpty(password))
                    {
                        return serializer.Serialize(new { status = "error", message = "Username or password cannot be empty." });
                    }

                    var client = new MongoClient(connectionString);
                    var database = client.GetDatabase("myLoginDatabase");
                    var usersCollection = database.GetCollection<BsonDocument>("users");

                    var filter = Builders<BsonDocument>.Filter.Or(
                        Builders<BsonDocument>.Filter.Eq("username", loginIdentifier),
                        Builders<BsonDocument>.Filter.Eq("email", loginIdentifier)
                    );

                    var userDoc = usersCollection.Find(filter).FirstOrDefault();

                    if (userDoc != null)
                    {
                        string storedHash = userDoc["password"].AsString;

                        var encoder = new ScryptEncoder(); // defaults for verification
                        bool isPasswordValid = encoder.Compare(password, storedHash);

                        if (isPasswordValid)
                        {

                            string username = userDoc["username"].AsString;
                            string email = userDoc["email"].AsString;
                            string userRole = userDoc.Contains("role") ? userDoc["role"].AsString : "customer";

                            if (userRole != role)
                            {
                                return serializer.Serialize(new { status = "error", message = "Invalid role for this user." });
                            }
                            context.Session["username"] = username;
                            context.Session["email"] = email;

                            if (userRole == "customer")
                            {
                                string fullname = userDoc["fullname"].AsString;
                                context.Session["fullname"] = fullname;

                            }

                            if (userRole == "distributor")
                            {
                                string distributorname = userDoc["distributorname"].AsString;
                                string pincode1 = userDoc["pincode"].AsString;
                                if (pincode1 != pincode)
                                {
                                    return serializer.Serialize(new { status = "error", message = "Invalid pincode for this user." });
                                }
                                context.Session["distributorname"] = distributorname;
                                context.Session["pincode"] = pincode1;
                            }

                            var response = new
                            {
                                status = "success",
                                message = "Login successful!",
                                role = userRole
                            };

                            return serializer.Serialize(response);
                        }
                        else
                        {
                            return serializer.Serialize(new { status = "error", message = "Invalid password!" });
                        }
                    }
                    else
                    {
                        return serializer.Serialize(new { status = "error", message = "Username not found!" });
                    }
                }
            }
            catch (Exception ex)
            {
                return serializer.Serialize(new { status = "error", message = "An error occurred: " + ex.Message });
            }
        }


        [WebMethod(EnableSession = true)]
        public static string placeorder()
        {
            var serializer = new JavaScriptSerializer();

            try
            {
                HttpContext context = HttpContext.Current;
                context.Request.InputStream.Position = 0;

                using (var reader = new System.IO.StreamReader(context.Request.InputStream))
                {
                    string json = reader.ReadToEnd();
                    var data = serializer.Deserialize<Dictionary<string, object>>(json);

                    // Required fields
                    var username = context.Session["username"]?.ToString();
                    var email = context.Session["email"]?.ToString();

                    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email))
                    {
                        return serializer.Serialize(new { status = "error", message = "User not logged in." });
                    }

                    string address = data.ContainsKey("address") ? data["address"].ToString() : null;
                    string phoneNumber = data.ContainsKey("phone_number") ? data["phone_number"].ToString() : null;
                    string pincode = data.ContainsKey("pincode") ? data["pincode"].ToString() : null;
                    string paymentOption = data.ContainsKey("paymentOption") ? data["paymentOption"].ToString() : null;
                    object items = data.ContainsKey("items") ? data["items"] : null;
                    double totalPrice = data.ContainsKey("totalPrice") ? Convert.ToDouble(data["totalPrice"]) : 0.0;

                    if (string.IsNullOrEmpty(address) || string.IsNullOrEmpty(phoneNumber) || string.IsNullOrEmpty(pincode))
                    {
                        return serializer.Serialize(new { status = "error", message = "Missing order details." });
                    }

                    var client = new MongoClient(connectionString);
                    var database = client.GetDatabase("myLoginDatabase");
                    var ordersCollection = database.GetCollection<BsonDocument>("Orders");

                    var orderDoc = new BsonDocument
            {
                { "address", address },
                { "phone_number", phoneNumber },
                { "pincode", pincode },
                { "paymentOption", paymentOption },
                { "items", BsonDocument.Parse(new JavaScriptSerializer().Serialize(items)) },
                { "totalPrice", totalPrice },
                { "username", username },
                { "email", email },
                { "status", "Pending" },
                { "orderDate", DateTime.UtcNow }
            };

                    ordersCollection.InsertOne(orderDoc);

                    return serializer.Serialize(new { status = "success", message = "Order placed successfully!" });
                }
            }
            catch (Exception ex)
            {
                return serializer.Serialize(new { status = "error", message = "An error occurred: " + ex.Message });
            }
        }


        [WebMethod(EnableSession = true)]
        public static string orders()
        {
            var serializer = new JavaScriptSerializer();

            try
            {
                HttpContext context = HttpContext.Current;
                string username = context.Session["username"]?.ToString();

                if (string.IsNullOrEmpty(username))
                {
                    return serializer.Serialize(new { status = "error", message = "User not logged in" });
                }

                var client = new MongoClient(connectionString);
                var database = client.GetDatabase("myLoginDatabase");
                var ordersCollection = database.GetCollection<BsonDocument>("Orders");

                var filter = Builders<BsonDocument>.Filter.Eq("username", username);
                var orders = ordersCollection.Find(filter).ToList();
                if (orders.Count == 0)
                {
                    return serializer.Serialize(new { status = "success", message = "No orders found for this user." });
                }
                var orderList = new List<Dictionary<string, object>>();

                foreach (var order in orders)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (var element in order.Elements)
                    {
                        if (element.Name == "_id")
                        {
                            dict["_id"] = element.Value.ToString(); // Convert ObjectId to string
                        }
                        else if (element.Name == "items")
                        {
                            // Convert BSON items back to Dictionary
                            var itemsDoc = BsonSerializer.Deserialize<Dictionary<string, object>>(element.Value.AsBsonDocument);
                            dict["items"] = itemsDoc;
                        }
                        else
                        {
                            dict[element.Name] = BsonTypeMapper.MapToDotNetValue(element.Value);
                        }
                    }

                    orderList.Add(dict);
                }

                return serializer.Serialize(new { status = "success", orders = orderList });
            }
            catch (Exception ex)
            {
                return serializer.Serialize(new { status = "error", message = "An error occurred: " + ex.Message });
            }
        }

        [System.Web.Services.WebMethod]
        public static string logout()
        {
            // Perform logout actions here, like clearing session
            HttpContext.Current.Session.Abandon();

            var result = new { status = "success", message = "Logged out successfully." };
            return new JavaScriptSerializer().Serialize(result);
        }


        [WebMethod]
        public static string GetProducts(string category)
        {
            var client = new MongoClient(connectionString);
            var database = client.GetDatabase("grocery_store");

            var collection = database.GetCollection<BsonDocument>(category);
            var documents = collection.Find(new BsonDocument()).ToList();

            var productList = new List<Dictionary<string, object>>();
            foreach (var doc in documents)
            {
                var dict = new Dictionary<string, object>();
                foreach (var element in doc.Elements)
                {
                    dict[element.Name] = BsonTypeMapper.MapToDotNetValue(element.Value);
                }
                productList.Add(dict);
            }

            var serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return serializer.Serialize(productList);
        }

        [WebMethod]
        public static string SearchProducts(string query)
        {
            var client = new MongoClient(connectionString);
            var database = client.GetDatabase("grocery_store");
            var collections = new List<string>
    {
        "Fresh_Produce", "Dairy_Eggs", "Meat_Seafood", "Bakery_Bread",
        "Pantry_Staples", "Beverages", "Frozen_Foods", "Health_Wellness",
        "Household_Cleaning_Supplies", "Personal_Care"
    };

            var productList = new List<Dictionary<string, object>>();

            foreach (var collectionName in collections)
            {
                var collection = database.GetCollection<BsonDocument>(collectionName);

                var filter = string.IsNullOrEmpty(query)
                    ? Builders<BsonDocument>.Filter.Empty
                    : Builders<BsonDocument>.Filter.Regex("product_name", new BsonRegularExpression(query, "i"));

                var documents = collection.Find(filter).ToList();

                foreach (var doc in documents)
                {
                    var dict = new Dictionary<string, object>();
                    foreach (var element in doc.Elements)
                    {
                        dict[element.Name] = BsonTypeMapper.MapToDotNetValue(element.Value);
                    }

                    // Optionally add category info for identification
                    dict["category"] = collectionName;

                    productList.Add(dict);
                }
            }

            var serializer = new JavaScriptSerializer { MaxJsonLength = int.MaxValue };
            return serializer.Serialize(productList);
        }
    
    [WebMethod(EnableSession = true)]
        public static string LoginOrNot()
        {
            var serializer = new JavaScriptSerializer();
            try
            {
                HttpContext context = HttpContext.Current;
                string username = context.Session["username"]?.ToString();
                string email = context.Session["email"]?.ToString();

                if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email))
                {
                    return serializer.Serialize(new { status = "error", message = "User is not logged in." });
                }

                return serializer.Serialize(new
                {
                    status = "success",
                    message = "User is logged in."
                });
            }
            catch (Exception ex)
            {
                return serializer.Serialize(new { status = "error", message = "An error occurred: " + ex.Message });
            }
        }


    }
}
