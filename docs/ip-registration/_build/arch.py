"""Architecture, deployment, ER and state diagrams."""

ARCH = {}

ARCH["A01_system_architecture"] = ("Kiến trúc tổng thể hệ thống HRM VSTECH", r'''
left to right direction
actor "Nhân viên (NV)" as NV
actor "Quản lý (QL)" as QL
actor "HR / Quản trị" as HR

package "Tầng người dùng" {
  rectangle "<b>Ứng dụng Mobile</b>\nFlutter · Android 8.0+ / iOS 14+\n(ESS / MSS)" as MOB
  rectangle "<b>Web Quản trị</b>\n(Admin Portal)\n<color:#B91C1C>[Web bổ sung]</color>" as WEB
}

package "Tầng dịch vụ" {
  rectangle "<b>HRM Backend API</b>\nREST · JSON · JWT\nAccount · Enrollments · LeaveRequests · LeavePlans\nOvertimeRequests · OvertimeTypes\nTimesheetConfirmRequests · ConfirmRequests\nEmployeeSalaryPayrolls · BaseNotifications\nHolidays · FCM" as API
  rectangle "<b>Face Authentication API</b>\nREST · multipart\ncheckreg · register · update\ndelete · verify · live_verify" as FACE
}

package "Tầng dữ liệu" {
  database "<b>CSDL HRM</b>\nNhân sự · Chấm công · Đơn từ\nLương · Thông báo\n<color:#B91C1C>[DB bổ sung]</color>" as DB
  database "<b>Kho vector khuôn mặt</b>" as FDB
}

cloud "Dịch vụ bên thứ ba" {
  rectangle "Firebase Cloud\nMessaging (FCM)" as FCM
  rectangle "Dịch vụ định vị\n(GPS / GNSS)" as GNSS
}

NV --> MOB
QL --> MOB
HR --> WEB
MOB --> API : HTTPS · Bearer JWT
MOB --> FACE : HTTPS · ảnh khuôn mặt
WEB --> API : HTTPS
API --> DB
FACE --> FDB
API --> FCM : gửi thông báo
FCM ..> MOB : push notification
GNSS ..> MOB : toạ độ chấm công
''')

ARCH["A02_mobile_clean_architecture"] = ("Kiến trúc Clean Architecture của ứng dụng Mobile", r'''
top to bottom direction
package "Presentation (lib/features/*/presentation)" as P {
  rectangle "Screens\n(≤ 300 dòng / file)" as SCR
  rectangle "Widgets dùng lại\n+ helpers" as WID
  rectangle "BLoC / Cubit\n(AttendanceBloc, AuthCubit…)" as BLOC
}
package "Domain (thuần Dart)" as D {
  rectangle "Entities" as ENT
  rectangle "UseCases\n(1 UseCase = 1 nghiệp vụ)" as UC
  rectangle "Repository\n(interface trừu tượng)" as RI
}
package "Data" as DA {
  rectangle "Repository Impl\n(Exception → Failure)" as RIMPL
  rectangle "Remote DataSources" as DS
  rectangle "Models / DTO\n(fromJson / toJson)" as MOD
}
package "Core" as CO {
  rectangle "DioClient · FaceDioClient\nAuthInterceptor · Logging\nMockDioInterceptor" as NET
  rectangle "GetIt (injector.dart)" as DI
  rectangle "GoRouter + authRedirectGuard\nAppShell (5 tab theo vai trò)" as ROUTER
  rectangle "AuthCubit · ThemeCubit · LocaleCubit" as SES
  rectangle "Theme Saigon Tile · AppLayout\nl10n (vi / en)" as THEME
  rectangle "AppPermissionHandler" as SRV
}
SCR --> BLOC
SCR --> UC : gọi qua GetIt\n(màn hình form / helper)
BLOC --> UC
UC --> RI
UC --> ENT
RIMPL ..|> RI : implements
RIMPL --> DS
DS --> MOD
DS --> NET
DI ..> RIMPL : đăng ký
DI ..> UC
note right of D
  Domain không phụ thuộc Flutter,
  Dio hay tầng Data.
  Kết quả trả về: Either<Failure, T> (fpdart)
end note
''')

ARCH["A03_deployment"] = ("Sơ đồ triển khai (Deployment)", r'''
node "Điện thoại nhân viên\n(Android 8.0+ / iOS 14+)" as PHONE {
  rectangle "App HRM VSTECH\n(Flutter)" as APP
  database "Keychain / Keystore\n(FlutterSecureStorage)\nJWT · phiên đăng nhập" as KS
  rectangle "Camera · GPS · Wi-Fi\nSinh trắc học (local_auth)" as HW
}
node "Máy trạm HR" as PC {
  rectangle "Trình duyệt\nWeb Quản trị" as BROWSER
}
node "Máy chủ ứng dụng\n<color:#B91C1C>[Backend bổ sung: OS, runtime, số node]</color>" as APPSRV {
  rectangle "Reverse proxy / TLS" as RP
  rectangle "HRM Backend API" as API
  rectangle "Web Quản trị (hosting)" as WEBH
}
node "Máy chủ nhận diện khuôn mặt" as FSRV {
  rectangle "Face Authentication API" as FACE
}
node "Máy chủ CSDL\n<color:#B91C1C>[DB bổ sung]</color>" as DBSRV {
  database "CSDL HRM" as DB
}
cloud "Firebase (FCM)" as FCM
cloud "App Store / Google Play\n(phân phối ứng dụng)" as STORE

APP --> RP : HTTPS 443
APP --> FACE : HTTPS 443
BROWSER --> RP : HTTPS 443
RP --> API
RP --> WEBH
API --> DB
API --> FCM
FCM ..> APP
STORE ..> APP : cài đặt / cập nhật
APP -- KS
APP -- HW
''')

ARCH["A04_er_diagram"] = ("Sơ đồ thực thể – quan hệ (ER) các nghiệp vụ cốt lõi", r'''
hide circle
hide methods
skinparam linetype ortho

entity "Employee\n(Nhân viên)" as Employee {
  * code : string <<PK>>
  --
  name, mail, phoneNumber
  birthday, gender, hireDate
  currentDepartmentCode <<FK>>
  currentPositionCode <<FK>>
  defaultShiftCode <<FK>>
  status, isQuit
}
entity "User\n(Tài khoản)" as User {
  * id : int <<PK>>
  --
  userName, email
  employeeCode <<FK>>
  mainDeviceId
  isFaceRegistered, allowFaceEnroll
  validTo, isActive
}
entity "Department\n(Phòng ban / Chi nhánh)" as Department {
  * code <<PK>>
  --
  name, managerCode <<FK>>
  parentCode, address
  latitude, longitude
}
entity "Position\n(Chức danh)" as Position {
  * code <<PK>>
  --
  name, isManager
}
entity "Shift\n(Ca làm việc)" as Shift {
  * code <<PK>>
  --
  name, startHour, endHour
  startBreak, endBreak
  allowLate, allowEarly
  latestCheckin, workDay
}
entity "Enrollment\n(Lượt chấm công)" as Enrollment {
  * id <<PK>>
  --
  employeeCode <<FK>>
  shiftCode <<FK>>
  timeSheetCode <<FK>>
  enrollDate, checkinTime, checkoutTime
  late, early, coordinate
  fingerprintIn, fingerprintOut
}
entity "TimeSheet\n(Công ngày)" as TimeSheet {
  * code <<PK>>
  --
  employeeCode <<FK>>
  workDate, workTime, actualWorkTime
  overtime, leaveTime, late, early
  symbol, isConfirmed
}
entity "MonthlyTimeSheet\n(Bảng công tháng)" as MTS {
  * code <<PK>>
  --
  employeeCode <<FK>>
  from, to, standardDate
  actualTime, totalWorkingDay
  normalOvertime, holidayOvertime
}
entity "LeavePlan\n(Loại phép)" as LeavePlan {
  * code <<PK>>
  --
  name, symbol, amount
  hasSalary, maxCarry
}
entity "LeaveEnrollment\n(Quỹ phép)" as LeaveEnrollment {
  * id <<PK>>
  --
  employeeCode <<FK>>
  leavePlanCode <<FK>>
  amount, total, expireDate
}
entity "LeaveRequest\n(Đơn nghỉ phép)" as LeaveRequest {
  * code <<PK>>
  --
  employeeCode <<FK>>
  leavePlanCode <<FK>>
  confirmByCode <<FK>>
  from, to, leaveAmountType
  halfShiftType, note, status
}
entity "OvertimeType\n(Loại tăng ca)" as OvertimeType {
  * code <<PK>>
  --
  name, scale
  dayOffScale, holidayScale
  maxMonth, maxYear
}
entity "OvertimeRequest\n(Đơn tăng ca)" as OvertimeRequest {
  * code <<PK>>
  --
  employeeCode <<FK>>
  overtimeTypeCode <<FK>>
  confirmByCode <<FK>>
  date, startOvertime, endOvertime
  length, status, note
}
entity "TimesheetConfirmRequest\n(Phiếu giải trình công)" as TCR {
  * id <<PK>>
  --
  employeeCode <<FK>>
  reasonTypeCode <<FK>>
  managerCode, hrAdminCode, hrManagerCode
  workDate, worktime, confirmedWorktime
  confirmLevel, isReject, imageUrl
}
entity "TimesheetConfirmRequestType\n(Lý do giải trình)" as TCRT {
  * code <<PK>>
  --
  name, mustHaveNote, mustHaveImage
}
entity "EmployeeSalaryPayroll\n(Phiếu lương)" as Payroll {
  * id <<PK>>
  --
  employeeCode <<FK>>
  month, baseSalary
  actualBaseSalary, actualAllowance
  actualOvertimeSalary, actualKpiSalary
  insurance1, insurance2, taxTNCN
  incomeTotal, payAmount
}
entity "Contract\n(Hợp đồng lao động)" as Contract {
  * code <<PK>>
  --
  employeeAcode <<FK>>
  contractTypeCode
  signDate, expireDate, salary
}
entity "Holiday\n(Ngày lễ)" as Holiday {
  * code <<PK>>
  --
  name, date, scale, yearly
}
entity "Notification\n(Thông báo)" as Notification {
  * id <<PK>>
  --
  userCode <<FK>>
  title, body, keyPage
  status, dateSent
}

Employee ||--o| User
Department ||--o{ Employee
Position ||--o{ Employee
Shift ||--o{ Employee
Employee ||--o{ Enrollment
Shift ||--o{ Enrollment
TimeSheet ||--o{ Enrollment
Employee ||--o{ TimeSheet
Employee ||--o{ MTS
Employee ||--o{ LeaveEnrollment
LeavePlan ||--o{ LeaveEnrollment
Employee ||--o{ LeaveRequest
LeavePlan ||--o{ LeaveRequest
Employee ||--o{ OvertimeRequest
OvertimeType ||--o{ OvertimeRequest
Employee ||--o{ TCR
TCRT ||--o{ TCR
Employee ||--o{ Payroll
MTS ||--o| Payroll
Employee ||--o{ Contract
User ||--o{ Notification
''')

ARCH["A05_approval_state"] = ("Vòng đời trạng thái đơn từ và quy trình duyệt 4 bước", r'''
[*] --> Nhap : Nhân viên tạo đơn
state "Nháp" as Nhap
state "Chờ duyệt" as Cho {
  state "Quản lý trực tiếp duyệt" as B1
  state "HR xác nhận" as B2
  state "Giám đốc phê duyệt" as B3
  [*] --> B1
  B1 --> B2 : Đồng ý
  B2 --> B3 : Xác nhận
}
state "Đã duyệt" as Duyet
state "Từ chối" as TuChoi
state "Đã huỷ" as Huy
state "Cần bổ sung" as BoSung
Nhap --> Cho : Gửi duyệt
Cho --> Duyet : Phê duyệt bước cuối
Cho --> TuChoi : Từ chối (lý do bắt buộc)
Cho --> Huy : Nhân viên thu hồi\n(chỉ khi chưa duyệt)
Cho --> BoSung : Yêu cầu bổ sung
BoSung --> Cho : Nhân viên cập nhật
Duyet --> [*]
TuChoi --> [*]
Huy --> [*]
''')

ARCH["A06_attendance_state"] = ("Trạng thái màn hình quét khuôn mặt (AttendanceProcessStatus)", r'''
[*] --> initial
initial --> loading : PrepareFaceScanEvent
loading --> faceNotRegistered : Face API: chưa đăng ký
loading --> readyToScan : Đã đăng ký + có vị trí
faceNotRegistered --> loading : Đăng ký xong (SD03)
readyToScan --> faceVerifying : SubmitFaceScanEvent
faceVerifying --> faceVerifyFailed : Không khớp
faceVerifyFailed --> faceVerifying : Chụp lại
faceVerifying --> submitting : Khớp khuôn mặt
submitting --> success : Enrollments 200
submitting --> failure : Lỗi máy chủ / nghiệp vụ
success --> readyToScan : ResetAttendanceStateEvent
failure --> readyToScan : ResetAttendanceStateEvent
success --> [*]
''')

ARCH["A07_navigation"] = ("Sơ đồ điều hướng chính theo vai trò", r'''
left to right direction
rectangle "Splash" as SP
rectangle "Đăng nhập" as LG
rectangle "Ứng viên mới\n(Onboarding)" as OB
package "AppShell – Nhân viên (NV)" {
  rectangle "Trang chủ" as H1
  rectangle "Chấm công" as A1
  rectangle "Yêu cầu" as R1
  rectangle "Bảng lương" as P1
  rectangle "Cá nhân" as C1
}
package "AppShell – Quản lý (QL)" {
  rectangle "Trang chủ\n+ dải Chờ duyệt" as H2
  rectangle "Chấm công" as A2
  rectangle "Phê duyệt\n(badge số đơn)" as R2
  rectangle "Bảng lương" as P2
  rectangle "Cá nhân" as C2
}
rectangle "Tất cả dịch vụ\n(4 nhóm)" as SV
SP --> LG : chưa đăng nhập
SP --> H1 : vai trò NV
SP --> H2 : vai trò QL
SP --> OB : vai trò ứng viên
LG --> H1
LG --> H2
H1 --> SV
H2 --> SV
''')
