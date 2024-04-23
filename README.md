# SQL---effectiveness-of-promotion
Xem xét độ hiệu quả của chương trình khuyến mãi cho các sản phẩm thanh toán tiền điện

**Bối cảnh**
Trong năm 2020, đội Marketing đã thực hiện nhiều chương trình khuyến mãi cho các sản phẩm thanh toán tiền điện. Chúng ta cần phải nghiên cứu những chương trình khuyến mãi đó có hiệu quả hay không để lên kế hoạch marketing trong năm nay

**Thông tin bộ dữ liệu**
_Bảng 1:_ fact_transaction_2020
  Nơi lưu trữ thông tin của các cuộc giao dịch diễn ra trong năm 2020 với các cột trường thông tin:
    - transaction_id (PK, int)
    - customer_id (int)
    - scenario_id (FK, nvarchar)
    - payment_channel_id (FK, nvarchar)
    - promotion_id (nvarchar)
    - status_id (FK, smallint)

_Bảng 2:_  dim_scenario
  Mô tả chi tiết của các loại giao dịch, bao gồm:
    - scenario_id (PK, nvarchar)
    - transaction_type (nvarchar)
    - sub_category (nvarchar)
    - category (nvarchar)

_Bảng 3_: dim_status
  Mô tả chi tiết kết quả giao dịch, bao gồm:
    - status_id (PK, smallint)
    - status_description (nvarchar)

_Bảng 4:_ dim_payment_channel
  Mô tả chi tiết phương thức thanh toán của giao dịch, bao gồm:
    - payment_channel_id (PK, nvarchar)
    - payment_method (nvarchar)


**Làm rõ vấn đề**
Để giải quyết vấn đề cần làm rõ 2 ý chính:
  1. Xu hướng của số lượng giao dịch thanh toán thành công có khuyến mãi chiếm bao nhiêu phần trăm lượng giao dịch thanh toán thành công (theo tuần)
  2. Trong tổng số khách hàng thanh toán thành công được hưởng khuyến mãi đó, có bao nhiêu % khách hàng tiếp tục phát sinh thêm giao dịch thanh toán thành công mà không hưởng khuyến mãi.
