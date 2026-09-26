# E-Commerce Data Dictionary

## `orders`

| Column | Description | Data Type |
|---|---|---|
| `sessionid` | Unique identifier for a website session associated with a completed purchase | VARCHAR |
| `sessiondate` | Date and time of the session | TIMESTAMP |
| `device` | Device used during the session | VARCHAR |
| `channel` | Acquisition or marketing channel that brought the session | VARCHAR |
| `sku` | Unique product identifier | VARCHAR |
| `category` | Product category | VARCHAR |
| `discount_applied` | Indicates whether a discount was applied to the purchase: 1 = Yes, 0 = No | INTEGER |
| `order_value` | Monetary value of the order | NUMERIC |
| `units` | Number of units purchased | INTEGER |

---

## `websession`

| Column | Description | Data Type |
|---|---|---|
| `sessionid` | Unique identifier for a website session | VARCHAR |
| `sessiondate` | Date and time of the session | TIMESTAMP |
| `device` | Device used during the session | VARCHAR |
| `channel` | Acquisition or marketing channel that brought the session | VARCHAR |
| `added_to_cart` | Indicates whether the user added a product to the cart: 1 = Yes, 0 = No | INTEGER |
| `purchased` | Indicates whether the session resulted in a purchase: 1 = Yes, 0 = No | INTEGER |

---

## Key Data Relationships

The two tables can be connected using:

```text
orders.sessionid = websession.sessionid
```

The `orders` table contains completed purchasing-session information, while `websession` contains the broader website-session funnel.

This relationship allows the analysis to connect **website activity with completed purchases**.


- `sessionid` represents a session, not a unique customer.
- The dataset contains **25,000 web sessions** and **3,037 purchasing sessions**.
- A data-quality check confirmed that each purchasing session contains a maximum of one product row in this dataset.
- Binary fields use `1` for Yes and `0` for No.
- `order_value` represents the monetary value recorded for each purchase.
