//
//  V2.swift
//  GenericDealership
//
//  Created by Darren Leak on 2019/02/24.
//  Copyright © 2019 Darren Leak. All rights reserved.
//

import Foundation

/*

 MODELS

 */
protocol MakeModel {
    associatedtype Brand
    func make() -> Brand
}

enum AudiModel: MakeModel {
    case a1
    case a3

    public func make() -> Audi {
        switch self {
        case .a1:
            return Audi(with: .a1)
        case .a3:
            return Audi(with: .a3)
        }
    }
}

enum VWModel: MakeModel {
    case golf
    case polo

    public func make() -> VW {
        switch self {
        case .golf:
            return VW(with: .golf)
        case .polo:
            return VW(with: .polo)
        }
    }
}



/*

 CAR

 */

class Car<Model> {
    var model: Model

    init(with model: Model) {
        self.model = model
    }
}

typealias Audi = Car<AudiModel>
typealias VW = Car<VWModel>



/*

 FACTORY

 */

struct CarFactoryFactory {
    static func makeFactory(with hq: AudiHQ) -> AudiFactory {
        return AudiFactory(with: hq)
    }

    static func makeFactory(with hq: VWHQ) -> VWFactory {
        return VWFactory(with: hq)
    }
}

protocol CarBuildable {
    associatedtype Model
    associatedtype Brand

    func build(model: Model)
    func dispatch(vehicle: Brand)
}

class CarFactory<HQ: CarHQ, Brand, Model: MakeModel>: CarBuildable {
    weak var delegate: HQ?
    
    init(with delegate: HQ) {
        self.delegate = delegate
    }
    
    private var vehicles: [Brand] = [Brand]() {
        didSet {
            if let firstVehicle = self.vehicles.first {
                self.dispatch(vehicle: firstVehicle)
            }
        }
    }

    public func build(model: Model) {
        if let vehicle = model.make() as? Brand {
            self.vehicles.append(vehicle)
        }
    }
    
    func dispatch(vehicle: Brand) {
        fatalError("")
    }
}

class AudiFactory: CarFactory<AudiHQ, Audi, AudiModel> {
    override func dispatch(vehicle: Audi) {
        self.delegate?.deliver(vehicle: vehicle)
    }
}

class VWFactory: CarFactory<VWHQ, VW, VWModel> {
    override func dispatch(vehicle: VW) {
        self.delegate?.deliver(vehicle: vehicle)
    }
}



/*

 DEALERSHIP

 */
struct DealershipFactory {
    static func makeDealership(with hq: AudiHQ) -> AudiDealership {
        return AudiDealership(with: hq)
    }

    static func makeDealership(with hq: VWHQ) -> VWDealership {
        return VWDealership(with: hq)
    }
}

protocol Dealership {
    associatedtype Model
    associatedtype Brand
    
    func placeOrder(for model: Model)
    func deliverCar(vehicle: Brand)
}

class CarDealership<DealershipHQ: CarHQ, Model> {
    weak var hq: DealershipHQ?

    init(with hq: DealershipHQ) {
        self.hq = hq
    }
}

class AudiDealership: CarDealership<AudiHQ, AudiModel>, Dealership {
    func placeOrder(for model: AudiModel) {
        self.hq?.placeOrder(with: model)
    }
    
    func deliverCar(vehicle: Audi) {
        print("Deliver: \(vehicle.model)")
    }
}

class VWDealership: CarDealership<VWHQ, VWModel>, Dealership {
    func placeOrder(for model: VWModel) {
        self.hq?.placeOrder(with: model)
    }
    
    func deliverCar(vehicle: VW) {
        print("Deliver: \(vehicle.model)")
    }
}



/*

 HQ

 */

protocol CarHQ: class {
    associatedtype Factory
    associatedtype CarDealership
    associatedtype Model
    associatedtype Vehicle

    var factories: [Factory] { get set }
    var dealerships: [CarDealership] { get set }

    func buildFactory()
    func buildDealership()

    func placeOrder(with model: Model)
    func deliver(vehicle: Vehicle)
}

class AudiHQ: CarHQ {
    var factories: [AudiFactory] = [AudiFactory]()
    var dealerships: [AudiDealership] = [AudiDealership]()

    init() {
        self.buildFactory()
        self.buildDealership()
    }

    public func buildFactory() {
        self.factories.append(CarFactoryFactory.makeFactory(with: self))
    }

    public func buildDealership() {
        self.dealerships.append(DealershipFactory.makeDealership(with: self))
    }

    public func placeOrder(with model: AudiModel) {
        self.factories[0].build(model: model)
    }

    public func deliver(vehicle: Audi) {
        self.dealerships[0].deliverCar(vehicle: vehicle)
    }
}

class VWHQ: CarHQ {
    var factories: [VWFactory] = [VWFactory]()
    var dealerships: [VWDealership] = [VWDealership]()

    init() {
        self.buildFactory()
        self.buildDealership()
    }

    public func buildFactory() {
        self.factories.append(CarFactoryFactory.makeFactory(with: self))
    }

    public func buildDealership() {
        self.dealerships.append(DealershipFactory.makeDealership(with: self))
    }

    public func placeOrder(with model: VWModel) {
        self.factories[0].build(model: model)
    }

    public func deliver(vehicle: VW) {
        self.dealerships[0].deliverCar(vehicle: vehicle)
    }
}
