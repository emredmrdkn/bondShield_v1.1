
import Foundation

// RoomListView için veri ve iş mantığını yöneten ViewModel.
@MainActor
class RoomListViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    // Belirli bir denetime ait odaların listesini çeken fonksiyon.
    func fetchRooms(for inspectionId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // Ağ isteğini simüle ediyoruz.
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 saniye bekle
            self.rooms = [
                Room(id: "101", name: "Salon", inspectionId: inspectionId),
                Room(id: "102", name: "Mutfak", inspectionId: inspectionId),
                Room(id: "103", name: "Yatak Odası", inspectionId: inspectionId),
                Room(id: "104", name: "Banyo", inspectionId: inspectionId)
            ]
        } catch {
            errorMessage = "Odalar yüklenirken bir hata oluştu: (error.localizedDescription)"
        }
        isLoading = false
    }
}
