//+------------------------------------------------------------------+
//|                                                   test_Traco.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

    CreateHline(0, "Linha D'Agua 0", D'2015.05.26', 53000, Red, STYLE_SOLID, 4, "LinhaDagua 0");
    CreateHline(0, "Linha D'Agua 1", D'2015.06.01', 55000, Green, STYLE_SOLID, 4, "LinhaDagua 1");

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
   ObjectSetInteger(chart_id,name,OBJPROP_BACK, false);
//----
}
