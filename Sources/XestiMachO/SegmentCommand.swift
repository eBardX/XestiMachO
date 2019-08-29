// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public final class SegmentCommand: LoadCommand {

    // MARK: Public Initializers

    public init(item: Item<segment_command>) throws {
        guard
            let segmentName = SegmentCommand._convert(item.ptr.pointee.segname)
            else { throw MachObject.Error.badLoadCommand }

        self.itemFormat = .itemFormat32(item)
        self.segmentName = segmentName

        try super.init(offset: item.offset,
                       size: item.size,
                       kind: LoadCommand.Kind(item.ptr.pointee.cmd),
                       rawData: item.rawData)
    }

    public init(item: Item<segment_command_64>) throws {
        guard
            let segmentName = SegmentCommand._convert(item.ptr.pointee.segname)
            else { throw MachObject.Error.badLoadCommand }

        self.itemFormat = .itemFormat64(item)
        self.segmentName = segmentName

        try super.init(offset: item.offset,
                       size: item.size,
                       kind: LoadCommand.Kind(item.ptr.pointee.cmd),
                       rawData: item.rawData)
    }

    // MARK: Public Instance Properties

    public let segmentName: String

    public var fileOffset: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return UInt64(item.ptr.pointee.fileoff)

        case let .itemFormat64(item):
            return item.ptr.pointee.fileoff
        }
    }

    public var fileSize: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return UInt64(item.ptr.pointee.filesize)

        case let .itemFormat64(item):
            return item.ptr.pointee.filesize
        }
    }

    public var flags: UInt32 {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.ptr.pointee.flags

        case let .itemFormat64(item):
            return item.ptr.pointee.flags
        }
    }

    public var initialProtection: vm_prot_t {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.ptr.pointee.initprot

        case let .itemFormat64(item):
            return item.ptr.pointee.initprot
        }
    }

    public var maximumProtection: vm_prot_t {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.ptr.pointee.maxprot

        case let .itemFormat64(item):
            return item.ptr.pointee.maxprot
        }
    }

    public var sectionCount: UInt32 {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.ptr.pointee.nsects

        case let .itemFormat64(item):
            return item.ptr.pointee.nsects
        }
    }

    public var vmAddress: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return UInt64(item.ptr.pointee.vmaddr)

        case let .itemFormat64(item):
            return item.ptr.pointee.vmaddr
        }
    }

    public var vmSize: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return UInt64(item.ptr.pointee.vmsize)

        case let .itemFormat64(item):
            return item.ptr.pointee.vmsize
        }
    }

    // MARK: Private Nested Types

    private enum ItemFormat {
        case itemFormat32(Item<segment_command>)
        case itemFormat64(Item<segment_command_64>)
    }

    // MARK: Private Type Methods

    // swiftlint:disable large_tuple line_length

    private static func _convert(_ tuple: (Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8)) -> String? {
        var tmpTuple = tuple
        let tmpArray = [Int8](UnsafeBufferPointer(start: &tmpTuple.0,
                                                  count: MemoryLayout.size(ofValue: tmpTuple)))

        return String(bytes: tmpArray.compactMap { $0 > 0 ? UInt8($0) : nil },
                      encoding: .utf8)
    }

    // MARK: Private Instance Properties

    private let itemFormat: ItemFormat
}
