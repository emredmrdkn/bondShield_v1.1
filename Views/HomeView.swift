//
//  HomeView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// HomeView, uygulamanın ana ekranını temsil eder.
struct HomeView: View {
    // body, görünümün içeriğini ve düzenini tanımlar.
    var body: some View {
        // VStack, elemanları dikey olarak hizalar.
        VStack {
            Text("Ana Sayfa")
                .font(.largeTitle) // Başlık fontu ayarlar
                .padding() // Kenar boşluğu ekler
            
            // TODO: Ana sayfa içeriği buraya eklenecek
        }
    }
}

// #Preview, geliştirme sırasında HomeView'in bir önizlemesini gösterir.
#Preview {
    HomeView()
}
