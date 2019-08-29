// © 2019 J. G. Pusey (see LICENSE.md)

public extension MachObject {

    // MARK: Public Instance Methods

    func dump(_ command: DylibCommand,
              _ index: UInt32) {
        print("Load command \(index)")
        print("          cmd \(command.kind)")
        print("      cmdsize \(command.size)")
        print("         name \(command.name) (offset \(command.nameOffset))")
        print("   time stamp \(command.timestamp)")
        print("      current version \(command.currentVersion)")
        print("compatibility version \(command.compatibilityVersion)")
    }

    func dump(_ arch: FatArch) {
        print("architecture \(arch.architecture)")
        print("    cputype \(arch.cpuType)")
        print("    cpusubtype \(arch.cpuSubtype)")
        print("    capabilities 0x0")
        print("    offset \(arch.offset)")
        print("    size \(arch.objectSize)")
        print("    align 2^\(arch.alignment) (\(1 << arch.alignment))")
    }

    func dump(_ header: FatHeader) {
        print("Fat headers")
        print("fat_magic \(header.magic)")
        print("nfat_arch \(header.archCount)")
    }

    func dump(_ command: LinkeditDataCommand,
              _ index: UInt32) {
        print("Load command \(index)")
        print("      cmd \(command.kind)")
        print("  cmdsize \(command.size)")
        print("  dataoff \(command.dataOffset)")
        print(" datasize \(command.dataSize)")
    }

    func dump(_ command: LoadCommand,
              _ index: UInt32) {
        switch command {
        case let command as DylibCommand:
            dump(command, index)

        case let command as LinkeditDataCommand:
            dump(command, index)

        case let command as RpathCommand:
            dump(command, index)

        case let command as SegmentCommand:
            dump(command, index)

        case let command as SymtabCommand:
            dump(command, index)

        default:
            print("Load command \(index)")
            print("      cmd \(command.kind)")
            print("  cmdsize \(command.size)")
        }
    }

    func dump(_ header: MachHeader) {
        print("Mach header")
        print("      magic cputype cpusubtype  caps    filetype ncmds sizeofcmds      flags")
        print(_padLeft(header.magic, 11),
              _padLeft(header.cpuType.briefDescription, 7),
              _padLeft(header.cpuSubtype.briefDescription, 10),
              _padLeft("0x00", 5),
              _padLeft(header.fileType.briefDescription, 11),
              _padLeft(header.commandCount, 5),
              _padLeft(header.totalCommandSize, 10),
              " ",
              header.flags)
    }

    func dump(_ command: RpathCommand,
              _ index: UInt32) {
        print("Load command \(index)")
        print("          cmd \(command.kind)")
        print("      cmdsize \(command.size)")
        print("         path \(command.path) (offset \(command.pathOffset))")
    }

    func dump(_ command: SegmentCommand,
              _ index: UInt32) {
        print("Load command \(index)")
        print("      cmd \(command.kind)")
        print("  cmdsize \(command.size)")
        print("  segname \(command.segmentName)")
        print("   vmaddr \(command.vmAddress)")
        print("   vmsize \(command.vmSize)")
        print("  fileoff \(command.fileOffset)")
        print(" filesize \(command.fileSize)")
        print("  maxprot \(command.maximumProtection)")
        print(" initprot \(command.initialProtection)")
        print("   nsects \(command.sectionCount)")
        print("    flags \(command.flags)")
    }

    func dump(_ command: SymtabCommand,
              _ index: UInt32) {
        print("Load command \(index)")
        print("     cmd \(command.kind)")
        print(" cmdsize \(command.size)")
        print("  symoff \(command.symbolTableOffset)")
        print("   nsyms \(command.symbolCount)")
        print("  stroff \(command.stringTableOffset)")
        print(" strsize \(command.stringTableSize)")
    }

    // MARK: Private Instance Methods

    private func _padLeft(_ item: Any,
                          _ width: Int) -> String {
        let string = String(describing: item)

        if string.count < width {
            return String(repeating: " ",
                          count: width - string.count) + string
        } else {
            return string
        }
    }
}
