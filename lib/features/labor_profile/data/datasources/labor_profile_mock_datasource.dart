import 'package:vstech_hrm/features/labor_profile/data/models/labor_profile_model.dart';

abstract class LaborProfileDataSource {
  Future<LaborProfileModel> getLaborProfile();
}

class LaborProfileMockDataSource implements LaborProfileDataSource {
  @override
  Future<LaborProfileModel> getLaborProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return LaborProfileModel(
      employeeCode: 'NV-04821',
      fullName: 'Nguyễn Minh Tuấn',
      department: 'Phân xưởng Lắp ráp & Hoàn thiện',
      jobTitle: 'Kỹ thuật viên Trưởng chuyền',
      contractType: 'HĐLĐ Xác định thời hạn (36 tháng)',
      contractNumber: 'HDLD-2023/04821-VSTECH',
      signingDate: DateTime(2023, 5, 2),
      effectiveDate: DateTime(2023, 5, 15),
      expirationDate: DateTime(2026, 5, 14),
      contractStatus: 'Đang có hiệu lực',
      agreedBaseSalary: 18500000,
      responsibilityAllowance: 2000000,
      mealAllowance: 1200000,
      socialInsuranceNumber: '7916238491',
      hospitalRegistered: 'Bệnh viện Đa khoa Khu vực Hóc Môn',
      insuranceSalaryLevel: 18500000,
      insuranceStatus: 'Đang tham gia liên tục (3 năm 4 tháng)',
      attachments: [
        LaborContractAttachmentModel(
          id: 'att_01',
          name: 'HDLD_NguyenMinhTuan_Signed.pdf',
          size: '2.4 MB',
          uploadedAt: DateTime(2023, 5, 2),
          url: 'https://vstech.vn/contracts/HDLD_NguyenMinhTuan_Signed.pdf',
        ),
        LaborContractAttachmentModel(
          id: 'att_02',
          name: 'Phu_Luc_Dieu_Chinh_Luong_2025.pdf',
          size: '860 KB',
          uploadedAt: DateTime(2025),
          url: 'https://vstech.vn/contracts/Phu_Luc_Dieu_Chinh_Luong_2025.pdf',
        ),
        LaborContractAttachmentModel(
          id: 'att_03',
          name: 'Cam_Ket_An_Toan_Lao_Dong_VSLĐ.pdf',
          size: '1.1 MB',
          uploadedAt: DateTime(2023, 5, 2),
          url: 'https://vstech.vn/contracts/Cam_Ket_An_Toan_Lao_Dong_VSLĐ.pdf',
        ),
      ],
    );
  }
}
