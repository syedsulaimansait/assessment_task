# 📘 Flutter E-Commerce App – Technical Documentation

This document is prepared for **project submission**, covering the requested sections:

1. Cart Screen
2. Product Detail Screen
3. Product List Screen
4. Wishlist Screen
5. RatingStars Widget
6. Product Model
7. Providers (Cart, Wishlist, Product)

Each section includes purpose, design explanation, architecture notes, and implementation details.

---

## **1. Cart Screen**

### **Purpose**

The Cart Screen allows users to:

* View products added to the cart
* Increase or decrease quantity
* Remove items
* View the updated total price dynamically
* Proceed to checkout

### **Design Choices**

* Minimal card layout for each cart item
* Product image left-aligned for quick visual recognition
* Quantity selector with increment/decrement buttons
* Total price visible at the bottom
* Consistent padding & spacing to maintain clean UI

### **Architecture Notes**

* Uses **CartProvider** for state updates
* Uses **Consumer** widgets for reactive UI
* Total price recalculates using a Provider getter

### **Key Functionalities**

* Quantity change triggers `notifyListeners()`
* Removing an item updates the UI instantly
* Uses `ListView.separated()` for spacing optimization

---


## **2. Architecture / File Structure**

```
lib
   model
      product_model.dart
   provider
      cart_provider.dart
      product_provider.dart
      wishlist_provider.dart
   screens
      cart_screen.dart
      product_detail_screen.dart
      product_list_screen.dart
      wishlist_screen.dart
   services
      api_services.dart
   theme
      app_theme.dart
   widgets
      product_card.dart
      rating_stars.dart
      shimmer_card.dart

	---


## **3. Product Detail Screen**

### **Purpose**

Displays information about a single product including:

* Hero image
* Title
* Price
* Rating
* Description
* Add to Cart and Wishlist buttons

### **Design Choices**

* **Hero animation** used for smooth transition from product list
* Large image focus for e-commerce professionalism
* CTA (Add to Cart) placed at the bottom for usability
* `RatingStars` widget shows rating clearly

### **Architecture Notes**

* Data passed via constructor or Provider
* Wishlist toggles using `WishlistProvider`
* Cart updates using `CartProvider`

### **Key Functionalities**

* Users can mark/unmark wishlist items
* Description expands for readability
* Hero tag ensures unique and smooth animation

---

## **4. Product List Screen**

### **Purpose**

This is the main screen where users browse products.

### **Features**

* Supports **GridView** (2-column layout)
* Search bar with animation
* Floating cart button with badge
* Bottom navigation bar

### **Design Choices**

* Grid layout used for high information density
* Cards with rounded corners & shadows
* Search bar animates for better UX without taking full space
* Floating Action Button keeps cart accessible from any screen

### **Architecture Notes**

* Uses `ProductProvider` to load product list
* Search logic filters products locally
* Lazy loading or shimmer UI can be added

---

## **5. Wishlist Screen**

### **Purpose**

* Stores user-favorite products for later viewing

### **Design Choices**

* Similar layout to product list for user familiarity
* Wishlist icon toggles between filled and outlined

### **Architecture Notes**

* Uses `WishlistProvider` for adding/removing items

### **Key Functionalities**

* Instant UI update via Provider
* Items can be moved to cart

---

## **6. RatingStars Widget**

### **Purpose**

To visually represent product ratings with stars.

### **Design Choices**

* Custom star icons for consistency across screens
* Uses Row + Icon widgets

### **Architecture Notes**

* Stateless widget for performance
* Accepts rating as parameter and renders filled/empty stars

---

## **7. Product Model**

### **Purpose**

Defines the structure of each product in the app.

### **Fields Typically Include:**

* `id`
* `title`
* `price`
* `description`
* `category`
* `rating`
* `image`

### **Design Choices**

* Clean model-based architecture for scalability
* Ensures type safety and reduces errors

---

## **8. Providers (State Management)**

### **Used Providers:**

* **ProductProvider** → loads and manages product list
* **CartProvider** → manages cart items and total price
* **WishlistProvider** → manages wishlist

### **Why Provider?**

* Lightweight and recommended for mid-sized apps
* Automatic rebuilds only where needed
* Easy to extend

### **Provider Responsibilities:**

| Provider         | Responsibilities                                     |
| ---------------- | ---------------------------------------------------- |
| ProductProvider  | Fetching products, search filtering                  |
| CartProvider     | Add/remove items, quantity update, total calculation |
| WishlistProvider | Add/remove favorites, sync with detail/list screens  |



---

## ✅ **Document Ready for Submission**

This documentation now:

* Explains purpose and architecture of each screen
* Defines all components clearly
* Uses consistent formatting
* Matches academic/industry submission standards

   
