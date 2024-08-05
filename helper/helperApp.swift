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
                callShell()
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
        // TODO: -
    }
    
    private func exitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    private func callShell() {
        guard let scriptPath = Bundle.main.path(forResource: "script", ofType: "sh") else {
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
        task.standardInput = nil
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
