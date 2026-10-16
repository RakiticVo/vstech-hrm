"""Backend-tier sequence diagrams (skeleton – completed later by the backend team).

Compact layout: Mobile App → Controller → Service → Database, one block per API
call, with the request / response contract taken from the OpenAPI specs.
Long flows are split into parts of at most CALLS_PER_PART calls.
"""
from style import BOX_SERVER, BOX_DATA

TBD = "<color:#B91C1C><i>[Backend bổ sung]</i></color>"
CALLS_PER_PART = 3
C = dict

CALLS = {
    "SD01": [
        C(s="hrm", m="GET", p="/api/Account/check-auth", ctl="AccountController", req="Bearer JWT",
          ok="200 (rỗng) · 401 ProblemDetails", tbl="Users"),
        C(s="hrm", m="POST", p="/api/Account", ctl="AccountController",
          req="LoginViewModel{username, password, device_id,\\nmodel, platform, version_app, root…}",
          ok="LoginResultViewModel{token, validTo, user{claims…}}\\n· 400/401/500 {message}", tbl="Users, UserRoles, Employees"),
    ],
    "SD02": [
        C(s="face", m="GET", p="/checkreg/", req="Code, AppCode", ok="{status, registered, count}"),
        C(s="face", m="POST", p="/verify/", req="multipart: Code, AppCode, file", ok="{status, match, similarity}"),
        C(s="hrm", m="POST", p="/api/Enrollments/Checkin | Checkout", ctl="EnrollmentsController",
          req="EnrollForm{coordinate, local, fingerprint, time, date}", ok="EnrollActionResponse{message, checkin, checkout}\\n· 400 {message}",
          tbl="Enrollments, TimeSheets, Shifts"),
        C(s="hrm", m="GET", p="/api/Enrollments/info", ctl="EnrollmentsController",
          req="date, time (tuỳ chọn)", ok="EnrollmentInfoResponse{timesheet, startShift,\\nendShift, enrolls[], serverTime}", tbl="Enrollments, TimeSheets"),
    ],
    "SD03": [
        C(s="face", m="GET", p="/checkreg/", req="Code, AppCode", ok="{status, registered, count}"),
        C(s="face", m="POST", p="/register/", req="multipart: Code, AppCode, files[]", ok="{status, message} · 422"),
        C(s="face", m="POST", p="/update/", req="multipart: Code, AppCode, file", ok="{status, message} · 422"),
    ],
    "SD04": [
        C(s="hrm", m="GET", p="/api/Enrollments/info", ctl="EnrollmentsController", req="(hôm nay)",
          ok="ca, giờ vào/ra, serverTime", tbl="Enrollments, TimeSheets, Shifts"),
        C(s="hrm", m="GET", p="/api/Enrollments/info?from&to", ctl="EnrollmentsController", req="khoảng ngày",
          ok="enrolls[{date, checkin, checkout, late, early, total}]", tbl="Enrollments, MonthlyTimeSheets"),
        C(s="hrm", m="GET", p="/api/OvertimeRequests/self?month", ctl="OvertimeRequestsController", req="month",
          ok="OvertimeRequestSelfItem[]", tbl="OvertimeRequests"),
        C(s="hrm", m="GET", p="/api/Holidays", ctl="HolidaysController", req="—",
          ok="HolidaysResponse{items[{code, name, date, scale}]}", tbl="Holidays"),
    ],
    "SD05": [
        C(s="hrm", m="GET", p="/api/LeaveRequests/self?init=1&version=1", ctl="LeaveRequestsController", req="—",
          ok="leavePlans[{code, name, symbol, amount}]", tbl="LeavePlans, Benefits, LeaveEnrollments"),
        C(s="hrm", m="GET", p="/api/LeaveRequests/self?From&To", ctl="LeaveRequestsController", req="From, To, Page, PageSize",
          ok="LeaveRequestResponsePagedResult{results[], rowCount}", tbl="LeaveRequests"),
        C(s="hrm", m="POST", p="/api/LeaveRequests/self", ctl="LeaveRequestsController",
          req="LeaveRequestCreate{from, to, halfShiftType, isMultiple,\\nleaveAmountType, leavePlanCode, note, validFrom, validTo}",
          ok="{message, data} · 400 vượt quỹ phép / trùng lịch", tbl="LeaveRequests, LeaveEnrollments"),
    ],
    "SD06": [
        C(s="hrm", m="GET", p="/api/LeaveRequests/self?From&To", ctl="LeaveRequestsController", req="From, To",
          ok="LeaveRequestResponsePagedResult", tbl="LeaveRequests"),
        C(s="hrm", m="GET", p="/api/OvertimeRequests/self?month", ctl="OvertimeRequestsController", req="month = yyyy-MM-01",
          ok="OvertimeRequestSelfItem[]", tbl="OvertimeRequests"),
    ],
    "SD07": [
        C(s="hrm", m="GET", p="/api/OvertimeTypes/fetch?IsActive=1", ctl="OvertimeTypesController", req="IsActive",
          ok="items[OvertimeType{code, name, scale…}]", tbl="OvertimeTypes"),
        C(s="hrm", m="GET", p="/api/OvertimeRequests/self?init=1", ctl="OvertimeRequestsController", req="(dự phòng)",
          ok="{overtimeTypes[]}", tbl="OvertimeTypes"),
        C(s="hrm", m="GET", p="/api/OvertimeRequests/self?month", ctl="OvertimeRequestsController", req="month = yyyy-MM-01",
          ok="OvertimeRequestSelfItem[]", tbl="OvertimeRequests"),
        C(s="hrm", m="POST", p="/api/OvertimeRequests", ctl="OvertimeRequestsController",
          req="{date, length, note, startOvertime,\\nendOvertime, overtimeTypeCode}", ok="{message} · 400 vượt giới hạn giờ",
          tbl="OvertimeRequests, OvertimeTypes, OvertimeBookings"),
    ],
    "SD08": [
        C(s="hrm", m="GET", p="/api/TimesheetConfirmRequests?month&personal", ctl="TimesheetConfirmRequestsController",
          req="month, personal", ok="{message, data[]}", tbl="TimesheetConfirmRequests"),
        C(s="hrm", m="GET", p="/api/TimesheetConfirmRequests/reasons", ctl="TimesheetConfirmRequestsController", req="—",
          ok="[{code, name, mustHaveNote, mustHaveImage}]", tbl="TimesheetConfirmRequestTypes"),
        C(s="hrm", m="POST", p="/api/TimesheetConfirmRequests", ctl="TimesheetConfirmRequestsController",
          req="{workDate, worktime, reasonTypeCode, note,\\nimageUrl, latitude, longitude, address}", ok="{message} · 400",
          tbl="TimesheetConfirmRequests"),
    ],
    "SD09": [
        C(s="hrm", m="GET", p="/api/TimesheetConfirmRequests?personal=false", ctl="TimesheetConfirmRequestsController",
          req="month, personal = false", ok="{message, data[]}", tbl="TimesheetConfirmRequests"),
        C(s="hrm", m="GET", p="/api/LeaveRequests/self?From&To", ctl="LeaveRequestsController", req="From, To",
          ok="LeaveRequestResponsePagedResult", tbl="LeaveRequests"),
        C(s="hrm", m="GET", p="/api/OvertimeRequests/self?month", ctl="OvertimeRequestsController", req="month",
          ok="OvertimeRequestSelfItem[]", tbl="OvertimeRequests"),
        C(s="hrm", m="POST", p="/api/TimesheetConfirmRequests/confirm/{id}", ctl="TimesheetConfirmRequestsController",
          req="{confirmedWorktime, confirmNote}", ok="{message} · 400", tbl="TimesheetConfirmRequests, TimeSheets"),
        C(s="hrm", m="POST", p="/api/TimesheetConfirmRequests/reject/{id}", ctl="TimesheetConfirmRequestsController",
          req="note (lý do)", ok="{message} · 400", tbl="TimesheetConfirmRequests"),
        C(s="hrm", m="GET", p="/api/ConfirmRequests/leave/accept|deny/{id}", ctl="ConfirmRequestsController",
          req="id", ok="{message} · 400", tbl="LeaveRequests, LeaveEnrollments"),
        C(s="hrm", m="GET", p="/overtime/accept|Deny/{id}", ctl="ConfirmRequestsController",
          req="id", ok="{message} · 400", tbl="OvertimeRequests"),
    ],
    "SD10": [
        C(s="hrm", m="GET", p="/api/EmployeeSalaryPayrolls/detail/{id}", ctl="EmployeeSalaryPayrollsController",
          req="id (bản ghi lương)", ok="{data{item: EmployeeSalaryPayroll{month, actualBaseSalary,\\nactualOvertimeSalary, taxTNCN, payAmount…}}}",
          tbl="EmployeeSalaryPayrolls, MonthlyTimeSheets"),
    ],
    "SD11": [
        C(s="hrm", m="GET", p="/api/BaseNotifications", ctl="BaseNotificationsController", req="size, isRead",
          ok="{data[Notification], deptData[]}", tbl="Notifications"),
        C(s="hrm", m="GET", p="/api/BaseNotifications/{id}/read", ctl="BaseNotificationsController", req="id",
          ok="200 · 404", tbl="Notifications"),
        C(s="hrm", m="GET", p="/api/BaseNotifications/read-all", ctl="BaseNotificationsController", req="—",
          ok="200", tbl="Notifications"),
    ],
    "SD12": [
        C(s="hrm", m="GET", p="/api/Account", ctl="AccountController", req="id (tuỳ chọn)",
          ok="EmployeeProfileResponse{employee, account, danh mục…}", tbl="Employees, EmployeeExtraInfos"),
    ],
}

HEADER = f'''
participant "Ứng dụng Mobile" as APP
box "Backend" {BOX_SERVER}
participant "Controller\\n<size:10>(JWT · phân quyền)</size>" as CTL
participant "Service\\n<size:10>nghiệp vụ</size>" as SVC
end box
box "Dữ liệu" {BOX_DATA}
database "Database" as DB
end box
'''
FACE = f'''
box "Dịch vụ khuôn mặt" {BOX_SERVER}
participant "Face Auth Service" as FACE
end box
'''


def backend_parts(code: str) -> list[str]:
    calls = CALLS[code]
    head = HEADER + (FACE if any(c["s"] == "face" for c in calls) else "")
    parts = []
    for i in range(0, len(calls), CALLS_PER_PART):
        lines = [head, "hide unlinked"]
        for c in calls[i:i + CALLS_PER_PART]:
            if c["s"] == "face":
                lines.append(f'APP -> FACE : <b>{c["m"]} {c["p"]}</b>\\n{c["req"]}')
                lines.append(f'note over FACE : Trích xuất vector, so khớp,\\nlưu trữ: {TBD}')
                lines.append(f'FACE --> APP : {c["ok"]}')
                continue
            lines.append(f'APP -> CTL : <b>{c["m"]} {c["p"]}</b>\\n{c["req"]}')
            lines.append(f'CTL -> SVC : {c["ctl"]} {TBD}')
            lines.append(f'SVC -> DB : {c["tbl"]} (dự kiến)')
            lines.append("DB --> SVC : dữ liệu")
            lines.append(f"SVC --> CTL : kết quả {TBD}")
            lines.append(f'CTL --> APP : {c["ok"]}')
        parts.append("\n".join(lines))
    return parts
