//
//  CurrentValueSubjectPublisher.swift
//  SwiftUIPublishers
//
//  Created by Saurabh Bisht on 28/05/24.
//

import SwiftUI
import Combine

class CurrentValueSubjectViewModel: ObservableObject {
    @Published var currentValue: String = ""
    
    private var cancellable: AnyCancellable?
    private let currentValueSubject = CurrentValueSubject<String, Never>("5")
    
    init() {
        cancellable = currentValueSubject
            .sink { [weak self] value in
                self?.currentValue = value
            }
    }
    
    func updateValue(newValue: String) {
        currentValueSubject.send(newValue)
    }
}

struct CurrentValueSubjectView: View {
    @ObservedObject var viewModel = CurrentValueSubjectViewModel()
    @State private var textFieldValue: String = ""
    
    var body: some View {
        VStack {
            Text("Current value: \(viewModel.currentValue)")
                .font(.largeTitle)
                .padding()
            TextField("Enter new value", text: $textFieldValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                viewModel.updateValue(newValue: textFieldValue)
            }) {
                Text("Update Value")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}

struct CurrentValueSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentValueSubjectView()
    }
}
