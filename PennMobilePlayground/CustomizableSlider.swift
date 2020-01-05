//
//  CustomizableSlider.swift
//  PennMobilePlayground
//
//  Created by Dominic Holmes on 1/5/20.
//  Copyright © 2020 Dominic Holmes. All rights reserved.
//

import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SwiftUISlider
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Binding<Double>
        
        // Create the binding when you initialize the Coordinator
        init(value: Binding<Double>) {
            self.value = value
        }
        
        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
        }
    }
    var min: Double
    var max: Double
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?
    var minImageName: String? = nil
    var maxImageName: String? = nil
    
    
    @Binding var value: Double
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.tintColor = .gray
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.value = Float(value)
        slider.maximumValue = Float(max)
        slider.minimumValue = Float(min)
        
        if let imageName = minImageName {
            let image = UIImage(systemName: imageName)
            slider.minimumValueImage =  image?.withRenderingMode(.alwaysTemplate).withTintColor(minTrackColor ?? .gray)
        }
        if let imageName = maxImageName {
            let image = UIImage(systemName: imageName)
            slider.maximumValueImage =  image?.withRenderingMode(.alwaysTemplate).withTintColor(maxTrackColor ?? .gray)
        }
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.value = Float(self.value)
    }
    
    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value)
    }
}

#if DEBUG
struct SwiftUISlider_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISlider(
            min: 0, max: 1,
            minTrackColor: .blue,
            maxTrackColor: .green,
            value: .constant(0.5)
        )
    }
}
#endif
