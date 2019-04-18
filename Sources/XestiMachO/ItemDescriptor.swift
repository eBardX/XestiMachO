// © 2019 J. G. Pusey (see LICENSE.md)

internal protocol ItemDescriptor {
    var count: Int { get }
    var item: Any { get }
    var offset: UInt64 { get }
}
