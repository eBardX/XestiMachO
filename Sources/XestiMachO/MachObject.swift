// © 2019 J. G. Pusey (see LICENSE.md)

 import Foundation
 import XestiPath

public final class MachObject {

    // MARK: Public Type Methods

    public static func determineArchitecture(_ path: Path) throws -> Architecture {
        let fh = try FileHandle(forReadingFrom: path.fileURL)
        let magic = try fh.readMagic(at: 0)

        if magic.isFat {
            let header = try fh.readFatHeader(with: magic)
            let archs = try fh.readFatArchs(for: header)

            return .universal(archs.map { $0.architecture })
        } else {
            return try fh.readMachHeader(at: 0,
                                         with: magic).architecture
        }
    }

    public static func load(_ path: Path,
                            allowUpdates: Bool = false) throws -> MachObject {
        let fh = /* allowUpdates ?
             try FileHandle(forUpdating: path.fileURL) : */
            try FileHandle(forReadingFrom: path.fileURL)

        let magic = try fh.readMagic(at: 0)
        let header: Header

        if magic.isFat {
            let fatHeader = try fh.readFatHeader(with: magic)
            let archs = try fh.readFatArchs(for: fatHeader)

            var triples: [Triple] = []

            for arch in archs {
                let mhMagic = try fh.readMagic(at: arch.objectOffset)
                let machHeader = try fh.readMachHeader(at: arch.objectOffset,
                                                       with: mhMagic)
                let loadCommands = try fh.readLoadCommands(for: machHeader)

                triples.append((arch, machHeader, loadCommands))
            }

            header = .universal(fatHeader, triples)
        } else {
            let machHeader = try fh.readMachHeader(at: 0,
                                                   with: magic)
            let loadCommands = try fh.readLoadCommands(for: machHeader)

            header = .single(machHeader, loadCommands)
        }

        return MachObject(path: path,
                          isReadOnly: !allowUpdates,
                          fileHandle: fh,
                          header: header)
    }

    // MARK: Public Instance Properties

    public let isReadOnly: Bool
    public let path: Path

    public var architecture: Architecture {
        switch header {
        case let .single(machHeader, _):
            return machHeader.architecture

        case let .universal(_, triples):
            return .universal(triples.map { $0.arch.architecture })
        }
    }

    public var isUpdating: Bool {
        return updatedHeader != nil
    }

    // MARK: Public Instance Methods

    public func beginUpdates() throws {
        guard
            updatedHeader == nil
            else { throw Error.alreadyUpdating }

        switch header {
        case let .single(machHeader, commands):
            updatedHeader = .single(try machHeader.copy(),
                                    try commands.map { try $0.copy() })

        case let .universal(fatHeader, triples):
            updatedHeader = .universal(try fatHeader.copy(),
                                       try triples.map { (try $0.arch.copy(),
                                                          try $0.header.copy(),
                                                          try $0.commands.map { try $0.copy() })
                                       })
        }
    }

    public func cancelUpdates() throws {
        guard
            updatedHeader != nil
            else { throw Error.notUpdating }

        updatedHeader = nil
    }

    public func canCommitUpdatesInPlace() throws -> Bool {
        guard
            updatedHeader != nil
            else { throw Error.notUpdating }

        return false
    }

    public func commitUpdates(to path: Path) throws {
        guard
            let dstHeader = updatedHeader
            else { throw Error.notUpdating }

        if path.exists {
            try path.remove()
        }

        let attrs = try self.path.attributes()

        guard
            path.createFile(attributes: attrs)
            else { throw Error.badWrite }

        let dstFH = try FileHandle(forUpdating: path.fileURL)

        dstFH.truncateFile(atOffset: 0)

        defer {
            dstFH.synchronizeFile()
            dstFH.closeFile()
        }

        let srcHeader = self.header
        let srcFH = self.fileHandle

        switch (srcHeader, dstHeader) {
        case let (.single(srcMachHeader, _),
                  .single(dstMachHeader, dstCommands)):
            let srcCopyOffset = srcMachHeader.offset + UInt64(srcMachHeader.size + srcMachHeader.totalCommandSize)
            let dstCopyOffset = dstMachHeader.offset + UInt64(dstMachHeader.size + dstMachHeader.totalCommandSize)
            let copySize = UInt32(srcFH.seekToEndOfFile() - srcCopyOffset)

            try _commitSlice(dstFH,
                             header: dstMachHeader,
                             commands: dstCommands,
                             srcCopyOffset: srcCopyOffset,
                             dstCopyOffset: dstCopyOffset,
                             copySize: copySize)

        case let (.universal(_, srcTriples),
                  .universal(dstFatHeader, dstTriples)):
            guard
                srcTriples.count == dstTriples.count
                else { throw Error.corrupt }

            try dstFH.writeFatHeader(dstFatHeader)
            try dstFH.writeFatArchs(dstTriples.map { $0.arch })

            for (srcTriple, dstTriple) in zip(srcTriples, dstTriples) {
                let srcMachHeader = srcTriple.header
                let dstMachHeader = dstTriple.header
                let srcSkipSize = UInt64(srcMachHeader.size + srcMachHeader.totalCommandSize)
                let dstSkipSize = UInt64(dstMachHeader.size + dstMachHeader.totalCommandSize)
                let srcCopyOffset = srcMachHeader.offset + srcSkipSize
                let dstCopyOffset = dstMachHeader.offset + dstSkipSize
                let srcCopySize = UInt32(srcTriple.arch.objectSize - srcSkipSize)
                let dstCopySize = UInt32(dstTriple.arch.objectSize - dstSkipSize)

                guard
                    srcCopySize == dstCopySize
                    else { throw Error.corrupt }

                try _commitSlice(dstFH,
                                 header: dstMachHeader,
                                 commands: dstTriple.commands,
                                 srcCopyOffset: srcCopyOffset,
                                 dstCopyOffset: dstCopyOffset,
                                 copySize: srcCopySize)
            }

        default:
            throw Error.corrupt
        }
    }

    public func commitUpdatesInPlace() throws {
        guard
            updatedHeader != nil
            else { throw Error.notUpdating }
    }

    public func dump() {
        switch header {
        case let .single(machHeader, commands):
            dump(machHeader)

            for (index, command) in commands.enumerated() {
                dump(command, UInt32(index))
            }

        case let .universal(fatHeader, triples):
            dump(fatHeader)

            for triple in triples {
                dump(triple.arch)
            }

            for triple in triples {
                dump(triple.header)

                for (index, command) in triple.commands.enumerated() {
                    dump(command, UInt32(index))
                }
            }
        }
    }

    public func insertDylib(_ name: String,
                            weakly: Bool = false,
                            timestamp: UInt32 = 0,
                            currentVersion: UInt32 = 0,
                            compatibilityVersion: UInt32 = 0) throws {
        guard
            let dstHeader = updatedHeader
            else { throw Error.notUpdating }

        switch dstHeader {
        case let .single(header, commands):
            let (newHeader, newCommands) = try _insertDylib(header: header,
                                                            commands: commands,
                                                            name: name,
                                                            weakly: weakly,
                                                            timestamp: timestamp,
                                                            currentVersion: currentVersion,
                                                            compatibilityVersion: compatibilityVersion)

            updatedHeader = .single(newHeader, newCommands)

        case let .universal(header, triples):
            updatedHeader = .universal(try header.copy(),
                                       try triples.map { (try $0.arch.copy(),
                                                          try $0.header.copy(),
                                                          try $0.commands.map { try $0.copy() })
                })
        }

    }

    public func invalidate() {
        fileHandle.closeFile()
    }

    public func removeCodeSignature() throws {
        guard
            updatedHeader != nil
            else { throw Error.notUpdating }

        switch header {
        case let .single(machHeader, _):
            return try _removeCodeSignature(machHeader)

        case let .universal(fatHeader, _):
            return try _removeCodeSignature(fatHeader)
        }
    }

    // MARK: Internal Instance Properties

    internal let fileHandle: FileHandle

    // MARK: Private Nested Types

    private enum Header {
        case single(MachHeader, [LoadCommand])
        case universal(FatHeader, [Triple])
    }

    private typealias Triple = (arch: FatArch, header: MachHeader, commands: [LoadCommand])

    // MARK: Private Initializers

    private init(path: Path,
                 isReadOnly: Bool,
                 fileHandle: FileHandle,
                 header: Header) {
        self.fileHandle = fileHandle
        self.header = header
        self.isReadOnly = isReadOnly
        self.path = path
    }

    // MARK: Private Instance Properties

    private let header: Header

    private var updatedHeader: Header?

    // MARK: Private Instance Methods

    private func _commitSlice(_ fileHandle: FileHandle,
                              header: MachHeader,
                              commands: [LoadCommand],
                              srcCopyOffset: UInt64,
                              dstCopyOffset: UInt64,
                              copySize: UInt32) throws {
        let dstFH = fileHandle
        let srcFH = self.fileHandle

        try dstFH.writeMachHeader(header)
        try dstFH.writeLoadCommands(commands)

        dstFH.truncateFile(atOffset: dstCopyOffset)

        try dstFH.copy(srcFH,
                       from: srcCopyOffset,
                       to: dstCopyOffset,
                       for: copySize)
    }

    private func _containsDylib(_ name: String) -> Bool {
        switch header {
        case let .single(_, commands):
            return _containsDylib(name, commands)

        case let .universal(_, triples):
            for triple in triples {
                if _containsDylib(name, triple.commands) {
                    return true
                }
            }
        }

        return false
    }

    private func _containsDylib(_ name: String,
                                _ commands: [LoadCommand]) -> Bool {
        for command in commands {
            switch command.kind {
            case .LC_LOAD_DYLIB,
                 .LC_LOAD_WEAK_DYLIB:
                if let command = command as? DylibCommand,
                    command.name == name {
                    return true
                }

            default:
                break
            }
        }

        return false
    }

    private func _insertDylib(header: MachHeader,
                              commands: [LoadCommand],
                              name: String,
                              weakly: Bool,
                              timestamp: UInt32,
                              currentVersion: UInt32,
                              compatibilityVersion: UInt32) throws -> (MachHeader, [LoadCommand]) {
        let lcsOffset = header.offset + UInt64(header.size)

        var lcOffset: UInt64

        if let lastCommand = commands.last {
            lcOffset = lastCommand.offset + UInt64(lastCommand.size)
        } else {
            lcOffset = lcsOffset
        }

        let dylibCommand = try _makeDylibCommand(offset: lcOffset,
                                                 isSwapped: header.magic.isSwapped,
                                                 name: name,
                                                 weakly: weakly,
                                                 timestamp: timestamp,
                                                 currentVersion: currentVersion,
                                                 compatibilityVersion: compatibilityVersion)

        var outCommands = commands

        outCommands.append(dylibCommand)

        lcOffset += UInt64(dylibCommand.size)

        let lcsSize = UInt32(lcOffset - lcsOffset)

        if header.totalCommandSize < lcsSize {
            header.totalCommandSize = lcsSize
        }

        header.commandCount += 1

        return (header, outCommands)
    }

    private func _makeDylibCommand(offset: UInt64,
                                   isSwapped: Bool,
                                   name: String,
                                   weakly: Bool,
                                   timestamp: UInt32,
                                   currentVersion: UInt32,
                                   compatibilityVersion: UInt32) throws -> DylibCommand {
        let kind: LoadCommand.Kind = weakly ? .LC_LOAD_WEAK_DYLIB : .LC_LOAD_DYLIB
        let nameOffset = UInt32(MemoryLayout<dylib_command>.size)
        let nameSize = (UInt32(name.utf8.count) & ~7) + 8
        let commandSize = nameOffset + nameSize
        let rawDylib = dylib(name: lc_str(offset: UInt32(nameOffset)),
                             timestamp: timestamp,
                             current_version: currentVersion,
                             compatibility_version: compatibilityVersion)
        var rawCommand = dylib_command(cmd: kind.rawValue,
                                       cmdsize: commandSize,
                                       dylib: rawDylib)

        if isSwapped {
            swap_dylib_command(&rawCommand, NX_UnknownByteOrder)
        }

        let data = NSMutableData(bytes: &rawCommand,
                                 length: Int(nameOffset))

        if let nameData = name.data(using: .utf8) {
            data.append(nameData)
        }

        if data.length < Int(commandSize) {
            data.increaseLength(by: Int(commandSize) - data.length)
        }

        let item = try Item(dylib_command.self,
                            offset: offset,
                            data: data,
                            isSwapped: isSwapped,
                            swapper: swap_dylib_command)

        return try DylibCommand(item: item)
    }

    private func _removeCodeSignature(_ header: FatHeader) throws {
    }

    private func _removeCodeSignature(_ header: MachHeader) throws {
    }
}
