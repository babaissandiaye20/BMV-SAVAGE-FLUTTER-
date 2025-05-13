import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:salvage_app/app/services/document_service.dart';
import 'package:salvage_app/app/services/ocr_service.dart';
import 'package:salvage_app/app/services/appointment_service.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import '../../../models/appointment_response.dart';
import '../../../routes/app_pages.dart';
import '../../../services/secure_storage_service.dart';

class UploadDocumentsController extends GetxController {
  final picker = ImagePicker();
  final DocumentService _service = DocumentService();
  final OcrService _ocrService = OcrService();

  final Rxn<XFile> licenseFile = Rxn<XFile>();
  final Rxn<XFile> titleFile = Rxn<XFile>();
  final Rxn<XFile> receiptFile = Rxn<XFile>();

  final RxBool isLicenseValid = false.obs;
  final RxBool isTitleValid = false.obs;
  final RxBool isReceiptValid = false.obs;

  final RxBool isLicenseLoading = false.obs;
  final RxBool isTitleLoading = false.obs;
  final RxBool isReceiptLoading = false.obs;

  final RxString licenseError = ''.obs;
  final RxString titleError = ''.obs;
  final RxString receiptError = ''.obs;

  final RxBool isLoading = false.obs;

  bool get isReadyForPayment => isLicenseValid.value && isTitleValid.value;

  @override
  void onInit() {
    super.onInit();
    _loadExistingLicense();
  }

  Future<void> _loadExistingLicense() async {
    try {
      final docs = await _service.getDocuments();
      final licenseDoc = docs.firstWhereOrNull((d) => d.type.name.toUpperCase() == 'LICENSE');

      if (licenseDoc?.fileUrl != null) {
        final file = await _downloadFile(licenseDoc!.fileUrl!);
        if (file != null) {
          licenseFile.value = XFile(file.path);
          await _validateLicense(file.path);
          CustomToast.showError(Get.context!, 'Permis de conduire déjà chargé.');
        }
      }
    } catch (e) {
      licenseError.value = 'Erreur lors du chargement du permis : ${e.toString()}';
    }
  }

  Future<File?> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${url.split('/').last}');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print('Téléchargement échoué : $e');
    }
    return null;
  }

  Future<void> pickDocument(String type, ImageSource source) async {
    if (type == 'license' && licenseFile.value != null) {
      CustomToast.showError(Get.context!, "Le permis de conduire est déjà chargé.");
      return;
    }

    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    _setLoading(type, true);

    try {
      if (type == 'license') {
        licenseFile.value = picked;
        await _validateLicense(picked.path);
      } else if (type == 'title') {
        titleFile.value = picked;
        await _validateTitle(picked.path);
      } else if (type == 'receipt') {
        receiptFile.value = picked;
        await _validateReceipt(picked.path);
      }
    } catch (e) {
      _handleOcrError(type, e.toString());
    } finally {
      _setLoading(type, false);
    }
  }

  Future<void> _validateLicense(String path) async {
    final data = await _ocrService.processImage(path, scanType: 'license');
    final name = _extractValue(data, ['nom']);
    final number = _extractValue(data, ['numéro du permis', 'license_number', 'permit_number', 'DL', 'DLN']);

    isLicenseValid.value = name.isNotEmpty && number.isNotEmpty;
    licenseError.value = isLicenseValid.value ? '' : 'Permis invalide ou incomplet.';
  }

  Future<void> _validateTitle(String path) async {
    final data = await _ocrService.processImage(path, scanType: 'title');
    final vin = _extractValue(data, ['VIN', 'vin']);
    final number = _extractValue(data, ['TitleNumber', 'Title Number', 'numero_de_titre', 'numerodetitre', 'numéro de titre']);
    final vehicle = _extractValue(data, ['VehicleType', 'type_de_vehicule', 'typedevehicule', 'type de véhicule']);

    isTitleValid.value = vin.isNotEmpty && number.isNotEmpty && vehicle.isNotEmpty;
    titleError.value = isTitleValid.value ? '' : 'Titre invalide ou incomplet.';
  }

  Future<void> _validateReceipt(String path) async {
    final data = await _ocrService.processImage(path, scanType: 'receipt');
    final receiptNo = _extractValue(data, ['ReceiptNumber', 'receipt no', 'Receipt No', 'receiptnumber']);
    final date = _extractValue(data, ['Issue Date', 'issue_date', 'issuedate']);

    isReceiptValid.value = receiptNo.isNotEmpty && date.isNotEmpty;
    receiptError.value = isReceiptValid.value ? '' : 'Reçu invalide ou illisible.';
  }

  void _handleOcrError(String type, String message) {
    final error = 'Erreur OCR : $message';
    if (type == 'license') {
      licenseError.value = error;
      isLicenseValid.value = false;
    } else if (type == 'title') {
      titleError.value = error;
      isTitleValid.value = false;
    } else if (type == 'receipt') {
      receiptError.value = error;
      isReceiptValid.value = false;
    }
  }

  void _setLoading(String type, bool value) {
    if (type == 'license') {
      isLicenseLoading.value = value;
    } else if (type == 'title') {
      isTitleLoading.value = value;
    } else if (type == 'receipt') {
      isReceiptLoading.value = value;
    }
  }

  void clearDocument(String type) {
    if (type == 'license') {
      licenseFile.value = null;
      isLicenseValid.value = false;
      licenseError.value = '';
    } else if (type == 'title') {
      titleFile.value = null;
      isTitleValid.value = false;
      titleError.value = '';
    } else if (type == 'receipt') {
      receiptFile.value = null;
      isReceiptValid.value = false;
      receiptError.value = '';
    }
  }

  Future<void> _createAppointmentAndHandle({required bool goToPayment}) async {
    if (!isReadyForPayment) {
      CustomToast.showError(Get.context!, "Veuillez valider le permis ET le titre.");
      return;
    }

    isLoading.value = true;

    try {
      final token = await SecureStorageService.readToken();
      final userId = await SecureStorageService.readUserId();

      if (userId == null || token == null) {
        CustomToast.showError(Get.context!, "Utilisateur introuvable.");
        return;
      }

      final titleData = await _ocrService.processImage(titleFile.value!.path, scanType: 'title');
      final vin = _extractValue(titleData, ['VIN', 'vin']);
      final titleNumber = _extractValue(titleData, ['TitleNumber', 'Title Number', 'numero_de_titre', 'numerodetitre', 'numéro de titre']);
      final vehicleType = _extractValue(titleData, ['VehicleType', 'type_de_vehicule', 'typedevehicule', 'type de véhicule']);

      String? receiptNumber;
      String? issueDate;

      if (receiptFile.value != null) {
        final receiptData = await _ocrService.processImage(receiptFile.value!.path, scanType: 'receipt');
        receiptNumber = _extractValue(receiptData, ['ReceiptNumber', 'receipt no', 'Receipt No', 'receiptnumber']);
        final rawDate = _extractValue(receiptData, ['Issue Date', 'issue_date', 'issuedate']);
        issueDate = _normalizeDate(rawDate);
      }

      final request = AppointmentRequest(
        userId: userId,
        vin: vin,
        vehicleType: vehicleType,
        titleNumber: titleNumber,
        receiptNumber: receiptNumber,
        issuesDate: issueDate,
      );

      print("📤 Données envoyées à l'API : ${request.toJson()}");

      final result = await AppointmentService().createAppointment(request: request, token: token);

      if (result['statusCode'] == 201 && result['data'] != null) {
        if (goToPayment) {
          CustomToast.showSuccess(Get.context!, "Rendez-vous créé. Redirection...");
          Get.toNamed(Routes.PAYMENT);
        } else {
          CustomToast.showSuccess(Get.context!, "Rendez-vous enregistré. Vous pouvez ajouter un autre véhicule.");
          _resetForm();
        }
      } else {
        final errorMessage = result['message'] ?? 'Erreur lors de la création du rendez-vous.';
        CustomToast.showError(Get.context!, errorMessage);
      }
    } catch (e) {
      CustomToast.showError(Get.context!, "Erreur: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToPayment() async {
    await _createAppointmentAndHandle(goToPayment: true);
  }

  Future<void> saveAppointmentOnly() async {
    await _createAppointmentAndHandle(goToPayment: false);
  }

  void _resetForm() {
    licenseFile.value = null;
    titleFile.value = null;
    receiptFile.value = null;

    isLicenseValid.value = false;
    isTitleValid.value = false;
    isReceiptValid.value = false;

    licenseError.value = '';
    titleError.value = '';
    receiptError.value = '';
  }

  String _extractValue(Map<String, dynamic> data, List<String> possibleKeys) {
    final normalized = data.map((k, v) => MapEntry(_normalize(k), v));
    for (final key in possibleKeys) {
      final k = _normalize(key);
      if (normalized.containsKey(k)) {
        final value = normalized[k];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }
    return '';
  }

  String _normalize(String input) {
    return input
        .replaceAll('Ã©', 'e')
        .replaceAll('Ã¨', 'e')
        .replaceAll('Ãª', 'e')
        .replaceAll('Ã´', 'o')
        .replaceAll('Ã', 'a')
        .toLowerCase()
        .replaceAllMapped(RegExp(r'[àâä]'), (_) => 'a')
        .replaceAllMapped(RegExp(r'[éèêë]'), (_) => 'e')
        .replaceAllMapped(RegExp(r'[îï]'), (_) => 'i')
        .replaceAllMapped(RegExp(r'[ôö]'), (_) => 'o')
        .replaceAllMapped(RegExp(r'[ùûü]'), (_) => 'u')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'\s+'), '')
        .trim();
  }

  String? _normalizeDate(String? input) {
    if (input == null || input.isEmpty) return null;
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return "$year-$month-$day"; // Format ISO
      }
    } catch (_) {}
    return input; // fallback
  }
}
