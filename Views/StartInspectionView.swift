//
//  StartInspectionView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// StartInspectionView, yeni bir denetim oturumu başlatma arayüzünü sağlar.
// API Endpoint: POST /inspections
struct StartInspectionView: View {
    
    // Önceki ekrandan (PropertiesListView) gelen mülk bilgisi.
    let property: Property
    
    // Gezinme durumunu yönetmek için state. Denetim oluşturulduğunda true olur.
    @State private var navigateToRoomList = false
    @State private var createdInspectionId: String? // Oluşturulan denetimin ID'si
    
    var body: some View {
        VStack(spacing: 40) {
            // Mülk adresi başlık olarak gösterilir.
            Text(property.address)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Lütfen denetim türünü seçin:")
                .font(.headline)
            
            // "Move-in" denetimini başlatan buton.
            Button(action: { 
                startInspection(type: "move_in")
            }) {
                Text("Giriş Denetimini Başlat (Move-in)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            // "Move-out" denetimini başlatan buton.
            Button(action: { 
                startInspection(type: "move_out")
            }) {
                Text("Çıkış Denetimini Başlat (Move-out)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Denetimi Başlat")
        .background(
            // Denetim başarıyla oluşturulduğunda RoomListView'a yönlendirme yapar.
            NavigationLink(
                destination: RoomListView(inspectionId: createdInspectionId ?? ""),
                isActive: $navigateToRoomList
            ) { 
                EmptyView() 
            }
        )
    }
    
    // Bir denetim oturumu oluşturmak için API isteği gönderen fonksiyon.
    private func startInspection(type: String) {
        print("API -> POST /inspections çağrılıyor...")
        print("Body: { propertyId: \(property.id), type: \"\(type)\" }")
        
        // --- API Çağrısı Simülasyonu ---
        // Gerçek uygulamada, burada bir ağ isteği yapılacak.
        // Başarılı olursa, sunucudan bir denetim ID'si dönecek.
        let newInspectionId = "insp_" + UUID().uuidString
        self.createdInspectionId = newInspectionId
        // --------------------------------
        
        // Başarılı API cevabından sonra oda listesi ekranına geçişi tetikle.
        self.navigateToRoomList = true
    }
}

// #Preview için örnek bir Mülk nesnesi oluşturma.
struct StartInspectionView_Previews: PreviewProvider {
    static var previews: some View {
        // NavigationView içinde önizleme yapmak, başlığın görünmesini sağlar.
        NavigationView {
            StartInspectionView(property: Property(id: UUID(), address: "123 Preview St, Sydney", imageUrl: "house.fill"))
        }
    }
}
