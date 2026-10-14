// Build No.4 – "Mô tả chức năng và kiến trúc" (.docx)
const fs = require("fs");
const path = require("path");
const { Packer } = require("docx");
const h = require("./docx_helpers");
const { FEATURES, SEQ, SCREENS, CODE, NEXT } = require("./no4_data");
const MANIFEST = JSON.parse(fs.readFileSync(path.join(__dirname, "../diagrams/manifest.json"), "utf8"));
const { P, H1, H1n, H2, H3, B, N, SP, table, kv, figure, placeholder, toc, coverPage, makeDoc } = h;

const REPO = path.resolve(__dirname, "../../..");
const OUT = path.resolve(__dirname, "..");
const DIA = path.join(OUT, "diagrams/png");
const SHOT = path.join(OUT, "screenshots");
const MAIN_SPEC = path.join(REPO, "docs/api/main/api-1 (1).json");
const d = (n) => path.join(DIA, n + ".png");
const fmt = (x) => x.toLocaleString("de-DE"); // 45.100 style thousands separator

// ---- Source statistics (hand-written Dart only) --------------------------
function dartFiles(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...dartFiles(p));
    else if (e.name.endsWith(".dart") && !/\.(g|freezed)\.dart$/.test(e.name)) out.push(p);
  }
  return out;
}
const lineCount = (f) => fs.readFileSync(f, "utf8").split("\n").length - 1;
const MODULE_DESC = {
  core: "Mạng, DI, điều hướng, phiên, hệ thiết kế, dịch vụ dùng chung", attendance: "Chấm công khuôn mặt, đăng ký khuôn mặt, tab Chấm công",
  requests: "Nghỉ phép, tăng ca, giải trình, công tác, trung tâm yêu cầu", profile: "Hồ sơ, người phụ thuộc, tài liệu",
  payroll: "Lương, phiếu lương, ký, khiếu nại", compliance: "Rủi ro tuân thủ, uỷ quyền (mô-đun mở rộng, chưa kích hoạt trên giao diện)", executive: "Bảng điều hành, phê duyệt cuối (mô-đun mở rộng, chưa kích hoạt trên giao diện)",
  onboarding: "Tiếp nhận nhân sự số hoá (mô-đun mở rộng, chưa kích hoạt trên giao diện)", auth: "Đăng nhập, khởi động", schedule: "Lịch ca, bảng công, đổi ca",
  recruitment: "Tuyển dụng nội bộ, giới thiệu (lộ trình phiên bản tiếp theo)", home: "Trang chủ", approvals: "Phê duyệt", qr_auth: "Đăng nhập Web bằng QR (lộ trình phiên bản tiếp theo)",
  announcements: "Bảng tin nội bộ (mô-đun mở rộng, chưa kích hoạt trên giao diện)", labor_profile: "Hồ sơ lao động, hợp đồng, BHXH (lộ trình phiên bản tiếp theo)", rewards: "Thưởng, hoa hồng, chỉ tiêu (lộ trình phiên bản tiếp theo)",
  notifications: "Thông báo", settings: "Cài đặt", holidays: "Ngày lễ", calendar: "Lịch công tháng 5 mã màu", services: "Tất cả dịch vụ",
};
const modules = [["core", path.join(REPO, "lib/core")],
  ...fs.readdirSync(path.join(REPO, "lib/features")).map((m) => [m, path.join(REPO, "lib/features", m)])];
const stats = modules.map(([m, dir]) => { const fs_ = dartFiles(dir); return { m, files: fs_.length, lines: fs_.reduce((a, f) => a + lineCount(f), 0) }; })
  .sort((a, b) => (a.m === "core" ? -1 : b.m === "core" ? 1 : b.lines - a.lines));
const totalFiles = stats.reduce((a, s) => a + s.files, 0);
const totalLines = stats.reduce((a, s) => a + s.lines, 0);
const screenCount = dartFiles(path.join(REPO, "lib/features")).filter((f) => f.includes("/presentation/screens/")).length;
const testCount = dartFiles(path.join(REPO, "test")).filter((f) => f.endsWith("_test.dart")).length;
const featureModules = stats.length - 1;
const totalLinesRounded = `≈ ${fmt(Math.round(totalLines / 100) * 100)}`;

function apiRows(file) {
  const spec = JSON.parse(fs.readFileSync(file, "utf8"));
  const rows = [];
  for (const [p, ops] of Object.entries(spec.paths)) {
    for (const [m, o] of Object.entries(ops)) {
      if (typeof o !== "object" || !o) continue;
      let s = (o.summary || o.operationId || "").split(/ \(| --|\. /)[0].replace(/\.$/, "");
      if (p.endsWith("refresh-token")) s = "Làm mới token truy cập";
      const params = (o.parameters || []).filter((x) => x.in === "query").map((x) => x.name);
      const body = o.requestBody ? Object.values(o.requestBody.content)[0].schema : null;
      const bodyName = body ? (body.$ref || body.type || "").replace("#/components/schemas/", "") : "";
      const resp = o.responses && o.responses["200"] && o.responses["200"].content
        ? (Object.values(o.responses["200"].content)[0].schema || {}) : {};
      const respName = (resp.$ref || (resp.items && resp.items.$ref && "List<" + resp.items.$ref + ">") || resp.type || "—")
        .replace(/#\/components\/schemas\//g, "");
      const io = [params.length ? "Query: " + params.slice(0, 6).join(", ") + (params.length > 6 ? ", …" : "") : "", bodyName ? "Body: " + bodyName : ""].filter(Boolean).join("; ") || "—";
      rows.push([m.toUpperCase(), p, s || "—", io, respName]);
    }
  }
  return rows;
}

const sections = [{ children: [], titlePage: true }];
const newSection = (landscape = false) => sections.push({ children: [], landscape });
const add = (...xs) => xs.flat().forEach((x) => sections[sections.length - 1].children.push(x));
const featureCount = Object.keys(CODE).length;
const allRows = FEATURES.flatMap((g) => g.rows);
const nextCount = allRows.filter((r) => r[5] === NEXT).length;
const liveCount = featureCount - nextCount;
const RELEASE = { live: "Phiên bản 0.1", next: "Lộ trình phiên bản tiếp theo" };

// ---------------------------------------------------------------- Cover
add(coverPage({
  docType: "TÀI LIỆU MÔ TẢ CHỨC NĂNG VÀ KIẾN TRÚC",
  title: "PHẦN MỀM QUẢN TRỊ NHÂN SỰ HRM VSTECH",
  subtitle: "Chương trình máy tính – Ứng dụng di động dành cho Nhân viên và Quản lý (Employee App)",
  meta: [
    ["Tên chương trình", "HRM VSTECH – Employee App"],
    ["Phiên bản", "0.1 (bản sơ khai)"],
    ["Chủ sở hữu quyền tác giả", "[Tên công ty / tổ chức]"],
    ["Tác giả", "[Họ tên các tác giả]"],
    ["Mã tài liệu", "02_Documentation / Mo_ta_chuc_nang_va_kien_truc"],
    ["Ngày hoàn thành", "[dd/mm/yyyy]"],
  ],
}));
add(h.BR(), toc());

// ---------------------------------------------------------------- 1
add(H1("1. GIỚI THIỆU CHUNG"));
add(H2("1.1. Mục đích tài liệu"));
add(P("Tài liệu mô tả đầy đủ chức năng, kiến trúc kỹ thuật, thiết kế dữ liệu, thiết kế giao tiếp lập trình (API) và các luồng xử lý (sơ đồ tuần tự) của chương trình máy tính **HRM VSTECH – Employee App**. Tài liệu được lập để kèm hồ sơ đăng ký quyền tác giả đối với chương trình máy tính tại Cục Bản quyền tác giả, đồng thời là tài liệu kỹ thuật tham chiếu cho nhóm phát triển."));
add(H2("1.2. Phạm vi"));
add(P("Tài liệu bao gồm 4 hạ tầng của hệ thống: Ứng dụng di động (Mobile App), Máy chủ nghiệp vụ (Backend API), Giao diện lập trình (API) và Cơ sở dữ liệu. Phần **Ứng dụng di động** được mô tả chi tiết dựa trên mã nguồn thực tế. Các phần Backend, Web quản trị và Cơ sở dữ liệu được trình bày ở mức khung; nội dung đánh dấu **[Backend bổ sung]**, **[API bổ sung]**, **[DB bổ sung]**, **[Web bổ sung]** do nhóm phụ trách tương ứng hoàn thiện."));
add(H2("1.3. Thuật ngữ và chữ viết tắt"));
add(table(["Thuật ngữ", "Giải thích"], [
  ["NV / ESS", "Nhân viên – Employee Self-Service (tự phục vụ)"],
  ["QL / MSS", "Quản lý trực tiếp – Manager Self-Service"],
  ["BGĐ", "Ban Giám đốc"],
  ["HR, C&B", "Bộ phận Nhân sự; chuyên viên Lương và Phúc lợi"],
  ["API", "Giao diện lập trình ứng dụng (Application Programming Interface)"],
  ["REST, JSON", "Kiểu kiến trúc dịch vụ web; định dạng dữ liệu trao đổi"],
  ["JWT", "JSON Web Token – mã xác thực phiên làm việc"],
  ["BLoC / Cubit", "Mẫu quản lý trạng thái giao diện (Business Logic Component)"],
  ["UseCase", "Lớp nghiệp vụ, mỗi lớp thực hiện đúng 1 hành động nghiệp vụ"],
  ["Geofence", "Hàng rào địa lý – bán kính hợp lệ quanh điểm chấm công"],
  ["BSSID", "Định danh điểm truy cập Wi-Fi dùng đối soát mạng nội bộ"],
  ["FCM", "Firebase Cloud Messaging – dịch vụ thông báo đẩy"],
], [0.25, 0.75]));
add(H2("1.4. Thông tin chương trình"));
add(kv([
  ["Tên chương trình", "HRM VSTECH – Employee App"],
  ["Loại tác phẩm", "Chương trình máy tính (ứng dụng di động)"],
  ["Nền tảng", "Android 8.0 (API 26) trở lên; iOS 14.0 trở lên; giao diện dọc"],
  ["Ngôn ngữ lập trình", "Dart 3 (Flutter SDK)"],
  ["Kiến trúc", "Clean Architecture theo tính năng (feature-first), BLoC/Cubit, GetIt"],
  ["Phạm vi chức năng", `${featureCount} chức năng: ${liveCount} chức năng thuộc phiên bản 0.1 và ${nextCount} chức năng thuộc lộ trình phiên bản tiếp theo (đã xây dựng giao diện trong mã nguồn)`],
  ["Quy mô mã nguồn", `${totalLinesRounded} dòng mã Dart tự viết trong ${fmt(totalFiles)} tệp, ${featureModules} phân hệ chức năng + lõi dùng chung, ${screenCount} màn hình, ${testCount} tệp kiểm thử tự động`],
  ["Ngôn ngữ giao diện", "Tiếng Việt, tiếng Anh"],
  ["Giao tiếp máy chủ", "HRM Backend API (REST/JSON/JWT); Face Authentication API (REST/multipart)"],
  ["Phiên bản đăng ký", "0.1 – bản sơ khai của chương trình; tài liệu sẽ được cập nhật khi phát hành các phiên bản tiếp theo"],
  ["Ngày hoàn thành phiên bản", "[dd/mm/yyyy]"],
]));

// ---------------------------------------------------------------- 2
add(H1("2. TỔNG QUAN SẢN PHẨM"));
add(H2("2.1. Bài toán và mục tiêu"));
add(P("HRM VSTECH là nền tảng quản trị nhân sự B2B, chuẩn hoá 4 trụ cột **Tuyển dụng – Công – Lương – Thưởng**. Ứng dụng di động là kênh tác nghiệp hằng ngày của người lao động và quản lý trực tiếp, đặc biệt phù hợp môi trường nhà máy quy mô lớn (≈ 3.000 lao động) nơi nhu cầu chấm công chính xác, xử lý đơn từ nhanh và minh bạch tiền lương rất cao."));
add(B("Chấm công chống gian lận bằng nhận diện khuôn mặt AI kết hợp vị trí GPS, mạng nội bộ và thiết bị đã đăng ký."));
add(B("Số hoá toàn bộ đơn từ (nghỉ phép, tăng ca, giải trình công, công tác) và quy trình duyệt nhiều cấp."));
add(B("Minh bạch tiền lương: phiếu lương điện tử có lớp bảo vệ sinh trắc học; lộ trình tiếp theo bổ sung ký xác nhận và khiếu nại ngay trên điện thoại."));
add(B("Một kênh thông tin chính thống: trung tâm thông báo phân nhóm theo nghiệp vụ."));
add(H2("2.2. Đối tượng sử dụng"));
add(table(["Vai trò", "Mô tả", "Phạm vi chức năng chính"], [
  ["Nhân viên (NV)", "Người lao động", "Chấm công, đơn từ, xem lương, hồ sơ, thông báo, tuyển dụng nội bộ"],
  ["Quản lý trực tiếp (QL)", "Trưởng nhóm, trưởng bộ phận", "Toàn bộ chức năng NV + dải chờ duyệt, hộp thư phê duyệt, xác nhận giờ công"],
  ["Ứng viên trúng tuyển", "Người chuẩn bị nhận việc", "Luồng tiếp nhận số hoá (Onboarding)"],
  ["Ban Giám đốc (BGĐ)", "Cấp điều hành", "Bảng điều hành, phê duyệt cuối, tuân thủ, uỷ quyền (lộ trình mở rộng)"],
  ["HR / Quản trị", "Bộ phận Nhân sự", "Vận hành qua Web quản trị [Web bổ sung]"],
], [0.22, 0.28, 0.50]));
add(H2("2.3. Điểm sáng tạo và đặc trưng kỹ thuật"));
add(N("**Xác thực chấm công 3 lớp**: khuôn mặt (Face API) + toạ độ GPS (geofence) + thông tin mạng Wi-Fi và dấu vân tay thiết bị gửi kèm mỗi lượt chấm; chỉ ghi nhận lượt chấm sau khi khuôn mặt khớp.", 1));
add(N("**Hộp thư phê duyệt hợp nhất**: một màn hình tải đồng thời phiếu giải trình công, đơn nghỉ phép, đơn tăng ca và tự gọi đúng nghiệp vụ duyệt / từ chối theo loại đơn.", 1));
add(N("**Bảo vệ dữ liệu lương**: số lương mặc định được che; phiếu lương chỉ mở sau xác thực sinh trắc học hoặc mã PIN, có cơ chế khoá tạm khi nhập sai nhiều lần.", 1));
add(N("**Điều hướng theo vai trò**: cùng một ứng dụng, thanh điều hướng và quyền truy cập tự thay đổi theo vai trò lấy từ quyền tài khoản.", 1));
add(N("**Hệ thiết kế \"Gạch bông Sài Gòn\"**: hoạ văn gạch bông được vẽ hoàn toàn bằng mã (CustomPainter) theo công thức hình học, bảng màu teal – hổ phách – kem, kiểu chữ Source Sans 3, hỗ trợ sáng / tối.", 1));
add(N("**Thiết kế đáp ứng thuần Flutter (AppLayout)**: tự điều chỉnh kích thước cho 3 nhóm màn hình (nhỏ < 360dp, thường 360–414dp, lớn > 414dp).", 1));
add(N("**Không mã hoá cứng chuỗi giao diện**: toàn bộ văn bản tách ra tệp ngôn ngữ, chuyển đổi Việt – Anh tức thời.", 1));

// ---------------------------------------------------------------- 3
add(H1("3. KIẾN TRÚC HỆ THỐNG"));
add(H2("3.1. Kiến trúc tổng thể"));
add(P("Hệ thống gồm 4 hạ tầng: (1) Ứng dụng di động cho Nhân viên và Quản lý; (2) Web quản trị cho bộ phận Nhân sự; (3) Lớp dịch vụ gồm HRM Backend API và dịch vụ nhận diện khuôn mặt Face Authentication API; (4) Lớp dữ liệu gồm cơ sở dữ liệu nghiệp vụ và kho vector khuôn mặt. Mọi giao tiếp đi qua HTTPS; các API nghiệp vụ yêu cầu JWT."));
add(figure(d("A01_system_architecture"), "Kiến trúc tổng thể hệ thống HRM VSTECH"));
add(H2("3.2. Kiến trúc ứng dụng di động"));
add(P("Ứng dụng tổ chức theo **Clean Architecture** và **feature-first**: mỗi phân hệ trong `lib/features/<tên>/` tự chứa 3 tầng; các thành phần dùng chung đặt ở `lib/core/`. Phụ thuộc chỉ đi một chiều `presentation → domain ← data`."));
add(figure(d("A02_mobile_clean_architecture"), "Kiến trúc Clean Architecture của ứng dụng di động"));
add(table(["Tầng", "Thành phần", "Trách nhiệm"], [
  ["Presentation", "Screens, Widgets, helpers, BLoC/Cubit", "Hiển thị giao diện, nhận thao tác, quản lý trạng thái màn hình; không chứa tính toán nghiệp vụ."],
  ["Domain", "Entities, UseCases, Repository (interface)", "Quy tắc nghiệp vụ thuần Dart, độc lập framework; mỗi UseCase = 1 hành động; trả về Either<Failure, T>."],
  ["Data", "RepositoryImpl, RemoteDataSource, Models", "Gọi API, chuyển JSON ↔ Model ↔ Entity; bắt ngoại lệ mạng và chuyển thành Failure."],
  ["Core", "Network, DI, Router, Session, Theme, Services", "Dio client và interceptor (JWT, log, dữ liệu mẫu), GetIt, GoRouter, AuthCubit, hệ thiết kế, xin quyền thiết bị."],
], [0.16, 0.32, 0.52]));
add(H2("3.3. Công nghệ sử dụng"));
add(table(["Hạng mục", "Công nghệ", "Vai trò"], [
  ["Framework", "Flutter, Dart 3", "Ứng dụng đa nền tảng Android / iOS"],
  ["Quản lý trạng thái", "flutter_bloc", "BLoC / Cubit theo phân hệ"],
  ["Tiêm phụ thuộc", "get_it", "Service locator (injector.dart)"],
  ["Điều hướng", "go_router", "ShellRoute 5 tab, redirect theo vai trò, deep link"],
  ["Mạng", "dio", "HTTP client, interceptor JWT / log / mock"],
  ["Xử lý lỗi", "fpdart", "Either<Failure, T> xuyên suốt các tầng"],
  ["So sánh giá trị", "equatable", "Entity / Event / State"],
  ["Lưu trữ an toàn", "flutter_secure_storage", "Token, phiên đăng nhập (Keychain / Keystore)"],
  ["Sinh trắc học", "local_auth", "Đăng nhập nhanh, khoá phiếu lương, xác nhận QR"],
  ["Camera", "camera", "Chụp ảnh khuôn mặt chấm công / đăng ký"],
  ["Định vị", "geolocator", "Toạ độ GPS đối soát geofence"],
  ["Thông tin mạng", "network_info_plus", "BSSID Wi-Fi"],
  ["An toàn thiết bị", "safe_device", "Phát hiện root / jailbreak, GPS giả"],
  ["Quyền thiết bị", "permission_handler", "Xin quyền đúng ngữ cảnh"],
  ["Đa ngôn ngữ", "intl, ARB", "Tiếng Việt / tiếng Anh, định dạng ngày, tiền tệ"],
  ["Cấu hình", "flutter_dotenv", "Môi trường dev / prod, chế độ dữ liệu mẫu"],
  ["Nhật ký", "logger", "Ghi log có cấu trúc, không ghi dữ liệu nhạy cảm"],
  ["Kiểm thử", "flutter_test, bloc_test, mocktail", "Kiểm thử đơn vị và giao diện"],
], [0.2, 0.3, 0.5]));
add(H2("3.4. Sơ đồ triển khai"));
add(figure(d("A03_deployment"), "Sơ đồ triển khai hệ thống"));
add(placeholder("[Backend bổ sung] Cấu hình máy chủ, hệ điều hành, môi trường chạy, cơ chế sao lưu và mở rộng."));
add(H2("3.5. Điều hướng và phân quyền"));
add(figure(d("A07_navigation"), "Sơ đồ điều hướng chính theo vai trò", { maxHcm: 12 }));
add(H2("3.6. Bảo mật"));
add(B("JWT lưu trong Keychain / Keystore qua FlutterSecureStorage, không lưu ở SharedPreferences; tự động đăng xuất khi máy chủ trả 401."));
add(B("Mọi request nghiệp vụ được AuthInterceptor gắn header `Authorization: Bearer <JWT>`; danh tính nhân viên khi tạo đơn được máy chủ xác định theo JWT."));
add(B("Đăng nhập gửi kèm thông tin thiết bị (mã thiết bị, model, hệ điều hành, cờ root) phục vụ ràng buộc thiết bị chính."));
add(B("Lượt chấm công gửi kèm toạ độ, thông tin mạng và dấu vân tay thiết bị; phát hiện root / jailbreak, GPS giả."));
add(B("Phiếu lương bảo vệ bằng sinh trắc học / mã PIN có giới hạn số lần thử."));
add(B("Ghi log chỉ bật ở môi trường phát triển và không ghi token, dữ liệu sinh trắc, nội dung phiếu lương."));
add(B("Xin quyền thiết bị đúng ngữ cảnh: camera trước khi quét mặt, vị trí trước lần chấm công, ảnh khi đính kèm minh chứng."));

// ---------------------------------------------------------------- 4
add(H1("4. THIẾT KẾ DỮ LIỆU"));
add(P("Sơ đồ thực thể – quan hệ dưới đây được lập từ đặc tả OpenAPI của HRM Backend API, giới hạn ở các thực thể phục vụ trực tiếp các nghiệp vụ của ứng dụng di động. Cấu trúc bảng vật lý, chỉ mục và ràng buộc chi tiết do nhóm Backend xác nhận."));
add(figure(d("A04_er_diagram"), "Sơ đồ thực thể – quan hệ các nghiệp vụ cốt lõi", { maxHcm: 12 }));
add(table(["Thực thể", "Ý nghĩa", "Quan hệ chính"], [
  ["Employee", "Hồ sơ nhân viên", "Thuộc Department, Position; có ca mặc định (Shift); 1–1 với User"],
  ["User", "Tài khoản đăng nhập", "Gắn thiết bị chính, trạng thái đăng ký khuôn mặt"],
  ["Department, Position, Shift", "Phòng ban / chi nhánh, chức danh, ca làm việc", "Danh mục tổ chức"],
  ["Enrollment", "Một lượt chấm công vào / ra", "Thuộc Employee, Shift, TimeSheet"],
  ["TimeSheet, MonthlyTimeSheet", "Công ngày, bảng công tháng", "Tổng hợp từ Enrollment, nguồn tính lương"],
  ["LeavePlan, LeaveEnrollment, LeaveRequest", "Loại phép, quỹ phép, đơn nghỉ", "Đơn nghỉ trừ vào quỹ phép theo loại"],
  ["OvertimeType, OvertimeRequest", "Loại tăng ca (hệ số), đơn tăng ca", "Đơn tham chiếu loại tăng ca"],
  ["TimesheetConfirmRequestType, TimesheetConfirmRequest", "Lý do giải trình, phiếu giải trình", "Duyệt nhiều cấp: quản lý → HR admin → HR manager"],
  ["EmployeeSalaryPayroll", "Bảng lương / phiếu lương tháng", "Tính từ MonthlyTimeSheet"],
  ["Contract", "Hợp đồng lao động", "Thuộc Employee"],
  ["Holiday, Notification", "Ngày lễ, thông báo", "Danh mục; thông báo gửi tới User"],
], [0.32, 0.30, 0.38]));
add(placeholder("[DB bổ sung] Hệ quản trị CSDL, sơ đồ vật lý, chỉ mục, chính sách sao lưu và lưu trữ dữ liệu sinh trắc học."));

// ---------------------------------------------------------------- 5
const mainRows = apiRows(MAIN_SPEC);
add(H1("5. THIẾT KẾ GIAO TIẾP LẬP TRÌNH (API)"));
add(H2("5.1. Quy ước chung"));
add(B("Giao thức HTTPS, định dạng JSON (riêng Face API dùng multipart/form-data cho ảnh)."));
add(B("Xác thực: `Authorization: Bearer <JWT>` cho mọi API nghiệp vụ; Face API định danh bằng cặp `Code` (mã nhân viên) và `AppCode`."));
add(B("Phản hồi lỗi nghiệp vụ dạng `ServiceResultResponse{message}` (400); lỗi xác thực `ProblemDetails` (401); lỗi dữ liệu đầu vào Face API `HTTPValidationError` (422)."));
add(B("Thời gian máy chủ theo UTC, ứng dụng chuyển sang giờ Việt Nam (UTC+7) khi hiển thị; danh sách theo tháng truyền tham số ngày đầu / cuối tháng."));
add(H2(`5.2. HRM Backend API (${mainRows.length} endpoint)`));
add(table(["Phương thức", "Đường dẫn", "Chức năng", "Tham số / Body", "Phản hồi 200"], mainRows, [0.1, 0.27, 0.27, 0.18, 0.18], { size: 18 }));
add(H2("5.3. Face Authentication API"));
add(table(["Phương thức", "Đường dẫn", "Chức năng", "Tham số / Body", "Phản hồi 200"], [
  ["GET", "/health/", "Kiểm tra tình trạng dịch vụ", "—", "—"],
  ["GET", "/checkreg/", "Kiểm tra nhân viên đã đăng ký khuôn mặt", "Query: Code, AppCode", "{status, registered, count, message}"],
  ["POST", "/register/", "Đăng ký khuôn mặt", "multipart: Code, AppCode, files[]", "{status, message}"],
  ["POST", "/update/", "Cập nhật khuôn mặt", "multipart: Code, AppCode, file", "{status, message}"],
  ["DELETE", "/delete/", "Xoá dữ liệu khuôn mặt", "Query: Code, AppCode", "{status, message}"],
  ["POST", "/verify/", "Xác thực khuôn mặt từ ảnh", "multipart: Code, AppCode, file", "{status, match, similarity, message}"],
  ["POST", "/verify-realtime/", "Xác thực thời gian thực", "Code, AppCode, image_base64", "{status, match, similarity}"],
  ["POST", "/live_verify/", "Xác thực kèm chống giả mạo (liveness)", "multipart: Code, AppCode, file", "{status, match, similarity}"],
], [0.1, 0.18, 0.3, 0.22, 0.2], { size: 18 }));
add(placeholder("[API bổ sung] Đặc tả chi tiết schema, mã lỗi, giới hạn tần suất và phiên bản API (OpenAPI_Spec.yaml đính kèm)."));

// ---------------------------------------------------------------- 6
add(H1("6. MÔ TẢ CHỨC NĂNG CHI TIẾT"));
add(P(`Ứng dụng gồm **${featureCount} chức năng** thuộc ${FEATURES.length} nhóm. Mỗi chức năng được gán mã CN-xx dùng để đối chiếu với sơ đồ tuần tự ở Mục 7. Cột **Phiên bản** cho biết thời điểm phát hành:`));
add(B(`**${RELEASE.live}** (${liveCount} chức năng): đã hoàn thiện giao diện và kết nối máy chủ trong phiên bản 0.1.`));
add(B(`**${RELEASE.next}** (${nextCount} chức năng): giao diện, điều hướng và mô hình dữ liệu đã được xây dựng trong mã nguồn của phiên bản này; chức năng được kích hoạt đầy đủ khi tích hợp với máy chủ ở phiên bản kế tiếp theo lộ trình sản phẩm.`));
FEATURES.forEach((g, i) => {
  add(H2(`6.${i + 1}. ${g.title}`));
  add(P(g.intro));
  add(table(["Mã", "Chức năng", "Vai trò", "Mô tả", "Màn hình / thành phần", "Phiên bản"],
    g.rows.map(([key, name, role, desc, screens, rel]) => [CODE[key], name, role, desc, screens, rel === NEXT ? RELEASE.next : RELEASE.live]),
    [0.08, 0.17, 0.08, 0.37, 0.17, 0.13], { size: 19 }));
});

// ---------------------------------------------------------------- 7
add(H1("7. SƠ ĐỒ TUẦN TỰ (SEQUENCE DIAGRAM)"));
add(P(`Mục này trình bày ${SEQ.length} luồng nghiệp vụ chính của phiên bản 0.1. Mỗi luồng gồm 2 tầng:`));
add(B("**Tầng Mobile App**: lập từ mã nguồn thực tế, thể hiện thao tác người dùng → màn hình → BLoC / Cubit / helper → UseCase → Repository → DataSource → máy chủ, kèm các nhánh thành công / thất bại. Luồng dài được chia thành nhiều phần liên tiếp."));
add(B("**Tầng Backend**: khung xử lý phía máy chủ (Controller → Service → Database) kèm hợp đồng giao tiếp của từng API (phương thức, đường dẫn, dữ liệu gửi, dữ liệu trả về). Phần ghi **[Backend bổ sung]** do nhóm Backend hoàn thiện."));
add(P("Quy ước màu: xanh ngọc – Presentation; vàng nhạt – Domain; tím nhạt – Data; xám – Thiết bị; hồng nhạt – Máy chủ. Mũi tên liền là lời gọi, mũi tên đứt là giá trị trả về; số thứ tự thể hiện trình tự thực hiện. Sơ đồ được đặt trên trang khổ ngang để bảo đảm kích thước chữ dễ đọc."));
SEQ.forEach((s, i) => {
  const m = MANIFEST[s.code];
  newSection(false);
  add(H2(`7.${i + 1}. ${s.code} – ${m.title}`));
  add(kv([["Chức năng liên quan", s.features], ["Tác nhân / thành phần", s.actors], ["Tiền điều kiện", s.pre], ["Ngoại lệ", s.exc]], 0.28));
  add(SP(80));
  add(P("**Luồng chính:**", { keepNext: true }));
  s.flow.forEach((f) => add(N(f, i + 2)));
  add(P(`Sơ đồ: ${m.mobile.length} phần tầng Mobile, ${m.backend.length} phần tầng Backend (trang sau).`, { run: { italics: true } }));
  newSection(true);
  m.mobile.forEach((d, j) => {
    add(H3(`7.${i + 1}.${j + 1}. ${d.subtitle}`));
    add(figure(path.join(DIA, d.file + ".png"), `${s.code} – ${d.subtitle}`, { maxWcm: 26.5, maxHcm: 15.6 }));
    add(h.BR());
  });
  m.backend.forEach((d, j) => {
    add(H3(`7.${i + 1}.${m.mobile.length + j + 1}. ${d.subtitle}`));
    add(figure(path.join(DIA, d.file + ".png"), `${s.code} – ${d.subtitle}`, { maxWcm: 26.5, maxHcm: 15.6 }));
    if (j < m.backend.length - 1) add(h.BR());
  });
});
newSection(false);

// ---------------------------------------------------------------- 8
add(H1n("8. SƠ ĐỒ TRẠNG THÁI"));
add(H2("8.1. Vòng đời đơn từ và quy trình duyệt 4 bước"));
add(figure(d("A05_approval_state"), "Vòng đời trạng thái đơn từ", { maxHcm: 12 }));
add(P("Trạng thái hiển thị cho người dùng: Chờ duyệt · Đã duyệt · Từ chối · Đã huỷ · Cần bổ sung. Đơn chỉ được thu hồi khi chưa được duyệt."));
add(H2("8.2. Trạng thái màn hình quét khuôn mặt"));
add(figure(d("A06_attendance_state"), "Trạng thái AttendanceProcessStatus của AttendanceBloc", { maxHcm: 13 }));

// ---------------------------------------------------------------- 9
add(H1("9. GIAO DIỆN ỨNG DỤNG"));
add(P("Ảnh chụp các màn hình chính của ứng dụng di động (thiết bị mô phỏng iPhone 17 Pro Max, kết nối máy chủ phát triển với tài khoản thử nghiệm). Ảnh chụp Web quản trị do nhóm Web bổ sung."));
const shots = SCREENS.filter(([f]) => fs.existsSync(path.join(SHOT, f + ".png")));
const missing = SCREENS.filter(([f]) => !fs.existsSync(path.join(SHOT, f + ".png"))).map(([f]) => f);
if (missing.length) console.warn("missing screenshots:", missing.join(", "));
for (let i = 0; i < shots.length; i += 2) {
  add(h.figurePair(shots.slice(i, i + 2).map(([f, cap]) => [path.join(SHOT, f + ".png"), cap])));
}
add(placeholder("[Web bổ sung] Ảnh chụp 3–5 màn hình chính của Web quản trị."));

// ---------------------------------------------------------------- 10
add(H1("10. PHỤ LỤC – CẤU TRÚC MÃ NGUỒN ỨNG DỤNG DI ĐỘNG"));
add(table(["Thư mục", "Số tệp", "Số dòng", "Nội dung"], [
  ...stats.map((s) => [s.m === "core" ? "lib/core" : `lib/features/${s.m}`, String(s.files), fmt(s.lines), MODULE_DESC[s.m] || "—"]),
  ["**Tổng cộng**", `**${fmt(totalFiles)}**`, `**${fmt(totalLines)}**`, "Không tính mã sinh tự động và tệp ngôn ngữ"],
], [0.32, 0.12, 0.14, 0.42], { size: 20 }));

const doc = makeDoc({ title: "Mô tả chức năng và kiến trúc – HRM VSTECH", headerText: "HRM VSTECH – Tài liệu mô tả chức năng và kiến trúc", sections });
Packer.toBuffer(doc).then((buf) => {
  const out = path.join(OUT, "04_Mo_ta_chuc_nang_va_kien_truc.docx");
  fs.writeFileSync(out, buf);
  console.log("written", out, buf.length, `| ${featureCount} features, ${mainRows.length} endpoints, ${totalLines} lines, ${screenCount} screens`);
});
