
import SwiftUI

// RoomListView, bir denetime ait odaları ve ilerlemeyi gösterir.
// ViewModel'den aldığı verileri gösterir ve kullanıcı etkileşimlerini ViewModel'e iletir.
struct RoomListView: View {
    
    // ViewModel'i bir StateObject olarak oluşturuyoruz.
    @StateObject private var viewModel = RoomListViewModel()
    
    // Önceki ekrandan gelen denetim ID'si.
    let inspectionId: String
    
    @State private var showingAddRoomAlert = false
    @State private var newRoomName = ""

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Odalar yükleniyor...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                roomList
            }
            
            // Rapor oluşturma ekranına geçiş butonu
            NavigationLink(destination: ReviewAndGeneratePDFView(inspectionId: inspectionId)) {
                 Text("Gözden Geçir ve Bitir")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .padding()
        }
        .navigationTitle("Odalar")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddRoomAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            // View göründüğünde ViewModel'den odaları çekmesini istiyoruz.
            await viewModel.fetchRooms(for: inspectionId)
        }
        .alert("Yeni Oda Ekle", isPresented: $showingAddRoomAlert) {
            TextField("Oda Adı (örn: Balkon)", text: $newRoomName)
            Button("İptal", role: .cancel) { }
            Button("Ekle") { 
                // TODO: Bu işlevselliği ViewModel'e taşı
                // addRoom(name: newRoomName)
            }
        } message: {
            Text("Lütfen eklenecek özel odanın adını girin.")
        }
    }
    
    // Odaların listelendiği görünüm.
    private var roomList: some View {
        List(viewModel.rooms) { room in
            NavigationLink(destination: CaptureView(inspectionId: inspectionId, roomId: room.id, roomName: room.name)) {
                HStack {
                    Image(systemName: "door.left.hand.open")
                    Text(room.name)
                    Spacer()
                }
            }
        }
    }
}

// Preview için.
struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RoomListView(inspectionId: "insp_preview_123")
        }
    }
}
