<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="distributor.aspx.cs" Inherits="store.distributor" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Admin - Orders</title>
     <link rel="stylesheet"  href="stylesanjavascript/css/distributor.css"/>
    </head>
    <body>
        <nav id="navbar">
            <div class="logo">
                <img src="static/images/elitegrocers_logo.jpg" />
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
       <script src="stylesanjavascript/js/distributor.js"></script>
    </body>
</html>
