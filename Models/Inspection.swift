
import Foundation

// Bir denetimin tüm detaylarını içeren ana veri modeli.
struct Inspection: Identifiable, Codable {
    var id: String
    var propertyId: String // Hangi mülke ait olduğunu belirtir.
    var date: Date
    var inspector: String
    var status: String // Örn: "Planlandı", "Devam Ediyor", "Tamamlandı"
}
