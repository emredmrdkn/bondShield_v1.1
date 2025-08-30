
import Foundation

// PropertiesListView için veri ve iş mantığını yöneten ViewModel.
@MainActor // UI güncellemelerinin ana iş parçacığında yapılmasını sağlar.
class PropertiesListViewModel: ObservableObject {
    
    // Yayınlanan değişkenler, SwiftUI tarafından gözlemlenir ve değişiklik olduğunda UI'ı günceller.
    @Published var properties: [Property] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // API'den mülklerin listesini çeken fonksiyon.
    func fetchProperties() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Burada gerçek API isteği yapılacak.
            // Şimdilik örnek verilerle dolduruyoruz.
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 saniye bekleme simülasyonu.
            self.properties = [
                Property(id: "1", name: "Lüks Villa", address: "123 Sahil Yolu, Belek"),
                Property(id: "2", name: "Şehir Merkezi Daire", address: "456 Atatürk Cad, Antalya"),
                Property(id: "3", name: "Dağ Evi", address: "789 Toroslar, Kemer")
            ]
        } catch {
            errorMessage = "Mülkler yüklenirken bir hata oluştu: (error.localizedDescription)"
        }
        
        isLoading = false
    }
}
