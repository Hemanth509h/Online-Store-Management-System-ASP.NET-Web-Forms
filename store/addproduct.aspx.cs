
using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Web.Hosting;
using System.IO;

namespace store
{
    public partial class addproduct : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = true)]
        public static string AddProduct(Dictionary<string, object> productData)
        {
            var response = new Dictionary<string, object>();
            var serializer = new JavaScriptSerializer();

            try
            {
                // Check if productData is null
                if (productData == null)
                {
                    response["success"] = false;
                    response["message"] = "No product data received.";
                    return serializer.Serialize(response);
                }

                // Validate required fields
                if (!productData.ContainsKey("name") || string.IsNullOrEmpty(productData["name"]?.ToString()))
                {
                    response["success"] = false;
                    response["message"] = "Product name is required.";
                    return serializer.Serialize(response);
                }

                string name = productData["name"].ToString().Trim();
                string description = productData.ContainsKey("description") ? productData["description"]?.ToString()?.Trim() ?? "" : "";
                string category = productData.ContainsKey("category") ? productData["category"]?.ToString()?.Trim() ?? "" : "";

                // Validate price
                if (!productData.ContainsKey("price") || !decimal.TryParse(productData["price"].ToString(), out decimal price))
                {
                    response["success"] = false;
                    response["message"] = "Invalid price format.";
                    return serializer.Serialize(response);
                }

                string imagePath = null;
                if (productData.ContainsKey("image") && productData["image"] != null)
                {
                    string imageBase64 = productData["image"].ToString();

                    // Check if it's a data URL (might not be if coming from different client)
                    if (imageBase64.StartsWith("data:image"))
                    {
                        imageBase64 = imageBase64.Substring(imageBase64.IndexOf(',') + 1);
                    }

                    try
                    {
                        byte[] imageBytes = Convert.FromBase64String(imageBase64);

                        // Get file extension from the base64 header if available
                        string extension = "jpg"; // default
                        if (productData["image"].ToString().StartsWith("data:image"))
                        {
                            extension = productData["image"].ToString().Split(';')[0].Split('/')[1];
                        }

                        string fileName = $"{name}.{extension}";
                        string folderPath = HostingEnvironment.MapPath("~/static/images/");

                        if (!Directory.Exists(folderPath))
                            Directory.CreateDirectory(folderPath);

                        string filePath = Path.Combine(folderPath, fileName);
                        File.WriteAllBytes(filePath, imageBytes);

                        imagePath = $"/static/images/{fileName}";
                    }
                    catch (Exception ex)
                    {
                        response["success"] = false;
                        response["message"] = $"Image processing failed: {ex.Message}";
                        return serializer.Serialize(response);
                    }
                }

                // TODO: Add database insertion logic here

                response["success"] = true;
                response["message"] = $"Product '{name}' saved successfully.";
                if (!string.IsNullOrEmpty(imagePath))
                {
                    response["imagePath"] = imagePath;
                }

                return serializer.Serialize(response);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.WriteLine($"Full error in AddProduct: {ex.ToString()}");
                response["success"] = false;
                response["message"] = $"Internal server error: {ex.Message}";
                response["stackTrace"] = ex.StackTrace; // Only for debugging!
                return serializer.Serialize(response);
            }
        }
    }
}
