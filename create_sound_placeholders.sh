#!/bin/bash

# Sound File Generator Script
# This script creates placeholder silent MP3 files for development
# Replace these with actual sound files for production

echo "Creating placeholder sound files..."

# Create sounds directory if it doesn't exist
mkdir -p assets/sounds

# Function to create a silent MP3 placeholder
create_placeholder() {
    local filename=$1
    local duration=$2

    echo "Creating $filename (${duration}ms silent placeholder)..."

    # Create an empty file as placeholder
    # In production, replace these with actual MP3 files
    touch "assets/sounds/$filename"

    echo "✓ Created assets/sounds/$filename"
}

# Create placeholder files
create_placeholder "click.mp3" 100
create_placeholder "correct.mp3" 500
create_placeholder "wrong.mp3" 300
create_placeholder "level_complete.mp3" 1500

echo ""
echo "✅ All placeholder sound files created!"
echo ""
echo "⚠️  IMPORTANT: These are EMPTY placeholder files."
echo "   Replace them with actual MP3 sound files for production."
echo ""
echo "📁 Location: assets/sounds/"
echo ""
echo "🔊 Required files:"
echo "   - click.mp3 (tap/select sound)"
echo "   - correct.mp3 (success chime)"
echo "   - wrong.mp3 (error buzz)"
echo "   - level_complete.mp3 (achievement fanfare)"
echo ""
echo "📖 See assets/sounds/README.md for details"
echo ""
