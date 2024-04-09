
String[] variants = {"PixelPusher", "PixelPusher Photon"};

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
    println("Registry changed!");
    if (updatedDevice != null) {
      println("Device change: " + updatedDevice);
      registry.startPushing();
    }

    List<PixelPusher> pushers = ((DeviceRegistry)registry).getPushers();
    if (pushers.size() > 0) {
      String[] nameArray = new String[pushers.size()];
      int i=0;
      for (PixelPusher pusher: pushers) {
        nameArray[i++] = pusher.getMacAddress();
      } 

      println("Setting list to :");
      for (String name: nameArray) 
        println("... "+name);
      try {  
      pusherList.setItems(nameArray, selectedPusher);
      } catch (Exception e) { }
      try {
        PixelPusher p = pushers.get(selectedPusher);
        pusherInfo.setText("Group "+p.getGroupOrdinal()+" Controller "+p.getControllerOrdinal()+" Firmware version "+p.getSoftwareRevision()/100.0+" Product ID "+variants[p.getProductId()-1]);
      } catch (Exception e) {
        PixelPusher p = pushers.get(0);
        if (p == null) {
           selectedPusher=0;
           pusherInfo.setText("(not found)");
           return; 
        }
        selectedPusher = 0;
        if (p.getProductId() != 0)
          pusherInfo.setText("Group "+p.getGroupOrdinal()+" Controller "+p.getControllerOrdinal()+" Firmware version "+p.getSoftwareRevision()/100.0+" Product ID "+variants[p.getProductId()-1]);
      }
      
    }
  }
};

