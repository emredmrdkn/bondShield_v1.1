//
//  ReviewAndGeneratePDFView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// Raporun durumunu ve bilgilerini tutan struct.
// Model: reports(id, inspectionId, version, pdfKey, status, createdBy)
struct ReportStatus {
    enum Status: String {
        case none = "Yok"
        case queued = "Sırada"
        case rendering = "Oluşturuluyor..."
        case ready = "Hazır"
        case failed = "Hata"
    }
    var status: Status = .none
    var reportId: String? = nil
    var downloadUrl: String? = nil
}

// ReviewAndGeneratePDFView, denetimi sonlandırma ve rapor oluşturma sürecini yönetir.
// API Endpoints: POST /inspections/{id}/reports, GET /reports/{id}, GET /reports/{id}/download, POST /reports/{id}/share
struct ReviewAndGeneratePDFView: View {
    
    let inspectionId: String
    
    // Raporun durumu ve bilgilerini tutan state.
    @State private var reportStatus = ReportStatus()
    @State private var timer: Timer? = nil // Rapor durumunu periyodik olarak kontrol etmek için

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Raporu Oluştur")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Raporun mevcut durumuna göre farklı görünümler gösterilir.
            switch reportStatus.status {
            case .none:
                generateButton
            case .queued, .rendering:
                statusIndicator
            case .ready:
                readyActions
            case .failed:
                errorView
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Gözden Geçir ve Bitir")
        .onDisappear(perform: { timer?.invalidate() }) // Ekrandan çıkıldığında zamanlayıcıyı durdur.
    }
    
    // Rapor oluşturma butonunu içeren görünüm.
    private var generateButton: some View {
        VStack {
            Text("Tüm kanıtları topladığınızdan emin olun. Rapor oluşturulduktan sonra denetimde değişiklik yapamazsınız.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
            
            Button(action: createReport) {
                Text("Nihai Raporu Oluştur")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
    // Rapor oluşturulurken gösterilecek durum göstergesi.
    private var statusIndicator: some View {
        VStack {
            ProgressView()
                .padding()
            Text("Raporunuz \(reportStatus.status.rawValue)")
                .font(.headline)
            Text("Bu işlem birkaç dakika sürebilir. Lütfen bekleyin.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // Rapor hazır olduğunda gösterilecek eylem butonları.
    private var readyActions: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            Text("Raporunuz Hazır!")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: downloadReport) {
                Label("Raporu İndir", systemImage: "arrow.down.circle.fill")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            Button(action: shareReport) {
                Label("E-posta ile Paylaş", systemImage: "paperplane.fill")
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }
    
    // Hata durumunda gösterilecek görünüm.
    private var errorView: some View {
        VStack {
            Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
            Text("Rapor oluşturulurken bir hata oluştu.")
            Button("Tekrar Dene", action: createReport)
        }
    }

    // --- API Fonksiyonları ---
    
    // Rapor oluşturma işini başlatan fonksiyon.
    private func createReport() {
        print("API -> POST /inspections/\(inspectionId)/reports çağrılıyor...")
        // Body: { includeGps, sections: [...] }
        reportStatus.status = .queued
        
        // Simülasyon: API, bir rapor ID'si ile döner.
        let newReportId = "report_" + UUID().uuidString
        reportStatus.reportId = newReportId
        print("Rapor oluşturma işi başlatıldı. Rapor ID: \(newReportId)")
        
        // Rapor durumunu kontrol etmeye başla.
        startPollingReportStatus()
    }
    
    // Rapor durumunu periyodik olarak kontrol eden fonksiyon.
    private func startPollingReportStatus() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            guard let reportId = reportStatus.reportId else { return }
            print("API -> GET /reports/\(reportId) çağrılıyor (Durum kontrolü)...")
            
            // Simülasyon: Durumun değiştiğini varsayalım.
            switch reportStatus.status {
            case .queued: reportStatus.status = .rendering
            case .rendering: 
                timer?.invalidate() // Durdur
                reportStatus.status = .ready
                reportStatus.downloadUrl = "https://s3.bucket.com/reports/report-final.pdf"
                print("Rapor hazır. İndirme URL'si: \(reportStatus.downloadUrl ?? "")")
            default: break
            }
        }
    }
    
    private func downloadReport() {
        guard let url = reportStatus.downloadUrl else { return }
        print("API -> GET /reports/\(reportStatus.reportId!)/download çağrılıyor (İmzalı URL alınıyor)...")
        print("Cihaz, \(url) adresinden PDF'i indiriyor.")
    }
    
    private func shareReport() {
        print("API -> POST /reports/\(reportStatus.reportId!)/share çağrılıyor (E-posta/link ile paylaş)...")
        print("Raporun emlakçıya gönderilmesi için istek yapıldı.")
    }
}

// #Preview için.
struct ReviewAndGeneratePDFView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReviewAndGeneratePDFView(inspectionId: "insp_preview_123")
        }
    }
}
