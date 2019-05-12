// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public class MachHeader: ItemDescriptor {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                magic: Magic,
                ptr: UnsafeMutablePointer<mach_header>,
                commands: [LoadCommand]) throws {
        guard
            !magic.isFat
            else { throw MachObject.Error.badMachHeader }

        self.commandCount = Int(ptr.pointee.ncmds)
        self.commands = commands
        self.cpuSubtype = CPUSubtype(UInt64(ptr.pointee.cputype) << 32 | UInt64(ptr.pointee.cpusubtype))
        self.cpuType = CPUType(UInt32(ptr.pointee.cputype))
        self.fileType = FileType(ptr.pointee.filetype)
        self.flags = Flags(rawValue: ptr.pointee.flags)
        self.magic = magic
        self.totalCommandSize = Int(ptr.pointee.sizeofcmds)

        try super.init(offset: offset,
                       size: size)
    }

    public init(offset: UInt64,
                size: Int,
                magic: Magic,
                ptr: UnsafeMutablePointer<mach_header_64>,
                commands: [LoadCommand]) throws {
        guard
            !magic.isFat
            else { throw MachObject.Error.badMachHeader }

        self.commandCount = Int(ptr.pointee.ncmds)
        self.commands = commands
        self.cpuSubtype = CPUSubtype(UInt64(ptr.pointee.cputype) << 32 | UInt64(ptr.pointee.cpusubtype))
        self.cpuType = CPUType(UInt32(ptr.pointee.cputype))
        self.fileType = FileType(ptr.pointee.filetype)
        self.flags = Flags(rawValue: ptr.pointee.flags)
        self.magic = magic
        self.totalCommandSize = Int(ptr.pointee.sizeofcmds)

        try super.init(offset: offset,
                       size: size)
    }

    // MARK: Public Instance Properties

    public let commandCount: Int
    public let commands: [LoadCommand]
    public let cpuSubtype: CPUSubtype
    public let cpuType: CPUType
    public let fileType: FileType
    public let flags: Flags
    public let magic: Magic
    public let totalCommandSize: Int
}

// MARK: -

public extension MachHeader {

    // MARK: Public Instance Properties

    var architecture: MachObject.Architecture {
        return .init(cpuType: cpuType,
                     cpuSubtype: cpuSubtype)
    }
}
