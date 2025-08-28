//
//  LoginView.swift
//  bondshield_v1
//
//  Created by Emre Demirdöken on 21.08.2025.
//

import SwiftUI

// LoginView, kullanıcı girişi ve kaydı için arayüzü yönetir.
// API Endpointleri: /auth/login, /auth/signup, /auth/forgot-password
struct LoginView: View {
    
    // Ekranın modunu (Giriş veya Kayıt) yöneten state
    @State private var isSigningUp = false
    
    // Form alanları için state değişkenleri
    @State private var email = ""
    @State private var password = ""
    @State private var name = "" // Sadece kayıt olurken kullanılır

    var body: some View {
        VStack(spacing: 20) {
            Text("BondShield")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            // isSigningUp durumuna göre isim alanı gösterilir
            if isSigningUp {
                TextField("Ad Soyad", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8.0)
            }
            
            // E-posta giriş alanı
            TextField("E-posta", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8.0)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            // Şifre giriş alanı
            SecureField("Şifre", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8.0)

            // Ana eylem butonu (Giriş veya Kayıt)
            Button(action: handlePrimaryAction) {
                Text(isSigningUp ? "Hesap Oluştur" : "Giriş Yap")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .padding(.top)
            
            // İkincil eylemler (Kayıt ol / Şifremi unuttum)
            HStack {
                Button(action: {
                    isSigningUp.toggle() // Modu değiştir
                }) {
                    Text(isSigningUp ? "Zaten hesabın var mı? Giriş Yap" : "Hesap Oluştur")
                }
                
                Spacer()
                
                if !isSigningUp {
                    Button(action: handleForgotPassword) {
                        Text("Şifremi Unuttum")
                    }
                }
            }
            .font(.footnote)
            .padding(.horizontal)

        }
        .padding()
    }
    
    // Ana butona tıklandığında çalışacak fonksiyon
    func handlePrimaryAction() {
        if isSigningUp {
            // TODO: API -> POST /auth/signup (email, password, name)
            print("Kayıt işlemi başlatılıyor: \(name), \(email)")
        } else {
            // TODO: API -> POST /auth/login (email, password)
            print("Giriş işlemi başlatılıyor: \(email)")
            // Başarılı giriş sonrası: GET /me çağrısı ve Properties List ekranına yönlendirme
        }
    }
    
    // Şifre sıfırlama linkine tıklandığında çalışacak fonksiyon
    func handleForgotPassword() {
        // TODO: API -> POST /auth/forgot-password (email)
        print("Şifre sıfırlama talebi gönderildi: \(email)")
    }
}

#Preview {
    LoginView()
}
