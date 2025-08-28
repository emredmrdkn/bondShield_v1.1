//
//  PropertiesListView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// Mülk verisini temsil eden basit bir struct. API modeline göre genişletilecek.
// Model: properties(id, address_line, unit, city, state, postcode, agencyId, geo)
struct Property: Identifiable {
    let id: UUID
    let address: String
    let imageUrl: String // Mülk görseli için bir alan
}

// PropertiesListView, kiracının ilişkili olduğu mülkleri listeler.
// API Endpoint: GET /properties?as=tenant
struct PropertiesListView: View {
    
    // Örnek mülk verileri. Bu dizi, API'den gelen gerçek veriyle doldurulacak.
    @State private var properties: [Property] = [
        Property(id: UUID(), address: "123 Apple St, Sydney NSW 2000", imageUrl: "house.fill"),
        Property(id: UUID(), address: "456 Orange Ave, Melbourne VIC 3000", imageUrl: "building.2.fill"),
        Property(id: UUID(), address: "789 Banana Rd, Brisbane QLD 4000", imageUrl: "house.circle.fill")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Eğer hiç mülk yoksa gösterilecek boş durum ekranı.
                if properties.isEmpty {
                    emptyStateView
                } else {
                    // Mülkleri listeleyen ana görünüm.
                    List(properties) { property in
                        // Her bir mülk için satır görünümü ve gezinme linki
                        NavigationLink(destination: StartInspectionView(property: property)) {
                            HStack(spacing: 15) {
                                Image(systemName: property.imageUrl)
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text(property.address)
                                        .font(.headline)
                                    // Opsiyonel: GET /properties/{id}/last-inspections özetini göstermek için alan
                                    Text("Son denetim: Beklemede")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                }
            }
            .navigationTitle("Mülklerim") // Ekran başlığı
            .onAppear(perform: fetchProperties) // Ekran göründüğünde verileri çek
        }
    }
    
    // Mülk listesi boş olduğunda gösterilecek görünüm.
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Image(systemName: "house.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Henüz bir mülke bağlı değilsiniz.")
                .padding()
            // Opsiyonel: POST /properties/join (davet kodu ile katılma akışı)
            Button(action: { /* Davet kodu ile katılma ekranını aç */ }) {
                Text("Davet Kodu ile Mülke Katıl")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
    
    // API'den mülk listesini çekmek için fonksiyon.
    private func fetchProperties() {
        // TODO: API -> GET /properties?as=tenant çağrısını yap
        // Gelen veriyi 'properties' state'ine ata.
        print("API'den mülk listesi çekiliyor...")
    }
}

// StartInspectionView'in bu dosyadan erişilebilir olması için ön tanım.
// Bu, derleme hatası almamak için geçici bir çözümdür.
// Gerçek StartInspectionView dosyası ayrı olarak yönetilecek.
struct StartInspectionView_PreviewProvider_Placeholder: View {
    var property: Property
    var body: some View {
        Text("\(property.address) için denetimi başlat.")
    }
}

#Preview {
    PropertiesListView()
}
