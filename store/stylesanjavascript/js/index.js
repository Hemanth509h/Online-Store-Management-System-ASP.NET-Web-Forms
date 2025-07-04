// script.js
document.addEventListener("DOMContentLoaded", function () {
    const roleSelect = document.getElementById("loginRole");
    const pincodeGroup = document.getElementById("pincode-group");
    const admincodeGroup = document.getElementById("adminpin-group");
    const useroremailingroup = document.getElementById("useroremailin-group");
    const passwordgroup = document.getElementById("password-group");
    const submit = document.getElementById("submit");
    const checkAdminBtn = document.getElementById("checkadminpin");

    // Initially hide check admin pin button
    checkAdminBtn.style.display = "none";

    roleSelect.addEventListener("change", function () {
        const role = roleSelect.value;

        if (role === "distributor") {
            pincodeGroup.style.display = "block";
            admincodeGroup.style.display = "none";
            useroremailingroup.style.display = "block";
            passwordgroup.style.display = "block";
            submit.style.display = "block";
            checkAdminBtn.style.display = "none";
        } else if (role === "admin") {
            pincodeGroup.style.display = "none";
            admincodeGroup.style.display = "block";
            useroremailingroup.style.display = "none";
            passwordgroup.style.display = "none";
            submit.style.display = "none";
            checkAdminBtn.style.display = "block";
        } else {
            pincodeGroup.style.display = "none";
            admincodeGroup.style.display = "none";
            useroremailingroup.style.display = "block";
            passwordgroup.style.display = "block";
            submit.style.display = "block";
            checkAdminBtn.style.display = "none";
        }
    });

    document.getElementById("checkadminpin").addEventListener("click", function (e) {
        e.preventDefault();
        const adminPin = document.getElementById("admincode").value.trim();
        if (adminPin === "1234") {
            // Reveal username + password inputs after pin validated
            document.getElementById("useroremailin-group").style.display = "block";
            document.getElementById("password-group").style.display = "block";
            document.getElementById("submit").style.display = "block";
            checkAdminBtn.style.display = "none";
        } else {
            alert("Invalid Admin Pin");
        }
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const productCategories = document.querySelectorAll(".product-categery");

    productCategories.forEach((category) => {
        category.addEventListener("click", function () {
            // Remove active class from all
            productCategories.forEach((cat) => cat.classList.remove("active"));
            // Add active class to the clicked one
            this.classList.add("active");

            // Ensure the radio input inside is checked
            const radio = this.querySelector("input[type='radio']");

            if (radio) {
                radio.checked = true;
                const selectedValue = radio.value;
                getProducts(selectedValue);
            }
        });
    });
});

// Toast message
function showToast(message, type = "success") {
    const toast = document.getElementById("toast");
    const toastMessage = document.getElementById("toast-message");

    toastMessage.innerText = message;
    toast.className = `toast show ${type}`;

    setTimeout(() => {
        toast.className = toast.className.replace("show", "");
    }, 5000);
}

//login script
const loginLink = document.getElementById("login-link");
const loginContainer = document.querySelector(".login-container");

if (loginLink) {
    loginLink.addEventListener("click", () => {
        event.preventDefault();
        loginContainer.style.display = "block";
        loginContainer.style.animation = "";
        setTimeout(() => {
            loginContainer.style.opacity = "1";
            loginContainer.style.transform = "translate(-50%, -50%) scale(1)";
            loginContainer.classList.add("show");
        }, 10);
    });
}

document.getElementById("login-form").addEventListener("submit", function (event) {
    event.preventDefault();

    const userInput = document.getElementById("useroremailin").value.trim();
    const passInput = document.getElementById("passin").value.trim();
    const role = document.getElementById("loginRole").value;
    const pincode = document.getElementById("pincode").value.trim();

    if (userInput === "") {
        showToast("Please enter your email", "error");
        return;
    }
    if (passInput === "") {
        showToast("Please enter your password", "error");
        return;
    }

    document.getElementById("loading-icon1").style.display = "block"; // Show loading icon

    // Prepare JSON payload
    const payload = JSON.stringify({
        pincode: pincode,
        useroremailin: userInput,
        passin: passInput,
        role: role,
    });

    fetch("index.aspx/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8",
        },
        body: payload,
    })
        .then((response) => response.json())
        .then((data) => {
            const login = JSON.parse(data.d);
            document.getElementById("loading-icon1").style.display = "none";
            showToast(login.message, login.status); // Show toast message
            if (login.status === "success") {
                document.getElementById("login-form").reset();
                loginContainer.style.display = "none";
                const userInput = (document.getElementById("useroremailin").value = "");
                const passInput = (document.getElementById("passin").value = "");
                if (login.role === "admin") {
                    window.location.href = "admin.aspx";
                } else if (login.role === "distributor") {
                    window.location.href = "distributor.aspx";
                } else {
                    setTimeout(() => location.reload(), 1000);
                }
            }
        })
        .catch((error) => {
            console.error("Error:", error);
            showToast("An error occurred. Please try again.", "error");
            document.getElementById("loading-icon1").style.display = "none";
        });
});

document.getElementById("close-login").addEventListener("click", () => {
    loginContainer.style.opacity = "0";
    loginContainer.style.transform = "translate(-50%, -50%) scale(0.9)";
    setTimeout(() => {
        loginContainer.style.display = "none";
    }, 300);
});

const registerLink1 = document.getElementById("register-link1");
if (registerLink1) {
    registerLink1.addEventListener("click", () => {
        event.preventDefault();
        loginContainer.style.opacity = "0";
        loginContainer.style.transform = "translate(-50%, -50%) scale(0.9)";
        setTimeout(() => {
            loginContainer.style.display = "none";
            registerContainer.style.display = "block";
            setTimeout(() => {
                registerContainer.style.opacity = "1";
                registerContainer.style.transform = "translate(-50%, -50%) scale(1)";
            }, 10);
        }, 300);
    });
}

//register script
const registerLink = document.getElementById("register-link");
const registerContainer = document.querySelector(".register-container");

if (registerLink) {
    registerLink.addEventListener("click", () => {
        event.preventDefault();
        registerContainer.style.display = "block";
        registerContainer.style.animation = "";
        setTimeout(() => {
            registerContainer.style.opacity = "1";
            registerContainer.style.transform = "translate(-50%, -50%) scale(1)";
            registerContainer.classList.add("show");
        }, 10);
    });
}
const registerForm = document.getElementById("sign-up-1");

registerForm.addEventListener("submit", function (event) {
    event.preventDefault();

    const fullnameElement = document.getElementById("register-fullname");
    const usernameElement = document.getElementById("register-username");
    const emailElement = document.getElementById("register-email");
    const password1Element = document.getElementById("pass");
    const password2Element = document.getElementById("pass2");

    const fullname = fullnameElement ? fullnameElement.value.trim() : "";
    const username = usernameElement ? usernameElement.value.trim() : "";
    const email = emailElement ? emailElement.value.trim() : "";
    const password1 = password1Element ? password1Element.value.trim() : "";
    const password2 = password2Element ? password2Element.value.trim() : "";

    if (fullname == "") {
        showToast("Please enter your Full Name", "error");
        return;
    }

    if (username === "") {
        showToast("Please enter your username", "error");
        return;
    }
    if (email === "") {
        showToast("Please enter your email", "error");
        return;
    }
    if (password1 === "") {
        showToast("Please enter your password", "error");
        return;
    }
    if (password1.length < 8) {
        showToast("Password must be at least 8 characters", "error");
        return;
    }
    if (password1 !== password2) {
        showToast("Passwords do not match", "error");
        return;
    }

    document.getElementById("loading-icon2").style.display = "block"; // Show loading icon

    // Prepare JSON payload matching the C# keys expected in Register()
    const payload = {
        registerfullname: fullname,
        registerUsername: username,
        registerEmail: email,
        password1: password1,
        password2: password2,
        role: "customer",
    };
    fetch("index.aspx/Register", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8",
        },
        body: JSON.stringify(payload),
    })
        .then((response) => response.json())
        .then((data) => {
            document.getElementById("loading-icon2").style.display = "none";

            const jsonString = data.d || data;
            const result = typeof jsonString === "string" ? JSON.parse(jsonString) : jsonString;

            showToast(result.message, result.status);

            if (result.status === "success") {
                document.getElementById("sign-up-1").reset();
                registerContainer.style.display = "none";
                loginContainer.style.display = "block";
            }
        });
});

const closeRegisterButton = document.getElementById("close-register");
closeRegisterButton.addEventListener("click", () => {
    registerContainer.style.opacity = "0";
    registerContainer.style.transform = "translate(-50%, -50%) scale(0.9)";
    setTimeout(() => {
        registerContainer.style.display = "none";
    }, 300);
});

//Logout
const logoutLink = document.getElementById("logout-link");
if (logoutLink) {
    logoutLink.addEventListener("click", () => {
        fetch("index.aspx/logout", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({}),
        })
            .then((response) => {
                if (response.headers.get("content-type")?.includes("application/json")) {
                    return response.json();
                } else {
                    throw new Error("Invalid JSON response (HTML received instead)");
                }
            })
            .then((data) => {
                const result = JSON.parse(data.d);
                showToast(result.message, result.status);
                if (result.status === "success") {
                    setTimeout(() => location.reload(), 1000);
                }
            })
            .catch((error) => {
                console.error("Error:", error);
                showToast("An error occurred. Please try again.", "error");
            });
    });
}

//getProducts
getProducts("Fresh_Produce");
function getProducts(category) {
    fetch("index.aspx/GetProducts", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8",
        },
        body: JSON.stringify({ category: category }),
    })
        .then((response) => response.json())
        .then((data) => {
            const products = JSON.parse(data.d);
            const selectedproductsname1 = (document.getElementById("selectedproductsname").innerHTML = category.replace(/_/g, " "));
            const displayArea = document.getElementById("dispalyproducts");
            displayArea.innerHTML = "";
            products.forEach((product) => {
                productData[product.product_name] = product;
                const productDiv = document.createElement("div");
                productDiv.className = "product-item";
                productDiv.innerHTML = `
                 <img id="product-image" src="${product.image}" alt="${product.product_name}">
                 <h3>${product.product_name}</h3>
                 <p>${product.description}</p>
                 <p>Price per 1/2Kg: ₹${product.price}</p>
                 <div class="quantity-controls">
                     <button class="decrement" onclick="updateQuantity('${product.product_name}', -1)">-</button>
                     <span class="quantity-product" id="quantity-${product.product_name}">0</span>
                     <button class="increment" onclick="updateQuantity('${product.product_name}', 1)">+</button>
                 </div>
             `;
                displayArea.appendChild(productDiv);
            });
        })
        .catch((error) => {
            console.error("Error fetching products:", error);
        });
}
const quantities = {};
const productData = {};

function updateQuantity(productName, change) {
    const span = document.getElementById(`quantity-${productName}`);
    let quantity = parseInt(span.textContent);
    quantity = Math.max(0, quantity + change); // prevent negative
    span.textContent = quantity;
}
window.updateQuantity = function (productName, change) {
    if (!quantities[productName]) {
        quantities[productName] = 0;
    }
    quantities[productName] = Math.max(0, quantities[productName] + change);
    document.getElementById(`quantity-${productName}`).innerText = quantities[productName];
    updateCartNumber();
    if (change > 0) {
        showToast(`${productName} added to cart`, "success");
    } else if (change < 0 && quantities[productName] === 0) {
        showToast(`${productName} removed from cart`, "error");
    }
};
function updateCartNumber() {
    const totalQuantity = Object.values(quantities).reduce((total, qty) => total + qty, 0);
    document.getElementById("Cartnumber").innerText = totalQuantity;
}

//search products
function searchProducts() {
    const query = document.getElementById("searchBox").value.trim();

    fetch("index.aspx/SearchProducts", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8"
        },
        body: JSON.stringify({ query: query })
    })
        .then(response => response.json())
        .then(data => {
            const products = JSON.parse(data.d);
            const container = document.getElementById("dispalyproducts");
            container.innerHTML = "";

            if (products.length === 0) {
                container.innerHTML = "<div style='color:red;'>No products found.</div>";
            } else {
                products.forEach(product => {
                    const div = document.createElement("div");
                    div.className = "product-item";
                    div.innerHTML = `
                     <img id="product-image" src="${product.image}" alt="${product.product_name}">
                     <h3>${product.product_name}</h3>
                     <p>${product.description}</p>
                     <p>Price per 1/2Kg: ₹${product.price}</p>
                     <div class="quantity-controls">
                         <button class="decrement" onclick="updateQuantity('${product.product_name}', -1)">-</button>
                         <span class="quantity-product" id="quantity-${product.product_name}">0</span>
                         <button class="increment" onclick="updateQuantity('${product.product_name}', 1)">+</button>
                     </div>`;
                    container.appendChild(div);
                });
            }
        })
        .catch(error => {
            console.error("Search error:", error);
        });
}

//Cart modal
const cartButton = document.getElementById("cart");
const cartModal = document.getElementById("cart-modal");
const closeCartButton = document.getElementById("close-cart");
const clearCartButton = document.getElementById("clear-cart");
const checkoutButton = document.getElementById("checkout");

cartButton.addEventListener("click", () => {
    if (cartModal.style.display === "block") {
        cartModal.classList.remove("show");
        cartModal.style.animation = "fadeOutDown 0.4s forwards";
        setTimeout(() => {
            cartModal.style.display = "none";
            cartModal.style.animation = "";
        }, 350);
    } else {
        cartModal.style.display = "block";
        cartModal.style.animation = "";
        setTimeout(() => {
            cartModal.classList.add("show");
        }, 10);
        displayCartItems();
    }
});
function displayCartItems() {
    const cartItemsContainer = document.getElementById("cart-items");
    const totalPriceElement = document.getElementById("total-price");
    cartItemsContainer.innerHTML = "";
    let totalPrice = 0;

    Object.keys(quantities).forEach((productName) => {
        if (quantities[productName] > 0) {
            const product = productData[productName];
            if (product) {
                const price = product.price * quantities[productName];
                totalPrice += price;

                cartItemsContainer.innerHTML += `
                     <div class='cart-item'>
                         <img src="${product.image}" width="80" height="80">
                         <span>${productName} - ${quantities[productName]} x ₹${product.price} = ₹${price}</span>
                     </div>
                 `;
            }
        }
    });
    totalPriceElement.innerText = totalPrice;
}

closeCartButton.addEventListener("click", () => {
    cartModal.style.animation = "fadeOutDown 0.4s forwards";
    setTimeout(() => {
        cartModal.classList.remove("show");
        cartModal.style.display = "none";
        cartModal.style.animation = "";
    }, 350);
});

clearCartButton.addEventListener("click", () => {
    Object.keys(quantities).forEach((productName) => {
        quantities[productName] = 0;
    });
    updateCartNumber();
    displayCartItems();
    showToast("Cart cleared successfully!", "success");
});

// Checkout modal
const radios = document.querySelectorAll("#credit-card, #cash-on-delivery, #net-banking, #upi");

radios.forEach((radio) => {
    radio.disabled = false;
    radio.style.display = "inline-block";
});

const checkoutModal = document.getElementById("checkout-modal");
const closeCheckoutButton = document.getElementById("close-checkout");
const confirmOrderButton = document.getElementById("confirm-order");


checkoutButton.addEventListener("click", async () => {
   try {
    const response = await fetch("index.aspx/LoginOrNot", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8"
        },
        body: JSON.stringify({}) // Empty body since this method doesn't need input
    });

    const result = await response.json();
       const data = JSON.parse(result.d);      // WebMethod response is nested under `d`
       // WebMethod response is nested under `d`

    if (data.status === "error" && data.message === "User is not logged in.") {
        showToast("Please login to proceed with checkout.", "error");
        cartModal.classList.remove("show");
        cartModal.style.animation = "fadeOutDown 0.4s forwards";
        setTimeout(() => {
            cartModal.style.display = "none";
            cartModal.style.animation = "";
        }, 350);
        loginContainer.style.display = "block";
        setTimeout(() => {
            loginContainer.style.opacity = "1";
            loginContainer.style.transform = "translate(-50%, -50%) scale(1)";
        }, 10);
        return;
    }

        if (Object.values(quantities).some((quantity) => quantity > 0)) {
            checkoutModal.style.display = "block";
            checkoutModal.style.animation = "";
            setTimeout(() => {
                checkoutModal.classList.add("show");
            }, 10);
        } else {
            showToast("Your cart is empty. Add items to proceed.", "error");
        }

    } catch (err) {
        console.error(err);
        showToast("Something went wrong. Please try again later.", "error");
    }
});

closeCheckoutButton.addEventListener("click", () => {
    checkoutModal.style.animation = "fadeOutUp 0.4s forwards";
    setTimeout(() => {
        checkoutModal.classList.remove("show");
        checkoutModal.style.display = "none";
        checkoutModal.style.animation = "";
    }, 350);
});

confirmOrderButton.addEventListener("click", () => {
    const address = document.getElementById("address").value.trim();
    const phoneNumber = document.getElementById("phone-number").value;
    const pincode = document.getElementById("pincode1").value.trim();
    const paymentOptionElement = document.querySelector('input[name="payment"]:checked');
    const paymentOption = paymentOptionElement ? paymentOptionElement.value : null;
    if (address === "") {
        showToast("Please enter your address.", "error");
        return;
    }

    if (phoneNumber === "") {
        showToast("Please enter your phone number.", "error");
        return;
    }
    if (phoneNumber.length != 10) {
        showToast("Please enter a valid phone number.", "error");
        return;
    }
    if (isNaN(phoneNumber)) {
        showToast("Please enter a valid phone number.", "error");
        return;
    }
    if (pincode === "") {
        showToast("Please enter your pincode.", "error");
        return;
    }
    if (!paymentOption) {
        showToast("Please select a payment option.", "error");
        return;
    }
    const orderDetails = {
        address: address,
        phone_number: phoneNumber,
        pincode: pincode,
        paymentOption: paymentOption,
        items: quantities,
        totalPrice: parseFloat(document.getElementById("total-price").innerText.replace("₹", "")),
    };

    fetch("index.aspx/placeorder", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(orderDetails),
    })
        .then((response) => response.json())
        .then((data) => {
            const placeOrder = JSON.parse(data.d);
            console.log(placeOrder);
            showToast(placeOrder.message, placeOrder.status);
            if (placeOrder.status === "success") {
                // Clear cart
                Object.keys(quantities).forEach((productName) => {
                    quantities[productName] = 0;
                });
                updateCartNumber();
                displayCartItems();
                checkoutModal.classList.remove("show");
                setTimeout(() => {
                    checkoutModal.style.display = "none";
                }, 300);
                cartModal.classList.remove("show");
                setTimeout(() => {
                    cartModal.style.display = "none";
                }, 300);
            }
        })
        .catch((error) => {
            console.error("Error:", error);
            showToast("An error occurred. Please try again.", "error");
        });
});

//Contact section
const contactLink = document.getElementById("contact-link");
const contactSection = document.getElementById("contact-section");
const closeContactSectionBtn = document.getElementById("close-contact-section");

const showFormBtn = document.getElementById("show-contact-form");
const formContainer = document.getElementById("complaint-form-container");
const closeFormBtn = document.getElementById("close-contact");
const form = document.getElementById("contact-form");
const loadingIcon = document.getElementById("loading-icon3");

// Show/hide contact section
contactLink?.addEventListener("click", () => {
    if (contactSection.style.display === "block") {
        contactSection.classList.remove("show");
        contactSection.style.animation = "fadeOutRight 0.4s forwards";
        setTimeout(() => {
            contactSection.style.display = "none";
            contactSection.style.animation = "";
        }, 350);
    } else {
        contactSection.style.display = "block";
        contactSection.style.animation = "";
        setTimeout(() => {
            contactSection.classList.add("show");
        }, 10);
    }
});

closeContactSectionBtn.addEventListener("click", () => {
    contactSection.style.animation = "fadeOutRight 0.4s forwards";
    setTimeout(() => {
        contactSection.classList.remove("show");
        contactSection.style.display = "none";
        contactSection.style.animation = "";
    }, 350);
});

// Show/hide complaint form
showFormBtn.addEventListener("click", () => {
    formContainer.style.display = "block";
});

closeFormBtn.addEventListener("click", () => {
    formContainer.style.display = "none";
    
});

// Submit complaint form
form.addEventListener("submit", async (e) => {
    e.preventDefault();
    loadingIcon.style.display = "inline-block";

    const name = document.getElementById("contact-name").value.trim();
    const email = document.getElementById("contact-email").value.trim();
    const message = document.getElementById("message").value.trim();
  const orderid = document.getElementById("orderid").value.trim();


    const response = await fetch('index.aspx/submitComplaint', {
         method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, message, orderid })
    });
    const result = await response.json();
     const data = JSON.parse(result.d);

    loadingIcon.style.display = "none";
    showToast(data.message, data.status);
    if (data.status === "success") {
        form.reset();
        formContainer.style.display = "none";
    }
});

//Order
const orderLink = document.getElementById("orders-link");
const orderSection = document.getElementById("order-section");
const orderList = document.getElementById("order-list");

if (orderLink) {
    orderLink.addEventListener("click", async() => {
 try {
    const response = await fetch("index.aspx/LoginOrNot", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=utf-8"
        },
        body: JSON.stringify({}) // Empty body since this method doesn't need input
    });

    const result = await response.json();
     const data = JSON.parse(result.d);      // WebMethod response is nested under `d`

    if (data.status === "error" && data.message === "User is not logged in.") {
        showToast("Please login to see your orders.", "error");
        
        loginContainer.style.display = "block";
        setTimeout(() => {
            loginContainer.style.opacity = "1";
            loginContainer.style.transform = "translate(-50%, -50%) scale(1)";
        }, 10);
        return;
    }
 } catch (err) {
        console.error(err);
        showToast("Something went wrong. Please try again later.", "error");
    }



        fetch("index.aspx/orders", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({}), // WebMethod requires a body even if empty
        })
            .then((response) => response.json())
            .then((data) => {
              
                const result = JSON.parse(data.d);  
                orderList.innerHTML = "";
                result.orders.reverse().forEach((order) => {
                    const orderDiv = document.createElement("div");
                    orderDiv.className = "order-item order-animated";
                    orderDiv.innerHTML = `
                     <h3>Order ID: ${order._id}</h3>
                     <p>Date: ${new Date(order.orderDate).toLocaleString()}</p>
                     <p>User Name: ${order.username}</p>
                <p>Email : ${order.email}</p>
                     <p>Status: ${order.status}</p>
                     <p>Total Price: ₹${order.totalPrice}</p>
                     <p>Phone Number: ${order.phone_number}</p>
                     <p>Address: ${order.address}</p>
                     <p>Pincode: ${order.pincode}</p>
                     <p>Payment Option: ${order.paymentOption}</p>
                     <div class="order-items">
                         ${order.items
                            ? Object.keys(order.items)
                                .map(
                                    (productName) => `
                         <div class="order-item-detail">
                             <span>${productName} - ${order.items[productName]} x ₹${productData[productName]?.price || "N/A"}</span>
                         </div>
                     `
                                )
                                .join("")
                            : ""
                        }
                     </div>`;

                    orderList.appendChild(orderDiv);
                });

                if (result.orders.length === 0) {
                    const noOrdersDiv = document.createElement("div");
                    noOrdersDiv.className = "order-item";
                    noOrdersDiv.innerHTML = "<p>You have no orders yet.</p>";
                    orderList.appendChild(noOrdersDiv);
                }

                // Show or hide order section
                if (orderSection.style.display === "block") {
                    orderSection.classList.remove("show");
                    setTimeout(() => {
                        orderSection.style.display = "none";
                    }, 300);
                } else {
                    orderSection.style.display = "block";
                    orderSection.style.animation = "";
                    setTimeout(() => {
                        orderSection.classList.add("show");
                    }, 10);
                }
            })
            .catch((error) => {
                console.error("Error:", error);
                showToast("An error occurred while fetching orders.", "error");
            });

        const closeOrdersButton = document.getElementById("close-orders");

        if (closeOrdersButton) {
            closeOrdersButton.addEventListener("click", () => {
                const orderSection = document.getElementById("order-section");
                orderSection.style.animation = "flipOut 0.5s forwards";
                setTimeout(() => {
                    orderSection.classList.remove("show");
                    orderSection.style.display = "none";
                    orderSection.style.animation = "";
                }, 450);
            });
        }
    });
}

const container = document.getElementById("selectedProducts");
const header = document.getElementById("selectedproductsname");
const searchbox = document.getElementById("searchBox");

container.addEventListener("scroll", () => {
    if (container.scrollTop > 0) {
        header.classList.add("blurred");
        searchbox.classList.add("blurred");
    } else {
        header.classList.remove("blurred");
        searchbox.classList.add("blurred");
    }
});