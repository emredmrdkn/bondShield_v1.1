//
//  CaptureView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// Bir kanıtı temsil eden struct.
// Model: evidence(id, inspectionId, roomId, fileKey, thumbKey, ...)
struct Evidence: Identifiable {
    let id: String
    let fileName: String
    let thumbnailUrl: String // Örnek olarak bir sistem ikonu kullanılacak
    let note: String?
}

// CaptureView, belirli bir oda için kanıtların (fotoğraf/video) toplanmasını yönetir.
// API Endpoints: POST /media/presign, POST /inspections/{id}/evidence, GET /inspections/{id}/evidence, DELETE /evidence/{id}
struct CaptureView: View {
    
    // Önceki ekrandan gelen ID'ler ve oda adı.
    let inspectionId: String
    let roomId: String
    let roomName: String
    
    // Bu odaya ait mevcut kanıtların listesi.
    @State private var evidenceList: [Evidence] = []
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            // Kanıt listesi
            List {
                ForEach(evidenceList) { evidence in
                    HStack {
                        Image(systemName: evidence.thumbnailUrl)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text(evidence.fileName)
                                .font(.headline)
                            if let note = evidence.note, !note.isEmpty {
                                Text(note)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteEvidence) // Kanıt silme işlemi
            }
            
            Spacer()
            
            // Kanıt ekleme butonu
            Button(action: { 
                showingImagePicker = true 
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("Fotoğraf / Video Ekle")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(15.0)
            }
            .padding()
        }
        .navigationTitle(roomName) // Ekran başlığına oda adını yazdır.
        .onAppear(perform: fetchEvidence) // Ekran açıldığında mevcut kanıtları yükle.
        .sheet(isPresented: $showingImagePicker) {
            // Gerçek uygulamada burada UIImagePickerController veya PHPickerViewController kullanılır.
            // Bu örnekte, seçimi ve yükleme akışını simüle ediyoruz.
            VStack {
                Text("Kamera/Galeri Arayüzü Simülasyonu")
                    .font(.title)
                Button("Örnek Fotoğraf Seçildi") {
                    // 1. Presigned URL al, 2. Yükle, 3. Backend'e bildir.
                    uploadFlow(fileName: "image_\(Int.random(in: 1...1000)).jpg")
                    showingImagePicker = false
                }
                .padding()
            }
        }
    }
    
    private func fetchEvidence() {
        print("API -> GET /inspections/\(inspectionId)/evidence?roomId=\(roomId) çağrılıyor...")
        // Simülasyon: Mevcut kanıtlar yükleniyor.
        self.evidenceList = [
            Evidence(id: "ev_1", fileName: "kitchen_sink.jpg", thumbnailUrl: "photo", note: "Hafif paslanma var."),
            Evidence(id: "ev_2", fileName: "kitchen_oven.mp4", thumbnailUrl: "video", note: nil)
        ]
    }
    
    private func uploadFlow(fileName: String) {
        print("--- Yeni Kanıt Yükleme Akışı Başladı ---")
        // 1. Backend'den presigned URL talep et.
        print("1. API -> POST /media/presign çağrılıyor...")
        // Simülasyon: a_presigned_url, a_file_key gibi bilgiler döner.
        let presignedUrl = "https://s3.bucket.com/presigned-url-xyz"
        let fileKey = "uploads/insp_123/\(fileName)"
        
        // 2. Dosyayı presigned URL kullanarak doğrudan S3'e yükle.
        print("2. Dosya \"\(fileName)\" S3'e yükleniyor: \(presignedUrl)")
        // Simülasyon: Yükleme başarılı.
        
        // 3. Yükleme başarılı olunca, backend'e metadata'yı bildir.
        print("3. API -> POST /inspections/\(inspectionId)/evidence çağrılıyor...")
        print("   Body: { roomId: \(roomId), fileKey: \(fileKey), ...exif, hash, etc. }")
        // Simülasyon: Backend onayı sonrası listeyi güncelle.
        let newEvidence = Evidence(id: "ev_\(Int.random(in: 1...100))", fileName: fileName, thumbnailUrl: "photo", note: "Yeni not eklenecek.")
        self.evidenceList.append(newEvidence)
        print("--- Akış Tamamlandı ---")
    }
    
    private func deleteEvidence(at offsets: IndexSet) {
        for index in offsets {
            let evidenceToDelete = evidenceList[index]
            print("API -> DELETE /evidence/\(evidenceToDelete.id) çağrılıyor...")
            // Simülasyon: API isteği başarılı olunca listeden kaldır.
            evidenceList.remove(atOffsets: offsets)
        }
    }
}

// #Preview için.
struct CaptureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CaptureView(inspectionId: "insp_preview", roomId: "room_preview", roomName: "Mutfak")
        }
    }
}
