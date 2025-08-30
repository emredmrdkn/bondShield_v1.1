
import SwiftUI

// PropertiesListView, ViewModel'den aldığı verileri gösterir ve kullanıcı etkileşimlerini ViewModel'e iletir.
struct PropertiesListView: View {
    
    // ViewModel'i bir StateObject olarak oluşturuyoruz.
    // Bu, view'un yaşam döngüsü boyunca ViewModel'in tek bir örneğinin kalmasını sağlar.
    @StateObject private var viewModel = PropertiesListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // ViewModel'in yüklenme durumuna göre farklı görünümler gösterilir.
                if viewModel.isLoading {
                    ProgressView("Mülkler Yükleniyor...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.properties.isEmpty {
                    emptyStateView
                } else {
                    propertiesList
                }
            }
            .navigationTitle("Mülklerim")
            .task {
                // .task, bu view göründüğünde asenkron bir işlemi başlatmanın modern yoludur.
                // Eğer mülkler daha önce yüklenmediyse, ViewModel'den verileri çekmesini isteriz.
                if viewModel.properties.isEmpty {
                    await viewModel.fetchProperties()
                }
            }
        }
    }
    
    // Mülklerin listelendiği ana görünüm.
    private var propertiesList: some View {
        List(viewModel.properties) { property in
            NavigationLink(destination: InspectionListView(property: property)) {
                HStack(spacing: 15) {
                    Image(systemName: "house.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(property.name)
                            .font(.headline)
                        Text(property.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 10)
            }
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
}

// InspectionListView için bir önizleme ve yer tutucu.
// Bu, projenin diğer kısımları tamamlanana kadar derleme hatalarını önler.
struct InspectionListView: View {
    let property: Property
    var body: some View {
        Text("\(property.name) için denetimler listelenecek.")
            .navigationTitle(property.name)
    }
}

#Preview {
    PropertiesListView()
}
