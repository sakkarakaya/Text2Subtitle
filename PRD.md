# SRT Metin Düzenleyici PRD (Product Requirements Document)

## Ürün Özeti
SRT Metin Düzenleyici, .srt altyazı dosyalarındaki zaman çizelgelerini koruyarak, metin içeriğini .txt dosyasından alarak yeni bir .srt dosyası oluşturan macOS uygulamasıdır.

## Hedef Kullanıcılar
- Altyazı düzenleyicileri
- Video içerik üreticileri
- Çevirmenler

## Temel Özellikler
1. Dosya Seçimi
   - .srt dosyası seçme
   - .txt dosyası seçme
   - Çıktı dosyası için konum belirleme

2. Dosya İşleme
   - .srt dosyasından zaman çizelgelerini okuma
   - .txt dosyasından metinleri okuma
   - Yeni .srt dosyası oluşturma

3. Kullanıcı Arayüzü
   - Modern ve minimalist tasarım
   - Sürükle-bırak dosya desteği
   - İşlem durumu göstergesi
   - Hata mesajları
   - Başarılı işlem bildirimleri

## Teknik Gereksinimler
- Python 3.x
- SwiftUI
- macOS 11.0 veya üzeri

## Kullanıcı Deneyimi
1. Uygulama Açılışı
   - Temiz ve basit bir arayüz
   - Dosya seçim alanları
   - "İşlemi Başlat" butonu

2. İşlem Akışı
   - Dosya seçimi
   - İşlem onayı
   - İlerleme göstergesi
   - Sonuç bildirimi
   - Dosya işlemleri sırasında ilerleme çubuğu

## Güvenlik ve Veri
- Orijinal dosyalar değiştirilmeyecek
- Yeni dosya farklı bir isimle kaydedilecek
- Hata durumunda veri kaybı olmayacak 

## Mevcut Python scripti
    # .srt ve .txt dosyalarını oku
    with open('dosya.srt', 'r', encoding='utf-8') as srt_file:
        srt_lines = srt_file.readlines()

    with open('dosya.txt', 'r', encoding='utf-8') as txt_file:
        txt_lines = txt_file.readlines()

    # Yeni .srt dosyasını oluştur
    with open('yeni_dosya.srt', 'w', encoding='utf-8') as new_srt_file:
        txt_index = 0
        srt_index = 0

        while srt_index < len(srt_lines):
            line = srt_lines[srt_index]

            # Zaman çizelgesi satırını bul
            if '-->' in line:
                # Zaman çizelgesini yaz
                new_srt_file.write(line)

                # .txt dosyasındaki metni yaz
                if txt_index < len(txt_lines):
                    new_srt_file.write(txt_lines[txt_index])  # Metni ekle
                    txt_index += 1
                else:
                    new_srt_file.write('\n')  # Eğer .txt dosyası daha kısa ise boş satır bırak

                # Eski metin satırlarını atla (eski metinleri sil)
                srt_index += 1
                while srt_index < len(srt_lines) and srt_lines[srt_index].strip() != '':
                    srt_index += 1
            else:
                # Diğer satırları (numara gibi) olduğu gibi yaz
                new_srt_file.write(line)
                srt_index += 1

    print("İşlem tamamlandı! 'yeni_dosya.srt' oluşturuldu.")
    - Bu scripti SwiftUI ile uygulamaya entegre etmek gerekiyor.
    - Bu scripti bir sınıf yapısına dönüştürüp, hata kontrollerini eklemek gerekiyor.