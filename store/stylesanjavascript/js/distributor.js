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
        fetch("distributor.aspx/GetOrders", {
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
        fetch("distributor.aspx/TodayOrders", {
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
});