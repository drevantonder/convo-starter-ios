# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is an iOS app with a widget extension that fetches conversation starters from an API. The project has three main targets:

- **ConvoStarter**: Main iOS app that displays conversation starters
- **ConvoStarterWidget**: iOS widget extension
- **ConvoStarterShared**: Swift package for shared code

## Key Architecture

- Main app uses SwiftUI with a simple `ContentView` that fetches data from `https://convo-starters.drevan.me/api/conversation-starters/latest`
- API response expected format: `{"text": "conversation starter text"}`

## Development Commands

This is an Xcode project. Use Xcode to build and run:

- Open `ConvoStarter.xcodeproj` in Xcode
- Select ConvoStarter scheme to run the main app
- Select ConvoStarterWidget scheme to run the widget extension
- Build with Cmd+B, Run with Cmd+R
