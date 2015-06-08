//+------------------------------------------------------------------+
//|                                                   PriceAlert.mq5 |
//|                             Copyright © 2011,   Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+ 
//---- author of the indicator
#property copyright "Copyright © 2011, Nikolay Kositsin"
//---- link to the website of the author
#property link "farria@mail.redcom.ru" 
//---- indicator version
#property version   "1.00"
#property description "The indicator gives signals in case of the horizontal level breakage"
//---- drawing the indicator in the main window
#property indicator_chart_window 
#property indicator_buffers 1
#property indicator_plots   1
//+------------------------------------------------+ 
//| Enumeration for the level width                |
//+------------------------------------------------+ 
enum ENUM_WIDTH //Type of constant
  {
   w_1 = 1,   //1
   w_2,       //2
   w_3,       //3
   w_4,       //4
   w_5        //5
  };
//+------------------------------------------------+ 
//| Enumeration for the level actuation indication |
//+------------------------------------------------+ 
enum ENUM_ALERT_MODE //Type of constant
  {
   OnlySound,   //only sound
   OnlyAlert    //only alert
  };
//+------------------------------------------------+
//| Indicator input parameters                     |
//+------------------------------------------------+
input string level_name="Price_Level_1";           // Actuation level name
input string level_comment="actuation level";      // Actuation level comment
input color active_level_color=Red;                // Active level color
input color inactive_level_color=Gray;             // Inactive level color
input ENUM_LINE_STYLE level_style=STYLE_SOLID;     // Actuation level style
input ENUM_WIDTH level_width=w_3;                  // Actuation level width
input ENUM_ALERT_MODE alert_mode=OnlyAlert;        // Actuation indication version
input uint AlertTotal=10;                          // Number of alerts 
input bool Deletelevel=true;                       // Level deletion
//+----------------------------------------------+

//+------------------------------------------------------------------+
//|  Building the horizontal line                                    |
//+------------------------------------------------------------------+
void CreateHline(long     chart_id,      // chart ID
                 string   name,          // object name
                 int      nwin,          // window index
                 double   price,         // horizontal level price
                 color    Color,         // line color
                 int      style,         // line style
                 int      width,         // line width
                 bool     background,    // line background display
                 string   text)          // text
  {
//----
   ObjectCreate(chart_id,name,OBJ_HLINE,nwin,0,price);
   ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
   ObjectSetInteger(chart_id,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_id,name,OBJPROP_WIDTH,width);
   ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_id,name,OBJPROP_BACK,background);
   ObjectSetInteger(chart_id,name,OBJPROP_RAY,true);
   ObjectSetInteger(chart_id,name,OBJPROP_SELECTED,true);
   ObjectSetInteger(chart_id,name,OBJPROP_SELECTABLE,true);
   ObjectSetInteger(chart_id,name,OBJPROP_ZORDER,true);
//----
  }
//+------------------------------------------------------------------+
//|  Horizontal line relocation                                      |
//+------------------------------------------------------------------+
void SetHline(long     chart_id,      // chart ID
              string   name,          // object name
              int      nwin,          // window index
              double   price,         // horizontal level price
              color    Color,         // line color
              int      style,         // line style
              int      width,         // line width
              bool     background,    // line background display
              string   text)          // text
  {
//----
   if(ObjectFind(chart_id,name)==-1) CreateHline(chart_id,name,nwin,price,Color,style,width,background,text);
   else
     {
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectMove(chart_id,name,0,0,price);
      ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
     }
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+  
void OnInit()
  {
//----
   if(ObjectFind(0,level_name)==-1) CreateHline(0,level_name,0,0,inactive_level_color,level_style,level_width,false,level_comment);
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+    
void OnDeinit(const int reason)
  {
//----
   if(Deletelevel) ObjectDelete(0,level_name);
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,    // number of bars in history at the current tick
                const int prev_calculated,// amount of history in bars at the previous tick
                const datetime &time[],
                const double &open[],
                const double& high[],     // price array of maximums of price for the calculation of indicator
                const double& low[],      // price array of minimums of price for the calculation of indicator
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---- declarations of local variables 
   double level,price0=close[rates_total-1];
   static double startprice,oldlevel;
   static uint count;

   if(ObjectFind(0,level_name)==-1)
     {
      if(count) CreateHline(0,level_name,0,oldlevel,active_level_color,level_style,level_width,false,level_comment);
      else CreateHline(0,level_name,0,oldlevel,inactive_level_color,level_style,level_width,false,level_comment);
     }

   if(prev_calculated>rates_total || prev_calculated<=0) // checking for the first start of calculation of an indicator
     {
      level=ObjectGetDouble(0,level_name,OBJPROP_PRICE);
      if(!level)
        {
         level=price0;
         SetHline(0,level_name,0,level,inactive_level_color,level_style,level_width,false,level_comment);
         oldlevel=level;
         count=0;
        }
     }

   level=ObjectGetDouble(0,level_name,OBJPROP_PRICE);

   if(level!=oldlevel)
     {
      SetHline(0,level_name,0,level,active_level_color,level_style,level_width,false,level_comment);
      oldlevel=level;
      count=AlertTotal;
      startprice=price0;
     }

   if(count)
      if(price0>=level && startprice<level || price0<=level && startprice>level)
        {
         if(alert_mode==OnlyAlert) Alert("Level breakout "+DoubleToString(level,_Digits));
         if(alert_mode==OnlySound) PlaySound("alert.wav");
         count--;
         if(!count) SetHline(0,level_name,0,level,inactive_level_color,level_style,level_width,false,level_comment);
        }

//----   
   return(rates_total);
  }
//+------------------------------------------------------------------+
