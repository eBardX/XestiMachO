// © 2019 J. G. Pusey (see LICENSE.md)

public extension MachObject {
    enum Error: Swift.Error {
        case alreadyUpdating
        case badFatArch
        case badFatHeader
        case badItem
        case badLoadCommand
        case badMachHeader
        case badMagic
        case badRead
        case badWrite
        case corrupt
        case notUpdating
        case readOnly
    }
}
