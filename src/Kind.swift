class Kind {
    var gtype: Gtype
    static var kinds = [Kind]()

    private init(_ g: Gtype) {
        gtype = g
    }
    
    static func has(_ g: Gtype) -> Kind? {
        let ki = kinds.firstIndex {
            $0.gtype.gEquivalent(g)
        }
        guard ki != nil else {
            return nil
        }
        return kinds[ki!]
    }
    static func produceKind(_ g: Gtype) throws -> Kind {
//        if !g.isValid() {
//            throw Perr(ETYPE)
//        }
        let k = has(g)
        if k != nil {
            return k!
        }
        let k2 = Kind(g)
        kinds.append(k2)
        return k2
    }
    func assignable(_ k: Kind) -> Bool {
        if self === k {
            return true
        }

        var ke = k
        if ke === gOne.rkind {
            ke = gOne.nkind
        } else if ke === gOne.nkind {
            ke = gOne.rkind
        }
        if self === ke {
            return true
        }
        
        if gtype.isPointer() && k === gOne.nkind || self === gOne.nkind && k.gtype.isPointer() {
            return true
        }
        
        return gtype.gAssignable(k.gtype)

    }
    func equivalent(_ k: Kind) -> Bool {
        if self === k {
            return true
        }
        
        
        if gtype.isPointer() && k === gOne.nkind || self === gOne.nkind && k.gtype.isPointer() {
            return true
        }
        
        return false
    }
}
