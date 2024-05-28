//
//  PassthroughSubjectPublisher.swift
//  SwiftUIPublishers
//
//  Created by Saurabh Bisht on 28/05/24.
//

import SwiftUI
import Combine

class PassthroughSubjectViewModel: ObservableObject {
    @Published var tapCount: Int = 0
    
    private var cancellable: AnyCancellable?
    private let buttonTapSubject = PassthroughSubject<Void, Never>()
    
    init() {
        cancellable = buttonTapSubject
            .sink { [weak self] in
                self?.tapCount += 1
            }
    }
    
    func buttonTapped() {
        buttonTapSubject.send()
    }
}

struct PassthroughSubjectView: View {
    @ObservedObject var viewModel = PassthroughSubjectViewModel()
    
    var body: some View {
        VStack {
            Text("Current Count \(viewModel.tapCount)")
                .font(.largeTitle)
                .padding()
            Button(action: {
                viewModel.buttonTapped()
            }) {
                Text("Tap")
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

struct PassthroughSubjectView_Previews: PreviewProvider {
    static var previews: some View {
        PassthroughSubjectView()
    }
}
