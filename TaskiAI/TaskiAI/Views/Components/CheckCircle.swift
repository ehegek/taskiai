import SwiftUI

struct CheckCircle: View {
    var checked: Bool
    var body: some View {
        ZStack {
            Circle().stroke(lineWidth: 2)
            if checked {
                Image(systemName: "checkmark")
            }
        }
        .frame(width: 24, height: 24)
    }
}
