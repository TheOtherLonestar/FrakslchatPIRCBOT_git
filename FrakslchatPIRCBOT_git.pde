/*
A port of the Fraksl Android App by Ella Jameson
 WASD to move, QE to rotate, [UP][DOWN] to zoom, P to take a picture in the sketch directory
 
 Twitch integration added by TheOtherLonestar
 Combined to create a Fraksl like experience that can be controlled via Twitch Chat
 
 You need the pircbot JAVA library to make this work. 
 In you libraries folder make a folder called pircbot. 
 In the pircbot folder make a folder called library
 put the pircbot.jar file into that folder
 
 pircbot.jar can be downloaded at. http://www.jibble.org/pircbot.php
 
 Combined to create a Fraksl like experience that can be controlled via Twitch Chat
 
 Go into the config tab/file and change the botname, oauth, and channel name to your bot's and channel's info
 
 */

import org.jibble.pircbot.*;
import processing.sound.*;

AudioIn input;
Amplitude loudness;


//GLOBALS
PImage prev_screen;
int x_pos;
int y_pos;
float rotation = 0;
float zoom = .5;
int translate_delta;
float rotate_delta = TWO_PI / (pow(2, 8));
float zoom_delta = 0.01;
boolean[] current_keys = new boolean[9];
int VALUE;
long previous;
color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color purple = color(255, 0, 255);
color white = color(255, 255, 255);
color current= color(255, 255, 255);

//initialize bot
MyBot bot = new MyBot();

class MyBot extends PircBot {
  MyBot() {
    this.setName(BOTNAME);
  }
  //reads new messages and if it's a command do stuff
  void onMessage(String channel, String sender, String login, String hostname, String message) {

    //check is the message is a command then do the parse stuff
    if (message.startsWith("!")) {
      String value;
      String[] messageArray = message.split(" ");
      String command = messageArray[0];

      //checks to see if a value was sent with command
      if (messageArray.length<2) {
        value="1"; //if only command was sent then set value to 1
      }
      //if value was sent set value to value sent
      else {
        value = messageArray[1];
      }
      print("Value ");
      println(value); //prints value just so we know

      //sends value to a function to check if the value is a number and not goblegook. Returns true if a number
      boolean flag=isInteger(value);

      if (flag)
      {
        VALUE = Integer.parseInt(value); //convert the string to an int
        VALUE=abs(VALUE); //only positive numbers please
      } 
      //if bs instead of a number was set then the number is set to a default
      else {
        VALUE=500;
      }

      println("Value " + VALUE);
      previous = millis();
      color from = current;
      switch(command.toUpperCase()) {

      default:
        break;

      case "!TWISTLEFT":
        bot.sendMessage(CHANNEL, "TWIST IT");
        VALUE=constrain(VALUE, 0, 720);
        float rad=VALUE*PI/180;
        float toRotation=rotation+rad;

        while (rotation < toRotation) { 
          if ((toRotation - rotation) < .01) { 
            rotation = toRotation;
          } else { 
            rotation += .01;
          }
          delay(10);
        }




        return;

      case "!TWISTRIGHT":
        bot.sendMessage(CHANNEL, "TWIST IT");
        VALUE=constrain(VALUE, 0, 720);
        rad=VALUE*PI/180;
        toRotation=rotation-rad;

        while (rotation > toRotation) { 
          if ((rotation - toRotation) < .01) { 
            rotation = toRotation;
          } else { 
            rotation -= .01;
          }
          delay(10);
        }

        return;
      case "!UP":
        VALUE = VALUE*1000;// multiply value by 1000 to convert seconds to milliseconds. 
        VALUE = constrain(VALUE, 0, 3000); //constrains value to 3 seconds so chat can't send a huge number
        bot.sendMessage(CHANNEL, "UP");
        while (nodelay(previous, VALUE)) {
          y_pos -= translate_delta;
          delay(20);
        }
        return;
      case "!DOWN":      
        VALUE = VALUE*1000;// multiply value by 1000 to convert seconds to milliseconds. 
        VALUE = constrain(VALUE, 0, 3000); //constrains value to 3 seconds so chat can't send a huge numberbot.sendMessage(CHANNEL, "DOWN");
        while (nodelay(previous, VALUE)) {
          y_pos += translate_delta;
          delay(20);
        }
        return;
      case "!LEFT":
        VALUE = VALUE*1000;// multiply value by 1000 to convert seconds to milliseconds. 
        VALUE = constrain(VALUE, 0, 3000); //constrains value to 3 seconds so chat can't send a huge number
        bot.sendMessage(CHANNEL, "LEFT");
        while (nodelay(previous, VALUE)) {
          x_pos -= translate_delta;
          delay(25);
        }
        return;
      case "!RIGHT":
        VALUE = VALUE*1000;// multiply value by 1000 to convert seconds to milliseconds. 
        VALUE = constrain(VALUE, 0, 3000); //constrains value to 3 seconds so chat can't send a huge number
        bot.sendMessage(CHANNEL, "RIGHT");
        while (nodelay(previous, VALUE)) {
          x_pos += translate_delta;
          delay(15);
        }
        return;
      case "!ZOOMIN":
        VALUE = VALUE*1000;// multiply value by 1000 to convert seconds to milliseconds. 
        VALUE = constrain(VALUE, 0, 3000); //constrains value to 3 seconds so chat can't send a huge number
        bot.sendMessage(CHANNEL, "Magnify!");
        while (nodelay(previous, VALUE)) {
          zoom += zoom_delta;
          zoom=abs(zoom);
          println("zoom " + zoom);
          if (zoom>0.9) {
            zoom=0.9;
          }
          delay(25);
        }
        return;
      case "!ZOOMOUT":
        VALUE = VALUE*1000;// multiply value by 1000 to convert seconds to milliseconds. 
        VALUE = constrain(VALUE, 0, 3000); //constrains value to 3 seconds so chat can't send a huge number
        bot.sendMessage(CHANNEL, "Away!");
        while (nodelay(previous, VALUE)) {
          zoom -= zoom_delta;
          zoom=abs(zoom);
          println("zoom " + zoom);
          if (zoom<0.2) {
            zoom=0.2;
          }
          delay(25);
        }
        return;
      case "!RED":

        for (float i =0; i<100; i=i+1) {
          float amount=map(i, 0.0, 100.0, 0.0, 1.0);
          current=lerpColor(from, red, amount);
          delay(15);
        }

        return;
      case "!GREEN":
        for (float i =0; i<100; i=i+1) {
          float amount=map(i, 0.0, 100.0, 0.0, 1.0);
          current=lerpColor(from, green, amount);
          delay(15);
        }
        return;
      case "!BLUE":

        for (float i =0; i<100; i=i+1) {
          float amount=map(i, 0.0, 100.0, 0.0, 1.0);
          current=lerpColor(from, blue, amount);
          delay(15);
        }
        return;

      case "!PURPLE":

        for (float i =0; i<100; i=i+1) {
          float amount=map(i, 0.0, 100.0, 0.0, 1.0);
          current=lerpColor(from, purple, amount);
          delay(15);
        }
        return;
      case "!WHITE":

        for (float i =0; i<100; i=i+1) {
          float amount=map(i, 0.0, 100.0, 0.0, 1.0);
          current=lerpColor(from, white, amount);
          delay(15);
        }
        return;
      }
    }
  }

  //if you get disconnected reconnect
  public void onDisconnect() {
    connectBot();
  }
}



void mirror_screen()
{
  loadPixels();  
  for (int row = 0; row < height; row++)
  {
    for (int col = 0; col < width / 2; col++)
    {
      pixels[(width - col - 1) + (width * row)] = pixels[col + (width * row)];
    }
  }
  updatePixels();
}

void make_prev_screen()
{
  prev_screen = get();
  prev_screen.filter(INVERT);
}




void key_list(int in_key, boolean in_pressed)
{
  if (in_key == 'q')
  {
    current_keys[0] = in_pressed;
  }
  if (in_key == 'w')
  {
    current_keys[1] = in_pressed;
  }
  if (in_key == 'e')
  {
    current_keys[2] = in_pressed;
  }
  if (in_key == 'a')
  {
    current_keys[3] = in_pressed;
  }
  if (in_key == 's')
  {
    current_keys[4] = in_pressed;
  }
  if (in_key == 'd')
  {
    current_keys[5] = in_pressed;
  }
  if (in_key == UP)
  {
    current_keys[6] = in_pressed;
  }
  if (in_key == DOWN)
  {
    current_keys[7] = in_pressed;
  }
  if (in_key == 'p')
  {
    current_keys[8] = in_pressed;
  }
}

void keyPressed()
{
  if (key == CODED)
  {
    key_list(keyCode, true);
  } else
  {
    key_list(key, true);
  }
}

void keyReleased()
{
  if (key == CODED)
  {
    key_list(keyCode, false);
  } else
  {
    key_list(key, false);
  }
}


void key_update()
{
  if (current_keys[0])
  {
    rotation -= rotate_delta;
  }
  if (current_keys[1])
  {
    y_pos -= translate_delta;
  }
  if (current_keys[2])
  {
    rotation += rotate_delta;
  }
  if (current_keys[3])
  {
    x_pos -= translate_delta;
  }
  if (current_keys[4])
  {
    y_pos += translate_delta;
  }
  if (current_keys[5])
  {
    x_pos += translate_delta;
  }
  if (current_keys[6])
  {
    zoom += zoom_delta;
    zoom=abs(zoom);
    if (zoom<0.05) {
      zoom=0.05;
    }
  }
  if (current_keys[7])
  {
    zoom -= zoom_delta;
    zoom=abs(zoom);
    if (zoom<0.05) {
      zoom=0.05;
    }
  }
  save_frame = false;
  if (current_keys[8])
  {
    save_frame = true;
  }
}
void connectBot() {
  try {
    bot.connect("irc.twitch.tv", 6667, OAUTH);
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  bot.joinChannel(CHANNEL);
  bot.sendMessage(CHANNEL, "Namaste");
}

void setup()
{
  size(1280, 720);

  // Enable debugging output.
  bot.setVerbose(true);

  connectBot();

  background(0);
  frameRate(60);
  make_prev_screen();
  x_pos = (int)(width / 2) - (int)((width * zoom) / 4);
  y_pos = (int)(height / 2);
  translate_delta = (int)(height / (pow(2, 8)));

  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);
  // Begin capturing the audio input
  input.start();
  // start() activates audio capture so that you can use it as
  // the input to live sound analysis, but it does NOT cause the
  // captured audio to be played back to you. if you also want the
  // microphone input to be played back to you, call
  //    input.play();
  // instead (be careful with your speaker volume, you might produce
  // painful audio feedback. best to first try it out wearing headphones!)

  // Create a new Amplitude analyzer
  loudness = new Amplitude(this);

  // Patch the input to the volume analyzer
  loudness.input(input);
}

boolean save_frame;
static float previousVolume; 
float adjust = 0.30; 
void draw()
{
  // loudness.analyze() return a value between 0 and 1. To adjust
  // the scaling and mapping of an ellipse we scale from 0 to 0.5
  float volume = loudness.analyze();
  volume = previousVolume * (1 - adjust) + volume * adjust;
  int size = int(map(volume, 0, 0.5, 150, 255));

  background(current);
  tint(255, size);
  key_update();

  prev_screen.resize((int)(width * zoom), (int)(height * zoom));
  translate(x_pos, y_pos);
  rotate(rotation);
  image(prev_screen, -prev_screen.width / 2, -prev_screen.height / 2);
  mirror_screen();
  make_prev_screen();

  if (save_frame)
  {
    saveFrame("####.png");
    delay(1000);
  }
}
public boolean isInteger( String input ) {
  try {
    Integer.parseInt( input );
    return true;
  }
  catch( Exception e ) {
    return false;
  }
}


public boolean nodelay(long previous, int value) {
  return millis() - previous<value;
}

