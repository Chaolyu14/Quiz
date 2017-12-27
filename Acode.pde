import processing.net.*; 
Client c; 

PFont f;
PImage loginbase,mouseCursor,over1,over2;
float framerate = 24;

QuestionPack CurrentPack;
Candidate User;

int must_right = 10;

Button[] Bnumber = new Button[10];
Button Blogin,BloginContent;
Button Bno, Byes;

int displayw = 1600;
int displayh = 900;

int PackNum = 1;

int QuestionNumber = 1;
float Timer = 10000;
int login = 0;
String selectedoption = "";
String logindata = "";
boolean selected = false;
boolean freeze = false;

int page = 1;
int user_id = 0;
int mark = 200;

void setup() {
  //fullScreen(SPAN);
  size(3200,900);
  frameRate(framerate);
  mouseCursor = loadImage("MouseCursor.png");
  over1 = loadImage("base-02-01.png");
  over2 = loadImage("base-03-01.png");
  cursor(mouseCursor, 0, 0);

  c = new Client(this, "192.168.1.123", 12345); 
  //c = new Client(this, "192.168.1.116", 12345); 
  
  // Replace with your server’s IP and port
  f = createFont("SourceHanSansCN-bold",52);
  loginbase = loadImage("base-01.jpg");
  loginbase.resize(displayw,displayh); 

  for(int i=0;i<10;i++){
    Bnumber[i] = new Button((i+1)*displayw/12,3*displayh/5,75,75);
  }

  Blogin = new Button(8*displayw/12,2*displayh/5,180,75);
  BloginContent = new Button(4*displayw/12,2*displayh/5,500,75);
  Bno = new Button(4*displayw/12,2.5*displayh/5,170,75);

  background(255);
  smooth();

}
int lastpage = 0;
void draw() {
  // Receive data from server
  if (c.available() > 0) { 
    String input = c.readString();

    if(input.indexOf("\n") >= 1){
      input = input.substring(0, input.indexOf("\n"));
    }
    
    //input = c.readStringUntil("\n"); 
    
    println(input);
    if(input.equals("start")){
       if(login == 1){
          login = 2; 
       }else if(login == 3){
         login = 4;
        NextQuestion();
       }else{
           time = millis();
           page++;
           if(page == 4){
               if(CurrentPack.op[QuestionNumber].getContent().equals(selectedoption)){
                  mark = mark + must_right;  
                  c.write("user" + "|" + user_id + "|" + "mark" + "|" + mark + "\n");  
                }
           }
           if(page == 5) page = 1;
           
       }
       freeze = false;
     }else if(input.equals("next")){
         if(login == 0 && QuestionNumber == 1){
           login = 1;
         }else if(QuestionNumber == 6 ){
           if(login == 2){
             login = 3;
           }else if(login ==3){
             login = 4; 
             NextQuestion();
           }
         }else{
           NextQuestion();
         }
     }else if(input.equals("pause")){
       freeze = true;
     }else{
       String data[];
       data = split(input, "|"); 
       if(data[0].equals("user")){
          if(data[2].equals("freeze")){
               if(user_id == int(data[1])){selected = true;}
               freeze = true;
          }else if(data[2].equals("mark")){
               if(user_id == int(data[1])){mark = int(data[3]);}
          }
        }else if(data[0].equals("pack")){
           PackNum = int(data[1]);
           CurrentPack = new QuestionPack(PackNum);
           QuestionNumber = int(data[2]);
           CurrentPack.Load(QuestionNumber);

           Timer = 10000;
           selectedoption = "";
           selected = false;
           freeze = false;

           page = 1;

        }
      }
   }
   lastpage = page;
  switch(login){
    case 0:
      ShowLoginPage();
      break;
    case 1:
      image(over1, 0, 0);
      User.Show(mark);
      break;
    case 2:
      if(!freeze){
        background(0);
        CurrentPack.show(page); 
        User.Show(mark);
        if(page == 2){countdown();}
      }
      break;
    case 3:
      image(over2, 0, 0);
      break;
    case 4:
      if(QuestionNumber > 6 && QuestionNumber < 19){
        if(selected){
          background(color(0,255,0));
        }else{
          background(color(0,0,0)); 
        }
        CurrentPack.show(3);
        if(selected){
          textAlign(CENTER);
          fill(color(0,255,0));
          text("抢答成功！",displayw/2,50,displayw/2,300);
        }
        User.Show(mark);
      }
      break;
  }
 
}

String temp = "";

void ShowLoginPage(){
  image(loginbase, 0, 0);
    for(int i=0;i<10;i++){
      Bnumber[i].show(str(i));
    }
    Blogin.show("登陆"); //login button
    BloginContent.show(logindata);
    if(!logindata.equals("")){
      User.TempShow();
      Bno.show("清空");  //clear button
  }
}

void mouseClicked(){
  switch(login){
    case 0:
      LoginPageUpdate();
      break;
    case 2:
      if(page == 2){
        selectedoption = CurrentPack.OptionSelected();
      }
      break;
    case 4:
      if(!freeze){
      c.write("user" + "|" + user_id + "|" + "freeze" + "|" + mark +"\n");
      }
      break;
    }
}

void LoginPageUpdate(){
    for(int i=0;i<10;i++){
      if(Bnumber[i].OverBox()){
         temp = str(i); 
         logindata = logindata + temp;
         if(int(logindata) < 201){
           User = new Candidate(int(logindata));
           user_id = User.id;
         }else{
           logindata = "";
         }
      }
    }
    if(Bno.OverBox()){
      logindata = "";
      User.clear();
    }else if(Blogin.OverBox() && !logindata.equals("")){
        login = 1;
        c.write("user" + "|" + user_id + "|" + "mark" + "|" + mark + "\n");
        CurrentPack = new QuestionPack(PackNum);
        CurrentPack.Load(QuestionNumber);
        c.write("user" + "|" + user_id + "|" + "login" + "|" + PackNum +"|" + QuestionNumber + "\n");

    }
}

void NextQuestion(){

  page = 1;
  QuestionNumber++;
  selected = false;
  freeze = false;
  selectedoption = "";  
  if(QuestionNumber < 19){
    CurrentPack.Load(QuestionNumber);
  }else{
    NextPack();
  }
    
}

void NextPack(){
  PackNum++;
  QuestionNumber = 1;
  User.clear();
  login = 0;
  logindata = "";

  Timer = 10000;
  selectedoption = "";
  selected = false;
  freeze = false;

  page = 1;
  user_id = 0;
  mark = 200;
}

int time;
void countdown(){
    float tempt = Timer/1000;
    textFont(f); 
    textAlign(LEFT);
    fill(255); 
    text("剩余答题时间",displayw/2+200,45,displayw/2,300);
    text("秒",displayw/2+700,45,displayw/2,300);
    textAlign(CENTER);
    text(str(tempt),displayw/2+200,45,displayw/2,300);
    Timer = Timer - (millis() - time);
    time = millis();
    if(Timer < 0){
      if( QuestionNumber < 7){
        page = 3;
        Timer = 10000;
      }else{
        login = 2; 
      }
    }
}