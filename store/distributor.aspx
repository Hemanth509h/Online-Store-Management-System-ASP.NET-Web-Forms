<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="distributor.aspx.cs" Inherits="store.distributor" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Admin - Orders</title>
        <style>
            body {
                background-color: #121212;
                display: flex;
                flex-direction: column;
                align-items: center;
                height: 100vh;
                background: linear-gradient(270deg, #121212, #272727, #121212);
                background-size: 600% 600%;
                animation: gradientBackground 8s ease infinite;
            }
            @keyframes gradientBackground {
                0% {
                    background-position: 0% 50%;
                }
                50% {
                    background-position: 100% 50%;
                }
                100% {
                    background-position: 0% 50%;
                }
            }
            h1 {
                text-align: center;
                color: #333;
                margin: 10px;
                color: #8affa3;
            }
            form {
                display: flex;
                align-items: center;
            }
            select {
                margin-right: 10px;
                padding: 5px;
            }
            button {
                padding: 5px 10px;
                background-color: #4caf50;
                color: white;
                border: none;
                cursor: pointer;
            }
            button:hover {
                background-color: #45a049;
            }
            .order-list {
                display: flex;
                flex-direction: column;
                gap: 20px;
                height: 800px;
                overflow-y: auto;
                scrollbar-width: thin;
                scrollbar-color: #2baa5b #1e1e1e;
                scroll-behavior: smooth;
            }
            .order-container {
                width: 1394px;
                border: solid #8affa3;
                padding: 30px;
                background-color: #ffffffa8;
                border-radius: 20px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 15px;
            }
            .order-container:hover {
                transform: translateY(-10px);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            }
            .order-header {
                font-weight: bold;
                margin-bottom: 10px;
            }
            .order-details {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;

            }
            .order-detail {
    flex: 1 1 200px;
    display: flex;
    align-items: center;
    gap: 10px;
}
            .order-actions {
                margin-top: 10px;
                display: flex;
                gap: 10px;
            }
            hr {
                border: 0;
                height: 1px;
                background: #000000;
                margin: 20px 0;
            }
            .order-container {
                opacity: 0;
                transform: translateY(10px);
                transition: opacity 0.4s ease, transform 0.4s ease;
            }
            .order-container.fade-in {
                opacity: 1;
                transform: translateY(0);
            }
            .pincode-container {
                margin-bottom: 40px;
            }
            .toast {
                visibility: hidden;
                max-width: 50%;
                margin: auto;
                background-color: #333;
                color: #fff;
                text-align: center;
                border-radius: 2px;
                padding: 16px;
                position: fixed;
                z-index: 1;
                left: 50%;
                top: 120px;
                font-size: 17px;
                transform: translateX(-50%);
            }
            .toast.show {
                visibility: visible;
                animation: fadein 0.5s, fadeout 0.5s 4.5s;
            }
            @keyframes fadein {
                from {
                    top: 0;
                    opacity: 0;
                }
                to {
                    top: 120px;
                    opacity: 1;
                }
            }
            @keyframes fadeout {
                from {
                    top: 120px;
                    opacity: 1;
                }
                to {
                    top: 0;
                    opacity: 0;
                }
            }
            @media (max-width: 786px) {
                body {
                    padding: 10px;
                }
                nav {
                    padding: 5px;
                }
                h1 {
                    font-size: 1.5em;
                }
                .order-container {
                    padding: 10px;
                    border: 1px solid #8affa3;
                }
                .order-details {
                    flex-direction: column;
                }
                .order-actions {
                    flex-direction: column;
                }
            }
        </style>
        <style>
            #navbar {
                width: 80%;
                height: 60px;
                background-color: #272727;
                text-align: center;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 5px;
                border-radius: 20px;
                margin-top: 30px;
            }
            input[type="checkbox"] {
                display: none;
            }
            .menu {
                display: none;
            }
            .logo {
                padding-left: 5%;
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .logo img {
                width: 50px;
                height: auto;
                border-radius: 50%;
            }
            .logo-name {
                color: #8affa3;
                font-size: 20px;
                letter-spacing: 2px;
            }
            .nav-links {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            nav ul {
                list-style: none;
                display: flex;
            }
            nav ul li {
                margin: auto 15px;
            }
            nav ul li a {
                color: #8affa3;
                text-decoration: none;
                font-size: 18px;
                transition: color 0.1s ease;
                display: flex;
                cursor: pointer;
            }
            nav ul li a:hover {
                color: #2e92d4;
            }
            #cart1 {
                align-items: center;
            }
            .profile {
                padding-right: 15px;
            }
            .profile-icon {
                cursor: pointer;
                width: 50px;
                height: 50px;
            }
            .profile-icon-in-links {
                width: 80px;
                height: 80px;
                margin: auto;
                background-color: rgba(127, 133, 133, 0.733);
                border-radius: 50%;
            }
            .profile-data {
                display: flex;
                justify-content: center;
                flex-direction: column;
                gap: 10px;
            }
            #cart {
                display: flex;
            }
            #Cartnumber {
                display: inline;
                transition: transform 0.3s ease;
            }
            #cart:hover #Cartnumber {
                animation: bounce 1s;
            }
            /* Updated "links-in-profileicon" styling */
            .links-in-profileicon {
                width: 370px;
                flex-direction: column;
                gap: 10px;
                position: absolute;
                background-color: rgba(255, 255, 255, 0.9);
                border-radius: 8px;
                padding: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: opacity 0.5s ease-in-out, visibility 0.5s ease-in-out;
                top: 100px;
                right: 10%;
                visibility: hidden;
                opacity: 0;
                z-index: 1;
            }
            .profile:hover .links-in-profileicon {
                visibility: visible;
                opacity: 1;
            }
            #show-username,
            #show-pincode,
            #show-distributor-name {
                color: #4caf50;
                font-size: 18px;
                text-align: center;
                margin: 0px;
            }
            #show-email {
                color: #4caf50;
                font-size: 16px;
                text-align: center;
                margin: 0px;
            }
            #logout-link {
                color: #185525;
                text-decoration: none;
                cursor: pointer;
                font-size: 18px;
                transition: color 0.1s ease;
                margin-right: 10px;
            }
            #logout-link:hover {
                color: #2e92d4;
            }
            #logout-link:active {
                color: #185525;
            }
            #cart,
            #Logindata {
                align-items: center;
            }
            #container {
                border: solid #8affa3;
                width: 95%;
                height: 75%;
                display: flex;
                flex-direction: column;
                align-items: center;
                margin-top: 50px;
            }
            .dropdown {
                position: relative;
                display: inline-block;
            }
            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 160px;
                z-index: 999;
                box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
                border-radius: 6px;
                padding: 0;
                cursor: pointer;
            }
            .dropdown-content li {
                list-style: none;
            }
            .dropdown-content li {
                text-decoration: none;
                display: block;
            }
            .dropdown-content li:hover {
                background-color: #ddd;
            }
            /* Show dropdown on hover */
            .dropdown:hover .dropdown-content {
                display: block;
            }
        </style>
    </head>
    <body>
        <nav id="navbar">
            <div class="logo">
                <img src="wwwroot/static/images/elitegrocers_logo.jpg" />
                <h2 class="logo-name">Elite Grocers</h2>
            </div>
            <input type="checkbox" id="menu-toggle" />
            <label class="menu" for="menu-toggle">☰</label>
            <div class="nav-links">
                <ul>
                    <li><a href="distributor.aspx">Home</a></li>
                    <li id="cart1" class="dropdown">
                        <a id="cart">
                            Cart :
                            <p id="totalorder"></p>
                        </a>
                        <ul class="dropdown-content">
                            <li>
                                <p id="allorders">All Orders</p>
                            </li>
                            <li>
                                <p id="todayorders">Today's Orders</p>
                            </li>
                        </ul>
                    </li>
                </ul>
                <div class="profile" id="profile">
                    <div class="profile-icon" id="profileIcon">
                        <!-- Profile icon SVG -->
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                            <path
                                d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 
                        1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"
                            />
                        </svg>
                    </div>
                    <div class="links-in-profileicon" id="links-in-profileicon">
                        <div class="profile-data">
                            <div class="profile-icon-in-links">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
                                    <path
                                        d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 
                              0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"
                                    />
                                </svg>
                            </div>
                            <h4 id="show-distributor-name">Distributor Name :<span id="distributorname"> <%=Session["distributorname"] %></span></h4>
                            <h4 id="show-pincode">Pincode :<span id="pincode"> <%=Session["pincode"] %></span></h4>
                            <h4 id="show-username">Username: <span id="usernameforplaceorder"> <%=Session["username"] %></span></h4>
                            <h4 id="show-email">Email: <%=Session["email"] %></h4>
                            <div id="loginorlogout">
                                <a id="logout-link">Logout</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <div id="toast" class="toast">
            <span id="toast-message"></span>
        </div>
        <div id="container">
            <div id="order-list" class="order-list"></div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                username = document.getElementById("usernameforplaceorder").textContent.trim();
                if (username == "") {
                    window.location.href = "index.aspx";
                } else {
                    setInterval(fetchOrders, 60000);
                    fetchOrders();
                }
                let intervalId = null;

                document.getElementById("allorders").addEventListener("click", () => {
                    if (intervalId) clearInterval(intervalId);
                    fetchOrders();
                    intervalId = setInterval(fetchOrders, 60000);
                });

                document.getElementById("todayorders").addEventListener("click", () => {
                    if (intervalId) clearInterval(intervalId);
                    todayorders();
                    intervalId = setInterval(todayorders, 60000);
                });

                let lastOrderCount = 0;
                function fetchOrders() {
                    fetch("admin.aspx/GetOrders", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: "{}",
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            const today = new Date().toISOString().split("T")[0];
                            const ordersData = JSON.parse(data.d);
                            const orderList = document.getElementById("order-list");
                            orderList.innerHTML = "";
                            let currentOrderCount = 0;

                            const heading = document.createElement("h1");
                            heading.textContent = "Orders";
                            heading.style.color = "#8affa3";
                            orderList.appendChild(heading);

                            ordersData.orders.reverse().forEach((order) => {
                                currentOrderCount++;

                                const orderContainer = document.createElement("div");
                                orderContainer.className = "order-container";
                                orderContainer.innerHTML = `
                       <div class="order-header">Order ID: ${order._id}</div>
                       <div class="order-details">
                            <div class="order-detail"><strong>Date:</strong><p id="orderdata"> ${order.orderDate}</p></div>
  <div class="order-detail"><strong>Username:</strong><p id="orderusername"> ${order.username}</p></div>
  <div class="order-detail"><strong>Email:</strong><p id="orderemail"> ${order.email}</p></div>
  <div class="order-detail"><strong>Phone:</strong><p id="orderphonenumber"> ${order.phone_number}</p></div>
  <div class="order-detail"><strong>Products:</strong> <p>${order.items
                                        ? Object.keys(order.items)
                                            .map((item) => `${item} (${order.items[item]})`)
                                            .join(", ")
                                        : ""
                                    }</p></div>
  <div class="order-detail"><strong>Price:</strong><p> ${order.totalPrice}₹</p></div>
  <div class="order-detail"><strong>Address:</strong><p> ${order.address}</p></div>
  <div class="order-detail"><strong>Pincode:</strong><p id="orderpincode"> ${order.pincode}</p></div>
  <div class="order-detail"><strong>Status:</strong><p id="orderstatus"> ${order.status}</p></div>
                       </div>
                       <div class="order-actions">
                           <form class="update-status-form" data-order-id="${order._id}">
                               <select name="status">
                                   <option value="Packing" ${order.status === "Packing" ? "selected" : ""}>Packing</option>
                                   <option value="Out for Delivery" ${order.status === "Out for Delivery" ? "selected" : ""}>Out for Delivery</option>
                                   <option value="Order Completed" ${order.status === "Order Completed" ? "selected" : ""}>Order Completed</option>
                               </select>
                               <button type="submit" id="update">Update</button>
                           </form>
                           <form class="delete-order-form" data-order-id="${order._id}">
                               <button type="submit" id="delete">Delete</button>
                           </form>
                       </div>
                   `;
                                setTimeout(() => {
                                    orderContainer.classList.add("fade-in");
                                }, currentOrderCount * 100);

                                orderList.appendChild(orderContainer);
                            });

                            // ✅ Proper placement
                            document.getElementById("totalorder").textContent = currentOrderCount;

                            if (typeof lastOrderCount !== "undefined" && currentOrderCount > lastOrderCount) {
                                showToast("New order received!", "success");
                            }

                            lastOrderCount = currentOrderCount;
                        })
                        .catch((error) => {
                            console.error("Error fetching orders:", error);
                            showToast("Failed to fetch orders.", "error");
                        });
                }

                function todayorders() {
                    fetch("admin.aspx/TodayOrders", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: "{}",
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            const todayStr = new Date().toISOString().split("T")[0]; // "YYYY-MM-DD"
                            const ordersData = JSON.parse(data.d);
                            const orderList = document.getElementById("order-list");
                            orderList.innerHTML = "";

                            // Filter orders to include only those from today
                            const todayOrders = ordersData.orders.filter((order) => {
                                return order.orderDate && order.orderDate.startsWith(todayStr);
                            });

                            let currentOrderCount = 0;

                            const heading = document.createElement("h1");
                            heading.textContent = "Orders";
                            heading.style.color = "#8affa3";
                            orderList.appendChild(heading);

                            todayOrders.reverse().forEach((order) => {
                                currentOrderCount++;

                                const orderContainer = document.createElement("div");
                                orderContainer.className = "order-container";
                                orderContainer.innerHTML = `
                   <div class="order-header">Order ID: ${order._id}</div>
                   <div class="order-details">
                                            <div class="order-detail"><strong>Date:</strong><p id="orderdata"> ${order.orderDate}</p></div>
                     <div class="order-detail"><strong>Username:</strong><p id="orderusername"> ${order.username}</p></div>
                     <div class="order-detail"><strong>Email:</strong><p id="orderemail"> ${order.email}</p></div>
                     <div class="order-detail"><strong>Phone:</strong><p id="orderphonenumber"> ${order.phone_number}</p></div>
                     <div class="order-detail"><strong>Products:</strong> <p>${order.items
                                        ? Object.keys(order.items)
                                            .map((item) => `${item} (${order.items[item]})`)
                                            .join(", ")
                                        : ""
                                    }</p></div>
                     <div class="order-detail"><strong>Price:</strong><p> ${order.totalPrice}₹</p></div>
                     <div class="order-detail"><strong>Address:</strong><p> ${order.address}</p></div>
                     <div class="order-detail"><strong>Pincode:</strong><p id="orderpincode"> ${order.pincode}</p></div>
                     <div class="order-detail"><strong>Status:</strong><p id="orderstatus"> ${order.status}</p></div>
                   </div>
                   <div class="order-actions">
                       <form class="update-status-form" data-order-id="${order._id}">
                           <select name="status">
                               <option value="Packing" ${order.status === "Packing" ? "selected" : ""}>Packing</option>
                               <option value="Out for Delivery" ${order.status === "Out for Delivery" ? "selected" : ""}>Out for Delivery</option>
                               <option value="Order Completed" ${order.status === "Order Completed" ? "selected" : ""}>Order Completed</option>
                           </select>
                           <button type="submit">Update</button>
                       </form>
                       <form class="delete-order-form" data-order-id="${order._id}">
                           <button type="submit">Delete</button>
                       </form>
                   </div>
               `;

                                setTimeout(() => {
                                    orderContainer.classList.add("fade-in");
                                }, currentOrderCount * 100);

                                orderList.appendChild(orderContainer);
                            });

                            document.getElementById("totalorder").textContent = currentOrderCount;

                            if (typeof lastOrderCount !== "undefined" && currentOrderCount > lastOrderCount) {
                                showToast("New order received!", "success");
                            }

                            lastOrderCount = currentOrderCount;
                        })
                        .catch((error) => {
                            console.error("Error fetching orders:", error);
                            showToast("Failed to fetch orders.", "error");
                        });
                }

                function showToast(message, type = "success") {
                    const toast = document.getElementById("toast");
                    const toastMessage = document.getElementById("toast-message");
                    toastMessage.innerText = message;
                    toast.className = `toast show ${type}`;
                    setTimeout(() => {
                        toast.className = toast.className.replace("show", "");
                    }, 5000);
                }

                document.addEventListener("submit", function (event) {
                    event.preventDefault();

                    if (event.target.classList.contains("update-status-form")) {
                        const form = event.target;
                        const orderId = form.getAttribute("data-order-id");
                        const status = form.querySelector('select[name="status"]').value;

                        fetch("admin.aspx/UpdateOrderStatus", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                            },
                            body: JSON.stringify({ orderId: orderId, status: status }),
                        })
                            .then((response) => response.json())
                            .then((data) => {
                                showToast("Order status updated!", "success");
                                fetchOrders();
                            })
                            .catch((error) => {
                                console.error("Error updating order status:", error);
                                showToast("Failed to update order status.", "error");
                            });
                    }

                    if (event.target.classList.contains("delete-order-form")) {
                        const form = event.target;
                        const orderId = form.getAttribute("data-order-id");

                        fetch("admin.aspx/DeleteOrder", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                            },
                            body: JSON.stringify({ orderId: orderId }),
                        })
                            .then((response) => response.json())
                            .then((data) => {
                                showToast("Order deleted!", "success");
                                fetchOrders();
                            })
                            .catch((error) => {
                                console.error("Error deleting order:", error);
                                showToast("Failed to delete order.", "error");
                            });
                    }
                });
            });
        </script>
        <!--Logout-->
        <script>
            document.getElementById("logout-link").addEventListener("click", function () {
                fetch("index.aspx/logout", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                })
                    .then((response) => response.json())
                    .then((result) => {
                        const res = result.d ? JSON.parse(result.d) : result;
                        if (res.status === "success") {
                            window.location.href = "index.aspx"; // Redirect to login page
                        } else {
                            alert(res.message);
                        }
                    })
                    .catch((error) => {
                        console.error("Logout error:", error);
                        alert("Logout failed. Please try again.");
                    });
            });
        </script>
    </body>
</html>
