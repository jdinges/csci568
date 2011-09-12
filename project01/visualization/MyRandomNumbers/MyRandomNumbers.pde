/*
 #myrandomnumber Tutorial
 blprnt@blprnt.com
 April, 2010
 */

//This is the Google spreadsheet manager and the id of the spreadsheet that we want to populate, along with our Google username & password
SimpleSpreadsheetManager sm;
String sUrl = "t6mq_WLV5c5uj6mUNSryBIA";
String googleUser = GUSER;
String googlePass = GPASS; 

//This is the font object
PFont label;

void barGraph(int[] nums, float y){
  //Make a list of number counts
  int[] counts = new int [100];
  
  //Fill it with zeros
  for(int i = 1; i < 100; i++){
    counts[i] = 0;
  }
  
  //Tally the counts
  for(int i = 0; i < nums.length; i++){
    counts[nums[i]]++;
  }
  
  //Draw the bar graph
  for(int i = 0; i < counts.length; i++){
    //fill(255, 255 - (counts[i] * 30), 0);
    colorMode(HSB);
    fill(counts[i] * 30, 255, 255);
    rect(i * 8, y, 8, -counts[i] * 10);
  }
}

void colorGrid (int[] nums, float x, float y, float s){
  //Make a list of number counts
  int[] counts = new int[100];
  
  //Fill it with zeros
  for(int i = 0; i < 100; i++){
    counts[i] = 0;
  }
  
  //Tally the counts
  for(int i = 0; i < nums.length; i++){
    counts[nums[i]]++;
  }
  
  //Move the drawing coordinates to the x,y position specified in the parameters
  pushMatrix();
  translate(x,y);
  
  //Draw the grid
  for(int i = 0; i < counts.length; i++){
    colorMode(HSB);
    fill(counts[i] * 30, 255, 255, counts[i] * 30);
    //rect((i % 10) * s, floor(i/10) * s, s, s);
    textAlign(CENTER);
    textFont(label);
    textSize(s/2);
    text(i, (i % 10) * s, floor(i/10) * s);
  }
  
  popMatrix();
}
  
void setup() {
  //This code happens once, right when our sketch is launched
  size(800,800);
  background(0);
  smooth();
  
  //Create the font object to make text with
  label = createFont("Helvetica",24);
  
  //Ask for some list of numbers
  int[] numbers = getNumbers();
  
  //Draw bar graph
  //barGraph(numbers, 100);
  colorGrid(numbers,50,50,70);
  
  //Generate some random number graphs to compare to
  /*
  for(int i = 1; i < 7; i++){
    int[] randoms = getRandomNumbers(255);
    barGraph(randoms, 100 + (i * 130));
  }
  */
}

void draw() {
  //This code happens once every frame.
  
}

