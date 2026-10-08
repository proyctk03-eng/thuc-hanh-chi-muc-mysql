# [Thực hành] Chỉ mục trong MySQL (MySQL Indexes & EXPLAIN)

## 📌 Giới Thiệu & Mục Tiêu

Bài thực hành hướng dẫn kỹ thuật tối ưu hóa hiệu năng truy vấn cơ sở dữ liệu MySQL thông qua việc sử dụng **Chỉ mục (Index)** và công cụ phân tích kế hoạch thực thi **EXPLAIN** trên bảng `customers` thuộc cơ sở dữ liệu mẫu `classicmodels`.

### 🎯 Mục tiêu bài học:
- **Hiểu bản chất của Index**: Nắm vững cơ chế hoạt động của chỉ mục B-Tree trong MySQL và sự tương đồng với cuốn sách có mục lục.
- **Sử dụng lệnh `EXPLAIN`**: Đọc và giải thích các chỉ số cốt lõi trong Execution Plan (`type`, `possible_keys`, `key`, `rows`, `Extra`) để nhận diện hiện tượng Quét toàn bảng (*Full Table Scan*).
- **Tạo và quản lý Index**: Thành thạo cú pháp tạo chỉ mục đơn (`Single-column Index`), chỉ mục phức hợp (`Composite Index`) và cách xóa chỉ mục (`DROP INDEX`).
- **Đánh giá hiệu năng**: Thấy rõ sự khác biệt vượt trội về số dòng cần quét (`rows`) trước và sau khi đánh chỉ mục.

---

## 📖 Cơ Chế Hoạt Động Của Index

### 1. Khái niệm Index là gì?
- **Index (Chỉ mục)** là một cấu trúc dữ liệu riêng biệt (thường là B-Tree trong InnoDB) được lưu trữ trên đĩa nhằm giúp MySQL định vị nhanh chóng các dòng dữ liệu thỏa mãn điều kiện tìm kiếm mà không cần phải duyệt qua từng dòng một.
- **Hình ảnh ví von**: Nếu một cuốn sách dày 1.000 trang không có mục lục, khi muốn tìm thông tin về một chủ đề cụ thể, bạn buộc phải lật đọc từ trang 1 đến trang 1.000 (*Full Table Scan*). Nếu có phần **Mục Lục (Index)**, bạn chỉ cần tra cứu từ khóa trong mục lục rồi nhảy thẳng tới số trang cụ thể để đọc dữ liệu.

### 2. Sự đánh đổi (Trade-off) khi dùng Index
- **Ưu điểm**:
  - Tăng tốc độ truy vấn `SELECT` có điều kiện `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY` lên gấp hàng trăm đến hàng nghìn lần.
- **Chi phí đánh đổi**:
  - Tốn thêm dung lượng lưu trữ trên đĩa để duy trì cây Index.
  - Làm chậm các thao tác ghi dữ liệu (`INSERT`, `UPDATE`, `DELETE`) vì mỗi khi dữ liệu thay đổi, MySQL phải tự động cập nhật và cân bằng lại cây Index.
  - *Nguyên tắc vàng*: Chỉ tạo Index trên các cột thường xuyên xuất hiện trong điều kiện lọc `WHERE` hoặc `JOIN`, và có độ chọn lọc (cardinality) cao.

---

## 🔬 Chi Tiết Thực Hành & Phân Tích Kế Hoạch Thực Thi (EXPLAIN)

### Bước 1: Khảo sát trước khi đánh Index (Full Table Scan)
```sql
EXPLAIN SELECT * 
FROM customers 
WHERE customerName = 'Land of Toys Inc.';
```
- **Kế hoạch thực thi**:
  - `type`: **ALL** (Toàn bảng - Full Table Scan). MySQL phải duyệt qua toàn bộ các dòng của bảng `customers`.
  - `possible_keys`: **NULL** (Không có chỉ mục nào có thể dùng).
  - `key`: **NULL** (Không có chỉ mục nào được sử dụng).
  - `rows`: Bằng tổng số dòng hiện có trong bảng (ví dụ: 20 hoặc 500.000 dòng).
  - `Extra`: `Using where`.

---

### Bước 2: Tạo chỉ mục đơn cho cột `customerName`
```sql
ALTER TABLE customers ADD INDEX idx_customerName(customerName);
```
- Lệnh này tạo ra một B-Tree Index có tên là `idx_customerName` sắp xếp các giá trị tên khách hàng theo thứ tự alphabet.

---

### Bước 3: Phân tích lại truy vấn sau khi có Index
```sql
EXPLAIN SELECT * 
FROM customers 
WHERE customerName = 'Land of Toys Inc.';
```
- **Kế hoạch thực thi sau khi tối ưu**:
  - `type`: **ref** (Tra cứu tham chiếu qua index có độ chọn lọc cao).
  - `possible_keys`: **idx_customerName**.
  - `key`: **idx_customerName** (MySQL quyết định sử dụng index này).
  - `rows`: **1** (MySQL chỉ cần đọc đúng 1 dòng khớp trực tiếp từ cây index thay vì quét toàn bộ bảng).

#### 📊 Bảng so sánh đối chiếu:
| Chỉ số EXPLAIN | Trước khi tạo Index | Sau khi tạo Index (`idx_customerName`) | Ý nghĩa tối ưu |
| :--- | :--- | :--- | :--- |
| **`type`** | `ALL` | `ref` | Chuyển từ quét tuần tự toàn bảng sang tra cứu index trực tiếp |
| **`possible_keys`** | `NULL` | `idx_customerName` | MySQL nhận diện được index ứng viên |
| **`key`** | `NULL` | `idx_customerName` | MySQL chọn dùng index tối ưu nhất |
| **`rows`** | Quét toàn bảng (N dòng) | **1 dòng** | Giảm số lần đọc I/O đĩa từ $N$ xuống $1$ |
| **`Extra`** | `Using where` | *(Trống)* | Không phải lọc từng dòng sau khi quét đĩa |

---

### Bước 4: Tạo chỉ mục phức hợp (Composite Index)
Khi thường xuyên truy vấn kết hợp nhiều cột cùng lúc, việc sử dụng Composite Index sẽ hiệu quả hơn nhiều so với việc tạo các index đơn lẻ rời rạc:
```sql
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);
```

### Bước 5: Kiểm tra với câu lệnh truy vấn lọc theo tên người liên hệ
```sql
EXPLAIN SELECT * 
FROM customers 
WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';
```
- **Kế hoạch thực thi**:
  - `type`: **range** (Quét trong dải giá trị index thỏa mãn điều kiện `OR`).
  - `key`: **idx_full_name** (Tận dụng nguyên lý tiền tố ngoài cùng bên trái - Leftmost Prefix Rule).
  - `Extra`: `Using index condition`.

---

### Bước 6: Xóa chỉ mục (DROP INDEX)
Khi chỉ mục không còn được sử dụng hoặc cần loại bỏ để cải thiện tốc độ ghi dữ liệu:
```sql
ALTER TABLE customers DROP INDEX idx_full_name;
```

Kiểm tra lại danh sách các chỉ mục còn lại trên bảng:
```sql
SHOW INDEX FROM customers;
```

---

## 🚀 Hướng Dẫn Chạy Script

1. **Khởi tạo bảng và nạp dữ liệu mẫu**:
   Mở MySQL CLI hoặc MySQL Workbench và chạy file:
   ```bash
   mysql -u root -p < 01_customers_schema_and_data.sql
   ```
2. **Chạy các câu lệnh thực hành và quan sát EXPLAIN**:
   ```bash
   mysql -u root -p classicmodels < 02_index_practice.sql
   ```
