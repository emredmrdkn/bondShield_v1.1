
import Foundation

// Mülklerin listelendiği ekrandaki her bir mülkü temsil eden veri modeli.
struct Property: Identifiable, Codable {
    var id: String
    var name: String
    var address: String
    var imageUrl: String? // Opsiyonel, çünkü her mülkün resmi olmayabilir.
}
