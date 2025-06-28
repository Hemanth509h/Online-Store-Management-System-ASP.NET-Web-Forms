<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addproduct.aspx.cs" Inherits="store.addproduct" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        body {
            background: linear-gradient(270deg, #121212, #272727, #121212);
            background-size: 600% 600%;
            animation: gradientBackground 8s ease infinite;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100vh;
        }
        @keyframes gradientBackground {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .toast {
            visibility: hidden;
            min-width: 250px;
            margin: 0 auto;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 5px;
            padding: 16px;
            position: fixed;
            z-index: 1000;
            left: 50%;
            top: 50px;
            transform: translateX(-50%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            opacity: 0;
            transition: opacity 0.5s ease-in-out, visibility 0.5s ease-in-out;
        }
        .toast.show { visibility: visible; opacity: 1; }
        .toast.success { background-color: #4caf50; }
        .toast.error { background-color: #f44336; }
        .toast.warning { background-color: #ffae42; }
        h1{
            text-align:center;
            color:#8affa3;
            margin-top:0px;
        }

        #addproduct {
            top: 19%;
            position: fixed;
            width: 85%;
            height: 65%;
            padding: 25px 30px;
            border-radius: 15px;
            border: 2px solid #8affa3;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
            background: linear-gradient(270deg, #121212, #272727, #121212);
            animation: gradientBackground 8s ease infinite;
            color: #ffffff;
            overflow: auto;
            z-index: 10;
        }
        table { border: 1px solid #8affa3; width: 100%; border-collapse: collapse; }
        th, td {
            padding: 10px;
            text-align: center;
            color: #8affa3;
            
        }
        img.product-image {
    width: 50px;
}
        thead{
            border: 1px solid #8affa3;
        }
        input[type="text"], input[type="number"], input[type="file"], select {
            width: 90%;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #8affa3;
            background: linear-gradient(270deg, #121212, #272727, #121212);
            color: #8affa3;
        }
        button {
            margin-right: 10px;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            background-color: #8affa3;
            color: #1e1e1e;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        button:hover { background-color: #5fd78f; }
        #buttons {
            position: absolute;
            right: 0px;
            margin-right: 35px;
            margin-top:15px;
        }
        #addproduct1 {
            border: 1px solid #8affa3;
            border-radius: 15px;
            height: 85%;
            overflow-y: auto;
        }
        #addproductform {
            position: absolute;
            border: 1px solid #8affa3;
            padding: 25px 30px;
            bottom: 25px;
            border-radius: 15px;
            background: linear-gradient(270deg, #121212, #272727, #121212);
            display: flex;
            flex-direction: column;
            align-items: start;
        }
        #category {
            border-radius: 50px;
            border: 2px solid #8affa3;
            background: linear-gradient(270deg, #121212, #272727, #121212);
            color: #8affa3;
        }
    </style>
</head>
<body>
    <div id="toast" class="toast"><span id="toast-message"></span></div>

    <div id="addproduct">
        <h1>Add Product</h1>
        <div id="addproduct1">
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Product Name</th>
                        <th>Product Category</th>
                        <th>Description</th>
                        <th>Price ₹</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="productTableBody"></tbody>
            </table>
            <div id="buttons">
                <button type="button" onclick="document.getElementById('addproductform').style.display='block'">Add</button>
            </div>
        </div>
        <form id="addproductform" style="display:none">
            <table>
                <tr><td><label for="image">Image File:</label></td><td><input id="image" type="file" /></td></tr>
                <tr><td><label for="name">Product Name:</label></td><td><input id="name" type="text" /></td></tr>
                <tr>
                    <td><label for="category">Category:</label></td>
                    <td><select id="category">
                        <option>-- Select Category --</option>
                        <option value="Fresh_Produce">Fresh Produce</option>
                        <option value="Dairy_Eggs">Dairy & Eggs</option>
                        <option value="Meat_Seafood">Meat & Seafood</option>
                        <option value="Bakery_Bread">Bakery & Bread</option>
                        <option value="Pantry_Staples">Pantry Staples</option>
                        <option value="Beverages">Beverages</option>
                        <option value="Frozen_Foods">Frozen Foods</option>
                        <option value="Health_Wellness">Health & Wellness</option>
                        <option value="Household_Cleaning_Supplies">Cleaning Supplies</option>
                        <option value="Personal_Care">Personal Care</option>
                    </select></td>
                </tr>
                <tr><td><label for="description">Description:</label></td><td><input id="description" type="text" /></td></tr>
                <tr><td><label for="price">Price:</label></td><td><input id="price" type="number" /></td></tr>
                <tr><td colspan="2" style="text-align:right;">
                    <button type="submit">Add Product</button>
                    <button type="button" onclick="document.getElementById('addproductform').style.display='none'">Close</button>
                </td></tr>
            </table>
        </form>
    </div>

  <script>
      // Move this outside the event handler
      function getBase64(file) {
          return new Promise((resolve, reject) => {
              const reader = new FileReader();
              reader.readAsDataURL(file);
              reader.onload = () => resolve(reader.result);
              reader.onerror = error => reject(error);
          });
      }

      document.getElementById("addproductform").addEventListener("submit", async function (e) {
          e.preventDefault();

          // Get form values
          const name = document.getElementById("name").value.trim();
          const category = document.getElementById("category").value;
          const description = document.getElementById("description").value.trim();
          const price = document.getElementById("price").value;
          const imageFile = document.getElementById("image").files[0];

          // Validate inputs
          if (!name || !category || !description || !price) {
              return showToast("All fields are required.", "warning");
          }

          // Validate price format
          if (isNaN(price) || parseFloat(price) <= 0) {
              return showToast("Please enter a valid price.", "warning");
          }

          let base64Image = "";
          if (imageFile) {
              try {
                  base64Image = await getBase64(imageFile);
              } catch (error) {
                  console.error("Image conversion error:", error);
                  return showToast("Error processing image.", "error");
              }
          }
          const product = {
              name,
              description,
              category,
              price: parseFloat(price).toFixed(2),
              image: base64Image
          };

          addProductToTable(product);
          document.getElementById("addproductform").reset();
          document.getElementById("addproductform").style.display = "none";
          showToast("Product added. Click Upload to save.", "success");
      });

      function addProductToTable(product) {
          const tbody = document.getElementById("productTableBody");
          const tr = document.createElement("tr");
          tr.dataset.productName = encodeURIComponent(product.name);

          tr.innerHTML = `
        <td>${product.image ? `<img src="${product.image}" class="product-image" />` : 'No Image'}</td>
        <td>${product.name}</td>
        <td>${product.category}</td>
        <td>${product.description}</td>
        <td>₹${product.price}</td>
        <td>
            <button class="upload-btn">Upload</button>
            <button class="delete-btn">Delete</button>
        </td>`;

          tbody.appendChild(tr);

          // Attach event to Upload button
          tr.querySelector(".upload-btn").addEventListener("click", function () {
              uploadToServer(product, this);
          });

          // Attach event to Delete button
          tr.querySelector(".delete-btn").addEventListener("click", function () {
              tr.remove();
              showToast("Product removed.", "info");
          });
      }

      function uploadToServer(product, button) {
          button.disabled = true;
          button.textContent = "Uploading...";
          button.classList.add("uploading");

          // Create the exact structure the server expects
          const requestData = {
              name: product.name,
              description: product.description,
              category: product.category,
              price: product.price
          };

          // Only add image if it exists and is valid
          if (product.image && product.image.startsWith('data:image')) {
              requestData.image = product.image;
          }

          fetch("addproduct.aspx/AddProduct", {
              method: "POST",
              headers: {
                  "Content-Type": "application/json",
              },
              body: JSON.stringify({
                  productData: requestData // Match the server parameter name
              })
          })
              .then(res => {
                  if (!res.ok) throw new Error("Network response was not ok");
                  return res.json();
              })
              .then(data => {
                  const result = data.d ? JSON.parse(data.d) : data;
                  if (result.success) {
                      button.textContent = "✓ Uploaded";
                      button.classList.remove("uploading");
                      button.classList.add("uploaded");
                      showToast(result.message, "success");
                  } else {
                      throw new Error(result.message || "Unknown error occurred");
                  }
              })
              .catch(err => {
                  console.error("Upload Error:", err);
                  button.textContent = "Upload";
                  button.disabled = false;
                  button.classList.remove("uploading");
                  showToast("Upload failed: " + err.message, "error");
              });
      }
  </script>

    <script>
        function showToast(message, type = "success") {
            const toast = document.getElementById("toast");
            const toastMessage = document.getElementById("toast-message");
            toastMessage.innerText = message;
            toast.className = `toast show ${type}`;
            setTimeout(() => toast.className = toast.className.replace("show", ""), 5000);
        }
    </script>
</body>
</html>