//
//  UIKitPublisher.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/05.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import Combine

extension UIControl {
    
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        UIControl.EventPublisher(control: self, event: event)
    }
    
    // Publisher
    struct EventPublisher: Publisher {
        
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            subscriber.receive(
                subscription: EventSubscription(
                    control: control,
                    subscrier: subscriber,
                    event: event)
            )
        }
    }
    
    // Subscription
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {
        
        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event
            addTarget()
        }
        
        private func addTarget(){
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}
