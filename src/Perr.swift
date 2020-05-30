import Antlr4

class Perr : Error {
    var str: String
    private var pval: Pval?
    private var prc: ParserRuleContext?
    private var tok: Token?
    init (_ s: String, _ prc: ParserRuleContext? = nil, _ pval: Pval? = nil, _ token: Token? = nil) {
        if s == EX {
            print(s)
        }
        str = s
        self.pval = pval
        self.prc = prc
        self.tok = token
        let _str = string
        _ = _str
        
    }
    convenience init(_ s: String, _ p: Pval?) {
        self.init(s, nil, p, nil)
    }
    convenience init(_ s: String, _ t: Token) {
        self.init(s, nil, nil, t)
    }
    var string: String {
        var rt = ""
        rt += "Error: \(str)."
        if let pv = pval {
            rt += "Pval. Line " + pv.prc.getStart()!.getLine() + " Col " + pv.prc.getStart()!.getCharPositionInLine() + "."
        }
        if let pc = prc {
            rt += "PRC. Text \(pc.getText()). Line \(pc.getStart()!.getLine()) Col \(pc.getStart()!.getCharPositionInLine())."
        }
        if let t = tok {
            rt += "TOKEN \(t.getText()!). Line \(t.getLine()) Col \(t.getCharPositionInLine())."
        }
        return rt
    }
}
