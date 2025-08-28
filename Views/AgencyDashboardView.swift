//
//  AgencyDashboardView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// Emlakçı paneli için örnek veri yapıları.
struct AgencyPortfolioProperty: Identifiable {
    let id: String
    let address: String
    let activeInspectionCount: Int
    let tenantName: String?
}

struct AgencyNotification: Identifiable {
    let id: String
    let message: String
    let date: String
}

// AgencyDashboardView, emlakçının portföyünü ve görevlerini yönetir.
// API Endpoints: GET /agency/portfolio, GET /agency/inspections, GET /agency/notifications
struct AgencyDashboardView: View {
    
    @State private var portfolio: [AgencyPortfolioProperty] = []
    @State private var notifications: [AgencyNotification] = []
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Seçim", selection: $selectedTab) {
                    Text("Mülk Portföyü").tag(0)
                    Text("Bildirimler").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == 0 {
                    portfolioListView
                } else {
                    notificationListView
                }
            }
            .navigationTitle("Emlakçı Paneli")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: inviteTenant) {
                        Image(systemName: "person.fill.badge.plus")
                    }
                }
            }
            .onAppear {
                fetchPortfolio()
                fetchNotifications()
            }
        }
    }
    
    // Mülk portföyünü listeleyen görünüm.
    private var portfolioListView: some View {
        List(portfolio) { property in
            NavigationLink(destination: InspectionDetailView(propertyId: property.id, propertyAddress: property.address)) {
                VStack(alignment: .leading) {
                    Text(property.address).font(.headline)
                    Text("Kiracı: \(property.tenantName ?? "Boş")")
                    Text("Aktif Denetimler: \(property.activeInspectionCount)")
                        .foregroundColor(property.activeInspectionCount > 0 ? .orange : .secondary)
                }
                .padding(.vertical, 5)
            }
        }
    }
    
    // Bildirimleri listeleyen görünüm.
    private var notificationListView: some View {
        List(notifications) { notification in
            VStack(alignment: .leading) {
                Text(notification.message)
                Text(notification.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // --- API Fonksiyonları ---
    
    private func fetchPortfolio() {
        print("API -> GET /agency/portfolio çağrılıyor...")
        self.portfolio = [
            .init(id: "prop_1", address: "123 Queen St, Sydney", activeInspectionCount: 1, tenantName: "John Appleseed"),
            .init(id: "prop_2", address: "456 King St, Melbourne", activeInspectionCount: 0, tenantName: "Jane Doe")
        ]
    }
    
    private func fetchNotifications() {
        print("API -> GET /agency/notifications çağrılıyor...")
        self.notifications = [
            .init(id: "notif_1", message: "123 Queen St için yeni giriş raporu yüklendi.", date: "2 saat önce"),
            .init(id: "notif_2", message: "Kiracı John Appleseed, mülke katılma davetini kabul etti.", date: "1 dün önce")
        ]
    }
    
    private func inviteTenant() {
        print("API -> POST /agency/invite-tenant çağrılıyor...")
        // TODO: Kiracı davet etme arayüzü gösterilecek.
    }
}

// #Preview için.
struct AgencyDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AgencyDashboardView()
    }
}
