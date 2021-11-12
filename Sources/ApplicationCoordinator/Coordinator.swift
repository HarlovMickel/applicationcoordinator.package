//
//  Coordinator.swift
//  
//
//  Created by Mickel Harlov on 09.11.2021.
//

import UIKit

// MARK: Coordinator implementation
public class Coordinator<Controller: UIViewController> {
    
    // MARK: Typealias
    public typealias CompleteFlow = (Coordinator) -> Void
    
    // MARK: Properties
    public let router: Router<Controller>
    public var coordinators = [Coordinator]()
    private var completions = [CompleteFlow]()
    
    // MARK: Public methods
    public init(controller: Controller) {
        self.router = Router(controller: controller)
    }
}

// MARK: Coordinator (Public)
extension Coordinator {
    
    public func start() {}
    public func runFlow(with coordinator: Coordinator,
                        completion: CompleteFlow? = nil) {
        if let completion = completion {
            coordinator.completions.append(completion)
        }
        coordinator.completions.append { [unowned self] child in
            remove(coordinator: child)
        }
        add(coordinator: coordinator)
        coordinator.start()
    }
    public func completeFlow() {
        completions.forEach { $0(self) }
        completions.removeAll()
    }
}

// MARK: Coordinator (Private)
extension Coordinator {
    
    private func add(coordinator: Coordinator) {
        let contains = coordinators.contains { $0 === coordinator }
        if !contains { coordinators.append(coordinator) }
    }
    private func remove(coordinator: Coordinator) {
        coordinators.removeAll { $0 === coordinator }
    }
}
