//+------------------------------------------------------------------+
//|                                                test_DateTime.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()  {
/*
struct MqlDateTime
  {
   int year;           // Ano
   int mon;            // Mês
   int day;            // Dia
   int hour;           // Hora
   int min;            // Minutos
   int sec;            // Segundos
   int day_of_week;    // Dia da semana (0-domingo, 1-segunda, ... ,6-sábado)
   int day_of_year;    // Número do dia do ano (1 de Janeiro é atribuído o valor 0)
  };
*/

//---
   datetime date1=D'2014.06.04';
   datetime date2=D'2015.06.04';
 
   MqlDateTime str1,str2;
   TimeToStruct(date1,str1);
   TimeToStruct(date2,str2);
   printf("%02d.%02d.%4d, dia do ano = %d, dia da semana = %d",str1.day, str1.mon, str1.year, str1.day_of_year, str1.day_of_week);
   printf("%02d.%02d.%4d, dia do ano = %d, dia da semana = %d",str2.day, str2.mon, str2.year, str2.day_of_year, str2.day_of_week);
  }
//+------------------------------------------------------------------+
