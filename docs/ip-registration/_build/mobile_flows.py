"""Mobile-tier sequence diagrams — derived 1:1 from the Flutter source code.

Each flow = (title, header, parts). The header declares participants once;
each part is rendered as its own diagram (with `hide unlinked`) so diagrams
stay narrow and short enough to remain readable on a landscape A4 page.
Only features that are live in the app are drawn (features marked
"đang chờ duyệt" in the document have no sequence diagram).
"""
from style import BOX_UI, BOX_DOMAIN, BOX_DATA, BOX_DEVICE, BOX_SERVER

API = f'''
box "Máy chủ" {BOX_SERVER}
participant "HRM Backend API" as API
end box
'''

MOBILE = {}

# ---------------------------------------------------------------- SD01
MOBILE["SD01"] = ("Đăng nhập và khôi phục phiên làm việc", f'''
actor "Người dùng" as U
box "Presentation" {BOX_UI}
participant "Splash /\\nLoginScreen" as S
participant "AuthCubit" as C
participant "GoRouter\\n(authRedirectGuard)" as R
end box
box "Domain" {BOX_DOMAIN}
participant "CheckAuth /\\nLogin UseCase" as UC
end box
box "Data" {BOX_DATA}
participant "AuthRepository\\n→ RemoteDataSource\\n(Dio + JWT)" as REPO
participant "SecureStorage\\n(Keychain/Keystore)" as SEC
end box
{API}
''', [
("Khởi động – khôi phục phiên", '''
U -> S : Mở ứng dụng
S -> C : checkAuthStatus()
C -> SEC : Đọc token và phiên đã lưu
SEC --> C : token, userJson
alt Có token
  C -> UC : CheckAuthUseCase()
  UC -> REPO : checkAuth()
  REPO -> API : GET /api/Account/check-auth\\n(Bearer JWT)
  alt 200 – token còn hiệu lực
    API --> REPO : 200
    REPO --> UC : Right(true)
    UC --> C : true
    C -> C : emit(Authenticated(user, role))
  else 401 – hết hạn
    API --> REPO : 401
    REPO --> UC : Right(false)
    UC --> C : false
    C -> SEC : Xoá token, phiên
    C -> C : emit(Unauthenticated)
  end
else Chưa đăng nhập
  C -> C : emit(Unauthenticated)
end
C -> R : Thông báo đổi trạng thái
R --> S : Authenticated → /home\\nUnauthenticated → /login
'''),
("Đăng nhập bằng mã nhân viên và mật khẩu", '''
U -> S : Nhập mã NV, mật khẩu,\\nbấm "Đăng nhập hệ thống"
S -> S : Kiểm tra bắt buộc nhập
S -> SEC : Lưu "Ghi nhớ" (mã hoá)
S -> C : login(username, password)
C -> UC : LoginUseCase(LoginParams + thông tin thiết bị)
UC -> REPO : login(params)
REPO -> API : POST /api/Account\\n{username, password, device_id, model,\\nplatform, version_app, root…}
alt 200 OK
  API --> REPO : {token, validTo, user{employeeCode,\\nemployeeName, claims}}
  REPO --> UC : Right(AuthResultEntity)
  UC --> C : AuthResultEntity
  C -> C : Vai trò: claims có "manager.approve"\\n→ Quản lý, ngược lại → Nhân viên
  C -> SEC : Lưu token, phiên, hạn token
  C -> R : emit(Authenticated)
  R --> S : /home – 5 tab theo vai trò
else 400 / 401 / 500
  API --> REPO : {message}
  REPO --> UC : Left(Failure)
  UC --> C : Failure
  C --> S : Hiển thị thông báo lỗi
end
'''),
("Đăng nhập nhanh bằng sinh trắc học", '''
U -> S : Bấm nút Face ID / vân tay
S -> S : local_auth: kiểm tra thiết bị hỗ trợ
S -> SEC : Đọc tài khoản đã ghi nhớ
S -> S : local_auth.authenticate()
alt Xác thực thành công
  S -> C : login(tài khoản đã ghi nhớ)
  note right of C : Tiếp tục như Phần 2
else Huỷ / thất bại
  S --> U : Giữ màn Đăng nhập
end
'''),
])

# ---------------------------------------------------------------- SD02
MOBILE["SD02"] = ("Chấm công vào / ra ca bằng nhận diện khuôn mặt AI", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "Home / Attendance\\n→ FaceScanScreen" as S
participant "AttendanceBloc" as B
end box
box "Thiết bị" {BOX_DEVICE}
participant "GPS · Camera" as DEV
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "FaceAuth / Attendance\\nRepository → DataSource" as REPO
end box
box "Máy chủ" {BOX_SERVER}
participant "Face Auth API" as FAPI
participant "HRM Backend API" as API
end box
''', [
("Chuẩn bị phiên quét", '''
U -> S : Bấm "CHECK IN" / "CHECK OUT"
S -> B : PrepareFaceScanEvent(type, mãNV)
B -> DEV : Quyền vị trí + toạ độ GPS (≤ 4 giây)
DEV --> B : lat, lng (lỗi → toạ độ trụ sở)
B -> UC : CheckFaceRegistrationUseCase(mãNV)
UC -> REPO : checkRegistration()
REPO -> FAPI : GET /checkreg/?Code&AppCode
FAPI --> REPO : {registered, count}
REPO --> UC : FaceCheckRegEntity
UC --> B : isRegistered
alt Chưa đăng ký
  B --> S : faceNotRegistered
  S --> U : Hộp thoại "Đăng ký khuôn mặt"
  ref over S : SD03
else Đã đăng ký
  B --> S : readyToScan(lat, lng, vị trí)
  S -> DEV : Xin quyền camera,\\nmở camera trước
  DEV --> S : Preview trong khung oval
  S --> U : Khung căn mặt, đồng hồ,\\ntrạng thái vị trí
end
'''),
("Chụp ảnh và xác thực khuôn mặt", '''
U -> S : Bấm "Chụp ảnh & Check in/out"
S -> DEV : takePicture()
DEV --> S : ảnh JPEG
S -> B : SubmitFaceScanEvent(ảnh, type)
B -> UC : VerifyFaceUseCase(mãNV, ảnh)
UC -> REPO : verifyFace()
REPO -> FAPI : POST /verify/ (multipart:\\nCode, AppCode, file)
FAPI --> REPO : {status, match, similarity}
REPO --> UC : FaceVerifyResultEntity
UC --> B : kết quả so khớp
alt Không khớp
  B --> S : faceVerifyFailed
  S --> U : "Khuôn mặt không khớp" – chụp lại
else Khớp
  B -> B : emit(submitting)
  note right of B : Tiếp tục Phần 3
end
'''),
("Ghi nhận chấm công và biên lai", '''
B -> UC : CheckIn / CheckOut UseCase\\n(lat, lng, bssid, thời điểm)
UC -> REPO : checkIn() / checkOut()
REPO -> API : POST /api/Enrollments/Checkin|Checkout\\nEnrollForm{coordinate, local, fingerprint}
alt 200 OK
  API --> REPO : {message, checkin, checkout}
  REPO --> UC : AttendanceRecordEntity\\n(đúng giờ / muộn / về sớm)
  UC --> B : record
  B -> UC : GetTodayAttendanceUseCase()
  UC -> REPO : getTodayAttendance()
  REPO -> API : GET /api/Enrollments/info
  API --> REPO : ca, giờ vào/ra, serverTime
  REPO --> UC : AttendanceTodayEntity
  UC --> B : todayAttendance
  B --> S : success
  S --> U : Rung nhẹ + biên lai chấm công
else 400 – vi phạm quy tắc
  API --> REPO : {message}
  REPO --> UC : Left(Failure)
  UC --> B : Failure
  B --> S : failure
  S --> U : Thông báo lỗi, hướng liên hệ HR
end
'''),
])

# ---------------------------------------------------------------- SD03
MOBILE["SD03"] = ("Đăng ký / cập nhật dữ liệu khuôn mặt", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "Hồ sơ / FaceScan" as P
participant "FaceEnrollmentScreen" as S
end box
box "Thiết bị" {BOX_DEVICE}
participant "Camera" as CAM
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "FaceAuthRepository\\n→ DataSource" as REPO
end box
box "Máy chủ" {BOX_SERVER}
participant "Face Auth API" as FAPI
end box
''', [
("Kiểm tra trạng thái và chụp ảnh", '''
U -> P : Hồ sơ → "Xác thực khuôn mặt"\\n(hoặc từ hộp thoại chưa đăng ký)
P -> S : Mở /profile/face-enrollment
S -> UC : CheckFaceRegistrationUseCase()
UC -> REPO : checkRegistration()
REPO -> FAPI : GET /checkreg/
FAPI --> REPO : {registered, count}
REPO --> UC : FaceCheckRegEntity
UC --> S : trạng thái đăng ký
S --> U : Hướng dẫn chụp (đủ sáng, nhìn thẳng)
U -> S : Bấm chụp
S -> CAM : takePicture()
CAM --> S : ảnh
'''),
("Gửi dữ liệu khuôn mặt và kết quả", '''
alt Đã có dữ liệu
  S -> UC : UpdateFaceUseCase(ảnh)
  UC -> REPO : updateFace()
  REPO -> FAPI : POST /update/ (Code, AppCode, file)
else Lần đầu
  S -> UC : RegisterFaceUseCase(ảnh)
  UC -> REPO : registerFace()
  REPO -> FAPI : POST /register/ (Code, AppCode, files[])
end
FAPI --> REPO : {status, message}
alt status = true
  REPO --> UC : Right(true)
  UC --> S : thành công
  S --> P : Đóng màn, sẵn sàng chấm công
else Lỗi / 422
  REPO --> UC : Left(Failure)
  UC --> S : Failure
  S --> U : Báo lỗi, cho chụp lại
end
'''),
])

# ---------------------------------------------------------------- SD04
MOBILE["SD04"] = ("Tab Chấm công, Lịch & Ca làm việc và Ngày lễ", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "AttendanceScreen" as S
participant "ShiftScheduleScreen\\n(Lịch ca · Lịch công)" as CAL
participant "HolidaysScreen" as HS
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "Attendance / Requests /\\nHolidays Repository\\n→ DataSource" as REPO
end box
{API}
''', [
("Tab Chấm công – hôm nay và nhật ký tháng", '''
U -> S : Mở tab "Chấm công"
S -> UC : GetTodayAttendanceUseCase()
UC -> REPO : getTodayAttendance()
REPO -> API : GET /api/Enrollments/info
API --> REPO : ca, giờ vào/ra, serverTime
REPO --> UC : AttendanceTodayEntity
UC --> S : trạng thái hôm nay
S -> UC : GetAttendanceHistoryUseCase(from, to)
UC -> REPO : getAttendanceHistory()
REPO -> API : GET /api/Enrollments/info?from&to
API --> REPO : enrolls[{date, checkin, checkout, late, early}]
REPO -> REPO : Đổi giờ UTC → UTC+7,\\nphân loại đúng giờ / đi muộn
REPO --> UC : List<AttendanceRecordEntity>
UC --> S : nhật ký ngày
S -> UC : GetOvertimeRequestsUseCase()
UC -> REPO : getOvertimeRequests(tháng)
REPO -> API : GET /api/OvertimeRequests/self?month
API --> REPO : đơn tăng ca trong tháng
REPO --> UC : List<OvertimeItemEntity>
UC --> S : tổng giờ tăng ca
S --> U : Giờ đã làm (đếm theo giây), nút CHECK IN/OUT,\\nô giờ vào/ra/đi muộn/tăng ca,\\ntổng hợp tháng, nhật ký từng ngày
'''),
("Lịch & Ca làm việc và Ngày lễ", '''
U -> CAL : Bấm "Lịch & Ca làm việc"
CAL -> UC : GetTodayAttendanceUseCase()
UC -> REPO : getTodayAttendance()
REPO -> API : GET /api/Enrollments/info
API --> REPO : thông tin ca hôm nay
REPO --> UC : AttendanceTodayEntity
UC --> CAL : ca hiện tại
CAL --> U : Tab "Lịch ca": tuần 7 ngày, chi tiết ca\\n(giờ, nghỉ giữa ca, địa điểm, quản lý ca)
U -> CAL : Chọn tab "Lịch công"
CAL --> U : Lịch tháng 5 mã màu + tổng hợp tháng\\n(ngày công, giờ làm, tăng ca, phép, muộn/sớm)
U -> S : Nhật ký từng ngày → "Ngày lễ"
S -> HS : Mở /holidays
HS -> UC : GetHolidaysUseCase()
UC -> REPO : getHolidays()
REPO -> API : GET /api/Holidays
API --> REPO : items[{name, date, scale}]
REPO --> UC : List<HolidayEntity>
UC --> HS : danh sách ngày lễ
HS --> U : Ngày lễ và nghỉ bù trong năm
'''),
])

# ---------------------------------------------------------------- SD05
MOBILE["SD05"] = ("Đơn xin nghỉ phép", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "LeaveManageScreen" as S
participant "LeaveRequestModal" as M
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "RequestsRepository\\n→ RemoteDataSource" as REPO
end box
{API}
''', [
("Tải loại phép và danh sách đơn theo tháng", '''
U -> S : Trang chủ / Tất cả dịch vụ → "Nghỉ phép"
S -> UC : GetLeavePlansUseCase()
UC -> REPO : getLeavePlans()
REPO -> API : GET /api/LeaveRequests/self?init=1&version=1
API --> REPO : leavePlans[{code, name, amount}]
REPO --> UC : List<LeavePlanEntity>
UC --> S : loại phép
U -> S : Chọn tháng (MonthPicker)
S -> UC : GetLeaveRequestsUseCase(from, to)
UC -> REPO : getLeaveRequests(from, to)
REPO -> REPO : Mặc định: ngày đầu → ngày cuối tháng
REPO -> API : GET /api/LeaveRequests/self?From&To
API --> REPO : results[] (đơn nghỉ trong tháng)
REPO --> UC : List<LeaveItemEntity>
UC --> S : danh sách đơn
S --> U : Danh sách + lọc Chờ duyệt / Đã duyệt / Từ chối
'''),
("Tạo đơn nghỉ phép", '''
U -> S : Bấm "Tạo đơn nghỉ phép"
S -> M : Mở form (loại phép, ngày mặc định)
U -> M : Cả ngày / nửa ca sáng / nửa ca chiều,\\nloại phép, từ ngày – đến ngày, lý do
M -> M : Tự tính số ngày; kiểm tra ngày, lý do
M --> S : onConfirm(...)
S -> S : CreateLeaveParams{from, to, validFrom, validTo,\\nleavePlanCode, leaveAmountType, halfShiftType,\\nnote, isMultiple = from ≠ to}
S -> UC : CreateLeaveRequestUseCase(params)
UC -> REPO : createLeaveRequest()
REPO -> REPO : Map → LeaveRequestCreateCommand
REPO -> API : POST /api/LeaveRequests/self\\n{from, to, halfShiftType, isMultiple, leaveAmountType,\\nleavePlanCode, note, validFrom, validTo}
alt 200 OK
  API --> REPO : {message, data}
  REPO --> UC : Right(true)
  UC --> S : thành công
  S --> U : "Đã gửi đơn … – chờ Quản lý duyệt"
else 400 – vượt quỹ phép / trùng lịch
  API --> REPO : {message}
  REPO --> UC : Left(ServerFailure)
  UC --> S : Failure
  S --> U : Thông báo lỗi của máy chủ
end
'''),
])

# ---------------------------------------------------------------- SD06
MOBILE["SD06"] = ("Trung tâm yêu cầu – theo dõi đơn theo tháng", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "RequestsScreen" as S
participant "RequestDetailScreen" as D
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "RequestsRepository\\n→ RemoteDataSource" as REPO
end box
{API}
''', [
("Tải và xem đơn theo tháng", '''
U -> S : Mở tab "Yêu cầu", chọn tháng
S -> UC : GetLeaveRequestsUseCase(from, to)
UC -> REPO : getLeaveRequests()
REPO -> API : GET /api/LeaveRequests/self?From&To
API --> REPO : đơn nghỉ phép
S -> UC : GetOvertimeRequestsUseCase(month)
UC -> REPO : getOvertimeRequests()
REPO -> API : GET /api/OvertimeRequests/self?month
API --> REPO : đơn tăng ca
REPO --> UC : các danh sách
UC --> S : entities
S -> S : Gộp, sắp xếp theo thời gian gửi
S --> U : Danh mục Nghỉ phép / Tăng ca,\\ndanh sách đơn, lọc theo trạng thái
U -> S : Chọn 1 đơn
S -> D : Mở /requests/detail
D --> U : Loại đơn, mã đơn, trạng thái,\\ntiến trình phê duyệt 4 cấp
'''),
])

# ---------------------------------------------------------------- SD07
MOBILE["SD07"] = ("Đăng ký làm thêm giờ (Tăng ca)", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "OvertimeManageScreen" as S
participant "OvertimeRequestModal" as M
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "RequestsRepository\\n→ RemoteDataSource" as REPO
end box
{API}
''', [
("Tải loại tăng ca và lịch sử trong tháng", '''
U -> S : Trang chủ / Tất cả dịch vụ → "Tăng ca"
S -> UC : GetOvertimeTypesUseCase()
UC -> REPO : getOvertimeTypes()
REPO -> API : GET /api/OvertimeTypes/fetch?IsActive=1
alt Có danh mục
  API --> REPO : items[{code, name, scale}]
else Rỗng / lỗi
  REPO -> API : GET /api/OvertimeRequests/self?init=1
  API --> REPO : overtimeTypes[]
end
REPO -> REPO : Bỏ mục giữ chỗ ("default")
REPO --> UC : List<OvertimeTypeEntity>
UC --> S : loại tăng ca + hệ số
S -> UC : GetOvertimeRequestsUseCase(month)
UC -> REPO : getOvertimeRequests()
REPO -> API : GET /api/OvertimeRequests/self?month=yyyy-MM-01
API --> REPO : đơn tăng ca trong tháng
REPO --> UC : List<OvertimeItemEntity>
UC --> S : lịch sử
S --> U : Tổng giờ tăng ca / giới hạn 40h tháng,\\ndanh sách lọc theo trạng thái
'''),
("Tạo đơn tăng ca", '''
U -> S : Bấm "Đăng ký tăng ca"
S -> M : Mở form (danh mục loại tăng ca)
U -> M : Ngày, giờ bắt đầu – kết thúc,\\nloại tăng ca, lý do
M -> M : Tự tính thời lượng; bắt buộc loại hợp lệ, lý do
M -> S : onConfirm(...)
S -> S : Chặn gửi trùng; ngày yyyy-MM-dd,\\ngiờ yyyy-MM-ddTHH:mm:00
S -> UC : CreateOvertimeRequestUseCase(params)
UC -> REPO : createOvertimeRequest()
REPO -> REPO : Map → OvertimeRequestCreateModel
REPO -> API : POST /api/OvertimeRequests\\n{date, length, note, startOvertime,\\nendOvertime, overtimeTypeCode}
alt 200 OK
  API --> REPO : {message}
  REPO --> UC : Right(true)
  UC --> S : thành công
  S --> M : Đóng form
  S --> U : "Đã gửi đăng ký tăng ca"
else 400
  API --> REPO : {message}
  REPO --> UC : Left(ServerFailure(message))
  UC --> S : Failure
  S --> M : message
  M --> U : Giữ form, hiện banner lỗi của máy chủ
end
'''),
])

# ---------------------------------------------------------------- SD08
MOBILE["SD08"] = ("Giải trình / điều chỉnh công (vai trò Quản lý)", f'''
actor "Quản lý" as U
box "Presentation" {BOX_UI}
participant "CorrectionManageScreen" as L
participant "AttendanceCorrection\\nScreen + Modal" as S
end box
box "Thiết bị" {BOX_DEVICE}
participant "Ảnh · GPS" as DEV
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "RequestsRepository\\n→ RemoteDataSource" as REPO
end box
{API}
''', [
("Danh sách phiếu và danh mục lý do", '''
U -> L : Tất cả dịch vụ → "Giải trình công"
L -> UC : GetCorrectionRequestsUseCase()
UC -> REPO : getCorrectionRequests()
REPO -> API : GET /api/TimesheetConfirmRequests?month&personal
API --> REPO : phiếu giải trình
REPO --> UC : List<CorrectionItemEntity>
UC --> L : danh sách
U -> L : Bấm tạo phiếu
L -> S : Mở /requests/correction-create
S -> UC : GetCorrectionReasonsUseCase()
UC -> REPO : getCorrectionReasons()
REPO -> API : GET /api/TimesheetConfirmRequests/reasons
API --> REPO : [{code, name, mustHaveNote, mustHaveImage}]
REPO --> UC : List<CorrectionReasonEntity>
UC --> S : lý do
'''),
("Lập và gửi phiếu giải trình", '''
U -> S : Ngày → vấn đề + giờ thực tế → giải trình
opt Lý do yêu cầu ảnh
  S -> DEV : Chụp / chọn ảnh, lấy vị trí
  DEV --> S : ảnh, toạ độ, địa chỉ
end
S -> S : Kiểm tra ghi chú / ảnh bắt buộc theo lý do
S -> UC : CreateCorrectionRequestUseCase(params)
UC -> REPO : createCorrectionRequest()
REPO -> API : POST /api/TimesheetConfirmRequests\\n{workDate, worktime, reasonTypeCode,\\nnote, imageUrl, latitude, longitude, address}
alt 200 OK
  API --> REPO : {message}
  REPO --> UC : Right(true)
  UC --> S : thành công
  S --> U : "Đã gửi phiếu giải trình"
else 400
  API --> REPO : {message}
  REPO --> UC : Left(Failure)
  UC --> S : Failure
  S --> U : Thông báo lỗi
end
'''),
])

# ---------------------------------------------------------------- SD09
MOBILE["SD09"] = ("Phê duyệt đơn: giải trình công, nghỉ phép, tăng ca", f'''
actor "Quản lý" as U
box "Presentation" {BOX_UI}
participant "Home / GoRouter" as R
participant "ApprovalsScreen\\n+ dialog" as S
participant "ApprovalsAction\\nHandler" as H
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "Approvals / Requests\\nRepository → DataSource" as REPO
end box
{API}
''', [
("Tải hộp thư phê duyệt", '''
U -> R : Dải "Chờ duyệt" / tab "Phê duyệt"
R -> R : authRedirectGuard: chỉ vai trò Quản lý
R -> S : Mở /approvals
S -> H : loadAllPendingApprovals()
par Future.wait – 3 nguồn
  H -> UC : GetPendingApprovalsUseCase()
  UC -> REPO : getPendingTimesheetApprovals()
  REPO -> API : GET /api/TimesheetConfirmRequests?personal=false
  API --> REPO : phiếu giải trình
else
  H -> UC : GetLeaveRequestsUseCase()
  UC -> REPO : getLeaveRequests()
  REPO -> API : GET /api/LeaveRequests/self?From&To
  API --> REPO : đơn nghỉ phép
else
  H -> UC : GetOvertimeRequestsUseCase()
  UC -> REPO : getOvertimeRequests()
  REPO -> API : GET /api/OvertimeRequests/self?month
  API --> REPO : đơn tăng ca
end
REPO --> UC : entities
UC --> H : 3 danh sách
H -> H : Lọc đơn chờ (status = 0),\\nchuẩn hoá ApprovalItem: GC · NP · TC
H --> S : List<ApprovalItem>
S --> U : Thẻ đơn + lọc: Tất cả · Giải trình · Tăng ca · Nghỉ phép
'''),
("Duyệt đơn", '''
U -> S : Bấm "Duyệt"
opt Phiếu giải trình công
  S --> U : Hộp thoại xác nhận giờ công
  U -> S : Số giờ xác nhận + ghi chú
end
S -> H : approve(item, hours, note)
alt Giải trình công
  H -> UC : ApproveTimesheetCorrectionUseCase
  UC -> REPO : approveTimesheetCorrection()
  REPO -> API : POST /api/TimesheetConfirmRequests/confirm/{id}\\n{confirmedWorktime, confirmNote}
else Nghỉ phép
  H -> UC : ApproveLeaveUseCase
  UC -> REPO : approveLeave()
  REPO -> API : GET /api/ConfirmRequests/leave/accept/{id}
else Tăng ca
  H -> UC : ApproveOvertimeUseCase
  UC -> REPO : approveOvertime()
  REPO -> API : GET /overtime/accept/{id}
end
API --> REPO : {message}
REPO --> UC : Right / Left
UC --> H : kết quả
H --> S : thông báo của máy chủ / Failure
S --> U : Gỡ thẻ đơn + SnackBar (hoặc báo lỗi)
'''),
("Từ chối đơn (bắt buộc lý do)", '''
U -> S : Bấm "Từ chối"
S --> U : Modal nhập lý do
U -> S : Lý do từ chối
S -> H : reject(item, reason)
alt Giải trình công
  H -> UC : RejectTimesheetCorrectionUseCase
  UC -> REPO : rejectTimesheetCorrection()
  REPO -> API : POST /api/TimesheetConfirmRequests/reject/{id}?note
else Nghỉ phép
  H -> UC : RejectLeaveUseCase
  UC -> REPO : rejectLeave()
  REPO -> API : GET /api/ConfirmRequests/leave/deny/{id}
else Tăng ca
  H -> UC : RejectOvertimeUseCase
  UC -> REPO : rejectOvertime()
  REPO -> API : GET /overtime/Deny/{id}
end
API --> REPO : {message}
REPO --> UC : Right / Left
UC --> H : kết quả
H --> S : thông báo / Failure
S --> U : Gỡ thẻ đơn + SnackBar (hoặc báo lỗi)
'''),
])

# ---------------------------------------------------------------- SD10
MOBILE["SD10"] = ("Bảng lương và phiếu lương có bảo vệ sinh trắc học", f'''
actor "Nhân viên" as U
box "Presentation" {BOX_UI}
participant "PayrollScreen" as P
participant "PayslipLockScreen" as L
participant "PayslipDetailScreen" as D
end box
box "Thiết bị" {BOX_DEVICE}
participant "local_auth" as BIO
end box
box "Domain" {BOX_DOMAIN}
participant "GetPayslipDetail\\nUseCase" as UC
end box
box "Data" {BOX_DATA}
participant "PayrollRepository\\n→ DataSource" as REPO
end box
{API}
''', [
("Tab Bảng lương và cổng bảo vệ", '''
U -> P : Mở tab "Bảng lương"
P -> UC : GetPayslipDetailUseCase(id)
UC -> REPO : getPayslipDetail(id)
REPO -> API : GET /api/EmployeeSalaryPayrolls/detail/{id}
API --> REPO : {data{item: EmployeeSalaryPayroll}}
REPO --> UC : PayslipEntity
UC --> P : thực nhận, thu nhập, khấu trừ
P --> U : Lương NET (bấm mắt để ẩn/hiện),\\nchi tiết thu nhập & khấu trừ, lịch sử kỳ lương
U -> P : Bấm "Xem phiếu lương"
P -> L : Mở /payroll/lock
L -> BIO : isDeviceSupported(), authenticate()
alt Sinh trắc hợp lệ
  BIO --> L : true
  L -> D : Mở phiếu lương
else Không hỗ trợ / huỷ → mã PIN 6 số
  U -> L : Nhập PIN
  alt Đúng
    L -> D : Mở phiếu lương
  else Sai
    L -> L : Rung, giảm lượt (tối đa 5),\\nhết lượt → khoá 30 giây
  end
end
'''),
("Phiếu lương chi tiết", '''
D -> UC : GetPayslipDetailUseCase(id)
UC -> REPO : getPayslipDetail(id)
REPO -> API : GET /api/EmployeeSalaryPayrolls/detail/{id}
API --> REPO : bản ghi lương của kỳ
REPO -> REPO : PayslipDetailModel.fromJson\\n→ PayslipEntity
REPO --> UC : PayslipEntity
UC --> D : dữ liệu phiếu lương
D --> U : Thu nhập: lương thực tế, phụ cấp, tăng ca, KPI\\nKhấu trừ: BHXH/BHYT/BHTN, thuế TNCN, công đoàn\\n→ Lương thực nhận
'''),
])

# ---------------------------------------------------------------- SD11
MOBILE["SD11"] = ("Trung tâm thông báo", f'''
actor "Người dùng" as U
box "Presentation" {BOX_UI}
participant "Home\\n(chuông · Cập nhật mới)" as HA
participant "NotificationsScreen" as S
end box
box "Domain" {BOX_DOMAIN}
participant "UseCases" as UC
end box
box "Data" {BOX_DATA}
participant "NotificationsRepository\\n→ DataSource" as REPO
end box
{API}
''', [
("Nhận và xử lý thông báo", '''
U -> HA : Trang chủ – khối "Cập nhật mới"
HA -> UC : GetNotificationsUseCase()
UC -> REPO : getNotifications()
REPO -> API : GET /api/BaseNotifications?size&isRead
API --> REPO : {data[], deptData[]}
REPO --> UC : List<NotificationEntity>
UC --> HA : thông báo mới nhất
U -> HA : Bấm chuông
HA -> S : Mở /notifications
S -> UC : GetNotificationsUseCase()
UC --> S : danh sách
S --> U : Lọc: Tất cả · Phép · Lương · Chấm công · Thưởng…
U -> S : Chạm 1 thông báo
S -> UC : MarkNotificationReadUseCase(id)
UC -> REPO : markAsRead(id)
REPO -> API : GET /api/BaseNotifications/{id}/read
opt "Đọc tất cả"
  S -> UC : MarkAllNotificationsReadUseCase()
  UC -> REPO : markAllAsRead()
  REPO -> API : GET /api/BaseNotifications/read-all
end
'''),
])

# ---------------------------------------------------------------- SD12
MOBILE["SD12"] = ("Hồ sơ cá nhân, cài đặt và đăng xuất", f'''
actor "Người dùng" as U
box "Presentation" {BOX_UI}
participant "ProfileScreen" as S
participant "SettingsScreen" as ST
participant "AuthCubit · Theme ·\\nLocale Cubit" as AC
end box
box "Data" {BOX_DATA}
participant "AuthRemoteDataSource" as DS
participant "SecureStorage" as SEC
end box
{API}
''', [
("Hồ sơ, cài đặt và đăng xuất", '''
U -> S : Mở tab "Cá nhân"
S -> DS : getFullProfile()
DS -> API : GET /api/Account
API --> DS : {employee, account, danh mục}
DS --> S : hồ sơ
S --> U : Thông tin cá nhân · công việc · ngân hàng
U -> ST : Cài đặt
ST --> U : Thông báo đẩy, email báo cáo, nhắc chấm công;\\ngiao diện, ngôn ngữ; mở khoá sinh trắc;\\nquyền thiết bị; xoá bộ nhớ đệm
opt Đổi giao diện / ngôn ngữ
  U -> ST : Chọn sáng/tối, Việt/Anh
  ST -> AC : ThemeCubit / LocaleCubit
  AC --> U : Áp dụng ngay toàn ứng dụng
end
opt Đăng xuất
  U -> ST : "Đăng xuất" → xác nhận
  ST -> AC : AuthCubit.logout()
  AC -> SEC : Xoá token, phiên, hạn token
  AC --> U : Về màn Đăng nhập
end
'''),
])
