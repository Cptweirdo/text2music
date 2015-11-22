//Sound lib
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//Mouse stuff
Boolean mouse_lock=false;
void mouseReleased(){mouse_lock=false;}
//File system stuff
import java.io.File;
File dir;
//set vars
HScrollbar Hscroll_bpm;
HScrollbar Hscroll_gain;
String samples_dir= "M:/max/samples/"; //Where samples are
String audio_out_dir="M:/"; //Where audio output is
String audio_name="recording";
int audio_name_c=1;
String myText = "o_o"; //Initial text
String myText1= myText;

String[] Sample_names;

float bpm=1000; // tempo, msec
float min_bpm=100; // tempo, msec
float max_bpm=5000; // tempo, msec

//float audio_volume=1.;
float audio_gain=0.;
float min_audio_gain=-100.;
float max_audio_gain=100.;

Integer timer;

IntDict keymap;

String[] cur_text;    //text split into separate words
Integer cur_pointer=-1; //word to be played back
Integer num_samples; //how many symbols we use

int red, green, blue;
//static int sc_h=1080;
//static int sc_w=1080;
int txt_size=30;  //font size


//JSON Keymapping
JSONArray keyconf;

Minim minim;
AudioOutput out;
AudioRecorder recorder;
Sampler[] samples;

void setup() {
  size(700, 700);
  background(255);
  textAlign(CENTER, CENTER);
  textSize(txt_size);
  
  keyconf= new JSONArray();
  count_samples();
//  init_map_keys();
  load_keyconf();
  setup_sound();
  
  
  Hscroll_bpm = new HScrollbar(0, height-33, width, 16, 16);Hscroll_bpm.setVmin(min_bpm);Hscroll_bpm.setVmax(max_bpm);Hscroll_bpm.setVal(bpm);
  Hscroll_gain = new HScrollbar(0, height-16, width, 16, 16);Hscroll_gain.setVmin(min_audio_gain);Hscroll_gain.setVmax(max_audio_gain);Hscroll_gain.setVal(audio_gain);  
  
  timer=millis()-2*int(bpm);
  
  cur_text=myText.split(" ");
}

void word2sound(String s){
  for (int i=0; i<s.length();i++){
    samples[keymap.get(str(s.charAt(i)))].trigger();
  }
}


void draw() {
  background(red, green, blue);


  bpm=min_bpm+Hscroll_bpm.getVal();
  out.setGain(Hscroll_gain.getVal());
  
  
  Hscroll_bpm.update();
  Hscroll_bpm.display();
  Hscroll_gain.update();
  Hscroll_gain.display();
 
  if (millis()-timer>=bpm){
    textSize(random(4)+30);
    timer=millis();
    //if ((myText.length()!=1 )&&(str(myText.charAt(0))!=" ")){
    if (!myText.equals(" ")){
    cur_text=myText.replaceAll("\n"," ").replaceAll("  "," ").split(" ");

     //println(str(int(myText.charAt(0))));
     
    cur_pointer=(cur_pointer+1) % cur_text.length;
    }else{cur_pointer=0; cur_text[0]=" ";}
    word2sound(cur_text[cur_pointer]);
  }
  fill(255-red, 255-green, 255-blue);
  text(myText, 0, 0, width, height);
}

String check_input(String s) {
 String res=s;
 if (s.endsWith("  ")){res=s.substring(0, s.length()-1);}
 if (s.endsWith("\n")){res=res+" ";}
 if (s.startsWith("\n")){res=" "+res;}
 if (s==""){res=" ";}
 return res;
}

void keyPressed() {
  // Set a random background color each time you hit then number keys
  red=int(random(255));
  green=int(random(255));
  blue=int(random(255)); 
  if (keyCode == BACKSPACE) {
    if (myText1.length()<2){
      myText1 = " ";
    }else{
      myText1 = myText1.substring(0, myText1.length()-1);
    }
  } else if (keyCode == ENTER) {
    myText1 = myText1 + "\n ";
  } else if (keyCode == DELETE) {
    myText1 = " ";
  } else if (keyCode == CONTROL) {
        if ( recorder.isRecording() ) 
      {
        recorder.endRecord();
        println("Recording done");
        audio_name_c=audio_name_c+1;
        recorder = minim.createRecorder(out, audio_out_dir+audio_name+str(audio_name_c)+".wav");
 //       recorded = true;
      }
      else 
      {
        println("Recording starting");
        recorder.beginRecord();
      }
    } else if (keyCode != SHIFT  && keyCode != ALT) {
//  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    if (!myText1.endsWith(" ")||(key != ' ')){
      myText1 = myText1 + key;
 //     samples[keymap.get(str(key))].trigger();
    }
  }

  myText=check_input(myText1);
}