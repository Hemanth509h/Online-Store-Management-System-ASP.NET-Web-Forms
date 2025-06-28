﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="store.index" EnableSessionState="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Product Selection</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
       <link rel="stylesheet" href="stylesanjavascript/css/index.css" />
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
                    <li><a href="index.aspx">Home</a></li>
                    <li id="cart">
                        <a>
                            Cart :
                            <p id="Cartnumber"></p>
                        </a>
                    </li>
                    <li><a id="orders-link">Orders</a></li>
                    <li><a id="contact-link">Contact</a></li>
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
                            <h4 id="show-fullname">Full Name :<span id="fullname"> <%=Session["fullname"] %> </span></h4>
                            <h4 id="show-username">Username: <span id="usernameforplaceorder"> <%=Session["username"] %> </span></h4>
                            <h4 id="show-email">Email: <%=Session["email"] %></h4>
                            <div id="loginorlogout">
                                <% if (Session["username"] !=null) { %>
                                <a id="logout-link">Logout</a>
                                <% } else { %>
                                <a id="login-link">Login</a>
                                <a id="register-link">Register</a>
                                <% } %>
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
        <section class="container">
            <!-- Left Category Panel -->
            <div class="products-nav" id="categoryList">
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkFreshProduce" name="Products" value="Fresh_Produce" class="product-checkbox" runat="server" />
                        Fresh Produce
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkDairyEggs" name="Products" value="Dairy_Eggs" class="product-checkbox" runat="server" />
                        Dairy & Eggs
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkMeatSeafood" name="Products" value="Meat_Seafood" class="product-checkbox" runat="server" />
                        Meat & Seafood
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkBakeryBread" name="Products" value="Bakery_Bread" class="product-checkbox" runat="server" />
                        Bakery & Bread
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkPantryStaples" name="Products" value="Pantry_Staples" class="product-checkbox" runat="server" />
                        Pantry Staples
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkBeverages" name="Products" value="Beverages" class="product-checkbox" runat="server" />
                        Beverages
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkFrozenFoods" name="Products" value="Frozen_Foods" class="product-checkbox" runat="server" />
                        Frozen Foods
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkHealthWellness" name="Products" value="Health_Wellness" class="product-checkbox" runat="server" />
                        Health & Wellness
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkCleaningSupplies" name="Products" value="Household_Cleaning_Supplies" class="product-checkbox" runat="server" />
                        Household Cleaning Supplies
                    </label>
                </div>
                <div class="product-categery">
                    <label>
                        <input type="radio" id="chkPersonalCare" name="Products" value="Personal_Care" class="product-checkbox" runat="server" />
                        Personal Care
                    </label>
                </div>
            </div>
            <!-- Right Display Area -->
            <div id="selectedProducts" class="selected-products">
                <div id="selectedproductsnameansearchbox" >
                <h2 id="selectedproductsname"></h2>
                <input type="text" id="searchBox" placeholder="Search products..." class="search-box" oninput="searchProducts()" />
              </div>
                <div id="dispalyproducts"></div>
            </div>
        </section>
        <!--login-->
        <div class="login-container">
            <form id="login-form">
                <img id="login-image" src="wwwroot/static/images/elitegrocers_logo.jpg" alt="logo" />
                <p id="logintext">Elite Grocers</p>
                <h1 class="h1">Login</h1>
                <hr />
                <div id="role">
                    <label for="loginRole" class="loginlable">Login as:</label>
                    <select id="loginRole" name="loginRole">
                        <option value="customer">Customer</option>
                        <option value="distributor">Distributor</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div class="form-group" id="adminpin-group" style="display: none;">
                    <label for="adminpin" class="loginlable">Admin pin</label>
                    <h6>To Access for login</h6>
                    <input type="password" id="admincode" name="admincode" />
                </div>
                <div class="form-group" id="pincode-group" style="display: none;">
                    <label for="pincode" class="loginlable">Pincode</label>
                    <input type="text" id="pincode" name="pincode" />
                </div>
                <div class="form-group" id="useroremailin-group">
                    <label for="useroremailin" class="loginlable">Username or Email</label>
                    <input type="text" id="useroremailin" name="useroremailin" />
                </div>
                <div class="form-group" id="password-group">
                    <label for="passin" class="loginlable">Password</label>
                    <input type="password" id="passin" name="passin" />
                </div>
                <div class="submit">
                    <input type="submit" name="login_user" id="submit" value="Login" />
                    <button id="checkadminpin">check</button>
                    <div class="loading-icon" id="loading-icon1">⏳</div>
                    <input type="button" id="close-login" value="Close" />
                </div>
                <p id="loginpage-link">Don't have an account? <a id="register-link1">Register</a></p>
            </form>
        </div>
        <!--register-->
        <div class="register-container">
            <form id="sign-up-1">
                  <img id="register-image" src="wwwroot/static/images/elitegrocers_logo.jpg" alt="logo" />
  <p id="registertext">Elite Grocers</p>
  <h1 class="h1">Register</h1>
  <hr />
                <div class="form-group">
                    <label for="register-fullname">Full Name</label>
                    <input type="text" id="register-fullname" />
                </div>
                <div class="form-group">
                    <label for="register-username">Username</label>
                    <input type="text" id="register-username" />
                </div>
                <div class="form-group">
                    <label for="register-email">Email</label>
                    <input id="register-email" type="email" />
                </div>
                <div class="form-group">
                    <label for="pass" id="passhr">Password</label>
                    <input id="pass" type="password" name="password_1" />
                </div>
                <div class="form-group">
                    <label for="pass2">Confirm Password</label>
                    <input id="pass2" type="password" name="password_2" />
                </div>
                <div class="submit">
                    <input type="submit" id="btn" value="Sign Up" />
                    <div class="loading-icon" id="loading-icon2">⏳</div>
                    <button type="button" id="close-register">Close</button>
                </div>
                <p id="registerpage-link">Already have an account? <a id="login-link1">Login</a></p>
            </form>
        </div>
        <!-- Cart Modal -->
        <div id="cart-modal" class="cart-modal">
            <div class="cart-content">
                <h2>Your Cart</h2>
                <div class="cart-items-container">
                    <div id="cart-items"></div>
                </div>
                <h3>Total Price: <span id="total-price">0</span>₹</h3>
                <div class="cart-buttons">
                    <button id="clear-cart" class="cart-button">Clear Cart</button>
                    <button id="checkout" class="cart-button">Checkout</button>
                    <button id="close-cart" class="cart-button">Close</button>
                </div>
            </div>
        </div>
        <!-- Checkout Modal -->
        <div id="checkout-modal" class="checkout-modal">
            <div class="checkout-content">
                <h2>Checkout</h2>
                <form id="checkout-form">
                    <label for="address">Address:</label>
                    <input type="text" id="address" placeholder="Your Address" required="required" />
                    <label for="phone-number">Phone Number:</label>
                    <input type="text" id="phone-number" placeholder="Your Phone Number" required="required" />
                    <label for="pincode">Pincode:</label>
                    <input type="text" id="pincode1" placeholder="Your Pincode" required="required" />
                    <label>Payment Option:</label>
                    <div>
                        <input type="radio" id="credit-card" name="payment" value="Credit Card" required="required" />
                        <label for="credit-card">Credit Card</label>
                    </div>
                    <div>
                        <input type="radio" id="upi" name="payment" value="UPI" required="required" />
                        <label for="upi">UPI</label>
                    </div>
                    <div>
                        <input type="radio" id="net-banking" name="payment" value="Net Banking" required="required" />
                        <label for="net-banking">Net Banking</label>
                    </div>
                    <div>
                        <input type="radio" id="cash-on-delivery" name="payment" value="Cash on Delivery" required="required" />
                        <label for="cash-on-delivery">Cash on Delivery</label>
                    </div>
                    <button type="button" id="confirm-order" class="checkout-button">Confirm Order</button>
                    <button type="button" id="close-checkout" class="checkout-button">Close</button>
                </form>
            </div>
        </div>
        <!-- Order list section -->
        <div id="order-section" class="order-container">
            <h2 id="yourorders">Your Orders</h2>
            <div class="orderlist">
                <div id="order-list" class="order-list">
                    <!-- Orders will be dynamically inserted here -->
                </div>
            </div>
            <button id="close-orders">Close</button>
        </div>
        <!-- Contact Section -->
        <div id="contact-section" class="contact-modal">
            <div class="contact-content">
                <h2>Contact Us</h2>
                <p><strong>Phone:</strong> <span id="contact-number">+1 234 567 890</span></p>
                <p><strong>Email:</strong> support@elitegrocers.com</p>
                <form id="contact-form">
                    <label for="contact-name">Name:</label>
                    <input type="text" id="contact-name" placeholder="Your Name" required="required" />
                    <label for="contact-email">Email:</label>
                    <input type="email" id="contact-email" placeholder="Your Email" required="required" />
                    <label for="message">Message:</label>
                    <textarea id="message" placeholder="Your Message" required="required"> </textarea>
                    <input type="submit" value="Send" />
                    <div class="loading-icon" id="loading-icon3">⏳</div>
                    <button id="close-contact" class="close-contact">Close</button>
                </form>
            </div>
        </div>
        <script src="stylesanjavascript/js/index.js"></script>
    </body>
</html>
    