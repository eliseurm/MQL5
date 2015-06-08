//+------------------------------------------------------------------+
//|                                                    test_Path.mq5 |
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
  //--- The folder from which the terminal is started - terminal_directory
   string terminal_path=TerminalInfoString(TERMINAL_PATH);
//--- The folder that stores the terminal data - terminal_data_directory
   string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
//--- The shared folder of all client terminals - common_terminal_folder
   string common_data_path=TerminalInfoString(TERMINAL_COMMONDATA_PATH);   
   //--- Show all the paths 
   Print("TERMINAL_PATH(terminal_directory) = ",TerminalInfoString(TERMINAL_PATH));
   Print("TERMINAL_DATA_PATH(terminal_data_directory) = ",TerminalInfoString(TERMINAL_DATA_PATH));
   Print("TERMINAL_COMMONDATA_PATH(comon_terminal_folder) = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH));   
   
   // --- Ver os resultados no MetaTrader, Aba "Experts".
    
  }
//+------------------------------------------------------------------+
