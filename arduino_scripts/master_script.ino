#include <GyverOLED.h>
#include <avr/io.h>
#include <avr/interrupt.h>

#define FREQ_MIN 40
#define FREQ_MAX 20000

GyverOLED<SSH1106_128x64> oled;
volatile uint16_t lastCount = 0;
volatile uint16_t period = 0;
volatile bool newData = false;
float frequency = 0;

void setupTimer1() {
    TCCR1A = 0;                               // Initialize timer1, normal mode
    TCCR1B = (1 << CS11);                     // Set Timer1 prescaler to 8
    Serial.println("Timer1 Setup Complete");
}

void setupExternalInterrupt() {
    EICRA |= (1 << ISC00) | (1 << ISC01);  // Set interrupt on rising edge of INT0
    EIMSK |= (1 << INT0);                  // Enable INT0 interrupt
    Serial.println("External Interrupt Setup Complete");
}

ISR(INT0_vect) {
    uint16_t currentCount = TCNT1;  // Read Timer1 value
    period = currentCount - lastCount;
    lastCount = currentCount;
    if (period > 0) {newData = true;}
}

void setup() {
    Serial.begin(9600);
    Serial.println("Initializing...");

    oled.init();
    oled.clear();
    oled.update();
    oled.setScale(2);
    
    oled.setCursor(0, 0);
    oled.print("ELECTRONICS");
    oled.setCursor(0, 2);
    oled.print("4 EMBEDDED");
    oled.setCursor(0, 4);
    oled.print("SYSTEMS");    
    oled.update();
    delay(3000);

    oled.clear();
    oled.setCursor(0, 0);    
    oled.print("Giacomo");
    oled.setCursor(0, 2);
    oled.print("Gramaglia");
    oled.setCursor(0, 4);
    oled.print("FPGA SYNTH");    
    oled.update();
    delay(3000);
    
    setupTimer1();
    setupExternalInterrupt();
    sei(); // Enable global interrupts
    Serial.println("Frequency Estimation Initialized");

    // Set pin D3 as input
    pinMode(3, INPUT);
}

void loop() {
    // Check the state of pin D3
    if (digitalRead(3) == HIGH) {
        // If D3 is HIGH, display "Writing to LUT"
        oled.clear();
        oled.setScale(2);
        oled.setCursor(0, 0);
        oled.print("Writing to");
        oled.setCursor(0, 2);
        oled.print("flash...");
        oled.update();
    } else {
        // If D3 is LOW, execute the rest of the code
        if (newData) {
            newData = false;
            if (period > 0) {
                frequency = 2000000.0 / period;  // 2 MHz clock, each tick = 0.5 µs
            } else {
                frequency = 0;
            }
            Serial.print("Period: ");
            Serial.print(period);
            Serial.print(" us, Frequency: ");
            Serial.println(frequency);
        } else {
            Serial.println("No new data");
        }

        oled.clear();
        oled.setCursor(0, 0);
        if (frequency >= FREQ_MIN && frequency <= FREQ_MAX) {
            oled.setScale(2);
            oled.print("Frequency: ");
            oled.setCursor(0, 2);
            if (frequency < 100) {
                oled.print(frequency, 1);
                oled.print(" Hz");
            } else if (frequency < 1000) {
                oled.print(frequency, 0);
                oled.print(" Hz");
            } else if (frequency < 10000){
                oled.print(frequency / 1000, 2);
                oled.print(" kHz");
            } else{
                oled.print(frequency / 1000, 1);
                oled.print(" kHz");  
            }
        } else {
            oled.setScale(2);
            oled.print("Range error");
        }
        oled.update();
    }
    delay(200);
}
