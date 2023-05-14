import SwiftUI

let a:Double = Double(300 + (180 / 2))
let b:Double = Double(500 - (180 / 2))
let limitAngle:Double = 2.0 * asin(Double(a / b)) * 180 / .pi

print(limitAngle)
print(a / b)
print(asin(a / b))

