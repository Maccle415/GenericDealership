//
//  ViewController.swift
//  GenericDealership
//
//  Created by Darren Leak on 2019/02/24.
//  Copyright © 2019 Darren Leak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hq = AudiHQ()
        hq.mainDealership()?.order(model: .a1)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

enum AudiModel {
    case a1
    case a3
}

class Car<Model> {
    var model: Model
    
    init(with model: Model) {
        self.model = model
    }
}

typealias Audi = Car<AudiModel>

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
// FACTORY
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

protocol Dispatchable {
    func dispatchVehicle()
}

class Factory<FactoryHQ: HQ, Stock>: Dispatchable {
    weak var hqDelegate: FactoryHQ?
    var stock: [Stock] = [Stock]() {
        didSet {
            if !self.stock.isEmpty {
                self.dispatchVehicle()
            }
        }
    }
    
    init(with delegate: FactoryHQ) {
        self.hqDelegate = delegate
    }
    
    func dispatchVehicle() {
        fatalError("Subclass to dispatchVehicle")
    }
}

class AudiFactory: Factory<AudiHQ, Audi> {
    override func dispatchVehicle() {
        if let delegate = self.hqDelegate {
            delegate.dispatch(vehicle: self.stock.removeFirst())
        }
    }
    
    func build(model: AudiModel) {
        switch model {
        case .a1:
            self.buildA1()
        case .a3:
            self.buildA3()
        }
    }
    
    private func buildA1() {
        self.stock.append(Audi(with: .a1))
    }
    
    private func buildA3() {
        self.stock.append(Audi(with: .a3))
    }
}

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
// DEALERSHIP
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

protocol Orderable {
    associatedtype Model
    func order(model: Model)
}

class Dealership<DealershipHQ: HQ, Model> {
    weak var hqDelegate: DealershipHQ?
    
    init(with delegate: DealershipHQ) {
        self.hqDelegate = delegate
    }
}

typealias AudiDealership = Dealership<AudiHQ, AudiModel>
extension Dealership: Orderable where Dealership == AudiDealership {
    func order(model: AudiModel) {
        if let delegate = self.hqDelegate {
            delegate.placeOrder(for: model)
        }
    }
}


/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
// HQ
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

protocol HQ: class {
    associatedtype Factory
    associatedtype Dealership
    associatedtype Model
    associatedtype Vehicle
    
    var factory: Factory? { get set }
    var dealerships: [Dealership]? { get set }
    
    func mainDealership() -> Dealership?
    
    func makeFactory()
    func makeDealership()
    
    func placeOrder(for model: Model)
    func dispatch(vehicle: Vehicle)
}

class AudiHQ: HQ  {
    var factory: AudiFactory?
    var dealerships: [AudiDealership]?
    
    init() {
        self.setupHQ()
    }
    
    func setupHQ() {
        self.dealerships = [AudiDealership]()
        
        self.makeFactory()
        self.makeDealership()
    }
    
    func mainDealership() -> AudiDealership? {
        guard let dealership = self.dealerships?.first else {
            return nil
        }
        
        return dealership
    }
    
    func makeFactory() {
        self.factory = AudiFactory(with: self)
    }
    
    func makeDealership() {
        self.dealerships?.append(AudiDealership(with: self))
    }
    
    func placeOrder(for model: AudiModel) {
        guard let factory = self.factory else {
            return
        }
        factory.build(model: model)
    }
    
    func dispatch(vehicle: Audi) {
        print(vehicle.model)
    }
}
