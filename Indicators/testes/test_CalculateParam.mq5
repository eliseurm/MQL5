//+------------------------------------------------------------------+
//|                                              test_Parametros.mq5 |
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

  for(int i=prev_calculated; i<rates_total; i++) { 
   
      PrintFormat("%d: Tempo: %s, Open: %s, high: %s, low: %s, close: %s, tick_volume: %s, volume: %s, spread: %s", 
         i, 
         TimeToString(time[i], TIME_DATE|TIME_MINUTES), 
         DoubleToString(open[i], 2), 
         DoubleToString(high[i], 2), 
         DoubleToString(low[i], 2),  
         DoubleToString(close[i], 2),  
         IntegerToString(tick_volume[i]),  
         IntegerToString(volume[i]), 
         IntegerToString(spread[i]) );
         
   }

   int size=ArraySize(time);
   PrintFormat("Size: %d", size);
  
   PrintFormat("rates_toral: %d", rates_total);
   PrintFormat("prev_calculated: %d", prev_calculated);



   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
