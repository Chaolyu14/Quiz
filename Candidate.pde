// The following short XML file called "mammals.xml" is parsed 
// in the code below. It must be in the project's "data" folder.
//
// <?xml version="1.0"?>
// <mammals>
//   <animal id="0" species="Capra hircus">Goat</animal>
//   <animal id="1" species="Panthera pardus">Leopard</animal>
//   <animal id="2" species="Equus zebra">Zebra</animal>
// </mammals>


class Candidate{
  int id;
  String Name = "";
  
  PFont f = createFont("SourceHanSansCN-bold",48);
  PFont f_big = createFont("SourceHanSansCN-bold",50);
  PImage loginbase;

  Candidate(int User_N){
    String ListName = "idPack1.xml";
    XML list = loadXML(ListName);
    XML[] identity = list.getChildren("identity");
    id = identity[User_N].getInt("id");
    Name = identity[User_N].getContent();
  }

  void TempShow(){
    textFont(f);
    textAlign(LEFT);
    fill(0);
    text(Name,6*displayw/12,2*displayh/5,300,70);
  }

  void Show(int mark){
    textFont(f_big);
    textAlign(LEFT);
    fill(255);
    text(Name + ":" + str(mark),displayw/2-100,45,displayw/2,300);
    textSize(720);
    fill(255);
    textAlign(CENTER);
    text(str(mark),displayw,0,displayw,displayh);
  }

  void clear(){
   id = 0;
   Name = "";
  }


}