//
//  InspectionDetailView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// Karşılaştırma için denetim verilerini tutan yapı.
struct InspectionData {
    let id: String
    let type: String // "move_in" veya "move_out"
    let evidence: [Evidence] // CaptureView'da tanımlanan Evidence struct'ını kullanıyoruz
}

// InspectionDetailView, bir mülkün denetimlerini ve kanıtlarını detaylı olarak gösterir.
// API Endpoints: GET /agency/inspections/{id}, GET /agency/inspections/{id}/compare, POST /comments
struct InspectionDetailView: View {
    
    let propertyId: String
    let propertyAddress: String
    
    @State private var moveInData: InspectionData?
    @State private var moveOutData: InspectionData?
    @State private var commentText: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Üst bilgi ve ana eylemler
                headerView
                
                Divider()
                
                // Karşılaştırma bölümü
                if let moveInData = moveInData, let moveOutData = moveOutData {
                    comparisonView(moveIn: moveInData, moveOut: moveOutData)
                } else if let moveInData = moveInData {
                    singleInspectionView(inspection: moveInData)
                } else {
                    Text("Bu mülk için henüz denetim verisi bulunmuyor.")
                        .padding()
                }
                
                // Yorum ekleme bölümü
                commentSection
            }
            .padding()
        }
        .navigationTitle(propertyAddress)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchInspectionDetails)
    }
    
    // Üst bilgi ve butonları içeren görünüm.
    private var headerView: some View {
        HStack {
            Text("Denetim Raporları")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Menu {
                Button("Değişiklik İste", action: { updateInspectionStatus("request_changes") })
                Button("Raporu Onayla", action: { updateInspectionStatus("approve") })
            } label: {
                Label("Eylemler", systemImage: "ellipsis.circle")
            }
        }
    }
    
    // Tek bir denetim raporunu (sadece move-in) gösteren görünüm.
    private func singleInspectionView(inspection: InspectionData) -> some View {
        VStack(alignment: .leading) {
            Text("Giriş Raporu (Move-in)").font(.headline)
            ForEach(inspection.evidence) { ev in
                evidenceRow(ev)
            }
        }
    }
    
    // Move-in ve Move-out raporlarını yan yana karşılaştıran görünüm.
    private func comparisonView(moveIn: InspectionData, moveOut: InspectionData) -> some View {
        VStack {
            Text("Giriş ve Çıkış Karşılaştırması")
                .font(.title3)
                .fontWeight(.bold)
            
            // Bu örnekte, her iki rapordaki ilk kanıtı yan yana gösteriyoruz.
            // Gerçek uygulamada bu, oda bazında veya kanıt bazında daha detaylı olabilir.
            HStack(alignment: .top, spacing: 10) {
                VStack {
                    Text("Giriş (Move-in)").font(.headline)
                    if let evidence = moveIn.evidence.first {
                        evidenceRow(evidence)
                    }
                }
                Divider()
                VStack {
                    Text("Çıkış (Move-out)").font(.headline)
                    if let evidence = moveOut.evidence.first {
                        evidenceRow(evidence)
                    }
                }
            }
        }
    }
    
    // Tek bir kanıtı gösteren satır.
    private func evidenceRow(_ evidence: Evidence) -> some View {
        VStack(alignment: .leading) {
            Image(systemName: evidence.thumbnailUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .cornerRadius(8)
            Text(evidence.fileName).font(.caption)
            if let note = evidence.note {
                Text("Not: \(note)").font(.caption).italic()
            }
        }.padding(.bottom)
    }
    
    // Yorum ekleme alanı.
    private var commentSection: some View {
        VStack(alignment: .leading) {
            Text("Yorum Ekle").font(.headline)
            TextEditor(text: $commentText)
                .frame(height: 100)
                .border(Color.gray, width: 0.2)
                .cornerRadius(8)
            Button("Yorumu Gönder", action: postComment)
        }
    }

    // --- API Fonksiyonları ---
    
    private func fetchInspectionDetails() {
        print("API -> GET /agency/inspections/{id} veya /compare çağrılıyor...")
        // Simülasyon: Hem move-in hem de move-out verisi olduğunu varsayalım.
        self.moveInData = InspectionData(
            id: "insp_123", type: "move_in", evidence: [
                Evidence(id: "ev_1", fileName: "movein_kitchen.jpg", thumbnailUrl: "photo.fill", note: "Yeni gibi.")
            ]
        )
        self.moveOutData = InspectionData(
            id: "insp_456", type: "move_out", evidence: [
                Evidence(id: "ev_10", fileName: "moveout_kitchen.jpg", thumbnailUrl: "photo.fill", note: "Fırın kapağında çizik var.")
            ]
        )
    }
    
    private func postComment() {
        guard !commentText.isEmpty else { return }
        print("API -> POST /agency/inspections/{id}/comments çağrılıyor...")
        print("Body: { text: \"\(commentText)\" }")
        // Simülasyon: Başarılı istek sonrası alanı temizle.
        self.commentText = ""
    }
    
    private func updateInspectionStatus(_ status: String) {
        print("API -> POST /agency/inspections/{id}/status çağrılıyor...")
        print("Body: { status: \"\(status)\" }")
    }
}

// #Preview için.
struct InspectionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InspectionDetailView(propertyId: "prop_123", propertyAddress: "123 Preview St, Sydney")
        }
    }
}
