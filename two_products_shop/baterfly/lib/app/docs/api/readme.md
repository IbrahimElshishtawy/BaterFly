# 🧠 API Documentation — Two Products Shop

This folder documents all backend interactions for the app.

---

## 📦 Supabase Tables
| Table | Purpose |
|--------|----------|
| `products` | Stores product details like name, price, features, images |
| `orders` | Customer orders with address, phone, and payment info |
| `product_reviews` | User-submitted reviews and ratings |
| `admins` | Authenticated users with full permissions |
| `settings` | App-level configuration like WhatsApp and shipping |

---

## 🔗 Endpoints

### 1. **Get Products**
```sql
GET from supabase.from('products').select()
