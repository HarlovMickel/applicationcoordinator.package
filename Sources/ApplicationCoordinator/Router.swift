//
//  Router.swift
//  
//
//  Created by Mickel Harlov on 09.11.2021.
//

import UIKit
import UIKitExtension

// MARK: RouterProtocol protocol
public protocol RouterProtocol {
    
    // MARK: Associatedtype
    associatedtype Controller: UIViewController
    
    // MARK: Properties
    var controller: Controller { get }
}

// MARK: RouterProtocol (UIViewController)
extension RouterProtocol {
    
    public func present(controller: UIViewController, animated: Bool = true,
                        presentationStyle: UIModalPresentationStyle = .fullScreen,
                        completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = presentationStyle
        self.controller.present(controller, animated: animated, completion: completion)
    }
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        controller.dismiss(animated: animated, completion: completion)
    }
}

// MARK: RouterProtocol (UINavigationController)
extension RouterProtocol where Controller == UINavigationController {
    
    public func run(controller: UIViewController, animated: Bool = true) {
        self.controller.setViewControllers([ controller ], animated: animated)
    }
    public func push(controller: UIViewController, animated: Bool = true) {
        self.controller.pushViewController(controller, animated: animated)
    }
    public func pop(animated: Bool = true) {
        self.controller.popViewController(animated: animated)
    }
    public func popToRoot(animated: Bool = true) {
        self.controller.popToRootViewController(animated: animated)
    }
}

// MARK: RouterProtocol (RootRouter)
extension RouterProtocol {
    
    public func run() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            scene.keyWindow?.rootViewController = controller
        }
    }
}

// MARK: Router implementation
public struct Router<Controller: UIViewController>: RouterProtocol {
    
    // MARK: Properties
    public let controller: Controller
}
