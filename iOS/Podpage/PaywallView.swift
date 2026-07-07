import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "star.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.accent)
                Text("Podpage - Podcast Log Pro")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.foreground)
                Text("Series stats, listening streaks, export")
                    .font(Theme.bodyFont)
                    .foregroundStyle(Theme.foreground.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer().frame(height: 8)
                Button {
                    Task { await purchases.purchase() }
                } label: {
                    Text(purchases.product != nil ? "Subscribe \(purchases.product!.displayPrice)/mo" : "Subscribe")
                        .font(Theme.bodyFont.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundStyle(Theme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .accessibilityIdentifier("subscribeButton")
                .padding(.horizontal)

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .foregroundStyle(Theme.foreground.opacity(0.7))

                Button("Not now") { dismiss() }
                    .foregroundStyle(Theme.foreground.opacity(0.5))
                    .accessibilityIdentifier("dismissPaywallButton")
            }
            .padding()
        }
    }
}
