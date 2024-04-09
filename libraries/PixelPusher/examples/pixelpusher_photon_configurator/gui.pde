/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void pusherList_click1(GDropList source, GEvent event) { //_CODE_:pusherList:965422:
  println("dropList1 - GDropList event occured " + System.currentTimeMillis()%10000000 );
  selectedPusher = source.getSelectedIndex();
  List<PixelPusher> pushers = registry.getPushers();
  PixelPusher p = pushers.get(selectedPusher);
  pusherInfo.setText("Group "+p.getGroupOrdinal()+" Controller "+p.getControllerOrdinal()+" Firmware version "+p.getSoftwareRevision()/100.0+" Product ID "+variants[p.getProductId()-1]);
  group = p.getGroupOrdinal();
  controller = p.getControllerOrdinal();
  groupNumber.setText(Integer.toString(group));
  controllerNumber.setText(Integer.toString(controller));
  length_slider1.setValue(p.getPixelsPerStrip());
  if (p.getNumberOfStrips() == 1) {
     numStrips = 1;
     strips_one.setSelected(true);
  } else {
     numStrips = 2;
     strips_two.setSelected(true);
  }
} //_CODE_:pusherList:965422:

public void resetButton_click1(GButton source, GEvent event) { //_CODE_:resetButton:606434:
  println("resetButton - GButton event occured " + System.currentTimeMillis()%10000000 );
  
  PusherCommand pc = new PusherCommand(PusherCommand.RESET);
  List<PixelPusher> pushers = registry.getPushers();
  PixelPusher p = pushers.get(selectedPusher);
  spamCommand(p, pc);
} //_CODE_:resetButton:606434:

public void ssid_change1(GTextField source, GEvent event) { //_CODE_:ssid:915600:
  println("ssid - GTextField event occured " + System.currentTimeMillis()%10000000 );
  wifiSsid = source.getText();
} //_CODE_:ssid:915600:

public void wifiKey_change1(GTextField source, GEvent event) { //_CODE_:wifiKey:502468:
  println("wifiKey - GTextField event occured " + System.currentTimeMillis()%10000000 );
  wifi_key = source.getText();
} //_CODE_:wifiKey:502468:

public void sec_none_clicked1(GOption source, GEvent event) { //_CODE_:sec_none:720530:
  println("sec_none - GOption event occured " + System.currentTimeMillis()%10000000 );
  wifiMode = "none";
} //_CODE_:sec_none:720530:

public void sec_wpa_clicked1(GOption source, GEvent event) { //_CODE_:sec_wpa:432619:
  println("sec_wpa - GOption event occured " + System.currentTimeMillis()%10000000 );
  wifiMode = "wpa";
} //_CODE_:sec_wpa:432619:

public void sec_wep_clicked1(GOption source, GEvent event) { //_CODE_:sec_wep:252457:
  println("sec_wep - GOption event occured " + System.currentTimeMillis()%10000000 );
  wifiMode = "wep";
} //_CODE_:sec_wep:252457:

public void sec_wpa2_clicked1(GOption source, GEvent event) { //_CODE_:sec_wpa2:384086:
  println("sec_wpa2 - GOption event occured " + System.currentTimeMillis()%10000000 );
  wifiMode = "wpa2";
} //_CODE_:sec_wpa2:384086:

public void sendwifi_click1(GButton source, GEvent event) { //_CODE_:sendwifi:713708:
  println("sendwifi - GButton event occured " + System.currentTimeMillis()%10000000 );
  PusherCommand pc = new PusherCommand(PusherCommand.WIFI_CONFIGURE, wifiSsid, wifi_key, wifiMode);
  List<PixelPusher> pushers = registry.getPushers();
  PixelPusher p = pushers.get(selectedPusher);
  spamCommand(p, pc);
} //_CODE_:sendwifi:713708:

public void strips_one_clicked1(GOption source, GEvent event) { //_CODE_:strips_one:873802:
  println("strips_one - GOption event occured " + System.currentTimeMillis()%10000000 );
  numStrips = 1;
  length_slider1.setLimits(length_slider1.getValueI(), 0, 480);
} //_CODE_:strips_one:873802:

public void strips_two_clicked1(GOption source, GEvent event) { //_CODE_:strips_two:235648:
  println("strips_two - GOption event occured " + System.currentTimeMillis()%10000000 );
  numStrips = 2;
  length_slider1.setLimits(length_slider1.getValueI(), 0, 288);
} //_CODE_:strips_two:235648:

public void length_slider1_change1(GCustomSlider source, GEvent event) { //_CODE_:length_slider1:506868:
  println("length_slider1 - GCustomSlider event occured " + System.currentTimeMillis()%10000000 );
  stripLength = source.getValueI();
} //_CODE_:length_slider1:506868:

public void strip1type_click1(GDropList source, GEvent event) { //_CODE_:strip1type:438953:
  println("strip1type - GDropList event occured " + System.currentTimeMillis()%10000000 );
  stripType[0] = (byte) source.getSelectedIndex();
} //_CODE_:strip1type:438953:

public void strip1order_click1(GDropList source, GEvent event) { //_CODE_:strip1order:315422:
  println("strip1order - GDropList event occured " + System.currentTimeMillis()%10000000 );
  colourOrder[0] = (byte) source.getSelectedIndex();
} //_CODE_:strip1order:315422:

public void strip2type_click1(GDropList source, GEvent event) { //_CODE_:strip2type:918351:
  println("strip2type - GDropList event occured " + System.currentTimeMillis()%10000000 );
  stripType[1] = (byte) source.getSelectedIndex();
} //_CODE_:strip2type:918351:

public void strip2order_click1(GDropList source, GEvent event) { //_CODE_:strip2order:415305:
  println("strip2order - GDropList event occured " + System.currentTimeMillis()%10000000 );
  colourOrder[1] = (byte) source.getSelectedIndex();
} //_CODE_:strip2order:415305:

public void sendLedConfig_click1(GButton source, GEvent event) { //_CODE_:sendLedConfig:536011:
  println("sendLedConfig - GButton event occured " + System.currentTimeMillis()%10000000 );
  PusherCommand pc = new PusherCommand(PusherCommand.LED_CONFIGURE, numStrips, stripLength, 
                                        stripType, colourOrder, (short)group, (short)controller);
                                        
  List<PixelPusher> pushers = registry.getPushers();
  PixelPusher p = pushers.get(selectedPusher);
  spamCommand(p, pc);
} //_CODE_:sendLedConfig:536011:

public void groupNumber_change1(GTextField source, GEvent event) { //_CODE_:groupNumber:726199:
  println("groupNumber - GTextField event occured " + System.currentTimeMillis()%10000000 );
  try {
    group = Integer.parseInt(source.getText());
  } 
  catch (NumberFormatException nfe) {
    // ignore this exception
  }
} //_CODE_:groupNumber:726199:

public void controllerNumber_change1(GTextField source, GEvent event) { //_CODE_:controllerNumber:503130:
  println("controllerNumber - GTextField event occured " + System.currentTimeMillis()%10000000 );
  try {
    controller = Integer.parseInt(source.getText());
  } 
  catch (NumberFormatException nfe) {
    // ignore this exception
  }
} //_CODE_:controllerNumber:503130:

public void rebootAll_click1(GButton source, GEvent event) { //_CODE_:rebootAll:933495:
  println("rebootAll - GButton event occured " + System.currentTimeMillis()%10000000 );
    PusherCommand pc = new PusherCommand(PusherCommand.RESET);
  List<PixelPusher> pushers = registry.getPushers();
  for (PixelPusher p : pushers)
    spamCommand(p, pc);
} //_CODE_:rebootAll:933495:

public void sendledtoall_click1(GButton source, GEvent event) { //_CODE_:sendLEDtoAll:367256:
  println("sendLEDtoAll - GButton event occured " + System.currentTimeMillis()%10000000 );
    println("sendLedConfig - GButton event occured " + System.currentTimeMillis()%10000000 );
  PusherCommand pc = new PusherCommand(PusherCommand.LED_CONFIGURE, numStrips, stripLength, 
                                        stripType, colourOrder, (short)group, (short)controller);
                                        
  List<PixelPusher> pushers = registry.getPushers();
  for (PixelPusher p : pushers)
    spamCommand(p, pc);
} //_CODE_:sendLEDtoAll:367256:

public void sendWifiToAll_click1(GButton source, GEvent event) { //_CODE_:sendWifiToAll:385718:
  println("sendWifiToAll - GButton event occured " + System.currentTimeMillis()%10000000 );
    PusherCommand pc = new PusherCommand(PusherCommand.LED_CONFIGURE, numStrips, stripLength, 
                                        stripType, colourOrder, (short)group, (short)controller);
                                        
  List<PixelPusher> pushers = registry.getPushers();
  for (PixelPusher p : pushers)
    spamCommand(p, pc);
} //_CODE_:sendWifiToAll:385718:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("Photon Configurator");
  pusherList = new GDropList(this, 130, 30, 200, 220, 10);
  pusherList.setItems(loadStrings("list_965422"), 0);
  pusherList.addEventHandler(this, "pusherList_click1");
  label1 = new GLabel(this, 20, 30, 110, 20);
  label1.setText("Target device");
  label1.setOpaque(false);
  pusherInfo = new GLabel(this, 340, 30, 290, 70);
  pusherInfo.setOpaque(true);
  resetButton = new GButton(this, 20, 70, 130, 30);
  resetButton.setText("Reboot device");
  resetButton.setTextBold();
  resetButton.addEventHandler(this, "resetButton_click1");
  ssid = new GTextField(this, 120, 130, 160, 30, G4P.SCROLLBARS_NONE);
  ssid.setText("HeroicRobotics");
  ssid.setDefaultText("HeroicRobotics");
  ssid.setOpaque(true);
  ssid.addEventHandler(this, "ssid_change1");
  label2 = new GLabel(this, 20, 130, 80, 20);
  label2.setText("WiFi SSID");
  label2.setOpaque(false);
  label3 = new GLabel(this, 300, 130, 80, 20);
  label3.setText("WiFi key");
  label3.setOpaque(false);
  wifiKey = new GTextField(this, 400, 130, 160, 30, G4P.SCROLLBARS_NONE);
  wifiKey.setText("PixelPusher");
  wifiKey.setDefaultText("PixelPusher");
  wifiKey.setOpaque(true);
  wifiKey.addEventHandler(this, "wifiKey_change1");
  togGroup1 = new GToggleGroup();
  sec_none = new GOption(this, 120, 170, 120, 20);
  sec_none.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  sec_none.setText("None");
  sec_none.setOpaque(false);
  sec_none.addEventHandler(this, "sec_none_clicked1");
  sec_wpa = new GOption(this, 120, 210, 120, 20);
  sec_wpa.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  sec_wpa.setText("WPA");
  sec_wpa.setOpaque(false);
  sec_wpa.addEventHandler(this, "sec_wpa_clicked1");
  sec_wep = new GOption(this, 120, 190, 120, 20);
  sec_wep.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  sec_wep.setText("WEP");
  sec_wep.setOpaque(false);
  sec_wep.addEventHandler(this, "sec_wep_clicked1");
  sec_wpa2 = new GOption(this, 120, 230, 120, 20);
  sec_wpa2.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  sec_wpa2.setText("WPA2");
  sec_wpa2.setOpaque(false);
  sec_wpa2.addEventHandler(this, "sec_wpa2_clicked1");
  togGroup1.addControl(sec_none);
  togGroup1.addControl(sec_wpa);
  togGroup1.addControl(sec_wep);
  togGroup1.addControl(sec_wpa2);
  sec_wpa2.setSelected(true);
  label4 = new GLabel(this, 20, 170, 80, 30);
  label4.setText("WiFi security mode");
  label4.setOpaque(false);
  sendwifi = new GButton(this, 440, 180, 170, 30);
  sendwifi.setText("Send WiFi settings");
  sendwifi.addEventHandler(this, "sendwifi_click1");
  togGroup2 = new GToggleGroup();
  strips_one = new GOption(this, 170, 290, 120, 20);
  strips_one.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  strips_one.setText("One strip");
  strips_one.setOpaque(false);
  strips_one.addEventHandler(this, "strips_one_clicked1");
  strips_two = new GOption(this, 170, 310, 120, 20);
  strips_two.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  strips_two.setText("Two strips");
  strips_two.setOpaque(false);
  strips_two.addEventHandler(this, "strips_two_clicked1");
  togGroup2.addControl(strips_one);
  togGroup2.addControl(strips_two);
  strips_two.setSelected(true);
  label99 = new GLabel(this, 20, 290, 130, 20);
  label99.setText("LED configuration");
  label99.setTextBold();
  label99.setOpaque(false);
  length_slider1 = new GCustomSlider(this, 400, 290, 210, 40, "grey_blue");
  length_slider1.setShowValue(true);
  length_slider1.setLimits(240, 0, 480);
  length_slider1.setNumberFormat(G4P.INTEGER, 0);
  length_slider1.setOpaque(false);
  length_slider1.addEventHandler(this, "length_slider1_change1");
  label5 = new GLabel(this, 310, 300, 80, 20);
  label5.setText("Pixels");
  label5.setOpaque(false);
  label7 = new GLabel(this, 20, 350, 80, 20);
  label7.setText("Strip 1");
  label7.setOpaque(false);
  strip1type = new GDropList(this, 220, 350, 170, 132, 6);
  strip1type.setItems(loadStrings("list_438953"), 0);
  strip1type.addEventHandler(this, "strip1type_click1");
  label6 = new GLabel(this, 130, 350, 80, 20);
  label6.setText("Driver type");
  label6.setOpaque(false);
  strip1order = new GDropList(this, 520, 350, 90, 132, 6);
  strip1order.setItems(loadStrings("list_315422"), 0);
  strip1order.addEventHandler(this, "strip1order_click1");
  label8 = new GLabel(this, 420, 350, 90, 20);
  label8.setText("Colour order");
  label8.setOpaque(false);
  label9 = new GLabel(this, 20, 400, 80, 20);
  label9.setText("Strip 2");
  label9.setOpaque(false);
  label10 = new GLabel(this, 130, 400, 80, 20);
  label10.setText("Driver type");
  label10.setOpaque(false);
  strip2type = new GDropList(this, 220, 400, 170, 132, 6);
  strip2type.setItems(loadStrings("list_918351"), 0);
  strip2type.addEventHandler(this, "strip2type_click1");
  label11 = new GLabel(this, 420, 400, 90, 20);
  label11.setText("Colour order");
  label11.setOpaque(false);
  strip2order = new GDropList(this, 520, 400, 90, 132, 6);
  strip2order.setItems(loadStrings("list_415305"), 0);
  strip2order.addEventHandler(this, "strip2order_click1");
  sendLedConfig = new GButton(this, 390, 490, 220, 30);
  sendLedConfig.setText("Send LED settings");
  sendLedConfig.addEventHandler(this, "sendLedConfig_click1");
  label98 = new GLabel(this, 20, 440, 80, 20);
  label98.setText("Group");
  label98.setOpaque(false);
  groupNumber = new GTextField(this, 120, 440, 90, 30, G4P.SCROLLBARS_NONE);
  groupNumber.setText("0");
  groupNumber.setDefaultText("0");
  groupNumber.setOpaque(true);
  groupNumber.addEventHandler(this, "groupNumber_change1");
  label12 = new GLabel(this, 220, 440, 80, 20);
  label12.setText("Controller");
  label12.setOpaque(false);
  controllerNumber = new GTextField(this, 320, 440, 80, 30, G4P.SCROLLBARS_NONE);
  controllerNumber.setText("0");
  controllerNumber.setDefaultText("0");
  controllerNumber.setOpaque(true);
  controllerNumber.addEventHandler(this, "controllerNumber_change1");
  rebootAll = new GButton(this, 170, 70, 160, 30);
  rebootAll.setText("Reboot all");
  rebootAll.addEventHandler(this, "rebootAll_click1");
  sendLEDtoAll = new GButton(this, 160, 490, 210, 30);
  sendLEDtoAll.setText("Send LED settings to all");
  sendLEDtoAll.addEventHandler(this, "sendledtoall_click1");
  sendWifiToAll = new GButton(this, 440, 220, 170, 30);
  sendWifiToAll.setText("Send WiFi settings to all");
  sendWifiToAll.addEventHandler(this, "sendWifiToAll_click1");
}

// Variable declarations 
// autogenerated do not edit
GDropList pusherList; 
GLabel label1; 
GLabel pusherInfo; 
GButton resetButton; 
GTextField ssid; 
GLabel label2; 
GLabel label3; 
GTextField wifiKey; 
GToggleGroup togGroup1; 
GOption sec_none; 
GOption sec_wpa; 
GOption sec_wep; 
GOption sec_wpa2; 
GLabel label4; 
GButton sendwifi; 
GToggleGroup togGroup2; 
GOption strips_one; 
GOption strips_two; 
GLabel label99; 
GCustomSlider length_slider1; 
GLabel label5; 
GLabel label7; 
GDropList strip1type; 
GLabel label6; 
GDropList strip1order; 
GLabel label8; 
GLabel label9; 
GLabel label10; 
GDropList strip2type; 
GLabel label11; 
GDropList strip2order; 
GButton sendLedConfig; 
GLabel label98; 
GTextField groupNumber; 
GLabel label12; 
GTextField controllerNumber; 
GButton rebootAll; 
GButton sendLEDtoAll; 
GButton sendWifiToAll; 

