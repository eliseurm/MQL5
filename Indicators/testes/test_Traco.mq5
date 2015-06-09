//+------------------------------------------------------------------+
//|                                                   test_Traco.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
    
    int ultimo = UltimoCandleDoDia(time);
    
    SetHline(0, "Linha D'Agua 0", D'2015.05.26', 53000, Red, STYLE_SOLID, 4, "LinhaDagua");
    SetHline(1, "Linha D'Agua 1", D'2015.06.01', 55000, Green, STYLE_SOLID, 4, "LinhaDagua");
    
    
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


void CreateHline(long   chart_id,      // chart ID
                 string name,          // object name
                 datetime dtInicio,     // Data Inicial
                 double price,         // price level
                 color  Color,         // line color
                 int    style,         // line style
                 int    width,         // line width
                 string text           // text
                 ) {
//----
   datetime dtFim = dtInicio + 50*60*60;

   ObjectCreate(chart_id,name,OBJ_TREND,0,dtInicio,price, dtFim, price);
   ObjectSetInteger(chart_id,name,OBJPROP_COLOR,Color);
   ObjectSetInteger(chart_id,name,OBJPROP_STYLE,style);
   ObjectSetInteger(chart_id,name,OBJPROP_WIDTH,width);
   ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_id,name,OBJPROP_BACK,true);
//----
}

void SetHline(long   chart_id,      // chart ID
              string name,          // object name
              datetime dtInicio,     // Data Inicial
              double price,         // price level
              color  Color,         // line color
              int    style,         // line style
              int    width,         // line width
              string text           // text
              )
  {
//----
   if(ObjectFind(chart_id,name)==-1) 
      CreateHline(chart_id,name,dtInicio,price,Color,style,width,text);
   else
     {
      //ObjectSetDouble(chart_id,name,OBJPROP_PRICE,price);
      ObjectSetString(chart_id,name,OBJPROP_TEXT,text);
      ObjectMove(chart_id,name,0,0,price);
     }
//----
  }

int UltimoCandleDoDia(const datetime &time[]) {

   
   return 0;
}