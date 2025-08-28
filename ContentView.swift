//
//  ContentView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // Uygulama açıldığında ilk olarak LoginView'ı göster.
        // Başarılı bir girişten sonra bu görünüm, PropertiesListView'a veya AgencyDashboardView'a yönlendirmelidir.
        // Şimdilik, başlangıç noktası olarak LoginView'ı kullanıyoruz.
        NavigationView {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
