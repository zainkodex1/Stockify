# Stockify Project Analysis Report

## 1. Executive Summary
Stockify is a robust, Flutter-based Point of Sale (POS) and Inventory Management system designed primarily for pharmacies or retail businesses handling batch-based inventory (expiration dates). It features a modern, responsive UI (Material Design) and uses a local SQLite database (Drift) for offline reliability.

## 2. Comprehensive Feature Breakdown

### A. Inventory Management (Products/Medicines)
The core of the system is a sophisticated inventory manager that handles products and their specific stock batches.

**Key Features:**
*   **Dual-Level Management**: Separates "Product Details" (Name, Category) from "Stock Details" (Batch, Price, Expiry).
*   **Batch Tracking**: Supports multiple batches for a single product. This is critical for pharmacies to track expiry dates and different purchase prices (FIFO/FEFO).
*   **Category System**: Supports Main Categories and Sub-categories for organized cataloging.
*   **Low Stock Alerts**: Configurable `minStock` levels trigger visual warnings in the POS.
*   **Autocomplete Search**: "Add Product" dialog features an intelligent search to quickly add stock to existing items without re-entering details.

**Fields (Data Structure):**
*   **Product Level**:
    *   `Name`: Product Name.
    *   `Code`: Unique Barcode/ID.
    *   `Main Category`: e.g., "Medicine", "Cosmetics".
    *   `Sub Category`: e.g., "Antibiotics", "Syrups".
    *   `Manufacturer`: Brand or Maker.
    *   `Description`: Optional details.
    *   `Min Stock`: Threshold for low-stock alerts.
*   **Batch Level**:
    *   `Batch Number`: Unique identifier for the lot.
    *   `Expiry Date`: Critical for shelf-life management.
    *   `Purchase Price`: Cost to business.
    *   `Sale Price`: Selling price.
    *   `Quantity`: Current stock level.

### B. Point of Sale (POS) System
A high-efficiency checkout interface designed for speed and accuracy.

**Key Features:**
*   **Smart Cart Logic**:
    *   **FEFO Allocation**: Automatically picks stock from the batch expiring soonest (First Expired, First Out).
    *   **Stock Warnings**: Alerts the cashier if requested quantity exceeds available stock or dips below minimum levels.
    *   **Flexible Pricing**: Global controls for Discount, GST, Tax, and POS Fees (supports both Percentage `%` and Fixed Amount logic).
*   **Customer Management**:
    *   **Walk-in Default**: Auto-loads a "Walk-in Customer" profile.
    *   **Customer Database**: Search existing customers or add new ones on the fly (Name + Phone).
*   **Keyboard Shortcuts**:
    *   `Ctrl+F`: Search Product.
    *   `F2` / `Ctrl+Enter`: Checkout.
    *   `Arrows`: Navigate product list.
    *   `Ctrl+Up/Down`: Adjust Cart Quantity.
*   **Responsive Layout**: Adapts between Desktop (Split View: Product List + Cart) and Mobile (Tabbed View).

### C. Invoicing & Billing System
Generates professional, thermal-printer-ready receipts.

**Invoice Fields & Layout:**
*   **Header**: Shop Name, Address, Phone, Email, Website, Business Type.
*   **Transaction Info**: Invoice Number (Unique), Date, Time, Payment Method (Cash/Card/Online).
*   **Customer Info**: Name, Phone Number (if registered).
*   **Line Items**:
    *   Item Name
    *   Quantity
    *   Rate (Unit Price)
    *   Total (Qty × Rate)
*   **Financials**:
    *   **Subtotal**: Sum of line items.
    *   **Discount**: Applied as % or Fixed value.
    *   **Taxes**: GST and Additional Tax (configurable rates).
    *   **POS Fee**: Additional service charge.
    *   **Grand Total**: Final payable amount.
    *   **Payment Details**: Amount Paid & Change Returned.

### D. Sales History & Reporting
*   **Transaction Log**: View list of all past sales.
*   **Details View**: Drill down into specific sales to see items sold.
*   **Reprint**: Logic exists to reprint past receipts (UI placeholder present).

## 3. Technical Architecture & Database

The app is built on a solid offline-first architecture using **Drift** (SQLite ORM) and **Riverpod** for state management.

### Database Schema (Drift)
| Table | Description | Key Fields |
| :--- | :--- | :--- |
| **Users** | Authentication & Roles | `username`, `passwordHash`, `role` (Admin/Cashier) |
| **Settings** | App Configuration | `key`, `value` (e.g., 'taxRate', 'shopName') |
| **Categories** | Catalog Organization | `name`, `parentId` (Self-referencing for hierarchy) |
| **Medicines** | Product Master Data | `name`, `code` (Barcode), `minStock`, `manufacturer` |
| **Batches** | Inventory & Pricing | `medicineId` (FK), `batchNumber`, `expiryDate`, `qty`, `prices` |
| **Customers** | CRM Data | `name`, `phoneNumber` (Unique identifier often used) |
| **Sales** | Transaction Headers | `invoiceNumber`, `customerId`, `grandTotal`, `tax`, `discount`, `posFee` |
| **SaleItems** | Transaction Details | `saleId`, `batchId`, `quantity`, `price` (snapshot at time of sale) |

### Key Logic & Workflows

1.  **Product Addition Workflow**:
    *   Owner opens "Add Product".
    *   System loads Categories.
    *   Owner searches for existing product:
        *   **If Found**: Form pre-fills, focus moves to "Add Batch" section to just update stock.
        *   **If New**: Owner fills Product Info -> Then Fills Batch Info.
    *   On Save: Creates `Medicine` record (if new) -> Creates `Batch` record linked to Medicine.

2.  **Checkout Workflow**:
    *   Cashier adds Item `X`.
    *   System queries `Batches` for Item `X`.
    *   **Logic**: Find batches with Qty > 0 -> Sort by Expiry (Ascending).
    *   System deducts requested qty from `Cart State` (not DB yet).
    *   **Checkout**:
        *   Confirm Payment (Cash/Card).
        *   **Transaction**:
            *   Create `Sales` record.
            *   Create `SaleItems` records.
            *   **CRITICAL**: Update `Batches` table to decrement `quantity` by sold amount.
        *   Generate PDF Receipt.

## 4. Analysis & Observations
*   **Robustness**: The separation of Medicines and Batches is a professional-grade architecture often missed in simple POS apps. It correctly handles real-world retail scenarios (e.g., old stock at old price vs new stock).
*   **User Experience**: Heavy investment in keyboard navigation and responsiveness indicates a focus on high-throughput environments (busy shops).
*   **Flexibility**: The `Settings` table and dynamic tax/fee calculation strategies (Percent vs Fixed) make the system adaptable to different regions and tax laws.
*   **Scalability**: The database structure is normalized, allowing for easy expansion (e.g., adding Supplier tracking or detailed Audit Logs) without breaking core features.
