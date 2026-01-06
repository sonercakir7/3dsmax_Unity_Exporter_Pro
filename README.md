# 3ds Max Unity Exporter Pro

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Platform](https://img.shields.io/badge/platform-3ds%20Max%20%7C%20Unity-orange)
![Version](https://img.shields.io/badge/version-1.0-green)

**3ds Max Unity Exporter Pro** is a robust MaxScript tool designed to streamline the asset pipeline between Autodesk 3ds Max (2024, 2025, 2026) and Unity 3D. It handles batch exporting, coordinate correction, pivot adjustments, and naming conventions automatically.

## 🚀 Features

* **Smart Group Handling:** Exports groups as single FBX files without breaking hierarchy or exploding components.
* **Unity Coordinate Fix:** Automatically handles the Z-Up (Max) to Y-Up (Unity) conversion.
* **Batch Processing:** Export hundreds of objects in seconds with a progress bar and detailed logs.
* **Auto-Collider Generation:** Optionally generates simplified mesh colliders (`UCX_` prefix) compatible with Unity/Unreal.
* **Naming Sanitization:** Converts names to "snake_case", removing spaces and illegal characters.
* **Smart Reset XForm:** Applies XForm reset only to geometry meshes to prevent hierarchy breakage.
* **Pivot Control:** Options to set pivots to "Bottom Center", "Object Center", or keep "Original".
* **FBX Version Control:** Supports FBX 2009 (Legacy), 2014, and 2020 (PBR) formats.
* **Detailed Logging:** Separate log window to track every exported file and potential errors.

## 📦 Installation

1.  Download the latest `.ms` file from the [Releases](../../releases) page.
2.  Drag and drop the script into the 3ds Max viewport.
3.  **Alternatively:** Go to `Scripting > Run Script...` and select the file.

## 🎮 Usage

1.  Select the objects or groups you want to export in the viewport.
2.  Run the script.
3.  **Geometry Processing:** Choose pivot settings and whether to apply Reset XForm.
4.  **Naming:** Set a prefix (e.g., `SM_`) and suffix.
5.  **Export Path:** Select your Unity project's `Assets` folder.
6.  Click **START BATCH EXPORT**.

## ⚙️ Requirements

* **Autodesk 3ds Max:** 2024, 2025, 2026 (Tested on 2025).
* **Unity:** Any version (Standard, URP, HDRP supported).

## 📄 License

This project is licensed under the **GNU General Public License v3.0**. See the [LICENSE](LICENSE) file for details.

## 👤 Author

**Soner Çakır**
* GitHub: [@sonercakir7](https://github.com/sonercakir7)


___________
# 3ds Max Unity Exporter Pro (Türkçe)

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Platform](https://img.shields.io/badge/platform-3ds%20Max%20%7C%20Unity-orange)

**3ds Max Unity Exporter Pro**, Autodesk 3ds Max (2024-2026) ve Unity 3D arasındaki model aktarım sürecini hızlandırmak için geliştirilmiş güçlü bir MaxScript aracıdır. Toplu export işlemleri, koordinat düzeltmeleri, pivot ayarları ve isimlendirme kurallarını otomatik olarak yönetir.

## 🚀 Özellikler

* **Akıllı Grup Yönetimi:** Gruplanmış objeleri hiyerarşiyi bozmadan veya dağıtmadan tek bir FBX olarak dışa aktarır.
* **Unity Koordinat Uyumu:** Z-Yukarı (Max) ekseninden Y-Yukarı (Unity) eksenine sorunsuz dönüşüm sağlar.
* **Toplu İşlem (Batch):** Yüzlerce objeyi saniyeler içinde export eder, işlem sırasında detaylı log tutar.
* **Otomatik Collider Oluşturma:** İsteğe bağlı olarak Unity ve Unreal ile uyumlu (`UCX_` öneki ile) optimize edilmiş mesh collider üretir.
* **İsim Düzenleme (Sanitization):** Dosya adlarındaki boşlukları ve geçersiz karakterleri temizler, otomatik olarak `snake_case` formatına çevirebilir.
* **Akıllı Reset XForm:** Hiyerarşiyi bozmamak için sadece geometri objelerine XForm uygular.
* **Pivot Kontrolü:** Pivot noktasını "Taban Merkez", "Obje Merkezi" veya "Orijinal" olarak ayarlama imkanı.
* **FBX Versiyon Seçimi:** FBX 2009 (Eski/Stabil), 2014 ve 2020 (PBR) formatlarını destekler.

## 📦 Kurulum

1.  En güncel `.ms` dosyasını indirin.
2.  Dosyayı 3ds Max ekranına sürükleyip bırakın.
3.  **Alternatif:** `Scripting > Run Script...` menüsünden dosyayı seçin.

## 🎮 Kullanım

1.  Sahnede export etmek istediğiniz objeleri veya grupları seçin.
2.  Scripti çalıştırın.
3.  **Geometry Processing:** Pivot tercihinizi ve Reset XForm isteğinizi belirtin.
4.  **Naming:** Prefix (Örn: `SM_`) ve Suffix ayarlarını yapın.
5.  **Export Path:** Unity projenizin `Assets` klasörünü seçin.
6.  **START BATCH EXPORT** butonuna tıklayın.

## 📄 Lisans

Bu proje **GNU General Public License v3.0** ile lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakınız.

## 👤 Yapımcı

**Soner Çakır**
* GitHub: [@sonercakir7](https://github.com/sonercakir7)
