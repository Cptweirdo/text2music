void count_samples(){
  dir = new File(samples_dir);
  num_samples=0;
  for (File s:dir.listFiles()){
    if (s.getAbsolutePath().toLowerCase().endsWith(".mp3")){num_samples=num_samples+1;}
  }
  println("Samples found:"+str(num_samples));
}

void init_map_keys(){
  keymap = new IntDict();
  int j=0;
  int id=0;
  Integer off_let= 97;
  Integer off_caps= -32;

  for (int i=0;i<26;i++){
    JSONObject keycode = new JSONObject();
    keycode.setInt("id",id);
    keycode.setString("Char",str(char(i+off_let)));
    keycode.setInt("ASCII",i+off_let);
    keycode.setString("Sample",dir.listFiles()[j].getAbsolutePath()); //TODO This is dangerous
    keyconf.setJSONObject(id,keycode);
   JSONObject keycode1 = new JSONObject();
    keycode1.setInt("id",id+1);
    keycode1.setString("Char",str(char(i+off_let+off_caps)));
    keycode1.setInt("ASCII",i+off_let+off_caps);
    keycode1.setString("Sample",dir.listFiles()[j].getAbsolutePath()); //TODO This is dangerous
    keyconf.setJSONObject(id+1,keycode1);
    

    keymap.set(str(char(i+off_let)),j);
    keymap.set(str(char(i+off_let)),j);
    j=j+1;
    id=id+2;
  }
  for (int i=32;i<=64;i++){
   JSONObject keycode = new JSONObject();
    keycode.setInt("id",id);
    keycode.setString("Char",str(char(i)));
    keycode.setInt("ASCII",i);
    keycode.setString("Sample",dir.listFiles()[j].getAbsolutePath()); //TODO This is dangerous
    keyconf.setJSONObject(id,keycode);
    id=id+1;  
    
    keymap.set(str(char(i)),j);
    j=j+1;

  }
  for (int i=91;i<96;i++){
    JSONObject keycode = new JSONObject();
    keycode.setInt("id",id);
    keycode.setString("Char",str(char(i)));
    keycode.setInt("ASCII",i);
    keycode.setString("Sample",dir.listFiles()[j].getAbsolutePath()); //TODO This is dangerous
    keyconf.setJSONObject(id,keycode);
    id=id+1;  
    
    keymap.set(str(char(i)),j);
    j=j+1;
  }
  num_samples=min(j,num_samples);
  println("Initial key binding done");
  save_keyconf();
}

void setup_sound(){
//fire up minim
  minim = new Minim(this);
  out   = minim.getLineOut();
  samples = new Sampler[num_samples];
  for(int i=0; i<num_samples; i++){
    JSONObject keycode = keyconf.getJSONObject(i); 
 //   println( );
//    samples[i] = new Sampler( dir.listFiles()[i].getAbsolutePath(),4,minim );
    samples[i] = new Sampler( keycode.getString("Sample"),4,minim );
    samples[i].patch(out);
    //samples[i] = minim.loadSample( dir.listFiles()[i].getAbsolutePath(),1024 );  
  }
  recorder = minim.createRecorder(out, audio_out_dir+audio_name+str(audio_name_c)+".wav");
}

void save_keyconf(){saveJSONArray(keyconf, "keyconf.json");}
void load_keyconf(){
keyconf=loadJSONArray( "keyconf.json");
num_samples=keyconf.size();
keymap = new IntDict();

for (int i = 0; i < num_samples; i++) {
  JSONObject keycode = keyconf.getJSONObject(i); 
  keymap.set(str(char(keycode.getInt("ASCII"))),i);
}
}