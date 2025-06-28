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
                // Validate required fields
                if (productData == null || !productData.ContainsKey("name") || string.IsNullOrWhiteSpace(productData["name"]?.ToString()))
                {
                    response["success"] = false;
                    response["message"] = "Product name is required.";
                    return serializer.Serialize(response);
                }

                string name = productData["name"].ToString();
                string description = productData.ContainsKey("description") ? productData["description"]?.ToString() ?? "" : "";
                string category = productData.ContainsKey("category") ? productData["category"]?.ToString() ?? "" : "";
                string price = productData.ContainsKey("price") ? productData["price"]?.ToString() ?? "" : "";
                string imageBase64 = productData.ContainsKey("image") ? productData["image"]?.ToString() : null;


                if (price == "")
                {
                    response["success"] = true;
                    response["message"] = "hello";
                    return serializer.Serialize(response);
                }
                string savedImagePath = null;

                // Handle base64 image
                if (!string.IsNullOrEmpty(imageBase64))
                {
                    try
                    {
                        string base64Data = imageBase64;
                        string extension = "jpg"; // default

                        if (imageBase64.Contains(","))
                        {
                            var parts = imageBase64.Split(',');
                            base64Data = parts[1];

                            var mimeType = parts[0].Split(';')[0].Split(':')[1]; // e.g., image/png
                            extension = mimeType.Split('/')[1]; // e.g., png
                        }

                        byte[] imageBytes = Convert.FromBase64String(base64Data);
                        string fileName = $"product_{Guid.NewGuid()}.{extension}";
                        string relativePath = $"static/images/{fileName}";
                        string fullPath = HostingEnvironment.MapPath("~/" + relativePath);

                        // Ensure directory exists
                        string dirPath = Path.GetDirectoryName(fullPath);
                        if (!Directory.Exists(dirPath))
                        {
                            Directory.CreateDirectory(dirPath);
                        }

                        // Save the image
                        File.WriteAllBytes(fullPath, imageBytes);
                        savedImagePath = relativePath;

                        response["savedImage"] = savedImagePath;
                    }
                    catch (Exception imgEx)
                    {
                        response["imageError"] = "Failed to process image: " + imgEx.Message;
                    }
                }

                // Final success response
                response["success"] = true;
                response["message"] = $"Product '{name}' saved successfully.";
                response["product"] = new
                {
                    name,
                    description,
                    category,
                    price,
                    image = savedImagePath ?? "No image"
                };

                return serializer.Serialize(response);
            }
            catch (Exception ex)
            {
                // Log error internally if needed
                response["success"] = false;
                response["message"] = "Internal server error. Please try again later.";
                return serializer.Serialize(response);
            }
        }
    }
}
