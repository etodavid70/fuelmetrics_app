# fuelmetrics assessment by Eto David



## Getting Started

I built a mobile application for field sales representatives.
The user can see customers, views available products, creates an order, and submits the order to a mock API(backend)

## TECHNOLOGY
I used Flutter for this mobile app.
Flutter 3.38.1
Dart 3.10.0 

## STATE MANAGEMENT
I used provider for state management and followed the Provider-Based Architecture since it’s a simple project.
  
## Core Requirements as requested.

1. CUSTOMERS

The app displays a list of customers, showing;
-Name
-Location
-Phone number
-Outstanding balance

The user can also search for a customer using;
-Name
-Location

Selecting a customer opens their details.


2. PRODUCTS
The product list page is displayed when the User tries to create an order.


The app displays a list products showing;

-Product name
-Price
-Available quantity

The salesperson can search for products.

3. CREATE ORDER

From a customer, the salesperson is able to create an order.

They should be able to:

Add products
Specify quantities
Remove products
See line totals
See the overall order total

4. SUBMIT ORDER

The salesperson can review and submit the order.

successful and failed submissions are correctly handlied and this is displayed in the app

5. OFFLINE BEHAVIOUR

I also ensured that if the user is in a place where there is limited internet where an order cannot be submitted, the app allows it to be saved locally as Pending.
The salesperson can see pending orders and retry submission later.

I did this using a package in flutter called “connectivity plus”
And I also used a package called “shared preferences” for local storage.




