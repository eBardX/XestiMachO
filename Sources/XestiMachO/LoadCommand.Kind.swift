// © 2019 J. G. Pusey (see LICENSE.md)

internal extension LoadCommand {
    enum Kind {
        case codeSignature
        case loadDylib
        case loadWeakDylib
        case segment
        case segment64
    }
}
