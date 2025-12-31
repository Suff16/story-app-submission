import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Story App',
      'welcome_back': 'Welcome Back',
      'login_to_continue': 'Login to continue',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'register': 'Register',
      'name': 'Name',
      'logout': 'Logout',
      'logout_confirmation': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'create_account': 'Create Account',
      'sign_up_to_get_started': 'Sign up to get started',
      'already_have_account': 'Already have an account?',
      'dont_have_account': "Don't have an account?",
      'stories': 'Stories',
      'story_detail': 'Story Detail',
      'add_new_story': 'Add New Story',
      'description': 'Description',
      'tap_to_select_image': 'Tap to select image',
      'change_image': 'Change Image',
      'upload_story': 'Upload Story',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'location': 'Location',
      'no_stories_yet': 'No stories yet',
      'be_first_to_share': 'Be the first to share a story',
      'retry': 'Retry',
      'loading': 'Loading...',
      'story_not_found': 'Story not found',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'password_min_8_chars': 'Password must be at least 8 characters',
      'please_enter_name': 'Please enter your name',
      'please_select_image': 'Please select an image',
      'please_enter_description': 'Please enter a description',
      'description_min_10_chars': 'Description must be at least 10 characters',
      'write_description_hint': 'Write a short description about your image...',
      'registration_successful': 'Registration successful! Please login.',
      'story_uploaded_successfully': 'Story uploaded successfully!',
      'failed_to_upload_story': 'Failed to upload story',
      'failed_to_pick_image': 'Failed to pick image',
      'just_now': 'Just now',
      'minutes_ago': 'minutes ago',
      'hours_ago': 'hours ago',
      'days_ago': 'days ago',
    },
    'id': {
      'app_title': 'Aplikasi Cerita',
      'welcome_back': 'Selamat Datang Kembali',
      'login_to_continue': 'Masuk untuk melanjutkan',
      'email': 'Email',
      'password': 'Kata Sandi',
      'login': 'Masuk',
      'register': 'Daftar',
      'name': 'Nama',
      'logout': 'Keluar',
      'logout_confirmation': 'Apakah Anda yakin ingin keluar?',
      'cancel': 'Batal',
      'create_account': 'Buat Akun',
      'sign_up_to_get_started': 'Daftar untuk memulai',
      'already_have_account': 'Sudah punya akun?',
      'dont_have_account': 'Belum punya akun?',
      'stories': 'Cerita',
      'story_detail': 'Detail Cerita',
      'add_new_story': 'Tambah Cerita Baru',
      'description': 'Deskripsi',
      'tap_to_select_image': 'Ketuk untuk memilih gambar',
      'change_image': 'Ganti Gambar',
      'upload_story': 'Unggah Cerita',
      'camera': 'Kamera',
      'gallery': 'Galeri',
      'location': 'Lokasi',
      'no_stories_yet': 'Belum ada cerita',
      'be_first_to_share': 'Jadilah yang pertama berbagi cerita',
      'retry': 'Coba Lagi',
      'loading': 'Memuat...',
      'story_not_found': 'Cerita tidak ditemukan',
      'please_enter_email': 'Silakan masukkan email Anda',
      'please_enter_valid_email': 'Silakan masukkan email yang valid',
      'please_enter_password': 'Silakan masukkan kata sandi Anda',
      'password_min_8_chars': 'Kata sandi minimal 8 karakter',
      'please_enter_name': 'Silakan masukkan nama Anda',
      'please_select_image': 'Silakan pilih gambar',
      'please_enter_description': 'Silakan masukkan deskripsi',
      'description_min_10_chars': 'Deskripsi minimal 10 karakter',
      'write_description_hint':
          'Tulis deskripsi singkat tentang gambar Anda...',
      'registration_successful': 'Registrasi berhasil! Silakan masuk.',
      'story_uploaded_successfully': 'Cerita berhasil diunggah!',
      'failed_to_upload_story': 'Gagal mengunggah cerita',
      'failed_to_pick_image': 'Gagal memilih gambar',
      'just_now': 'Baru saja',
      'minutes_ago': 'menit yang lalu',
      'hours_ago': 'jam yang lalu',
      'days_ago': 'hari yang lalu',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
