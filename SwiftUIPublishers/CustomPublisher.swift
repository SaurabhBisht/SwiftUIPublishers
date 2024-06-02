//
//  CustomPublisher.swift
//  SwiftUIPublishers
//
//  Created by Saurabh Bisht on 01/06/24.
//

import SwiftUI
import Combine

struct CustomPublisher: View {
    @State private var numbers: [Int] = []
    
    var body: some View {
        VStack {
            List(numbers, id: \.self) { number in
                Text("\(number)")
            }
            .onAppear {
                let numberPublisher = NumberPublisher(numbers: Array(1...10))
                numberPublisher
                    .sink { number in
                        print(number)
                        numbers.append(number)
                    }
                    .store(in: &cancellables)
            }
        }
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}

#Preview {
    CustomPublisher()
}

struct NumberPublisher: Publisher {
    typealias Output = Int
    typealias Failure = Never
    
    let numbers: [Int]
    
    func receive<S>(subscriber: S) where S : Subscriber, NumberPublisher.Failure == S.Failure, NumberPublisher.Output == S.Input {
        let subscription = NumberSubscription(subscriber: subscriber, numbers: numbers)
        subscriber.receive(subscription: subscription)
    }
}

final class NumberSubscription<S: Subscriber>: Subscription where S.Input == Int, S.Failure == Never {
    private var subscriber: S?
    private let numbers: [Int]
    
    init(subscriber: S, numbers: [Int]) {
        self.subscriber = subscriber
        self.numbers = numbers
    }
    
    func request(_ demand: Subscribers.Demand) {
        var currentDemand = demand
        
        for number in numbers {
            if currentDemand == .none {
                break
            }
            _ = subscriber?.receive(number)
            currentDemand -= 1
        }
        
        subscriber?.receive(completion: .finished)
    }
    
    func cancel() {
        subscriber = nil
    }
}
