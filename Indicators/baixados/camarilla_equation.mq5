

//+------------------------------------------------------------------+
//|                                           Camarilla Equation.mq5 |
//|                             Copyright © 2011,   Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+
//---- author of the indicator
#property copyright "Copyright © 2011, Nikolay Kositsin"
//---- link to the website of the author
#property link "farria@mail.redcom.ru"
//---- indicator version
#property version   "1.00"
//---- drawing the indicator in the main window
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots 1
//+-----------------------------------+
//|  enumeration declaration          |
//+-----------------------------------+
enum STYLE
  {
   STYLE_SOLID_,     // Solid line
   STYLE_DASH_,      // Dashed line
   STYLE_DOT_,       // Dotted line
   STYLE_DASHDOT_,   // Dot-dash line
   STYLE_DASHDOTDOT_ // Dot-dash line with double dots
  };
//+-----------------------------------+
//|  Indicator input parameters       |
//+-----------------------------------+
input ENUM_TIMEFRAMES CPeriod=PERIOD_D1;
//----
input color  color_H5 = Green;         // H5 level color
input color  color_H4 = Lime;          // H4 level color
input color  color_H3 = Lime;          // H3 level color
input color  color_H2 = Green;         // H2 level color
input color  color_H1 = DarkSlateGray; // H1 level color
input color  color_L1 = Purple;        // L1 level color
input color  color_L2 = Crimson;       // L2 level color
input color  color_L3 = Red;           // L3 level color
input color  color_L4 = Red;           // L4 level color
input color  color_L5 = Crimson;       // L5 level color
//----
input STYLE  style_H5 = STYLE_DASHDOT;     // H5 level line style
input STYLE  style_H4 = STYLE_DASHDOTDOT;  // H4 level line style
input STYLE  style_H3 = STYLE_SOLID;       // H3 level line style
input STYLE  style_H2 = STYLE_DASHDOTDOT;  // H2 level line style
input STYLE  style_H1 = STYLE_DASHDOTDOT;  // H1 level line style
input STYLE  style_L1 = STYLE_DASHDOTDOT;  // L1 level line style
input STYLE  style_L2 = STYLE_DASHDOTDOT;  // L2 level line style
input STYLE  style_L3 = STYLE_SOLID;       // L3 level line style
input STYLE  style_L4 = STYLE_DASHDOTDOT;  // L4 level line style
input STYLE  style_L5 = STYLE_DASHDOT;     // L5 level line style
//----
input int  width_H5 = 1;  // H5 level width
input int  width_H4 = 1;  // H4 level width
input int  width_H3 = 2;  // H3 level width
input int  width_H2 = 1;  // H2 level width
input int  width_H1 = 1;  // H1 level width
input int  width_L1 = 1;  // L1 level width
input int  width_L2 = 1;  // L2 level width
input int  width_L3 = 2;  // L3 level width
input int  width_L4 = 1;  // L4 level width
input int  width_L5 = 1;  // L5 level width
//+------------------------------------------------------------------+
//|  Creating horizontal price level                                 |
//+------------------------------------------------------------------+
void CreateHline(long   chart_id,      // chart ID
                 string name,          // object name
                 int    nwin,          // window index
                 double price,         // price level
                 color  Color,         // line color
                 int    style,         // line style
                 int    width,         // line width
                 string text           // text
                 )
  {
//----
   ObjectCreate(chart_id,name,OBJ_HLINE,0,0,price);
   ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
   ObjectSetInteger(chart_id,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_id,name,OBJPROP_WIDTH,width);
   ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_id,name,OBJPROP_BACK,true);
//----
  }
//+------------------------------------------------------------------+
//|  Reinstallation of the horizontal price level                    |
//+------------------------------------------------------------------+
void SetHline(long   chart_id,      // chart ID
              string name,          // object name
              int    nwin,          // window index
              double price,         // price level
              color  Color,         // line color
              int    style,         // line style
              int    width,         // line width
              string text           // text
              )
  {
//----
   if(ObjectFind(chart_id,name)==-1) CreateHline(chart_id,name,nwin,price,Color,style,width,text);
   else
     {
      //ObjectSetDouble(chart_id,name,OBJPROP_PRICE,price);
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectMove(chart_id,name,0,0,price);
     }
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+  
void OnInit()
  {
//----

//----
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+    
void OnDeinit(const int reason)
  {
//----
   ObjectDelete(0,"Camarilla_Level_H5");
   ObjectDelete(0,"Camarilla_Level_H4");
   ObjectDelete(0,"Camarilla_Level_H3");
   ObjectDelete(0,"Camarilla_Level_H2");
   ObjectDelete(0,"Camarilla_Level_H1");
   ObjectDelete(0,"Camarilla_Level_L1");
   ObjectDelete(0,"Camarilla_Level_L2");
   ObjectDelete(0,"Camarilla_Level_L3");
   ObjectDelete(0,"Camarilla_Level_L4");
   ObjectDelete(0,"Camarilla_Level_L5");
//----
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,    // amount of history in bars at the current tick
                const int prev_calculated,// number of bars calculated at previous call
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---- checking correctness of the chart period
   if(Period()>=CPeriod)
     {
      Print("The period of the chart is more than necessary!!!");
      return(0);
     }

//---- checking the number of bars to be enough for the calculation
   if(rates_total<1) return(0);

//---- declaration of local variables
   double iClose[],iHigh[],iLow[];
   double Level_H1,Level_H2,Level_H3,Level_H4,Level_H5;
   double Level_L1,Level_L2,Level_L3,Level_L4,Level_L5;

//---- copy data from a day time frame to the variables arrays
   if(CopyClose(NULL,CPeriod,1,1,iClose)<1)return(0);
   if(CopyHigh(NULL,CPeriod,1,1,iHigh)<1)return(0);
   if(CopyLow(NULL,CPeriod,1,1,iLow)<1)return(0);

//---- indexing elements in arrays as timeseries  
   ArraySetAsSeries(iClose,true);
   ArraySetAsSeries(iHigh,true);
   ArraySetAsSeries(iLow,true);

//---- calculation of Camarilla Equation levels
   Level_H1=iClose[0]+(iHigh[0]-iLow[0])*1.1/12;
   Level_H2=iClose[0]+(iHigh[0]-iLow[0])*1.1 /6;
   Level_H3=iClose[0]+(iHigh[0]-iLow[0])*1.1 /4;
   Level_H4=iClose[0]+(iHigh[0]-iLow[0])*1.1 /2;
   Level_H5=(iHigh[0]/iLow[0])*iClose[0];

//---- calculation of Camarilla Equation levels
   Level_L1=iClose[0]-(iHigh[0]-iLow[0])*1.1 /12;
   Level_L2=iClose[0]-(iHigh[0]-iLow[0])*1.1 /6;
   Level_L3= iClose[0]-(iHigh[0]-iLow[0])*1.1/4;
   Level_L4=iClose[0]-(iHigh[0]-iLow[0])*1.1 /2;
   Level_L5=iClose[0]-(Level_H5-iClose[0]);

//---- levels generation or relocation
   SetHline(0,"Camarilla_Level_H5",0,Level_H5,color_H5,style_H5,width_H5,"Camarilla Level H5 "+DoubleToString(Level_H5,_Digits));
   SetHline(0,"Camarilla_Level_H4",0,Level_H4,color_H4,style_H4,width_H4,"Camarilla Level H4 "+DoubleToString(Level_H4,_Digits));
   SetHline(0,"Camarilla_Level_H3",0,Level_H3,color_H3,style_H3,width_H3,"Camarilla Level H3 "+DoubleToString(Level_H3,_Digits));
   SetHline(0,"Camarilla_Level_H2",0,Level_H2,color_H2,style_H2,width_H2,"Camarilla Level H2 "+DoubleToString(Level_H2,_Digits));
   SetHline(0,"Camarilla_Level_H1",0,Level_H1,color_H1,style_H1,width_H1,"Camarilla Level H1 "+DoubleToString(Level_H1,_Digits));
   SetHline(0,"Camarilla_Level_L1",0,Level_L1,color_L1,style_L1,width_L1,"Camarilla Level L1 "+DoubleToString(Level_L1,_Digits));
   SetHline(0,"Camarilla_Level_L2",0,Level_L2,color_L2,style_L2,width_L2,"Camarilla Level L2 "+DoubleToString(Level_L2,_Digits));
   SetHline(0,"Camarilla_Level_L3",0,Level_L3,color_L3,style_L3,width_L3,"Camarilla Level L3 "+DoubleToString(Level_L3,_Digits));
   SetHline(0,"Camarilla_Level_L4",0,Level_L4,color_L4,style_L4,width_L4,"Camarilla Level L4 "+DoubleToString(Level_L4,_Digits));
   SetHline(0,"Camarilla_Level_L5",0,Level_L5,color_L5,style_L5,width_L5,"Camarilla Level L5 "+DoubleToString(Level_L5,_Digits));
//----    
   return(rates_total);
  }
//+------------------------------------------------------------------+
