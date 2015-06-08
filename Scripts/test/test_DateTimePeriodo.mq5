//+------------------------------------------------------------------+
//|                                          test_DateTimeCandle.mq5 |
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
   int start = 0; // bar index
   int count = 10; // number of bars
   datetime tm[]; // array storing the returned bar time
   //--- copy time 
   CopyTime(_Symbol, PERIOD_M15, start, count, tm);
   //--- output result
   
   int size=ArraySize(tm);
   for(int i=0;i<size;i++) {
      Print(i+": Tempo: "+tm[i]);
   }
   
  }
//+------------------------------------------------------------------+
