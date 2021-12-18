float calcShift, lengNoiseX, lengNoiseY, angNoiseX, angNoiseY;
String[] sys = new String[2];



//////Config area//////
//再帰回数や図形の設定を変更したい場合はこのconfigの値を操作。

  
  // Recursive config(再帰関連の設定)
  //Default setting is make like a snowflake.
    
    int gen = 6;
      //再帰回数。8以上の数値は計算数が膨大になるため7以下に設定を推奨。
    
    int branch = 6;
    int onemore_branch = 6;
      //枝分かれの回数指定。枝の数が増えることも計算回数の肥大につながるため、再帰回数と合わせて考慮。
      //onemore_branchはonemoreLineがtrueの場合に、その枝分かれに使用される。
    
    float shift = 3;
    boolean fraction = true;
      //一世代ごとに変化する線の長さの設定。
      //fractonをtrueにした場合、shiftの値を分母とした分数（を計算した小数）として計算される。
      
    boolean onemoreLine = false;
      //分かれた枝の先にもう一つ、1.5倍の枝を追加する。
      //genを1～3、branchを6、onemore_branchを4で試してみると分かりやすい。
      
    boolean autoSetting_Angles = true;
      //自動的にangleの値を算出するかどうか。
      //trueの場合は自動算出された値が上書きされて実行。
    
    
  // Shape config(図形の設定)
    
    float leng = 300;
      //デフォルトの線の長さを決定。
    
    float angle = 39;
    float onemore_angle = 120;
      //三角関数の回転操作を行うときにデフォルトで適用される角度。度数法で指定。
      //onemore_angleはもう一つの枝分かれで使用。
      
    int weight = 1;
      //線の太さ。
    
    
  // Color config(色の設定)
    
    int[] BG_Color = {100,200,1000};
      //背景のグラデーションの基準となる色。ここから彩度（2つ目の値）を700加算する。
    
    int[] colorS = {220,30,100};
      //strokeの色。
    
    
  // Effect config(エフェクト関連の設定)
    
    boolean noiseOn = false;
    int seed = 1;
      //ノイズを用いたleng変数の変化を使うかどうか。
      //trueでスイッチオン。falseでオフ。
      //seedにはnoiseSeedの引数を入れる。
  

//////




void setup(){
  size(1000, 1000);
  noiseSeed(seed);
  
  if(autoSetting_Angles){
    sys = autoSetting();  //角度自動設定機能を呼び出し。
    println(sys[0],"\n"+sys[1]);  //ちゃんと動いたかどうかを出力。
  }
  
  backgroundSet();
  
  colorMode(HSB,360,100,100);
  
  strokeWeight(weight);
  stroke(colorS[0], colorS[1], colorS[2]);
  
  
  if(fraction){
    calcShift = 1/shift;
  }else{
    calcShift = shift;
  }
  translate(width/2, height/2);
  //rotate(radians(90));
  
  for(int i = 0; i < branch; i++){
    //再帰　始動。
    //Recursion is here.
    
    calcCoord(gen, 0, 0, leng, angle*i);
  }
  
  //save("images.png");
  //If you want to save result, remove commentout on save function.
  //Caution:File name is fixed. if exist same name already, it will be overwrite.
}




void calcCoord(int gen1, float xs, float ys, float leng1, float ang){  
  //座標の計算。
  //Calculate Next generation coordinates.
  
  noiseMaker(xs, ys);
  
  float xe = (leng1*(1+lengNoiseX)) *cos(radians(ang*(1+angNoiseX))) +xs;
  float ye = (leng1*(1+lengNoiseY)) *sin(radians(ang*(1+angNoiseY))) +ys;
  
  drawLine(gen1, xs, ys, xe, ye, leng1);
}

void drawLine(int gen1, float xS, float yS, float xE, float yE, float leng2){  
  //lineを描写。
  //line drawing.
  
  stroke(colorS[0]+int(random(20)), colorS[1]+int(random(20)), colorS[2]-int(random(10)));
  line(xS, yS, xE, yE);
  
  if(gen1 > 0){
    for(int i = 0; i < branch; i++){
      calcCoord(gen1 -1, xE, yE, leng2*calcShift, angle*i);
    }
  }
  
  if(onemoreLine){
    line(xS*1.5, yS*1.5, xE*1.5, yE*1.5);
    
    if(gen1 > 0){
      for(int i = 0; i < onemore_branch; i++){
        calcCoord(gen1 -1, xE*1.5, yE*1.5, leng2*calcShift, onemore_angle*i);
      }
    }
  }
}

void noiseMaker(float xs, float ys){
  //ノイズを作る関数
  //Making noise if noiseOn is true.
  
  if(noiseOn){
      lengNoiseX = noise(0.2 *pow( 2, abs(xs) ));
      lengNoiseY = noise(0.2 *pow( 2, abs(ys) ));
      
      angNoiseX = noise(3 *pow( 17, abs(xs) ));
      angNoiseY = noise(3 *pow( 17, abs(ys) ));
  }
}

void backgroundSet(){
  //背景作成
  //Making background
  
  colorMode(HSB,360,2000,1000);
  
  for(int i = 0; i < 700; i++){
    int j = i*4;
    fill(BG_Color[0], BG_Color[1]+i, BG_Color[2]);
    noStroke();
    ellipseMode(CENTER);
    ellipse(0, 0, 2850-j,2850-j);
  }
  
  for(int i = 0; i < 200; i++){
    for(int j = 0; j < 200; j++){
      fill(0, 0, 1000);
      rectMode(CENTER);
      
    }
  }
}

String[] autoSetting(){
  //角度の自動設定機能
  //Autosetting to var"angle".
  
  String[] systemMessage = {"none","none"};
  if(branch != 0 && onemore_branch != 0){
    angle = 360/branch;
    onemore_angle = 360/onemore_branch;
    
    systemMessage[0] = "角度の自動設定機能は正常に動作しました。";
    systemMessage[1] = "AutosettingAngles is done.";
  }else{
    systemMessage[0] = "いずれかの枝の値に0が入っています。0除算の原因となるため、枝分かれを0に設定することはできません。";
    systemMessage[1] = "Detect 0 in \"branch\" or \"onemore_branch\" value. Branch amount can't setting at 0, because induce to Zero division.";
    exit();
  }
  return systemMessage;
}
