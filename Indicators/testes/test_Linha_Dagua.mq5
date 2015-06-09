//+------------------------------------------------------------------+
//|                                             test_Linha_Dagua.mq5 |
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
   
   datetime inicio, fim;
   double valor;
   
   for (int i=prev_calculated; i<rates_total; i++){
      if ( i>0 ){
         // --- So entro a partir do segundo candle
         
         if (AnoMesDia(inicio)<AnoMesDia(fim)){
            // --- Se for um novo dia
            inicio = time[i-1];
            fim = time[i]+10*15*60; // --- 10 periodos de 15min
            valor = close[i-1];
            

            CreateTrendLine(inicio, fim, valor, Red, STYLE_SOLID, 2, DoubleToString(valor,0));
         }
      }
   }
   
   
   
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

void CreateTrendLine(
         datetime inicio, 
         datetime fim,
         double   preco,
         color    Color,         // line color
         int      style,         // line style
         int      width,         // line width
         string   text           // text
                 ) {
//----
   int chart_id = 0;
   string name = "Trend"+TimeToString(inicio, TIME_DATE);
   int nWin = 0;
   
   int win = ObjectFind(chart_id, name);
   if (win>=0){
      ObjectDelete(chart_id, name);
   }
   
   ObjectCreate(chart_id ,name, OBJ_TREND, nWin, inicio, preco, fim, preco);
   ObjectSetInteger(chart_id, name, OBJPROP_COLOR, Color);
   ObjectSetInteger(chart_id, name, OBJPROP_STYLE, style);
   ObjectSetInteger(chart_id, name, OBJPROP_WIDTH, width);
   ObjectSetString(chart_id, name, OBJPROP_TEXT, text);
   ObjectSetInteger(chart_id, name, OBJPROP_BACK, false);
//----
}


int AnoMesDia( datetime data ) {
   MqlDateTime dt;
   TimeToStruct(data,dt);
   
   return dt.year*10000+dt.mon*100+dt.day;
}
