<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="store.admin" %>
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

            button,
            #searchbutton {
                padding: 5px 10px;
                background-color: #4caf50;
                color: white;
                border: none;
                cursor: pointer;
                border-radius: 30px;
            }

            button:hover {
                background-color: #45a049;
            }

            .order-list {
                display: flex;
                gap: 50px;
                flex-wrap: wrap;
                margin: 50px;
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

            

            .pincode-container {
                margin-bottom: 40px;
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

            #container2 {
                overflow-y: auto;
                scrollbar-width: thin;
                scrollbar-color: #2baa5b #1e1e1e;
                scroll-behavior: smooth;
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

            .toast.show {
                visibility: visible;
                opacity: 1;
            }

            .toast.success {
                background-color: #4caf50;
            }

            .toast.error {
                background-color: #f44336;
            }

            .toast.warning {
                background-color: #ffae42;
            }
            .loading-icon {
                display: none;
                width: 20px;
                height: 20px;
                border: 3px solid #8affa3;
                border-top: 3px solid transparent;
                border-radius: 50%;
                animation: spin 0.7s linear infinite;
            }
            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
            @keyframes fadein {
                from {
                    bottom: 0;
                    opacity: 0;
                }

                to {
                    bottom: 30px;
                    opacity: 1;
                }
            }

            @keyframes fadeout {
                from {
                    bottom: 30px;
                    opacity: 1;
                }

                to {
                    bottom: 0;
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

            #allorders,
            #todayorders,
            #Distributor,
            #Admin,
            #Users {
                color: #4caf50;
            }

            nav ul li a:hover,
            #allorders:hover,
            #todayorders:hover,
            #Users:hover,
            #Distributor:hover,
            #Admin:hover{
                color: black;
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

            #cart1,
            #LoginData {
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
                z-index: 100;
            }

            .profile:hover .links-in-profileicon {
                visibility: visible;
                opacity: 1;
            }

            #show-username {
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

            #container {
                border: solid #8affa3;
                width: 95%;
                height: 75%;
                display: flex;
                flex-direction: column;
                align-items: center;
                overflow-y: auto;
                margin-top: 50px;
            }
        </style>
        <style>
            #cart,
            #Logindata {
                align-items: center;
            }

            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content,
            .dropdown-content1 {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 160px;
                z-index: 999;
                box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
                border-radius: 6px;
                padding: 0;
                margin-top: 35px;
                cursor: pointer;
            }

            .dropdown-content1 {
                margin-top: 22px;
            }

            .dropdown-content li {
                list-style: none;
            }

            .dropdown-content li {
                text-decoration: none;
                display: block;
            }

            .dropdown-content li:hover,
            .dropdown-content1 li:hover {
                background-color: #ddd;
            }

            /* Show dropdown on hover */
            .dropdown:hover .dropdown-content,
            .dropdown:hover .dropdown-content1 {
                display: block;
            }

            .users-container {
                border: 5px solid #8affa3;
                padding: 30px;
                background-color: #ffffffa8;
                border-radius: 20px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s, box-shadow 0.3s;
            }

            h3 {
                text-align: center;
                color: #333;
                margin: 10px;
                color: #00891d;
            }

            .userdiv {
                display: flex;
                align-items: center;
            }

            #userbuttons {
                display: flex;
                gap: 15px;
            }

            #edit,
            #delete,
            #update,
            #searchbutton {
                border-radius: 30px;
            }

            #formsearch {
                display: none;
                align-items: center;
                gap: 10px;
                align-self: flex-end;
                margin: 10px 100px;
            }

            label {
                display: block;
                font-size: 18px;
                color: #8affa3;
            }

            input#search {
                border-radius: 15px;
                padding: 6px;
            }

            #dashboard-stats1 {
                border: 5px solid #8affa3;
                padding: 30px;
                background-color: #ffffffa8;
                border-radius: 20px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .dashboard-stats1-1 {
                color: #00891d;
            }

            #dashboardstatistics1 {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                width: 95%;
            }
            #addusers,
            #addProducts {
                padding: 30px;
                border: 5px solid #8affa3;
                background-color: #ffffffa8;
                border-radius: 20px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                display: flex;
                justify-content: center;
                align-items: center;
                max-width: 95px;
                max-height: 25px;
            }
        </style>
        <style>
            #adduser {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%) scale(0.9);
                background-color: #1e1e1e;
                color: #ffffff;
                padding: 25px 30px;
                border-radius: 15px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
                border: 2px solid #8affa3;
                z-index: 1000;
                max-width: 90%;
                opacity: 0;
                transition: opacity 0.4s ease, transform 0.4s ease;
            }

            #adduser.show {
                opacity: 1;
                transform: translate(-50%, -50%) scale(1);
            }

            @keyframes zoomIn {
                0% {
                    opacity: 0;
                    transform: translate(-50%, -50%) scale(0.5);
                }
                70% {
                    transform: translate(-50%, -50%) scale(1.05);
                }
                100% {
                    opacity: 1;
                    transform: translate(-50%, -50%) scale(1);
                }
            }
            #adduserform {
                display: flex;
                flex-direction: column;
            }

            #addrole {
                color: #8affa3;
                margin-bottom: 10px;
                border-radius: 50px;
                border: 2px solid #8affa3;
                background-color: #272727;
            }
            .form-group {
                margin-bottom: 20px;
            }
            #role {
                display: flex;
                gap: 15px;
                align-items: center;
            }
            label {
                display: block;
                margin-bottom: 10px;
                font-size: 18px;
                color: #8affa3;
            }
            .h1 {
                text-align: center;
                color: #8affa3;
                letter-spacing: 2px;
            }
            .addlable,
            h6 {
                color: #8affa3;
            }
            input[type="text"],
            input[type="password"],
            input[type="email"] {
                padding: 10px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                background-color: #333;
                color: #8affa3;
                outline: none;
                margin-bottom: 10px;
    background: linear-gradient(270deg, #121212, #272727, #121212);


            }
            
            hr {
    border: 1px solid #ccc;
    margin: 15px 0;
    height: 1px;
    background-color: #ccc;
    visibility: visible;
    width:160px;
}
            input[type="submit"],
            input[type="button"],
            #close-adduser {
                padding: 12px 20px;
                font-size: 18px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                background-color: #8affa3;
                color: #121212;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }
            input[type="submit"]:hover,
            input[type="button"]:hover,
            #close-adduser:hover {
                background-color: #5cb85c;
                transform: scale(1.05);
            }
            input[type="submit"]:active,
            input[type="button"]:active,
            #close-adduser:active {
                background-color: #3e8e41;
                transform: scale(0.95);
            }
            .submit{
                display: flex;
                align-items: center;
                gap: 30px;
                margin:10px
            }
            #adminpin{
                 border-radius: 15px;
 box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
 border: 2px solid #8affa3;
 text-align:center;
 padding:10px 15px;
 display: none;
 position: fixed;
 top: 50%;
 left: 50%;
 transform: translate(-50%, -50%) scale(0.9);
 background-color: #1e1e1e;
 color: #ffffff;
 max-width: 90%;
 opacity: 0;
 transition: opacity 0.4s ease, transform 0.4s ease;
            }
             #adminpin.show {
     opacity: 1;
     transform: translate(-50%, -50%) scale(1);
 }
            #admindis{
                margin:0px;
                margin-bottom:15px;
            }
            #adminpinform{
                display:flex;
                flex-direction:column;
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
                    <li><a href="admin.aspx">Home</a></li>
                    <li id="LoginData" class="dropdown">
                        <a id="Logindata">Login Data</a>
                        <ul class="dropdown-content1">
                            <li>
                                <p id="Users">Customer</p>
                            </li>
                            <li>
                                <p id="Distributor">Distributor</p>
                            </li>
                             <li>
     <p id="Admin">Admins</p>
 </li>
                        </ul>
                    </li>
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
                            <h4 id="show-username">
                                Username:
                                <span id="usernameforplaceorder">
                                    <%=Session["username"] %>
                                </span>
                            </h4>
                            <h4 id="show-email">Email: <%=Session["email"] %></h4>
                            <div id="loginorlogout">
                                <a id="logout-link">Logout</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
        <!-- Toast message -->
        <div id="toast" class="toast">
            <span id="toast-message"></span>
        </div>
        <div id="container">
            <div id="container2">
                <h1 id="title"></h1>
                <form id="formsearch">
                    <label for="search">Search :</label>
                    <input type="text" id="search" placeholder="Search..." />
                </form>
                <div id="order-list" class="order-list"></div>
            </div>

            <div id="dashboardstatistics">
                <h1>Dashboard Statistics</h1>
                <div id="dashboardstatistics1">
                    <div id="dashboard-stats1">
                        <p>
                            <strong>Users: <span class="dashboard-stats1-1" id="total-users"></span></strong>
                        </p>
                        <p>
                            <strong>Customers: <span class="dashboard-stats1-1" id="customer-count"></span></strong>
                        </p>
                        <p>
                            <strong>Distributors: <span class="dashboard-stats1-1" id="distributor-count"></span></strong>
                        </p>
                        <p>
                            <strong>Total Orders: <span class="dashboard-stats1-1" id="total-orders"></span></strong>
                        </p>
                        <p>
                            <strong>Total Revenue: ₹<span class="dashboard-stats1-1" id="total-revenue"></span></strong>
                        </p>
                        <div id="order-status-counts"></div>
                    </div>

                    <div id="addusers">
                        <button id="adduserbutton">Add User</button>
                    </div>
                    <div id="addProducts">
                        <button  onclick="document.getElementById('addproduct').style.display='block'">Add Product</button>
                    </div>
                </div>
            </div>
        </div>


        <div id="adminpin">
            <form id="adminpinform">
            <h1>Admins</h1> 
            <h6 id="admindis">To access admins you have to verify</h6>
            <label for="pin" id="pinlable">Pin :</label>
            <input id="pin" type="password"/> 
                <div class="submit">
                <input  type="submit" value="Enter"/>
                    <input type="button" id="close-adminpin" value="Close" />
</div>
</form>
        </div>

        <div id="adduser">
            <form id="adduserform">
                <h1 class="h1">Add User</h1>
                <hr />
                <div id="role">
                    <label for="addrole" class="addlable">Add As:</label>
                    <select id="addrole" name="loginRole">
                        <option></option>
                        <option value="distributor">Distributor</option>
                        <option value="customer">Customer</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div class="form-group" id="customer-group" style="display: none;">
                    <label for="customerfullname" class="addlable">Customer Full Name</label>
                    <input type="text" id="customerfullname" name="customerfullname" />

                    <label for="customerusername" class="addlable">Customer Username</label>
                    <input type="text" id="customerusername" name="customerusername" />
                </div>
                <div class="form-group" id="pincode-group" style="display: none;">
                    <label for="pincode" class="addlable">Pincode</label>
                    <input type="text" id="pincode" name="pincode" />
                </div>
                <div class="form-group" id="distributor-group" style="display: none;">
                    <label for="distributorname" class="addlable">Distributor Name</label>
                    <input type="text" id="distributorname" name="distributorname" />

                    <label for="distributorusername" class="addlable">Distributor UserName</label>
                    <input type="text" id="distributorusername" name="distributorusername" />
                </div>
                <div class="form-group" id="admin-group" style="display: none;">
                    <label for="admin" class="addlable">Admin UserName</label>
                    <input type="text" id="admin" name="adminname" />
                </div>
                <div class="form-group" id="email-group" style="display: none;">
                    <label for="email" class="addlable">Email</label>
                    <input type="text" id="email" name="email" />
                </div>
                <div class="form-group" id="password-group" style="display: none;">
                    <label for="passin" class="loginlable">Password</label>
                    <input type="password" id="password" name="passin" />
                </div>
                <div class="submit">
                    <input type="submit" name="add_user" id="submit" value="Add" onclick="addUser(event)" />
                    <div class="loading-icon" id="loading-icon1" style="display: none;">⏳</div>
                    <input type="button" id="close-adduser" value="Close" />
                </div>
            </form>
        </div>
        



        <!--Add User-->
        <script>

            <!-- Add User Modal -->

    const adduser = document.getElementById("adduser");

    // Show modal
    document.getElementById("adduserbutton").addEventListener("click", (event) => {
        event.preventDefault();
        adduser.style.display = "block";
        setTimeout(() => {
            adduser.style.opacity = "1";
            adduser.style.transform = "translate(-50%, -50%) scale(1)";
            adduser.classList.add("show");
        }, 10);
    });

    // Hide modal
    document.getElementById("close-adduser").addEventListener("click", () => {
        adduser.style.opacity = "0";
        adduser.style.transform = "translate(-50%, -50%) scale(0.9)";
        setTimeout(() => {
            adduser.style.display = "none";
        }, 300);
    });

    document.addEventListener("DOMContentLoaded", function () {
        const roleSelect = document.getElementById("addrole");

        const fields = {
            pincode: document.getElementById("pincode-group"),
            customer: document.getElementById("customer-group"),
            distributor: document.getElementById("distributor-group"),
            admin: document.getElementById("admin-group"),
            email: document.getElementById("email-group"),
            password: document.getElementById("password-group"),
        };

        const submit = document.getElementById("submit");
        submit.style.display = "none";

        roleSelect.addEventListener("change", function () {
            const role = roleSelect.value;
            submit.style.display = "none";

            // Hide all by default
            for (let key in fields) {
                fields[key].style.display = "none";
            }

            // Show based on role
            if (role === "distributor") {
                fields.pincode.style.display = "block";
                fields.distributor.style.display = "block";
                fields.email.style.display = "block";
                fields.password.style.display = "block";
                submit.style.display = "block";
            } else if (role === "admin") {
                fields.admin.style.display = "block";
                fields.email.style.display = "block";
                fields.password.style.display = "block";
                submit.style.display = "block";
            } else if (role === "customer") {
                fields.customer.style.display = "block";
                fields.email.style.display = "block";
                fields.password.style.display = "block";
                submit.style.display = "block";
            }
        });
    });

            function addUser() {

                const roleSelect = document.getElementById("addrole");
                const role = roleSelect.value;
                const username =
                    (document.getElementById("distributorname")?.value?.trim()) ||
                    (document.getElementById("customerusername")?.value?.trim()) ||
                    (document.getElementById("admin")?.value?.trim()) ||
                    "";
                const email = document.getElementById("email").value;
                const password = document.getElementById("password").value;
                const distributorname = document.getElementById("distributorname")?.value || "";
                const fullname = document.getElementById("customerfullname")?.value || "";
                const pincode = document.getElementById("pincode")?.value || "";
                event.preventDefault();

                const userData = {
                    role,
                    username,
                    email,
                    password,
                    distributorname,
                    fullname,
                    pincode
                };

                fetch("admin.aspx/AddUser", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json; charset=utf-8"
                    },
                    body: JSON.stringify({ userData })
                })
                    .then(response => {
                        if (!response.ok) throw new Error("Server error");
                        return response.json();
                    })
                    .then(result => {
                        const res = JSON.parse(result.d);
                        showToast(res.message, res.success);
                    })
                    .catch(error => {
                        console.error("Error adding user:", error);
                        showToast("Error: " + error.message, false);
                    });

                adduser.style.opacity = "0";
                adduser.style.transform = "translate(-50%, -50%) scale(0.9)";
                setTimeout(() => {
                    adduser.style.display = "none";
                }, 300);
            }
        </script>
        <!--hide an show dashboard-->
        <script>
            function showDashboard() {
                document.getElementById("dashboardstatistics").style.display = "block";
                document.getElementById("container2").style.display = "none";
            }

            function hideDashboard() {
                document.getElementById("dashboardstatistics").style.display = "none";
                document.getElementById("container2").style.display = "block";
            }

            // Show on initial page load
            document.addEventListener("DOMContentLoaded", () => {
                showDashboard(); // default
            });

            // Hide dashboard when switching to users
            document.getElementById("Users").addEventListener("click", function () {
                hideDashboard();
            });

            document.getElementById("Distributor").addEventListener("click", function () {
                hideDashboard();
            });

            document.getElementById("allorders").addEventListener("click", function () {
                hideDashboard();
            });

            document.getElementById("todayorders").addEventListener("click", function () {
                hideDashboard();
            });
        </script>
        <!--DashboardStats-->
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                showDashboard(); 
                loadDashboardStats(); 
            });

            function loadDashboardStats() {
                fetch("admin.aspx/GetDashboardStats", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                })
                    .then((res) => res.json())
                    .then((response) => {
                        const data = typeof response.d === "string" ? JSON.parse(response.d) : response.d;
                        document.getElementById("total-users").textContent = data.totalUsers;
                        document.getElementById("customer-count").textContent = data.customers;
                        document.getElementById("distributor-count").textContent = data.distributors;
                        document.getElementById("total-orders").textContent = data.totalOrders;
                        document.getElementById("total-revenue").textContent = parseFloat(data.totalRevenue).toFixed(2);

                        const statusDiv = document.getElementById("order-status-counts");
                        statusDiv.innerHTML = "<h4>Orders by Status:</h4>";

                        if (data.ordersByStatus) {
                            for (const [status, count] of Object.entries(data.ordersByStatus)) {
                                const p = document.createElement("p");
                                p.textContent = `${status}: ${count}`;
                                statusDiv.appendChild(p);
                            }
                        } else {
                            statusDiv.innerHTML += "<p>No order status data found.</p>";
                        }
                    })
                    .catch((err) => console.error("Dashboard stats error:", err));
            }
        </script>
        <!-- showToast and GetUsers and Deleteusers-->
        <script>
            function showToast(message, type = "success") {
                const toast = document.getElementById("toast");
                const toastMessage = document.getElementById("toast-message");
                toastMessage.innerText = message;
                toast.className = `toast show ${type}`;
                setTimeout(() => {
                    toast.className = toast.className.replace("show", "");
                }, 5000);
            }

            let intervalId = null;
            document.getElementById("Users").addEventListener("click", function () {
                if (intervalId) clearInterval(intervalId);
                getusers("customer");
            });
            document.getElementById("Distributor").addEventListener("click", function () {
                if (intervalId) clearInterval(intervalId);
                getusers("distributor");
            });
            document.addEventListener("DOMContentLoaded", function () {
                const adminButton = document.getElementById("Admin");
                const adminPinPopup = document.getElementById("adminpin");
                const adminPinForm = document.getElementById("adminpinform");
                const closeBtn = document.getElementById("close-adminpin");
                let intervalId = null;

                adminButton.addEventListener("click", function () {
                    adminPinPopup.style.display = "block";

                    setTimeout(() => {
                        adminPinPopup.style.opacity = "1";
                        adminPinPopup.style.transform = "translate(-50%, -50%) scale(1)";
                        adminPinPopup.classList.add("show");
                    }, 10);
                });

                adminPinForm.addEventListener("submit", function (event) {
                    event.preventDefault();

                    const pin = document.getElementById("pin").value.trim();
                    if (pin === "1234") {
                        if (intervalId) clearInterval(intervalId);
                        getusers("admin");
                        document.getElementById("pin").value = ""; 
                        adminPinPopup.style.display = "none"; 
                    } else {
                        alert("Incorrect pin");
                    }
                });

                // Handle close button click
                closeBtn.addEventListener("click", function () {
                    closePopup();
                });

                // Helper function to close popup
                function closePopup() {
                    adminPinPopup.style.opacity = "0";
                    adminPinPopup.style.transform = "translate(-50%, -50%) scale(0.8)";
                    setTimeout(() => {
                        adminPinPopup.style.display = "none";
                        adminPinPopup.classList.remove("show");
                        document.getElementById("pin").value = ""; 
                    }, 300); 
                }
            });

            function getusers(role) {
                fetch("admin.aspx/GetUser", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify({
                        role: role,
                    }),
                })
                    .then((response) => response.json())
                    .then((data) => {
                        const usersData = JSON.parse(data.d).users;
                        const List = document.getElementById("order-list");
                        List.innerHTML = "";
                        document.getElementById("formsearch").style.display = "block";
                        usersData.forEach((user) => {
                            const usersContainer = document.createElement("div");
                            usersContainer.className = "users-container";

                            let extraField = "";
                            let extraField1 = "";

                            if (user.role === "customer") {
                                document.getElementById("title").innerHTML = "Customers";
                                extraField = `<div class="userdiv"><strong>Full Nname :</strong><h3 id="userfullname">${user.fullname}</h3></div>`;
                            } else if (user.role === "distributor") {
                                document.getElementById("title").innerHTML = "Distributors";
                                extraField1 = ` <div class="userdiv"><strong>Distributor name:</strong><h3 id="userdistributorname">${user.distributorname}</h3></div>
                             <div class="userdiv"><strong>Pincode :</strong><h3 id="userpincode">${user.pincode}</h3></div>`;
                            } else if (user.role === "admin") {
                                document.getElementById("title").innerHTML = "Admins";
                            }

                            usersContainer.innerHTML = `
                         ${extraField}
                          ${extraField1}
                     <div class="userdiv"><strong>User Name :</strong><h3 id="userusername">${user.username}</h3></div>
                     <div class="userdiv"><strong>Email :</strong><h3 id="useremail">${user.email}</h3></div>
                     <div class="userdiv"><strong>Role :</strong><h3>${user.role}</h3></div>
                     <div id="userbuttons">
                      <form class="edit-user-form" data-user-id="${user._id}">
                            <button type="submit" id="edit">Edit</button>
                      </form>
                      <form class="delete-user-form" data-user-id="${user._id}">
                          <button type="submit" id="delete">Delete</button>
                      </form></div>
                 `;

                            List.appendChild(usersContainer);
                        });
                    })
                    .catch((error) => {
                        console.error("Error fetching users:", error);
                    });
            }

            document.addEventListener("submit", function (event) {
                event.preventDefault();
                if (event.target.classList.contains("delete-user-form")) {
                    const form = event.target;
                    const userId = form.getAttribute("data-user-id");

                    fetch("admin.aspx/Deleteuser", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                        },
                        body: JSON.stringify({
                            userId: userId,
                        }),
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            showToast("user is deleted!", "success");
                        })
                        .catch((error) => {
                            console.error("Error deleting user:", error);
                            showToast("Failed to delete user.", "error");
                        });
                }
            });
        </script>
        <!--Search button-->
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                document.getElementById("search").addEventListener("input", function () {
                    const searchTerm = this.value.trim().toLowerCase();

                    // --- Search in users ---
                    const users = document.querySelectorAll(".users-container");
                    users.forEach((user) => {
                        const fullName = user.querySelector("#userfullname")?.textContent.toLowerCase().trim() || "";
                        const userName = user.querySelector("#userusername")?.textContent.toLowerCase().trim() || "";
                        const email = user.querySelector("#useremail")?.textContent.toLowerCase().trim() || "";
                        const distributorName = user.querySelector("#userdistributorname")?.textContent.toLowerCase().trim() || "";
                        const pincode = user.querySelector("#userpincode")?.textContent.toLowerCase().trim() || "";

                        user.style.display = fullName.includes(searchTerm) || userName.includes(searchTerm) || email.includes(searchTerm) || distributorName.includes(searchTerm) || pincode.includes(searchTerm) ? "block" : "none";
                    });

                    // --- Search in orders ---
                    const orders = document.querySelectorAll(".order-container");
                    orders.forEach((order) => {
                        const orderId = order.querySelector(".order-header")?.textContent.toLowerCase().trim() || "";
                        const orderDate = order.querySelector("#orderdata")?.textContent.toLowerCase().trim() || "";
                        const orderUsername = order.querySelector("#orderusername")?.textContent.toLowerCase().trim() || "";
                        const orderEmail = order.querySelector("#orderemail")?.textContent.toLowerCase().trim() || "";
                        const orderPhone = order.querySelector("#orderphonenumber")?.textContent.toLowerCase().trim() || "";
                        const orderPincode = order.querySelector("#orderpincode")?.textContent.toLowerCase().trim() || "";
                        const orderStatus = order.querySelector("#orderstatus")?.textContent.toLowerCase().trim() || "";
                        const orderContent = order.textContent.toLowerCase();

                        order.style.display =
                            orderId.includes(searchTerm) ||
                            orderDate.includes(searchTerm) ||
                            orderUsername.includes(searchTerm) ||
                            orderEmail.includes(searchTerm) ||
                            orderPhone.includes(searchTerm) ||
                            orderPincode.includes(searchTerm) ||
                            orderStatus.includes(searchTerm) ||
                            orderContent.includes(searchTerm) // fallback full search
                                ? "block"
                                : "none";
                    });
                });
            });
        </script>
        <!--GetOrders and TodayOrders-->
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                username = document.getElementById("usernameforplaceorder").textContent.trim();
                if (username == "") {
                    window.location.href = "index.aspx";
                }

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
                            document.getElementById("formsearch").style.display = "block";
                            let currentOrderCount = 0;

                            document.getElementById("title").innerHTML = "All Orders";

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
                     <div class="order-detail"><strong>Products:</strong> <p>${
                         order.items
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
                            document.getElementById("formsearch").style.display = "block";

                            // Filter orders to include only those from today
                            const todayOrders = ordersData.orders.filter((order) => {
                                return order.orderDate && order.orderDate.startsWith(todayStr);
                            });

                            let currentOrderCount = 0;
                            document.getElementById("title").innerHTML = "Today orders";

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
  <div class="order-detail"><strong>Products:</strong> <p>${
      order.items
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
                            body: JSON.stringify({
                                orderId: orderId,
                                status: status,
                            }),
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
                            body: JSON.stringify({
                                orderId: orderId,
                            }),
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
