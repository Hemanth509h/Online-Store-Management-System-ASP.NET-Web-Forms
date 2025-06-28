// Toast functionality
function showToast(message, type = "success") {
    const toast = document.getElementById("toast");
    const toastMessage = document.getElementById("toast-message");
    toastMessage.innerText = message;
    toast.className = `toast show ${type}`;
    setTimeout(() => {
        toast.className = toast.className.replace("show", "");
    }, 5000);
}

// Add User Modal functionality
const adduser = document.getElementById("adduser");

document.getElementById("adduserbutton").addEventListener("click", (event) => {
    event.preventDefault();
    adduser.style.display = "block";
    setTimeout(() => {
        adduser.style.opacity = "1";
        adduser.style.transform = "translate(-50%, -50%) scale(1)";
        adduser.classList.add("show");
    }, 10);
});

document.getElementById("close-adduser").addEventListener("click", () => {
    adduser.style.opacity = "0";
    adduser.style.transform = "translate(-50%, -50%) scale(0.9)";
    setTimeout(() => {
        adduser.style.display = "none";
    }, 300);
});

// Role selection functionality
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

// Add User functionality
function addUser(event) {
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

// Dashboard show/hide functionality
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

// Dashboard Stats functionality
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

// User management functionality
let intervalId = null;
document.getElementById("Users").addEventListener("click", function () {
    if (intervalId) clearInterval(intervalId);
    getusers("customer");
});

document.getElementById("Distributor").addEventListener("click", function () {
    if (intervalId) clearInterval(intervalId);
    getusers("distributor");
});

// Admin pin functionality
document.addEventListener("DOMContentLoaded", function () {
    const adminButton = document.getElementById("Admin");
    const adminPinPopup = document.getElementById("adminpin");
    const adminPinForm = document.getElementById("adminpinform");
    const closeBtn = document.getElementById("close-adminpin");

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

    closeBtn.addEventListener("click", function () {
        closePopup();
    });

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

// Search functionality
document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("search").addEventListener("input", function () {
        const searchTerm = this.value.trim().toLowerCase();

        // Search in users
        const users = document.querySelectorAll(".users-container");
        users.forEach((user) => {
            const fullName = user.querySelector("#userfullname")?.textContent.toLowerCase().trim() || "";
            const userName = user.querySelector("#userusername")?.textContent.toLowerCase().trim() || "";
            const email = user.querySelector("#useremail")?.textContent.toLowerCase().trim() || "";
            const distributorName = user.querySelector("#userdistributorname")?.textContent.toLowerCase().trim() || "";
            const pincode = user.querySelector("#userpincode")?.textContent.toLowerCase().trim() || "";

            user.style.display = fullName.includes(searchTerm) || userName.includes(searchTerm) || email.includes(searchTerm) || distributorName.includes(searchTerm) || pincode.includes(searchTerm) ? "block" : "none";
        });

        // Search in orders
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
                    orderContent.includes(searchTerm)
                    ? "block"
                    : "none";
        });
    });
});

// Order management functionality
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
                const todayStr = new Date().toISOString().split("T")[0];
                const ordersData = JSON.parse(data.d);
                const orderList = document.getElementById("order-list");
                orderList.innerHTML = "";
                document.getElementById("formsearch").style.display = "block";

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

// Logout functionality
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
                window.location.href = "index.aspx";
            } else {
                alert(res.message);
            }
        })
        .catch((error) => {
            console.error("Logout error:", error);
            alert("Logout failed. Please try again.");
        });
});