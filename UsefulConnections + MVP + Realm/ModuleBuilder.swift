//
//  ModuleBuilder.swift
//  UsefulConnections + MVP + Realm
//
//  Created by Vasily on 12.05.2022.
//

import Foundation
import UIKit
import RealmSwift
protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        
        let model = Person()
        let view = MainViewController()
        
        let presenter = MainPresenter(view: view, person: model)
        view.presenter = presenter
        return view
    }
    
    
}
