class FormatDate {
  static String ToString(DateTime date)
  {
    return date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
  }

  static String toMonthYear(DateTime date)
  {
    String month = "";
    int m = date.month;
    if (m==1) month = "Jan";
    else if (m==2) month = "Feb";
    else if (m==3) month = "Mar";
    else if (m==4) month = "Apr";
    else if (m==5) month = "May";
    else if (m==6) month = "Jun";
    else if (m==7) month = "Jul";
    else if (m==8) month = "Aug";
    else if (m==9) month = "Sep";
    else if (m==10) month = "Oct";
    else if (m==11) month = "Nov";
    else if (m==12) month = "Dec";
    return month+", "+date.year.toString();
  }
}