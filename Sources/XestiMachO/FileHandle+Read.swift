// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public extension FileHandle {

    // MARK: Public Instance Methods

    func readFatArch(at offset: UInt64,
                     with magic: Magic,
                     full: Bool) throws -> FatArch {
        if magic.is64Bit {
            let faSize = MemoryLayout<fat_arch_64>.size
            let faData = try _readMutableData(from: offset,
                                              for: faSize)
            let faPtr = try faData.extractFatArch64(magic.isSwapped)
            let mhOffset = faPtr.pointee.offset
            let mhMagic = try readMagic(at: mhOffset)
            let header = try readMachHeader(at: mhOffset,
                                            with: mhMagic,
                                            full: full)

            return try FatArch(offset: offset,
                               size: faSize,
                               ptr: faPtr,
                               header: header)
        } else {
            let faSize = MemoryLayout<fat_arch>.size
            let faData = try _readMutableData(from: offset,
                                              for: faSize)
            let faPtr = try faData.extractFatArch(magic.isSwapped)
            let mhOffset = UInt64(faPtr.pointee.offset)
            let mhMagic = try readMagic(at: mhOffset)
            let header = try readMachHeader(at: mhOffset,
                                            with: mhMagic,
                                            full: full)

            return try FatArch(offset: offset,
                               size: faSize,
                               ptr: faPtr,
                               header: header)
        }
    }

    func readFatHeader(at offset: UInt64,
                       with magic: Magic,
                       full: Bool) throws -> FatHeader {
        let fhSize = MemoryLayout<fat_header>.size
        let fhData = try _readMutableData(from: 0,
                                          for: fhSize)
        let fhPtr = try fhData.extractFatHeader(magic.isSwapped)

        var fhOffset = UInt64(fhSize)
        var archs: [FatArch] = []

        for _ in 1...fhPtr.pointee.nfat_arch {
            let arch = try readFatArch(at: fhOffset,
                                       with: magic,
                                       full: full)

            archs.append(arch)

            fhOffset += UInt64(arch.size)
        }

        return try FatHeader(offset: offset,
                             size: fhSize,
                             magic: magic,
                             archs: archs)
    }

    func readLoadCommands(at offset: UInt64,
                          size: Int,
                          count: Int,
                          with magic: Magic) throws -> [LoadCommand] {
        let lcsData = try _readMutableData(from: offset,
                                           for: size)

        var commands: [LoadCommand] = []
        var lcOffset = 0

        let tmpSize = MemoryLayout<load_command>.size

        for _ in 1...count {
            let rawPtr = lcsData.mutableBytes.advanced(by: lcOffset)
            let tmpData = NSMutableData(bytes: rawPtr,
                                        length: tmpSize)
            let tmpPtr = try tmpData.extractLoadCommand(magic.isSwapped)
            let lcKind = LoadCommand.Kind(tmpPtr.pointee.cmd)
            let lcSize = Int(tmpPtr.pointee.cmdsize)
            let lcData = NSMutableData(bytes: rawPtr,
                                       length: lcSize)
            let command = try _makeLoadCommand(offset: offset + UInt64(lcOffset),
                                               size: lcSize,
                                               kind: lcKind,
                                               data: lcData,
                                               isSwapped: magic.isSwapped)

            commands.append(command)

            lcOffset += lcSize
        }

        return commands
    }

    func readMachHeader(at offset: UInt64,
                        with magic: Magic,
                        full: Bool) throws -> MachHeader {
        if magic.is64Bit {
            let mhSize = MemoryLayout<mach_header_64>.size
            let mhData = try _readMutableData(from: offset,
                                              for: mhSize)
            let mhPtr = try mhData.extractMachHeader64(magic.isSwapped)
            let commands: [LoadCommand] = full ?
                try readLoadCommands(at: offset + UInt64(mhSize),
                                     size: Int(mhPtr.pointee.sizeofcmds),
                                     count: Int(mhPtr.pointee.ncmds),
                                     with: magic) :
                []

            return try MachHeader(offset: offset,
                                  size: mhSize,
                                  magic: magic,
                                  ptr: mhPtr,
                                  commands: commands)
        } else {
            let mhSize = MemoryLayout<mach_header>.size
            let mhData = try _readMutableData(from: offset,
                                              for: mhSize)
            let mhPtr = try mhData.extractMachHeader(magic.isSwapped)
            let commands: [LoadCommand] = full ?
                try readLoadCommands(at: offset + UInt64(mhSize),
                                     size: Int(mhPtr.pointee.sizeofcmds),
                                     count: Int(mhPtr.pointee.ncmds),
                                     with: magic) :
                []

            return try MachHeader(offset: offset,
                                  size: mhSize,
                                  magic: magic,
                                  ptr: mhPtr,
                                  commands: commands)
        }
    }

    func readMagic(at offset: UInt64) throws -> Magic {
        let mdata = try _readMutableData(from: offset,
                                         for: MemoryLayout<UInt32>.size)

        guard
            let mptr = mdata.bindMutable(UInt32.self)
            else { throw MachObject.Error.badMagic }

        return try Magic(mptr.pointee)
    }

    // MARK: Private Instance Methods

    private func _makeLoadCommand(offset: UInt64,
                                  size: Int,
                                  kind: LoadCommand.Kind,
                                  data: NSMutableData,
                                  isSwapped: Bool) throws -> LoadCommand {
        switch kind {
            //        case .LC_BUILD_VERSION:
            //            guard
            //                let lcPtr = data.extractBuildVersionCommand(isSwapped)
            //                else { return nil }

        case .LC_CODE_SIGNATURE,
             .LC_DATA_IN_CODE,
             .LC_DYLIB_CODE_SIGN_DRS,
             .LC_FUNCTION_STARTS,
             .LC_LINKER_OPTIMIZATION_HINT,
             .LC_SEGMENT_SPLIT_INFO:
            return try LinkeditDataCommand(offset: offset,
                                           size: size,
                                           kind: kind,
                                           data: data,
                                           isSwapped: isSwapped)

            //        case .LC_DYLD_ENVIRONMENT,
            //             .LC_ID_DYLINKER,
            //             .LC_LOAD_DYLINKER:
            //            guard
            //                let lcPtr = data.extractDylinkerCommand(isSwapped)
            //                else { return nil }

            //        case .LC_DYLD_INFO,
            //             .LC_DYLD_INFO_ONLY:
            //            guard
            //                let lcPtr = data.extractDyldInfoCommand(isSwapped)
            //                else { return nil }

            //        case .LC_DYSYMTAB:
            //            guard
            //                let lcPtr = data.extractDysymtabCommand(isSwapped)
            //                else { return nil }

            //        case .LC_ENCRYPTION_INFO:
            //            guard
            //                let lcPtr = data.extractEncryptionInfoCommand(isSwapped)
            //                else { return nil }

            //        case .LC_ENCRYPTION_INFO_64:
            //            guard
            //                let lcPtr = data.extractEncryptionInfoCommand64(isSwapped)
            //                else { return nil }

        case .LC_ID_DYLIB,
             .LC_LOAD_DYLIB,
             .LC_LOAD_WEAK_DYLIB,
             .LC_REEXPORT_DYLIB:
            return try DylibCommand(offset: offset,
                                    size: size,
                                    kind: kind,
                                    data: data,
                                    isSwapped: isSwapped)

            //        case .LC_LINKER_OPTION:
            //            guard
            //                let lcPtr = data.extractLinkerOptionCommand(isSwapped)
            //                else { return nil }

            //        case .LC_MAIN:
            //            guard
            //                let lcPtr = data.extractEntryPointCommand(isSwapped)
            //                else { return nil }

            //        case .LC_NOTE:
            //            guard
            //                let lcPtr = data.extractNoteCommand(isSwapped)
            //                else { return nil }

            //        case .LC_ROUTINES:
            //            guard
            //                let lcPtr = data.extractRoutinesCommand(isSwapped)
            //                else { return nil }

            //        case .LC_ROUTINES_64:
            //            guard
            //                let lcPtr = data.extractRoutinesCommand64(isSwapped)
            //                else { return nil }

            //        case .LC_RPATH:
            //            guard
            //                let lcPtr = data.extractRpathCommand(isSwapped)
            //                else { return nil }

        case .LC_SEGMENT,
             .LC_SEGMENT_64:
            return try SegmentCommand(offset: offset,
                                      size: size,
                                      kind: kind,
                                      data: data,
                                      isSwapped: isSwapped)

            //        case .LC_SOURCE_VERSION:
            //            guard
            //                let lcPtr = data.extractSourceVersionCommand(isSwapped)
            //                else { return nil }

            //        case .LC_SUB_CLIENT:
            //            guard
            //                let lcPtr = data.extractSubClientCommand(isSwapped)
            //                else { return nil }

            //        case .LC_SUB_FRAMEWORK:
            //            guard
            //                let lcPtr = data.extractSubFrameworkCommand(isSwapped)
            //                else { return nil }

            //        case .LC_SUB_LIBRARY:
            //            guard
            //                let lcPtr = data.extractSubLibraryCommand(isSwapped)
            //                else { return nil }

            //        case .LC_SUB_UMBRELLA:
            //            guard
            //                let lcPtr = data.extractSubUmbrellaCommand(isSwapped)
            //                else { return nil }

        case .LC_SYMTAB:
            return try SymtabCommand(offset: offset,
                                     size: size,
                                     kind: kind,
                                     data: data,
                                     isSwapped: isSwapped)

            //        case .LC_THREAD,
            //             .LC_UNIXTHREAD:
            //            guard
            //                let lcPtr = data.extractThreadCommand(isSwapped)
            //                else { return nil }

            //        case .LC_TWOLEVEL_HINTS:
            //            guard
            //                let lcPtr = data.extractTwolevelHintsCommand(isSwapped)
            //                else { return nil }

            //        case .LC_UUID:
            //            guard
            //                let lcPtr = data.extractUuidCommand(isSwapped)
            //                else { return nil }

            //        case .LC_VERSION_MIN_IPHONEOS,
            //             .LC_VERSION_MIN_MACOSX,
            //             .LC_VERSION_MIN_TVOS,
            //             .LC_VERSION_MIN_WATCHOS:
            //            guard
            //                let lcPtr = data.extractVersionMinCommand(isSwapped)
            //                else { return nil }

        default:
            return try LoadCommand(offset: offset,
                                   size: size,
                                   kind: kind)
        }
    }

    private func _readMutableData(from offset: UInt64,
                                  for size: Int) throws -> NSMutableData {
        seek(toFileOffset: offset)

        let data = readData(ofLength: size) as NSData

        guard
            data.length >= size,
            let mdata = data.mutableCopy(with: nil) as? NSMutableData
            else { throw MachObject.Error.badRead }

        return mdata
    }
}
