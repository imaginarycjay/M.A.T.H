# Sound Effects

This folder should contain the following sound effect files:

## Required Sound Files

1. **click.mp3** - A subtle click/tap sound when selecting an answer
   - Duration: ~100ms
   - Volume: Low (subtle feedback)
   - Suggested: Short "pop" or "click" sound

2. **correct.mp3** - A cheerful sound when answering correctly
   - Duration: ~500ms
   - Volume: Medium
   - Suggested: "Ding", "Chime", or positive bell sound

3. **wrong.mp3** - A low error sound when answering incorrectly
   - Duration: ~300ms
   - Volume: Medium
   - Suggested: "Buzz" or soft error tone

4. **level_complete.mp3** - A fanfare when completing a level/node
   - Duration: ~1-2 seconds
   - Volume: Medium-High
   - Suggested: Success fanfare or achievement jingle

## File Format

- Format: MP3
- Sample Rate: 44.1kHz recommended
- Bitrate: 128kbps or higher

## Free Sound Resources

You can find free sound effects at:
- [Freesound.org](https://freesound.org)
- [Zapsplat.com](https://www.zapsplat.com)
- [Mixkit.co](https://mixkit.co/free-sound-effects/)

## Current Status

⚠️ **Placeholder files are currently being used.** Replace with actual sound files for production.

## Implementation

The sounds are managed by `SoundManager` singleton class located at:
`lib/utils/sound_manager.dart`

Sounds are played automatically at:
- **Click**: When selecting an answer option
- **Correct**: When submitting a correct answer
- **Wrong**: When submitting an incorrect answer
- **Level Complete**: When passing a level/quiz
