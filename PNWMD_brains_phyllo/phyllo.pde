import processing.dxf.*;

int maxCircles;
float slope;
float expansion;
float r_min;
float r_max;
float awesomeness;

float global_rotation;
float rotation_factor;

float spiral_type;

int shape_type;

float previous_cx, previous_cy;

void drawCircle(float distance, float angle, float radius, float rmax, int i) {
  
  //float cx, cy;
  float hue;
  hue = (100.0*(millis()%4000.0)/4000.0 + (5+3*sin(millis()/4000.0))*angle/180)%100;
  stroke(hue, awesomeness, random(awesomeness,100), 70);
  fill(hue, awesomeness, random(awesomeness,100), 70);
  
  //cx = 130 + width/4 + distance*cos(angle);
  //cy = height/2 + distance*sin(angle);

  // println(radius);
  // println(rmax);


  //switch(shape_type) {
  //  case 0:
  //    pushMatrix();
  //translate(cx, cy);
  //rotate(angle);
  //  ellipse(0, 0, radius*2, radius*2);
  //    popMatrix();
  //  break;
  //  case 1:
  //        pushMatrix();
  //translate(cx, cy);
  //rotate(angle);
  //  quad(0, -radius, -radius, 0, 0, radius, radius, 0);
  //    popMatrix();
  //  break;
  //  case 2:
  //        pushMatrix();
  //translate(cx, cy);
  //rotate(angle);
  //  rect(-radius,-radius, radius*2,radius*2);
  //        popMatrix();
  //  break;
  //  case 3:
          pushMatrix();
  rotate(angle);
  distance += random(-10+awesomeness/10,10-awesomeness/10);
  translate(distance, random(-10+awesomeness/10,10-awesomeness/10));
  
    quad(0, -(radius*2), -radius, 0, 0, radius*2, radius, 0);
          popMatrix();
  //  break;
  //  case 4:
  //  if(i>1)
  //  {
  //        line(previous_cx, previous_cy, cx,cy);
  //  }
  //  previous_cx = cx;
  //  previous_cy = cy;
  //  break;
  //}

}

void outputCircle(float distance, float angle, float radius, float rmax) {
  float cx, cy;
  cx = distance*cos(angle);
  cy = distance*sin(angle);
  // output.println("Circle radius:"+radius+" pos:["+cx+","+cy+",0.00]");
}

void drawSunFlower(int maxCircles)  {
  int i;
  // float radius;
  float phi, distance, increment;
  float d_min, d_max;
  float result_radius;
  // float packing;  // how closely packed should they be? 0 to 10 where 0 is very packed and 10 is very loosely packed.
  // int maxCircles; //maximum number of circles.
  float c;
  // float slope;
  float r_avg;
  float d_avg;
  float r_awesomed = r_max + awesomeness/10;

  c = 100;
  r_avg = (r_min + r_awesomed)/2.0;
  d_min = 1.0;
  d_max = sqrt(maxCircles)*expansion;
  d_avg = (d_min + d_max)/2.0;
  phi = (1+sqrt(5.0))/2.0;
  
  if(spiral_type <= 1)
  {
    increment = 2*PI*phi;
  }
  else
  {
    increment = 2*PI*phi + (2*PI/spiral_type);
  }

  //fill(0,0,0,255);
  //rect(0,0,width,height);
  for(i=1;i<maxCircles;i++) {
     distance = sqrt(i)*expansion;
     result_radius = r_avg + slope*(distance-d_avg)/(d_max-d_avg)*(r_awesomed-r_avg);
     drawCircle(distance, (increment*i + global_rotation), result_radius, r_awesomed , i);
     //if(record) {
     // outputCircle(distance, increment*i, result_radius, r_max);
     //}
   }
   /*
   if(record) {
     output.flush(); // Writes the remaining data to the file
     output.close(); // Finishes the file
     record = false;
   }*/
}
