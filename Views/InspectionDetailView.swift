
import SwiftUI

// InspectionDetailView, bir denetimin detaylarını gösterir.
// ViewModel'den aldığı verileri gösterir ve kullanıcı etkileşimlerini ViewModel'e iletir.
struct InspectionDetailView: View {
    
    // ViewModel'i bir StateObject olarak oluşturuyoruz.
    @StateObject private var viewModel = InspectionDetailViewModel()
    
    let inspectionId: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Denetim Detayları Yükleniyor...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if let inspection = viewModel.inspection {
                    inspectionDetailContent(inspection: inspection)
                } else {
                    Text("Denetim detayı bulunamadı.")
                }
            }
            .padding()
        }
        .navigationTitle("Denetim Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // View göründüğünde ViewModel'den denetim detaylarını çekmesini istiyoruz.
            await viewModel.fetchInspectionDetails(for: inspectionId)
        }
    }
    
    // Denetim detaylarını gösteren ana içerik.
    private func inspectionDetailContent(inspection: Inspection) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            detailRow(label: "Durum", value: inspection.status)
            detailRow(label: "Denetçi", value: inspection.inspector)
            detailRow(label: "Tarih", value: inspection.date, format: .date)
            
            Divider()
            
            // Bu denetime ait odaları listelemek için bir sonraki adıma yönlendirme
            NavigationLink(destination: RoomListView(inspectionId: inspection.id)) {
                HStack {
                    Text("Denetimi Başlat / Devam Et")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
    
    // Detay satırlarını oluşturan yardımcı bir view.
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .fontWeight(.bold)
            Text(value)
            Spacer()
        }
    }
    
    // Tarih formatlaması için overload edilmiş bir yardımcı view.
    private func detailRow(label: String, value: Date, format: Date.FormatStyle) -> some View {
        HStack {
            Text("\(label):")
                .fontWeight(.bold)
            Text(value, format: format)
            Spacer()
        }
    }
}

// Preview için.
struct InspectionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InspectionDetailView(inspectionId: "insp_preview_123")
        }
    }
}
