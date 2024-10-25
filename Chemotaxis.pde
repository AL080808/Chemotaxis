int numBacteria = 100;               // Initial number of bacteria
Bacteria[] bacteriaArray;             // Array to hold all bacteria
float biasStrength = 0.5;             // Bias strength towards/away from the mouse (positive = towards, negative = away)

void setup() {
  size(800, 600);                     // Size of the window
  bacteriaArray = new Bacteria[numBacteria];
  
  // Initialize each bacteria with a random position and random color
  for (int i = 0; i < numBacteria; i++) {
    bacteriaArray[i] = new Bacteria(int(random(width)), int(random(height)), color(int(random(255)), int(random(255)), int(random(255))));
  }
}

void draw() {
  background(255);                    // Clear the background
  
  // Move, display, check for reproduction, and remove dead bacteria
  for (int i = 0; i < bacteriaArray.length; i++) {
    if (bacteriaArray[i] != null) {
      bacteriaArray[i].move(biasStrength);
      bacteriaArray[i].show();
      
      // Check if bacteria is dead
      if (bacteriaArray[i].isDead()) {
        bacteriaArray[i] = null;      // Remove dead bacteria
      } else {
        // Check for reproduction
        Bacteria child = bacteriaArray[i].reproduce();
        if (child != null) {
          addBacteria(child);
        }
      }
    }
  }
}

// Adjust bias strength based on mouse button clicks
void mousePressed() {
  if (mouseButton == LEFT) {
    biasStrength = 0.5;               // Move towards the mouse
  } else if (mouseButton == RIGHT) {
    biasStrength = -0.5;              // Move away from the mouse
  }
}

// Add a new bacteria to the array if there's space
void addBacteria(Bacteria b) {
  for (int i = 0; i < bacteriaArray.length; i++) {
    if (bacteriaArray[i] == null) {
      bacteriaArray[i] = b;
      return;
    }
  }
}

// Define the Bacteria class
class Bacteria {
  int x, y;                           // X and Y coordinates of the bacteria
  int col;                            // Color of the bacteria (renamed from color to col)
  int lifespan;                       // Lifespan of the bacteria
  
  // Constructor to initialize the bacteria
  Bacteria(int xPos, int yPos, int col) {
    x = xPos;
    y = yPos;
    this.col = col;
    lifespan = int(random(1000, 2000)); // Bacteria live for 1000 to 2000 frames
  }

  // Move the bacteria in a random walk with bias toward or away from the mouse
  void move(float bias) {
    // Calculate direction toward the mouse
    float deltaX = mouseX - x;
    float deltaY = mouseY - y;
    
    // Normalize the direction vector
    float distance = dist(x, y, mouseX, mouseY);
    if (distance != 0) {
      deltaX /= distance;
      deltaY /= distance;
    }
    
    // Apply a random walk with bias towards/away from the mouse
    x += int(random(-1, 2)) + deltaX * bias;
    y += int(random(-1, 2)) + deltaY * bias;
    
    lifespan--;                       // Decrease lifespan
  }

  // Display the bacteria as a circle
  void show() {
    fill(col);
    noStroke();
    ellipse(x, y, 10, 10);
  }

  // Check if bacteria is dead
  boolean isDead() {
    return lifespan <= 0;
  }

  // Reproduce with a 1% chance each frame
  Bacteria reproduce() {
    if (random(1) < 0.01) {           // 1% chance to reproduce each frame
      return new Bacteria(x, y, col); // New bacteria at the same location
    }
    return null;
  }
}
