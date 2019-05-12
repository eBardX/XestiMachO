// © 2019 J. G. Pusey (see LICENSE.md)

public extension MachObject {
    enum Error: Swift.Error {
        case badFatArch
        case badFatHeader
        case badItemDescriptor
        case badLoadCommand
        case badMachHeader
        case badMagic
        case badRead
        case readOnly
    }
}
