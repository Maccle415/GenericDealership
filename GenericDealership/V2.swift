//
//  V2.swift
//  GenericDealership
//
//  Created by Darren Leak on 2019/02/24.
//  Copyright © 2019 Darren Leak. All rights reserved.
//

import Foundation

///*
//
// MODELS
//
// */
//protocol MakeModel {
//    associatedtype Brand
//    func make() -> Brand
//}
//
//enum AudiModel: MakeModel {
//    case a1
//    case a3
//
//    public func make() -> Audi {
//        switch self {
//        case .a1:
//            return Audi(with: .a1)
//        case .a3:
//            return Audi(with: .a3)
//        }
//    }
//}
//
//enum VWModel: MakeModel {
//    case golf
//    case polo
//
//    public func make() -> VW {
//        switch self {
//        case .golf:
//            return VW(with: .golf)
//        case .polo:
//            return VW(with: .polo)
//        }
//    }
//}
//
//
//
///*
//
// CAR
//
// */
//
//class Car<Model> {
//    var model: Model
//
//    init(with model: Model) {
//        self.model = model
//    }
//}
//
//typealias Audi = Car<AudiModel>
//typealias VW = Car<VWModel>
//
//
///*
//
// FACTORY
//
// */
//
//struct CarFactoryFactory {
//    static func makeFactory(with hq: AudiHQ) -> AudiFactory {
//        return AudiFactory()
//    }
//
//    static func makeFactory(with hq: VWHQ) -> VWFactory {
//        return VWFactory()
//    }
//}
//
//protocol CarBuildable {
//    associatedtype Model
//
//    func build(model: Model)
//}
//
//class CarFactory<Brand, Model: MakeModel>: CarBuildable {
//    private var vehicles: [Brand] = [Brand]() {
//        didSet {
//            print(vehicles)
//        }
//    }
//
//    public func build(model: Model) {
//        if let vehicle = model.make() as? Brand {
//            self.vehicles.append(vehicle)
//        }
//    }
//}
//
//typealias AudiFactory = CarFactory<Audi, AudiModel>
//typealias VWFactory = CarFactory<VW, VWModel>
//
//
///*
//
// DEALERSHIP
//
// */
//struct DealershipFactory {
//    static func makeDealership(with hq: AudiHQ) -> AudiDealership {
//        return AudiDealership(with: hq)
//    }
//
//    static func makeDealership(with hq: VWHQ) -> VWDealership {
//        return VWDealership(with: hq)
//    }
//}
//
//protocol Dealership {
//    associatedtype Model
//
//    func placeOrder(for model: Model)
//    func deliverCar()
//}
//
//class CarDealership<DealershipHQ: CarHQ, Model> {
//    weak var hq: DealershipHQ?
//
//    init(with hq: DealershipHQ) {
//        self.hq = hq
//    }
//}
//
//typealias AudiDealership = CarDealership<AudiHQ, AudiModel>
//extension CarDealership: Dealership where CarDealership == AudiDealership {
//    func deliverCar() {
//        print()
//    }
//
//    func placeOrder(for model: AudiModel) {
//        self.hq?.placeOrder(with: model)
//    }
//}
//
//typealias VWDealership = CarDealership<VWHQ, VWModel>
//
//
//
///*
//
// HQ
//
// */
//
//protocol CarHQ: class {
//    associatedtype HQFactory
//    associatedtype HQDealership
//    associatedtype HQModel
//    associatedtype HQBrand
//
//    var factories: [HQFactory] { get set }
//    var dealerships: [HQDealership] { get set }
//
//    func buildFactory()
//    func buildDealership()
//
//    func placeOrder(with model: HQModel)
//    func deliver(vehicle: HQBrand)
//}
//
//class AudiHQ: CarHQ {
//    var factories: [AudiFactory] = [AudiFactory]()
//    var dealerships: [AudiDealership] = [AudiDealership]()
//
//    init() {
//        self.buildFactory()
//        self.buildDealership()
//    }
//
//    func buildFactory() {
//        self.factories.append(CarFactoryFactory.makeFactory(with: self))
//    }
//
//    func buildDealership() {
//        self.dealerships.append(DealershipFactory.makeDealership(with: self))
//    }
//
//    func placeOrder(with model: AudiModel) {
//        self.factories[0].build(model: model)
//    }
//
//    func deliver(vehicle: Audi) {
//
//    }
//}
//
//class VWHQ: CarHQ {
//    var factories: [VWFactory] = [VWFactory]()
//    var dealerships: [VWDealership] = [VWDealership]()
//
//    init() {
//        self.buildFactory()
//        self.buildDealership()
//    }
//
//    func buildFactory() {
//        self.factories.append(CarFactoryFactory.makeFactory(with: self))
//    }
//
//    func buildDealership() {
//        self.dealerships.append(DealershipFactory.makeDealership(with: self))
//    }
//
//    func placeOrder(with model: VWModel) {
//        self.factories[0].build(model: model)
//    }
//
//    func deliver(vehicle: VW) {
//
//    }
//}
