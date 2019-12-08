//
//  Kind.swift
//  pinn
//
//  Created by Ryan Keppel on 11/14/19.
//  Copyright © 2019 Ryan Keppel. All rights reserved.
//

import Foundation


enum Kinde {
    case vt(Ptype.Type)
    case k(Kind)
    case km([Kind])
    
    func getVt() -> Ptype.Type? {
        if case .vt(let pw) = self {
            return pw
        }
        return nil
    }
        func getK() -> Kind? {
            if case .k(let ar) = self {
                return ar
            }
            return nil
        }
        func getKm() -> [Kind]? {
            if case .km(let map) = self {
                return map
            }
            return nil
            
    }
    
    
    
    
}

    
class Kind {


    
    init(_ vtype: Ptype.Type) {
        ke = .vt(vtype)
        gtype = .gScalar
        count = 1
    }

    init(_ k: Kind?, _ gtype: Gtype, _ count: Int? = nil) {
        self.gtype = gtype
        switch gtype {
        case .gScalar, .gTuple, .gPointer:
            de(ECASE)
//        case .gPointer:
//            ade(k == nil)
//            ade(count == nil)
//            self.count = 0
//            ke = .vt(Nil.self)
//
        case .gMap:
            ade(count == nil)
            self.count = 0
            ke = .k(k!)
        case .gArray, .gSlice:
            self.count = count!
            ke = .k(k!)
        }
    }
    init(_ ka: [Kind]) {
        gtype = .gTuple
        var kar = ka
        self.count = kar.count
        ke = .vt(Nil.self)
                    for (k, v) in kar.enumerated() {
                        if gtype == .gPointer && v.isPointer() {
                            de(ETYPE)
                        }
                        if v.isNil() {
                                    gtype = .gPointer
                                    
                                    kar[k] = self                                
                            }
                    }
        ke = .km(kar)
    }
    var ke: Kinde
  
    var gtype: Gtype
    var count: Int
    func isOneNil() -> Bool {
        return ke.getVt() == Nil.self
    }
    func isNil() -> Bool {
        return gtype == .gScalar && isOneNil()
    }
    func isPointer() -> Bool {
        return gtype == .gPointer
    }
    
    func kindEquivalent(_ k2: Kind, _ sg: Bool ) -> Bool {
        ade(sg == true)
        
        if isOneNil() && k2.isPointer() || isPointer() && k2.isOneNil() {
            return true
        }
        if gtype != k2.gtype {
            return false
        }
//        if gtype == .gPointer && !sg && self === k2{
//            return gtype == k2.gtype
//        }
        switch ke {
        case .vt(let vt):
            ade(gtype == .gScalar && k2.gtype == .gScalar)
            
            return k2.ke.getVt() != nil && vt == k2.ke.getVt()!
        case .k(let k):
            if k2.ke.getK() == nil {
                return false
            }
            switch gtype {
            case .gArray:
                return k.kindEquivalent(k2.ke.getK()!, true) && count == k2.count
            case .gMap, .gSlice:
                return k.kindEquivalent(k2.ke.getK()!, true)
            case .gTuple, .gScalar, .gPointer:
                de(ECASE)
            }
        case .km(let km):
            return k2.ke.getKm() != nil && km.elementsEqual(k2.ke.getKm()!, by: {
                if self === $0 && k2 === $1 {
                    return true
                }
                    return $0.kindEquivalent($1, true)
            })
        }
    }
}
