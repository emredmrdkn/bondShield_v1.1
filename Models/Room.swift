
import Foundation

// Bir denetimdeki her bir odayı temsil eden veri modeli.
struct Room: Identifiable, Codable {
    var id: String
    var name: String
    var inspectionId: String // Hangi denetime ait olduğunu belirtir.
}
