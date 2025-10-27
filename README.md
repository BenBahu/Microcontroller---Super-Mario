# Homemade Mario Game - Microcontroller Project

A classic Mario-style platformer game implemented on an ATmega128 microcontroller with LED matrix display, LCD interface, and sound effects.

## 🎮 Game Overview

This project implements a complete Mario-style platformer game featuring:
- **Real-time gameplay** on an 8x8 LED matrix display
- **Two challenging levels** with different obstacle patterns
- **Physics-based jumping mechanics** with collision detection
- **60-second time limit** for added challenge
- **LCD interface** for game status and menu navigation
- **Sound effects** for enhanced gaming experience
- **Rotary encoder** for menu navigation and volume control

### 🎬 Demo Video
This video shows the complete gameplay experience including menu navigation, level progression, and game mechanics.

<video width="640" height="480" controls>
  <source src="Projet.mp4" type="video/mp4">
</video>

[Download Demo Video](Projet.mp4)

## 🎯 Game Features

### Core Gameplay
- **Character Movement**: Green pixel representing Mario
- **Jumping Mechanics**: Physics-based jumping with gravity simulation
- **Collision Detection**: Orange obstacles that end the game on lateral contact
- **Level Progression**: Two distinct levels with increasing difficulty
- **Time Challenge**: 60-second countdown timer

### Hardware Integration
- **LED Matrix Display**: 8x8 WS2812B RGB LED matrix for game visualization
- **LCD Screen**: HD44780U-compatible display for menus and game status
- **Input Controls**: 
  - Button 0: Move forward/advance
  - Button 1: Jump
  - Button 6: Restart game
- **Rotary Encoder**: Menu navigation and volume control
- **Piezo Speaker**: Sound effects and background music

### Game Mechanics
- **Level Design**: Procedurally designed levels with various obstacle patterns
- **Physics Engine**: Realistic jumping with ascent and descent phases
- **Memory Management**: Efficient LED matrix data handling
- **Interrupt System**: Real-time game loop with timer and external interrupts

## 🔧 Hardware Requirements

### Microcontroller
- **ATmega128L** running at 4MHz
- **STK-300** development board

### Peripherals
- **8x8 WS2812B LED Matrix** (64 RGB LEDs)
- **HD44780U LCD Display** (16x2 characters)
- **Rotary Encoder** with push button
- **Piezo Speaker** (2kHz frequency)
- **Push Buttons** (3x for game controls)

### Pin Configuration
```
PORTB: LEDs, Speaker (pin 2), Encoder (pins 4,5,6), IR (pin 7)
PORTD: Push buttons (pins 0,1,6)
PORTE: WS2812B data line (pin 1)
```

## 🚀 Getting Started

### Prerequisites
- Atmel Studio 7.0 or compatible IDE
- AVR-GCC toolchain
- STK-300 development board
- Required hardware components

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Microcontrôleurs
   ```

2. **Open the project**
   - Launch Atmel Studio 7.0
   - Open `map.atsln` solution file
   - Or open `map/map.asmproj` project file

3. **Configure hardware**
   - Connect WS2812B matrix to PORTE pin 1
   - Connect LCD to external SRAM interface
   - Connect buttons to PORTD pins 0, 1, 6
   - Connect rotary encoder to PORTB pins 4, 5, 6
   - Connect piezo speaker to PORTB pin 2

4. **Build and flash**
   - Select Debug configuration
   - Build the project (Ctrl+F7)
   - Flash to ATmega128L microcontroller

## 🎮 How to Play

### Game Controls
- **Button 0**: Move Mario forward (advance through level)
- **Button 1**: Make Mario jump over obstacles
- **Button 6**: Restart current game
- **Rotary Encoder**: Navigate menus and adjust volume

### Gameplay
1. **Menu Navigation**: Use rotary encoder to select level and adjust volume
2. **Start Game**: Press encoder button to begin
3. **Movement**: Press Button 0 to advance through the level
4. **Jumping**: Press Button 1 to jump over orange obstacles
5. **Objective**: Reach the end of the level within 60 seconds
6. **Avoid**: Orange obstacles - touching them ends the game

### Scoring
- Complete levels as quickly as possible
- Avoid collisions with orange obstacles
- Beat the 60-second time limit

## 📁 Project Structure

```
map/
├── Map1Done.asm          # Main game implementation
├── definitions.asm       # Hardware definitions and constants
├── macros.asm           # General-purpose macros
├── macros_map.asm       # Game-specific macros and LED control
├── macros_LCD.asm       # LCD display macros
├── lcd.asm              # LCD driver implementation
├── encoder.asm          # Rotary encoder handling
├── sound.asm            # Sound generation and music
├── file_sound.asm       # Game sound effects and music data
├── ws2812b_4MHz_demo01_S.asm  # LED matrix driver
└── Debug/               # Build output files
```

## 🔬 Technical Details

### Architecture
- **Assembly Language**: Pure AVR assembly for optimal performance
- **Memory Management**: Efficient use of SRAM for game data
- **Interrupt System**: Timer and external interrupts for real-time control
- **Modular Design**: Separate modules for different functionalities

### Performance
- **Clock Speed**: 4MHz ATmega128L
- **Frame Rate**: ~10 FPS LED matrix refresh
- **Response Time**: <10ms button response
- **Memory Usage**: ~4KB program memory, ~1KB SRAM

### Game Engine Features
- **Collision Detection**: Pixel-perfect collision with obstacles
- **Physics Simulation**: Realistic jumping mechanics
- **Level Generation**: Pre-designed level patterns
- **State Management**: Game states (menu, playing, game over)

## 🎵 Audio Features

### Sound Effects
- **Jump Sound**: Short beep when Mario jumps
- **Game Over**: Melodic sequence on collision/timeout
- **Level Complete**: Victory fanfare on level completion
- **Background Music**: Mario theme song (optional)

### Audio Control
- **Volume Control**: 10 levels (0-9) via rotary encoder
- **Sound Toggle**: Enable/disable via encoder button

## 🐛 Troubleshooting

### Common Issues
1. **LED Matrix Not Working**
   - Check PORTE pin 1 connection
   - Verify WS2812B power supply (5V)
   - Ensure proper timing in macros

2. **LCD Display Issues**
   - Check external SRAM interface
   - Verify HD44780U connections
   - Check contrast adjustment

3. **Button Response Problems**
   - Verify PORTD pin connections
   - Check pull-up resistors
   - Test interrupt configuration

4. **Sound Issues**
   - Check PORTB pin 2 connection
   - Verify piezo speaker functionality
   - Test sound generation routines

## 📊 Performance Optimization

### Memory Optimization
- Efficient register usage
- Optimized LED data structures
- Minimal stack usage

### Timing Optimization
- Precise WS2812B timing macros
- Efficient interrupt handling
- Optimized game loop

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on hardware
5. Submit a pull request

## 📄 License

This project is created for educational purposes. Please respect the original work and give appropriate credit.

## 👨‍💻 Authors

- **Main Developer**: Benjamin Bahurel
- **Sound Implementation**: Jacques Benand
- **Project Supervisor**: Pr. Alexandre Schmid

## 📚 References

- ATmega128L Datasheet
- WS2812B LED Datasheet
- HD44780U LCD Controller Manual
- AVR Assembly Programming Guide

---

**Note**: This project demonstrates advanced microcontroller programming techniques including real-time systems, hardware interfacing, and game development in assembly language.
