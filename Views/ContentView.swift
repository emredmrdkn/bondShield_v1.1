
//
//  ContentView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// ContentView, uygulamanın ana görünümünü temsil eden yapıdır.
struct ContentView: View {
    // body, görünümün içeriğini ve düzenini tanımlar.
    var body: some View {
        // VStack, elemanları dikey olarak hizalar.
        VStack {
            // Image, bir sistem ikonunu (bu durumda bir dünya küresi) gösterir.
            Image(systemName: "globe")
                .imageScale(.large) // İkonun boyutunu büyütür.
                .foregroundStyle(.tint) // İkonun rengini varsayılan renk tonuna ayarlar.
            // Text, "Welcome bondShield world!" metnini gösterir.
            Text("Welcome bondShield world!")
        }
        .padding() // VStack'in etrafına boşluk ekler.
    }
}

// #Preview, geliştirme sırasında ContentView'in bir önizlemesini gösterir.
#Preview {
    ContentView()
}
