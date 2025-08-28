//
//  RoomListView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// Oda verisini temsil eden struct.
// Model: rooms(id, inspectionId, name, orderIndex)
struct Room: Identifiable {
    let id: String
    let name: String
    // TODO: checklist_items(id, roomId, label, ...) eklenecek.
}

// RoomListView, bir denetime ait odaları ve ilerlemeyi gösterir.
// API Endpoints: GET /inspections/{id}/rooms, POST /inspections/{id}/rooms
struct RoomListView: View {
    
    // Önceki ekrandan gelen denetim ID'si.
    let inspectionId: String
    
    // Oda listesini tutan state.
    @State private var rooms: [Room] = []
    @State private var showingAddRoomAlert = false
    @State private var newRoomName = ""

    var body: some View {
        VStack {
            if rooms.isEmpty {
                ProgressView("Odalar yükleniyor...")
            } else {
                List(rooms) { room in
                    // Her oda, fotoğraf çekim ekranına (CaptureView) yönlendirir.
                    NavigationLink(destination: CaptureView(inspectionId: inspectionId, roomId: room.id, roomName: room.name)) {
                        HStack {
                            Image(systemName: "door.left.hand.open")
                            Text(room.name)
                            Spacer()
                            // TODO: Odanın tamamlanma durumunu gösteren bir ikon eklenebilir.
                        }
                    }
                }
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
            // Yeni oda eklemek için buton.
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddRoomAlert = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear(perform: fetchRooms) // Ekran göründüğünde odaları çek.
        .alert("Yeni Oda Ekle", isPresented: $showingAddRoomAlert) {
            TextField("Oda Adı (örn: Balkon)", text: $newRoomName)
            Button("İptal", role: .cancel) { }
            Button("Ekle") { 
                addRoom(name: newRoomName)
            }
        } message: {
            Text("Lütfen eklenecek özel odanın adını girin.")
        }
    }
    
    // API'den odaları çeken fonksiyon.
    private func fetchRooms() {
        print("API -> GET /inspections/\(inspectionId)/rooms çağrılıyor...")
        // Simülasyon: Normalde burada ağ isteği yapılır.
        // Locale'ye göre varsayılan oda şablonları (Mutfak, Banyo, vb.) yüklenir.
        self.rooms = [
            Room(id: "room_1", name: "Mutfak"),
            Room(id: "room_2", name: "Salon"),
            Room(id: "room_3", name: "Yatak Odası 1"),
            Room(id: "room_4", name: "Banyo")
        ]
    }
    
    // Yeni bir oda eklemek için API isteği gönderen fonksiyon.
    private func addRoom(name: String) {
        guard !name.isEmpty else { return }
        print("API -> POST /inspections/\(inspectionId)/rooms çağrılıyor...")
        print("Body: { name: \"\(name)\" }")
        // Simülasyon: Başarılı API cevabından sonra liste güncellenir.
        let newRoom = Room(id: "room_" + UUID().uuidString, name: name)
        self.rooms.append(newRoom)
        self.newRoomName = "" // Alanı temizle
    }
}

// #Preview için.
struct RoomListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RoomListView(inspectionId: "insp_preview_123")
        }
    }
}
