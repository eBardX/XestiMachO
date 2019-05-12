// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public class FatArch: ItemDescriptor {

    // MARK: Public Initializers

    internal init(offset: UInt64,
                  size: Int,
                  ptr: UnsafeMutablePointer<fat_arch>,
                  header: MachHeader) throws {
        self.alignment = Int(ptr.pointee.align)
        self.header = header
        self.objectSize = UInt64(ptr.pointee.size)

        try super.init(offset: offset,
                       size: size)
    }

    internal init(offset: UInt64,
                  size: Int,
                  ptr: UnsafeMutablePointer<fat_arch_64>,
                  header: MachHeader) throws {
        self.alignment = Int(ptr.pointee.align)
        self.header = header
        self.objectSize = ptr.pointee.size

        try super.init(offset: offset,
                       size: size)
    }

    // MARK: Public Instance Properties

    public let alignment: Int
    public let header: MachHeader
    public let objectSize: UInt64
}
