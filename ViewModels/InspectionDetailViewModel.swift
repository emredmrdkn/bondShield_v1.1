
import Foundation

// InspectionDetailView için veri ve iş mantığını yöneten ViewModel.
@MainActor
class InspectionDetailViewModel: ObservableObject {
    // @Published, bu değişken değiştiğinde SwiftUI'ın view'u güncellemesini sağlar.
    @Published var inspection: Inspection? = nil
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // Belirli bir denetimin detaylarını çeken fonksiyon.
    func fetchInspectionDetails(for inspectionId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // Gerçek API çağrısını burada yaparsınız.
            // Şimdilik 2 saniyelik bir gecikme ile sahte veri oluşturuyoruz.
            try await Task.sleep(nanoseconds: 2_000_000_000)
            self.inspection = Inspection(id: inspectionId, propertyId: "1", date: Date(), inspector: "Emre D.", status: "Devam Ediyor")
        } catch {
            errorMessage = "Denetim detayları yüklenirken bir hata oluştu: (error.localizedDescription)"
        }

        isLoading = false
    }
}
