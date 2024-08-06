//
//  helperApp.swift
//  helper
//
//  Created by developer on 18.07.2024.
//

import SwiftUI

@main
struct helperApp: App {
    var body: some Scene {
        MenuBarExtra {
            Button("Fetch flutter module updates") {
                callFlutterShell()
            }
            Divider()
            Button("Install test") {
                installTest()
            }
            Button("Install prod") {
                installProd()
            }
            Divider()
            Button("Remove Derived Data") {
                removeDerivedData()
            }
            Divider()
            Button("Quit") {
                exitApp()
            }
        } label: {
            Image(systemName: "swift")
        }
        .menuBarExtraStyle(.menu)
    }
    
    private func install(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    private func installTest() {
        install(Urls.Test)
    }
    
    private func installProd() {
        install(Urls.Prod)
    }
    
    private func removeDerivedData() {
        guard let scriptPath = getBundlePath(named: Scripts.derived) else {
            print("Script file not found in bundle.")
            return
        }
        let arguments = [scriptPath]
        runScript(with: arguments)
    }
    
    private func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    private func getBundlePath(named: String) -> String? {
        Bundle.main.path(forResource: named, ofType: "sh")
    }
    
    private func runScript(
        with arguments: [String]
    ) {
        let task = Process()
        let arguments = arguments
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = arguments
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        DispatchQueue.global(qos: .utility).async {
            do {
                try task.run()
                task.waitUntilExit()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    print("Script output: \(output)")
                }
            } catch {
                print("Failed to run script: \(error)")
            }
        }
    }
    
    private func callFlutterShell() {
        guard let scriptPath = Bundle.main.path(forResource: "flutter", ofType: "sh") else {
            print("Script file not found in bundle.")
            return
        }
        let pipe = Pipe()
        let task = Process()
        let flutterPath = ""
        let appPath = ""
        let arguments = [scriptPath, flutterPath, appPath]
        task.arguments = arguments
        task.standardOutput = pipe
        task.standardError = pipe
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        DispatchQueue.global(qos: .utility).async {
            do {
                try task.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)!
                print(output)
            } catch {
                print("error")
            }
        }
    }
}
