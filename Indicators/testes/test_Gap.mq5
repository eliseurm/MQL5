//+------------------------------------------------------------------+
//|                                                     test_Gap.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <CandlestickType.mqh>


#property indicator_chart_window

input int   InpPeriodSMA   =10;         // Period of averaging
input bool  InpAlert       =true;       // Enable. signal
input int   InpCountBars   =1000;       // Amount of bars for calculation
input color InpColorBull   =DodgerBlue; // Color of bullish models
input color InpColorBear   =Tomato;     // Color of bearish models
input bool  InpCommentOn   =true;       // Enable comment
input int   InpTextFontSize=10;         // Font size

datetime CurTime=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ObjectsDeleteAll(0,-1,-1);
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

   string comment;
   datetime inicio, fim;
   double valor;
   int objcount=0;

   for (int i=prev_calculated; i<rates_total; i++){
      if ( i>0 ){
         // --- So entro a partir do segundo candle
         
         inicio = time[i-1];
         fim = time[i]+10*15*60; // --- 10 periodos de 15min
         valor = close[i-1];
         CurTime=time[rates_total-2];
         
         if (AnoMesDia(inicio)<AnoMesDia(fim)){
            // --- Se for um novo dia
            
            CANDLE_STRUCTURE cand1;
            if(!RecognizeCandle(_Symbol, _Period, time[i-1], InpPeriodSMA, cand1))
               continue;

            CANDLE_STRUCTURE cand2;
            if(!RecognizeCandle(_Symbol, _Period, time[i],   InpPeriodSMA, cand2))
               continue;

            CANDLE_STRUCTURE cand3;
            if(!RecognizeCandle(_Symbol, _Period, time[i+1], InpPeriodSMA, cand3))
               continue;

  /* Analise de 2 candles */
            // Gap normal, sem analise do formato do candle
            if (objcount==22) {
               objcount=objcount;
            }
            
            if( cand1.bull && cand2.bull &&
               (cand1.close<cand2.open || cand1.open>cand2.close)) // gap between them
              {
               comment="Gap normal";
               DrawSignal("Gap normal model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
            if( !cand1.bull && !cand2.bull &&
               (cand1.close>cand2.open || cand1.open<cand2.close)) // gap between them
              {
               comment="Gap normal";
               DrawSignal("Gap normal model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
              
            // Gap normal (Bull)
            if(!cand1.bull && cand2.bull && // check direction of trend and direction of candlestick
               cand1.open<cand2.open) // gap between them
              {
               comment="Gap normal (Bull)";
               DrawSignal("Gap normal the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
            // Gap normal (Bear)
            if(cand1.bull && !cand2.bull && // check direction of trend and direction of candlestick
               cand1.open>cand2.open) // gap between them
              {
               comment="Gap normal (Bear)";
               DrawSignal("Gap normal the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }
            
  
            // Kicking, the bull model
            if(!cand1.bull && cand2.bull && // check direction of trend and direction of candlestick
               cand1.type==CAND_MARIBOZU_LONG && cand2.type==CAND_MARIBOZU_LONG && // two maribozu
               cand1.open<cand2.open) // gap between them
              {
               comment="Kicking (Bull)";
               DrawSignal("Kicking the bull model"+string(objcount++),cand1,cand2,InpColorBull,comment);
              }
            // Kicking, the bearish model
            if(cand1.bull && !cand2.bull && // check direction of trend and direction of candlestick
               cand1.type==CAND_MARIBOZU_LONG && cand2.type==CAND_MARIBOZU_LONG && // two maribozu
               cand1.open>cand2.open) // gap between them
              {
               comment="Kicking (Bear)";
               DrawSignal("Kicking the bear model"+string(objcount++),cand1,cand2,InpColorBear,comment);
              }


   /* Analidse de 3 Candles */
            if(cand1.trend==UPPER && cand1.bull && cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
               (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // the first two candles are "long"
               cand2.open>cand1.close && // gap between the second and first candlesticks
               cand3.open>cand2.open && cand3.open<cand2.close && cand3.close<cand1.close) // the third candlestick is opened inside the second one and it fills the gap
              {
               comment="Upside Gap Three Methods (Bull)";
               DrawSignal("Upside Gap Three Methods the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
            //------      
            // Downside Gap Three Methods, the bullish model
            if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
               (cand1.type==CAND_LONG || cand1.type==CAND_MARIBOZU_LONG) && (cand2.type==CAND_LONG || cand2.type==CAND_MARIBOZU_LONG) && // the first two candles are "long"
               cand2.open<cand1.close && // gap between the first and second candlesticks
               cand3.open<cand2.open && cand3.open>cand2.close && cand3.close>cand1.close) // the third candlestick is opened inside the second one and fills the gap
              {
               comment="Downside Gap Three Methods (Bear)";
               DrawSignal("Downside Gap Three Methods the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }
            //------      
            // Upside Tasuki Gap, the bullish model
            if(cand1.trend==UPPER && cand1.bull && cand2.bull && !cand3.bull && // check direction of trend and direction of candlestick
               cand1.type!=CAND_DOJI && cand2.type!=CAND_DOJI && // the first two candlesticks are not Doji
               cand2.open>cand1.close && // gap between the second and first candlesticks
               cand3.open>cand2.open && cand3.open<cand2.close && cand3.close<cand2.open && cand3.close>cand1.close) // the third candlestick is opened inside the second one and is closed inside the gap
              {
               comment="Upside Tasuki Gap (Bull)";
               DrawSignal("Upside Tasuki Gap the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBull,comment);
              }
            //------      
            // Downside Tasuki Gap, the bullish model
            if(cand1.trend==DOWN && !cand1.bull && !cand2.bull && cand3.bull && // check direction of trend and direction of candlestick
               cand1.type!=CAND_DOJI && cand2.type!=CAND_DOJI && // the first two candlesticks are not Doji
               cand2.open<cand1.close && // gap between the first and second candlesticks
               cand3.open<cand2.open && cand3.open>cand2.close && cand3.close>cand2.open && cand3.close<cand1.close) // the third candlestick is opened isnside the second one, and is closed within the gap
              {
               comment="Downside Tasuki Gap (Bear)";
               DrawSignal("Downside Tasuki Gap the bull model"+string(objcount++),cand1,cand2,cand3,InpColorBear,comment);
              }


         }
      }
   }

   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

int AnoMesDia( datetime data ) {
   MqlDateTime dt;
   TimeToStruct(data,dt);
   
   return dt.year*10000+dt.mon*100+dt.day;
}


void DrawSignal(string objname,CANDLE_STRUCTURE &cand1,CANDLE_STRUCTURE &cand2,color Col,string comment)
  {
   string objtext=objname+"text";
   double price_low=MathMin(cand1.low,cand2.low);
   double price_high=MathMax(cand1.high,cand2.high);

   if(ObjectFind(0,objtext)>=0) ObjectDelete(0,objtext);
   if(ObjectFind(0,objname)>=0) ObjectDelete(0,objname);
   if(InpAlert && cand2.time>=CurTime)
     {
      Alert(Symbol()," ",PeriodToString(_Period)," ",comment);
     }

   ObjectCreate(0,objname,OBJ_RECTANGLE,0,cand1.time,price_low,cand2.time,price_high);
   if(Col==InpColorBull)
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand1.time,price_low);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,-90);
        }
     }
   else
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand1.time,price_high);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,90);
        }
     }
   ObjectSetInteger(0,objname,OBJPROP_COLOR,Col);
   ObjectSetInteger(0,objname,OBJPROP_BACK,false);
   ObjectSetString(0,objname,OBJPROP_TEXT,comment);
   if(InpCommentOn)
     {
      ObjectSetInteger(0,objtext,OBJPROP_COLOR,Col);
      ObjectSetString(0,objtext,OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,objtext,OBJPROP_FONTSIZE,InpTextFontSize);
      ObjectSetString(0,objtext,OBJPROP_TEXT,"    "+comment);
     }
   }

void DrawSignal(string objname,CANDLE_STRUCTURE &cand1,CANDLE_STRUCTURE &cand2,CANDLE_STRUCTURE &cand3,color Col,string comment)
  {
   string objtext=objname+"text";
   double price_low=MathMin(cand1.low,MathMin(cand2.low,cand3.low));
   double price_high=MathMax(cand1.high,MathMax(cand2.high,cand3.high));

   if(ObjectFind(0,objtext)>=0) ObjectDelete(0,objtext);
   if(ObjectFind(0,objname)>=0) ObjectDelete(0,objname);
   if(InpAlert && cand3.time>=CurTime)
     {
      Alert(Symbol()," ",PeriodToString(_Period)," ",comment);
     }
   ObjectCreate(0,objname,OBJ_RECTANGLE,0,cand1.time,price_low,cand3.time,price_high);
   if(Col==InpColorBull)
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand3.time,price_low);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,-90);
        }
     }
   else
     {
      if(InpCommentOn)
        {
         ObjectCreate(0,objtext,OBJ_TEXT,0,cand3.time,price_high);
         ObjectSetInteger(0,objtext,OBJPROP_ANCHOR,ANCHOR_LEFT);
         ObjectSetDouble(0,objtext,OBJPROP_ANGLE,90);
        }
     }
   ObjectSetInteger(0,objname,OBJPROP_COLOR,Col);
   ObjectSetInteger(0,objname,OBJPROP_BACK,false);
   ObjectSetInteger(0,objname,OBJPROP_WIDTH,2);
   ObjectSetString(0,objname,OBJPROP_TEXT,comment);
   if(InpCommentOn)
     {
      ObjectSetInteger(0,objtext,OBJPROP_COLOR,Col);
      ObjectSetString(0,objtext,OBJPROP_FONT,"Tahoma");
      ObjectSetInteger(0,objtext,OBJPROP_FONTSIZE,InpTextFontSize);
      ObjectSetString(0,objtext,OBJPROP_TEXT,"    "+comment);
     }
  }


string PeriodToString(ENUM_TIMEFRAMES period)
  {
   switch(period)
     {
      case PERIOD_M1: return("M1");
      case PERIOD_M2: return("M2");
      case PERIOD_M3: return("M3");
      case PERIOD_M4: return("M4");
      case PERIOD_M5: return("M5");
      case PERIOD_M6: return("M6");
      case PERIOD_M10: return("M10");
      case PERIOD_M12: return("M12");
      case PERIOD_M15: return("M15");
      case PERIOD_M20: return("M20");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H2: return("H2");
      case PERIOD_H3: return("H3");
      case PERIOD_H4: return("H4");
      case PERIOD_H6: return("H6");
      case PERIOD_H8: return("H8");
      case PERIOD_H12: return("H12");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN1");
     }
   return(NULL);
  };
