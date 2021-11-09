//
//  Router.swift
//  
//
//  Created by Mickel Harlov on 09.11.2021.
//

import UIKit

// MARK: Router protocol
protocol Router {
    
    // MARK: Associatedtype
    associatedtype Controller: UIViewController
    
    // MARK: Properties
    var controller: Controller { get }
}

// MARK: Router (UIViewController)
extension Router {
    
    func present(controller: UIViewController, animated: Bool = true,
                 presentationStyle: UIModalPresentationStyle = .fullScreen,
                 completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = presentationStyle
        self.controller.present(controller, animated: animated, completion: completion)
    }
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        controller.dismiss(animated: animated, completion: completion)
    }
}

// MARK: Router (Factory)
extension Router {
    
    static func rootRouter<Controller>(controller: Controller) -> Routers.RootRouter<Controller>
    where Controller: UIViewController {
        Routers.RootRouter(controller: controller)
    }
    
    static func navigationRouter(controller: UINavigationController) -> Routers.NavigationRouter {
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

// MARK: UIStoryboard (Factory)
extension UIStoryboard {
    
    static func initialViewController(with storyboardName: String, bundle: Bundle? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateInitialViewController()
    }
    
    static func controller(with storyboardName: String, identifier: String, bundle: Bundle? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: Routers namespace
enum Routers {
    
    // MARK: RootRouter implementation
    struct RootRouter<Controller: UIViewController>: Router {
        
        // MARK: Properties
        let controller: Controller
        
        // MARK: Public methods
        func run() {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                scene.keyWindow?.rootViewController = controller
            }
        }
    }
    
    // MARK: NavigationRouter implementation
    struct NavigationRouter: Router {
        
        // MARK: Properties
        let controller: UINavigationController
        
        // MARK: Public methods
        func run(controller: UIViewController, animated: Bool = true) {
            self.controller.setViewControllers([ controller ], animated: animated)
        }
        func push(controller: UIViewController, animated: Bool = true) {
            self.controller.pushViewController(controller, animated: animated)
        }
        func pop(animated: Bool = true) {
            self.controller.popViewController(animated: animated)
        }
        func popToRoot(animated: Bool = true) {
            self.controller.popToRootViewController(animated: animated)
        }
    }
}