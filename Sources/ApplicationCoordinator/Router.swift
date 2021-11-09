//
//  Router.swift
//  
//
//  Created by Mickel Harlov on 09.11.2021.
//

import UIKit
import UIKitExtension

// MARK: Router protocol
public protocol Router {
    
    // MARK: Associatedtype
    associatedtype Controller: UIViewController
    
    // MARK: Properties
    var controller: Controller { get }
}

// MARK: Router (UIViewController)
extension Router {
    
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

// MARK: Router (Factory)
extension Router {
    
    public static func rootRouter<Controller>(controller: Controller) -> Routers.RootRouter<Controller>
    where Controller: UIViewController {
        Routers.RootRouter(controller: controller)
    }
    
    public static func navigationRouter(controller: UINavigationController) -> Routers.NavigationRouter {
        Routers.NavigationRouter(controller: controller)
    }
}

// MARK: Router (Storyboard)
extension Router {
    
    static func rootRouter(with storyboardName: String, bundle: Bundle? = nil) -> Routers.RootRouter<UIViewController>? {
        let controller = UIStoryboard.initialViewController(with: storyboardName, bundle: bundle)
        return controller != nil ? Routers.RootRouter(controller: controller!) : nil
    }
    
    static func navigationRouter(with storyboardName: String, identifier: String, bundle: Bundle? = nil) -> Routers.NavigationRouter? {
        let controller = UIStoryboard.controller(with: storyboardName, identifier: identifier, bundle: bundle) as? UINavigationController
        return controller != nil ? Routers.NavigationRouter(controller: controller!) : nil
    }
}

// MARK: Routers namespace
public enum Routers {
    
    // MARK: RootRouter implementation
    public struct RootRouter<Controller: UIViewController>: Router {
        
        // MARK: Properties
        public let controller: Controller
        
        // MARK: Public methods
        func run() {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                scene.keyWindow?.rootViewController = controller
            }
        }
    }
    
    // MARK: NavigationRouter implementation
    public struct NavigationRouter: Router {
        
        // MARK: Properties
        public let controller: UINavigationController
        
        // MARK: Public methods
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
}
