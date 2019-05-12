// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public class SegmentCommand: LoadCommand {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                kind: Kind,
                data: NSMutableData,
                isSwapped: Bool) throws {
        switch kind {
        case .LC_SEGMENT:
            let ptr = try data.extractSegmentCommand(isSwapped)

            guard
                let segmentName = SegmentCommand._convert(ptr.pointee.segname)
                else { throw MachObject.Error.badLoadCommand }

            self.fileOffset = UInt64(ptr.pointee.fileoff)
            self.fileSize = UInt64(ptr.pointee.filesize)
            self.flags = ptr.pointee.flags
            self.initialProtection = ptr.pointee.initprot
            self.maximumProtection = ptr.pointee.maxprot
            self.sectionCount = Int(ptr.pointee.nsects)
            self.segmentName = segmentName
            self.vmAddress = UInt64(ptr.pointee.vmaddr)
            self.vmSize = UInt64(ptr.pointee.vmsize)

        case .LC_SEGMENT_64:
            let ptr = try data.extractSegmentCommand64(isSwapped)

            guard
                let segmentName = SegmentCommand._convert(ptr.pointee.segname)
                else { throw MachObject.Error.badLoadCommand }

            self.fileOffset = ptr.pointee.fileoff
            self.fileSize = ptr.pointee.filesize
            self.flags = ptr.pointee.flags
            self.initialProtection = ptr.pointee.initprot
            self.maximumProtection = ptr.pointee.maxprot
            self.sectionCount = Int(ptr.pointee.nsects)
            self.segmentName = segmentName
            self.vmAddress = ptr.pointee.vmaddr
            self.vmSize = ptr.pointee.vmsize

        default:
            throw MachObject.Error.badLoadCommand
        }

        try super.init(offset: offset,
                       size: size,
                       kind: kind)
    }

    // MARK: Public Instance Properties

    public let fileOffset: UInt64
    public let fileSize: UInt64
    public let flags: UInt32
    public let initialProtection: vm_prot_t
    public let maximumProtection: vm_prot_t
    public let sectionCount: Int
    public let segmentName: String
    public let vmAddress: UInt64
    public let vmSize: UInt64

    // MARK: Private Type Methods

    // swiftlint:disable large_tuple line_length

    private static func _convert(_ tuple: (Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8, Int8)) -> String? {
        var tmpTuple = tuple
        let tmpArray = [Int8](UnsafeBufferPointer(start: &tmpTuple.0,
                                                  count: MemoryLayout.size(ofValue: tmpTuple)))

        return String(bytes: tmpArray.compactMap { $0 > 0 ? UInt8($0) : nil },
                      encoding: .utf8)
    }
}
