class QuestionPack{
  PFont f = createFont("SourceHanSansCN-Bold",32);
  PFont f_bold = createFont("SourceHanSansCN-Bold",44);
  
  PImage base01,base02,base03;

  int displayw = 1600;
  int displayh = 900;

  int PackNumber;
  int CurrentQuestion = 0;
  int type;
  String content;
  String optionA,optionB,optionC,optionD;
  String option1,option2;
  String answer;
  XML Question_list;
  XML[] question;
  XML[] op; 

  Button B_A,B_B,B_C,B_D;
  Button B_R,B_W;
  int x,y,bx,by;

  QuestionPack(int a){
    PackNumber = a;
    String ListName = "QuestionPack" + str(a) + ".xml";
    Question_list = loadXML(ListName);
    question = Question_list.getChildren("question");
    op = Question_list.getChildren("option"); 

    base01 = loadImage("base-01.jpg");
    base01.resize(displayw,displayh);
    base02 = loadImage("base-02.jpg");
    base02.resize(displayw,displayh); 
    base03 = loadImage("base-03.png");
    base03.resize(displayw,displayh); 
  }

  void Load(int index){
    content = index + "." + question[index].getContent();
    answer = op[QuestionNumber].getContent();
      x = displayw/6;
      y = 7*displayh/10;
      bx = displayw/6;
      by = displayh/3;
    type = question[index].getInt("type");
    if(type == 1){  // if it's select question, display 2 options
       B_R= new Button(1.5*x,y,100,75);
       B_W= new Button(3.5*x,y,100,75);
    }else if(type == 2 || type == 4){ // if it's judge question, display 4 options
       optionA = op[index].getString("A");
       optionB = op[index].getString("B");
       optionC = op[index].getString("C");
       optionD = op[index].getString("D");
       B_A= new Button(x,y,70,70);
       B_B= new Button(2*x,y,70,70);
       B_C= new Button(3*x,y,70,70);
       B_D= new Button(4*x,y,70,70);
    }
    
    CurrentQuestion = index;
  }
  
  void show(int page){
    if(CurrentQuestion <= 6){    // displaying only base image
      image(base02,0,0);
    }else if(CurrentQuestion > 6 ){
      image(base03,0,0);
    }
    textFont(f_bold); 
    textAlign(LEFT);
    fill(0); 
    text(content, displayw/4, displayh/4, 3*displayw/5, displayh/3); 

    if(page == 2 || page == 3){
      //display question
      textFont(f_bold); 
      textAlign(CENTER);
      fill(0);
      switch(type){
        case 1:
         B_R.show("对");
         B_W.show("错");
         break;
        case 2:
         B_A.show("A");
         B_B.show("B");
         B_C.show("C");
         B_D.show("D");
         textFont(f_bold);
         text(optionA,  x,  y+75, bx, by);
         text(optionB, 2*x, y+75, bx, by);
         text(optionC, 3*x, y+75, bx, by);
         text(optionD, 4*x, y+75, bx, by);
         break;
      }
    }else if(page == 4){
        if(type == 2){
         text(optionA,  x,  y+75, bx, by);
         text(optionB, 2*x, y+75, bx, by);
         text(optionC, 3*x, y+75, bx, by);
         text(optionD, 4*x, y+75, bx, by);
        }
       switch(answer){
         case "A":
           B_A.showAnswer("A"); B_B.show("B");B_C.show("C");B_D.show("D");
           break;
         case "B":
           B_A.show("A");B_B.showAnswer("B");B_C.show("C");B_D.show("D");
           break;
         case "C":
           B_A.show("A");B_B.show("B");B_C.showAnswer("C");B_D.show("D");
           break;
         case "D":
           B_A.show("A");B_B.show("B");B_C.show("C");B_D.showAnswer("D");
           break;
         case "R":
           B_R.showAnswer("对");B_W.show("错");
           break;
         case "W":
           B_R.show("对");B_W.showAnswer("错");
         break;
       }
     }
  }

  String OptionSelected(){
    type = question[CurrentQuestion].getInt("type");    // 1=select; 2=judge
    switch(type){
      case 1:
        if(B_R.OverBox()){
          B_W.unselected();
          return "R";
        }else if(B_W.OverBox()){
          B_R.unselected();
          return "W";
        }
        break;
      case 2:
        if(B_A.OverBox()){
          B_B.unselected();
          B_C.unselected();
          B_D.unselected();
          return "A";
        }else if(B_B.OverBox()){
          B_A.unselected();
          B_C.unselected();
          B_D.unselected();
          return "B";     
        }else if(B_C.OverBox()){
          B_A.unselected();
          B_B.unselected();
          B_D.unselected();
          return "C";
        }else if(B_D.OverBox()){
          B_A.unselected();
          B_B.unselected();
          B_C.unselected();
          return "D";
        }
        break;
    }
    return "N";
  }
}