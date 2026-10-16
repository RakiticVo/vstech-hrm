// Build No.3 – "Tài liệu kỹ thuật – Ứng dụng di động" (~10 pages, 4 core features)
// Content is meant to be copied into a master Word document, so there is no
// cover / introduction: every section follows the same template
//   Mô tả nghiệp vụ → API sử dụng → Mã nguồn đại diện (Model · DataSource · Repository)
const fs = require("fs");
const path = require("path");
const { Packer } = require("docx");
const h = require("./docx_helpers");
const { P, H1n, H2, B, table, code, makeDoc, excerpt } = h;

const REPO = path.resolve(__dirname, "../../..");
const OUT = path.resolve(__dirname, "..");

// Excerpt located by content so the document always mirrors the current code.
function snippet(rel, spec, caption) {
  const e = excerpt(REPO, rel, spec);
  return [
    code(e.text, { title: `${rel}  (dòng ${e.from}–${e.to})`, startLine: e.from, size: 16 }),
    P(caption, { align: "center", run: { italics: true, size: 21 }, after: 160 }),
  ];
}

const apiTable = (rows) => table(["Thao tác", "Phương thức", "Endpoint"], rows, [0.4, 0.14, 0.46], { size: 20 });

const children = [];
const add = (...xs) => xs.flat().forEach((x) => children.push(x));

// ---------------------------------------------------------------- 1 Attendance
add(H1n("1. CHỨC NĂNG CHẤM CÔNG"));
add(H2("1.1. Mô tả nghiệp vụ"));
add(P("Nhân viên chấm công vào / ra ca bằng nhận diện khuôn mặt AI ngay trên điện thoại. Mỗi lượt chấm được xác thực **3 lớp**: (1) khuôn mặt được so khớp bởi Face Authentication API; (2) toạ độ GPS đối soát bán kính geofence quanh điểm làm việc; (3) thông tin mạng Wi-Fi và dấu vân tay thiết bị gửi kèm. Ứng dụng chỉ ghi nhận lượt chấm công lên máy chủ sau khi khuôn mặt được xác thực khớp với hồ sơ nhân viên."));
add(B("Trình tự: lấy toạ độ GPS → kiểm tra đã đăng ký khuôn mặt → mở camera trước, chụp ảnh trong khung căn mặt → xác thực khuôn mặt → ghi nhận chấm công → hiển thị biên lai (giờ, trạng thái đúng giờ / đi muộn / về sớm, vị trí)."));
add(B("Ngoại lệ: chưa đăng ký khuôn mặt → chuyển màn đăng ký; khuôn mặt không khớp → chụp lại; vi phạm quy tắc chấm công → thông báo kèm hướng liên hệ HR."));
add(H2("1.2. API sử dụng"));
add(apiTable([
  ["Kiểm tra nhân viên đã đăng ký khuôn mặt", "GET", "/checkreg/?Code&AppCode  (Face API)"],
  ["Đăng ký / cập nhật khuôn mặt", "POST", "/register/ · /update/  (Face API)"],
  ["Xác thực khuôn mặt từ ảnh chụp", "POST", "/verify/  (Face API, multipart)"],
  ["Chấm công vào ca", "POST", "/api/Enrollments/Checkin"],
  ["Chấm công ra ca", "POST", "/api/Enrollments/Checkout"],
  ["Trạng thái công hôm nay / lịch sử", "GET", "/api/Enrollments/info"],
]));
add(H2("1.3. Mã nguồn đại diện"));
add(snippet("lib/features/attendance/data/datasources/face_auth_remote_datasource.dart",
  { after: "class FaceAuthRemoteDataSourceImpl", start: "Future<FaceVerifyResponseModel> verifyFace\\(", back: 1 },
  "Đoạn mã 1.1 – DataSource: gửi ảnh khuôn mặt (multipart) tới Face Authentication API để xác thực"));
add(snippet("lib/features/attendance/presentation/bloc/attendance_bloc.dart",
  { start: "final isVerified = verifyResult\\.fold\\(", end: "^\\s+\\};\\s*$" },
  "Đoạn mã 1.2 – AttendanceBloc: chỉ ghi nhận chấm công sau khi khuôn mặt được xác thực khớp"));
add(snippet("lib/features/attendance/data/datasources/attendance_remote_datasource.dart",
  { start: "Future<AttendanceRecordModel> checkIn\\(CheckInParams params\\) async", back: 1 },
  "Đoạn mã 1.3 – DataSource: lập EnrollForm (toạ độ, mạng, thiết bị), gửi lượt chấm công vào ca và phân loại kết quả"));

// ---------------------------------------------------------------- 2 Leave
add(H1n("2. CHỨC NĂNG NGHỈ PHÉP"));
add(H2("2.1. Mô tả nghiệp vụ"));
add(P("Nhân viên xem danh sách đơn nghỉ theo tháng (lọc Chờ duyệt / Đã duyệt / Từ chối) và tạo đơn nghỉ trực tuyến: chọn nghỉ cả ngày, nửa ca sáng hoặc nửa ca chiều, loại phép (phép năm, hiếu, hỷ, thai sản, chăm vợ sinh con…), từ ngày – đến ngày và lý do; ứng dụng tự tính số ngày nghỉ. Đơn đi qua quy trình duyệt **Nhân viên → Quản lý trực tiếp → HR → Giám đốc**; quản lý duyệt / từ chối ngay trên điện thoại. Lộ trình phiên bản tiếp theo bổ sung thu hồi đơn đang chờ duyệt."));
add(H2("2.2. API sử dụng"));
add(apiTable([
  ["Danh mục loại phép", "GET", "/api/LeaveRequests/self?init=1&version=1"],
  ["Danh sách đơn của tôi theo tháng", "GET", "/api/LeaveRequests/self?From&To"],
  ["Tạo đơn nghỉ phép", "POST", "/api/LeaveRequests/self"],
  ["Quản lý duyệt / từ chối", "GET", "/api/ConfirmRequests/leave/accept|deny/{id}"],
]));
add(H2("2.3. Mã nguồn đại diện – Tạo đơn nghỉ phép"));
add(snippet("lib/features/requests/data/models/leave_request_models.dart",
  { start: "/// DTO mapping to LeaveRequestCreate", endBlock: "Map<String, dynamic> toJson\\(\\)" },
  "Đoạn mã 2.1 – Model LeaveRequestCreateCommand: dữ liệu đơn nghỉ và chuyển đổi sang JSON gửi máy chủ"));
add(snippet("lib/features/requests/data/datasources/requests_remote_datasource.dart",
  { start: "Future<bool> createLeaveRequest\\(.*\\) async", back: 1 },
  "Đoạn mã 2.2 – DataSource: gửi đơn nghỉ phép tới máy chủ"));
add(snippet("lib/features/requests/data/repositories/requests_repository_impl.dart",
  { start: "Future<Either<Failure, bool>> createLeaveRequest\\(", back: 1 },
  "Đoạn mã 2.3 – Repository: lập lệnh tạo đơn từ tham số nghiệp vụ, chuẩn hoá lỗi thành Failure"));

// ---------------------------------------------------------------- 3 Overtime
add(H1n("3. CHỨC NĂNG TĂNG CA"));
add(H2("3.1. Mô tả nghiệp vụ"));
add(P("Nhân viên xem tổng giờ tăng ca trong tháng theo loại (ngày thường, cuối tuần, ngày lễ) so với giới hạn tháng, và đăng ký làm thêm giờ: chọn ngày, giờ bắt đầu – kết thúc, loại tăng ca và lý do. Danh mục loại tăng ca kèm hệ số **×1,5 / ×2,0 / ×3,0** được tải từ máy chủ; ứng dụng tự tính thời lượng, bắt buộc chọn loại hợp lệ và nhập lý do, chặn gửi trùng khi đang xử lý. Nếu máy chủ từ chối (ví dụ vượt giới hạn giờ), thông báo lỗi hiển thị ngay trên form để nhân viên sửa lại."));
add(H2("3.2. API sử dụng"));
add(apiTable([
  ["Danh mục loại tăng ca (hệ số)", "GET", "/api/OvertimeTypes/fetch?IsActive=1"],
  ["Danh mục dự phòng", "GET", "/api/OvertimeRequests/self?init=1"],
  ["Lịch sử tăng ca theo tháng", "GET", "/api/OvertimeRequests/self?month=yyyy-MM-01"],
  ["Tạo đơn tăng ca", "POST", "/api/OvertimeRequests"],
  ["Quản lý duyệt / từ chối", "GET", "/overtime/accept|Deny/{id}"],
]));
add(H2("3.3. Mã nguồn đại diện – Tạo đơn tăng ca"));
add(snippet("lib/features/requests/data/models/overtime_request_models.dart",
  { start: "/// DTO mapping to OvertimeRequestVM", endBlock: "Map<String, dynamic> toJson\\(\\)" },
  "Đoạn mã 3.1 – Model OvertimeRequestCreateModel: dữ liệu đơn tăng ca và chuyển đổi sang JSON"));
add(snippet("lib/features/requests/data/datasources/requests_remote_datasource.dart",
  { start: "Future<bool> createOvertimeRequest\\(.*\\) async", back: 1 },
  "Đoạn mã 3.2 – DataSource: gửi đơn tăng ca, chuyển thông báo lỗi của máy chủ thành ServerException"));
add(snippet("lib/features/requests/data/repositories/requests_repository_impl.dart",
  { start: "Future<Either<Failure, bool>> createOvertimeRequest\\(", back: 1 },
  "Đoạn mã 3.3 – Repository: lập lệnh tạo đơn tăng ca, chuẩn hoá lỗi thành Failure"));

// ---------------------------------------------------------------- 4 Payslip
add(H1n("4. CHỨC NĂNG PHIẾU LƯƠNG"));
add(H2("4.1. Mô tả nghiệp vụ"));
add(P("Nhân viên xem lương thực nhận (NET) của kỳ lương, chi tiết thu nhập (lương cơ bản thực tế, phụ cấp, ăn trưa, điện thoại, lương tăng ca, thưởng KPI), các khoản khấu trừ (bảo hiểm, thuế TNCN, quỹ) và lịch sử kỳ lương. Số lương mặc định được che, bấm biểu tượng mắt để hiện; phiếu lương chi tiết chỉ mở sau xác thực sinh trắc học (Face ID / vân tay) hoặc mã PIN 6 số. Lộ trình phiên bản tiếp theo bổ sung ký xác nhận phiếu lương bằng chữ ký tay và khiếu nại sai lệch từng dòng lương."));
add(H2("4.2. API sử dụng"));
add(apiTable([
  ["Chi tiết phiếu lương theo kỳ", "GET", "/api/EmployeeSalaryPayrolls/detail/{id}"],
  ["Tổng hợp lương theo phòng ban của đợt chốt lương", "GET", "/api/EmployeeSalaryPayrolls/summary/{id}"],
]));
add(H2("4.3. Mã nguồn đại diện – Lấy chi tiết phiếu lương"));
add(snippet("lib/features/payroll/data/models/payslip_detail_model.dart",
  { start: "/// DTO for Payslip Detail", endBlock: "factory fromJson\\(" },
  "Đoạn mã 4.1 – Model PayslipDetailModel: đọc phiếu lương từ phản hồi máy chủ (data.item)"));
add(snippet("lib/features/payroll/data/datasources/payroll_remote_datasource.dart",
  { start: "Future<PayslipDetailModel> getPayslipDetail\\(int id\\) async", back: 1 },
  "Đoạn mã 4.2 – DataSource: lấy chi tiết phiếu lương"));
add(snippet("lib/features/payroll/data/repositories/payroll_repository_impl.dart",
  { start: "Future<Either<Failure, PayslipEntity>> getPayslipDetail\\(int id\\) async", back: 1 },
  "Đoạn mã 4.3 – Repository: chuyển Model thành Entity phiếu lương cho tầng nghiệp vụ"));

const doc = makeDoc({ title: "Tài liệu kỹ thuật – HRM VSTECH (Mobile)", headerText: "HRM VSTECH – Tài liệu kỹ thuật – Ứng dụng di động", children, titlePage: false });
Packer.toBuffer(doc).then((buf) => {
  const out = path.join(OUT, "03_Tai_lieu_ky_thuat.docx");
  fs.writeFileSync(out, buf);
  console.log("written", out, buf.length);
});
