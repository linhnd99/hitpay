class Common {
  static String FormatMoney(String value) {
    int d=0;
    for (int i=value.length-1;i>=0;i--){
      d++;
      if (d%3==0){
        value = value.substring(0,i)+","+value.substring(i,value.length);
        //i-=2;
      }
    }
    if (value[0]==',') value=value.replaceRange(0, 1, '');
    return value;
  }
}