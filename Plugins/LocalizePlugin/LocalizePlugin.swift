import Foundation
import PackagePlugin

@main
struct LocalizePlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        let input = target.directory.appending(subpath: "\(target.name)/Resources/en.lproj/Localizable.strings")
        let outputDir = context.pluginWorkDirectory.appending("GeneratedFiles")
        let output = outputDir.string + "/Localized.swift"

//        let output = context.pluginWorkDirectory.appending(subpath: "\(target.name)/Localized.swift")
//        try FileManager.default.createDirectory(atPath: output.removingLastComponent().string, withIntermediateDirectories: false)
        debugPrint("PluginWorkDirectory: \(context.pluginWorkDirectory)")

        let executable = context.package.directory
            .appending(subpath: "scripts/Localizable")
        debugPrint("Excecutable \(executable)")

        return [
            .prebuildCommand(
                displayName: "Generate Localized.swift [build Command] for \(target.name)",
                executable: executable,
                arguments: [
                    "generateCode",
                    input,
                    "-o=\(output)",
                    "-m=1"
                ],
                environment: [:],
                outputFilesDirectory: outputDir
            )
        ]
    }
}
