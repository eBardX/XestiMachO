// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation
import MachO
import XestiPath

public final class MachObject {

    // MARK: Public Initializers

    public init(path: Path,
                update: Bool) throws {
        let tmpFileHandle = update ?
            try FileHandle(forUpdating: path.fileURL) :
            try FileHandle(forReadingFrom: path.fileURL)

        guard
            let tmpMagic = tmpFileHandle.readMagic(at: 0)
            else { throw Error.badMagic }

        self.fileHandle = tmpFileHandle
        self.magic = tmpMagic
    }

    // MARK: Public Instance Properties

    public var architecture: Architecture {
        _readHeader()

        guard
            let header = header
            else { return .unknown }

        switch header {
        case let .single(machHeader):
            return machHeader.architecture

        case let .universal(fatHeader):
            return fatHeader.architecture
        }
    }

    public var isUniversal: Bool {
        return magic.isFat
    }

    // MARK: Private Nested Types

    private enum Header {
        case single(MachHeader)
        case universal(FatHeader)
    }

    // MARK: Private Instance Properties

    private let fileHandle: FileHandle
    private let magic: Magic

    private var didReadHeader = false
    private var didReadLocalCommands = false
    private var header: Header?

    // MARK: Private Instance Methods

    private func _readFatArch(at offset: UInt64,
                              with magic: Magic) -> FatArch? {
        let mhOffset: UInt64
        let count: Int
        let item: Any

        if magic.is64Bit {
            count = MemoryLayout<fat_arch_64>.size

            guard
                let data = fileHandle.read(from: offset,
                                           for: count),
                let arch = data.extractFatArch64(magic.isSwapped)
                else { return nil }

            item = arch
            mhOffset = arch.offset

        } else {
            count = MemoryLayout<fat_arch>.size

            guard
                let data = fileHandle.read(from: offset,
                                           for: count),
                let arch = data.extractFatArch(magic.isSwapped)
                else { return nil }

            item = arch
            mhOffset = UInt64(arch.offset)

        }

        guard
            let mhMagic = fileHandle.readMagic(at: mhOffset),
            let header = _readMachHeader(at: mhOffset,
                                         with: mhMagic)
            else { return nil }

        return FatArch(offset: offset,
                       count: count,
                       item: item,
                       header: header)
    }

    private func _readFatHeader(at offset: UInt64,
                                with magic: Magic) -> FatHeader? {
        let count = MemoryLayout<fat_header>.size

        guard
            let data = fileHandle.read(from: 0,
                                       for: count),
            let item = data.extractFatHeader(magic.isSwapped)
            else { return nil }

        var archOffset = UInt64(count)
        var archs: [FatArch] = []

        for _ in 1...item.nfat_arch {
            guard
                let arch = _readFatArch(at: archOffset,
                                        with: magic)
                else { return nil }

            archs.append(arch)

            archOffset += UInt64(arch.count)
        }

        return FatHeader(magic: magic,
                         offset: offset,
                         count: count,
                         item: item,
                         archs: archs)
    }

    private func _readHeader() {
        guard
            !didReadHeader
            else { return }

        didReadHeader = true

        if magic.isFat {
            guard
                let header = _readFatHeader(at: 0,
                                            with: magic)
                else { return }

            self.header = .universal(header)
        } else {
            guard
                let header = _readMachHeader(at: 0,
                                             with: magic)
                else { return }

            self.header = .single(header)
        }
    }

    private func _readLoadCommands(at offset: UInt64,
                                   count: Int,
                                   isSwapped: Bool) {
        //        let lcSize = MemoryLayout<load_command>.size
        //
        //        var lcOffset = offset
        //
        //        for _ in 1...count {
        //            guard
        //                let lcData = _fileHandle.read(from: lcOffset,
        //                                              for: lcSize),
        //                let tmpCommand = lcData.extractLoadCommand(isSwapped),
        //                let data = _fileHandle.read(from: lcOffset,
        //                                            for: Int(tmpCommand.cmdsize)),
        //                let command = LoadCommand.parse(data: data,
        //                                                isSwapped: isSwapped)
        //                else { break }
        //
        //            lcOffset += UInt64(command.size)
        //        }
    }

    private func _readMachHeader(at offset: UInt64,
                                 with magic: Magic) -> MachHeader? {
        let count: Int
        let item: Any

        if magic.is64Bit {
            count = MemoryLayout<mach_header_64>.size

            guard
                let data = fileHandle.read(from: offset,
                                           for: count),
                let header = data.extractMachHeader64(magic.isSwapped)
                else { return nil }

            item = header
        } else {
            count = MemoryLayout<mach_header>.size

            guard
                let data = fileHandle.read(from: offset,
                                           for: count),
                let header = data.extractMachHeader(magic.isSwapped)
                else { return nil }

            item = header
        }

        return MachHeader(magic: magic,
                          offset: offset,
                          count: count,
                          item: item)
    }
}
