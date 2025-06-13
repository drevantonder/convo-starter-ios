# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

This is an iOS app with a widget extension that fetches conversation starters from an API. The project has three main targets:

- **ConvoStarter**: Main iOS app that displays conversation starters
- **ConvoStarterWidget**: iOS widget extension (currently template code)
- **ConvoStarterShared**: Swift package for shared code (currently empty)

## Key Architecture

- Main app uses SwiftUI with a simple `ContentView` that fetches data from `https://convo-starters.drevan.me/api/conversation-starters/latest`
- API response expected format: `{"text": "conversation starter text"}`
- Widget uses `TimelineProvider` pattern but currently displays placeholder content

## Development Commands

This is an Xcode project. Use Xcode to build and run:

- Open `ConvoStarter.xcodeproj` in Xcode
- Select ConvoStarter scheme to run the main app
- Select ConvoStarterWidget scheme to run the widget extension
- Build with Cmd+B, Run with Cmd+R

## Widget Integration

The widget currently shows placeholder content. To integrate with the conversation starter API:
- Implement API fetching in the widget's `Provider`
- Update `SimpleEntry` to include conversation text
- Modify `ConvoStarterWidgetEntryView` to display the fetched content