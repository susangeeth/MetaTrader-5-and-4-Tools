//+------------------------------------------------------------------+
//|                                                    DbCommand.mqh |
//|                                             Copyright GF1D, 2010 |
//|                                             garf1eldhome@mail.ru |
//+------------------------------------------------------------------+
#property copyright "GF1D, 2010"
#property link      "garf1eldhome@mail.ru"

//--------------------------------------------------------------------
#include "ClrObject.mqh"
#include "DbConnection.mqh"
#include "DbTransaction.mqh"
#include "DbDataReader.mqh"
#include "DbParameterList.mqh"
#include "..\..\AdoTypes.mqh"
#include "..\..\Data\AdoValue.mqh"

//--------------------------------------------------------------------
#import "AdoSuite.dll"
long GetDbCommandParameterList(const long,string&,string&);
void SetDbCommandText(const long,const string,string&,string&);
string GetDbCommandText(const long,string&,string&);
void SetDbCommandTimeout(const long,const int,string&,string&);
int GetDbCommandTimeout(const long,string&,string&);
void SetDbCommandType(const long,const int,string&,string&);
int GetDbCommandType(const long,string&,string&);
void SetDbCommandConnection(const long,const long,string&,string&);
void    SetDbCommandTransaction(const long,const long,string&,string&);
void DbCommandExecuteNonQuery(const long,string&,string&);
long DbCommandExecuteReader(const long,string&,string&);
int DbCommandExecuteScalar(const long,long&,string&,string&);
bool DbCommandScalarGetBool(const long,string&,string&);
long DbCommandScalarGetLong(const long,string&,string&);
double DbCommandScalarGetDouble(const long,string&,string&);
string DbCommandScalarGetString(const long,string&,string&);
void DbCommandScalarGetDatetime(const long,MqlDateTime&,string&,string&);
#import
//--------------------------------------------------------------------
/// \brief  \~russian Ïåðå÷èñëåíèå, ïðåäñòàâëÿþùåå òèï êîìàíäû
///         \~english Command types
enum ENUM_COMMAND_TYPES
  {
   CMDTYPE_STOREDPROCEDURE=4,
   CMDTYPE_TABLEDIRECT=0x200,
   CMDTYPE_TEXT=1
  };
//--------------------------------------------------------------------
/// \brief  \~russian Êëàññ, ïðåäñòàâëÿþùèé èñïîëíÿåìóþ êîìàíäó â áàçîâîì èñòî÷íèêå äàííûõ
///         \~english Represents an SQL statement or stored procedure to execute against a data source
class CDbCommand : public CClrObject
  {
private:
   // variables
   CDbParameterList *_Parameters;
   CDbConnection    *_Connection;
   CDbTransaction   *_Transaction;

protected:
   // methods

   /// \brief  \~russian Ñîçäàåò ñïèñîê ïàðàìåòðîâ êîìàíäû. Âèðòóàëüíûé ìåòîä. Äîëæåí áûòü ïåðåîïðåäåëåí â íàñëåäíèêàõ
   ///         \~english Creates parameter collection for the command. Virtual. Must be overriden
   virtual CDbParameterList *CreateParameters() { return NULL; }

   /// \brief  \~russian Ñîçäàåò îáúåêò, ïðîèçâîäíûé CDbDataReader äëÿ èñòî÷íèêà äàííûõ. Âèðòóàëüíûé ìåòîä. Äîëæåí áûòü ïåðåîïðåäåëåí â íàñëåäíèêàõ
   ///         \~english Creates CDbDataReader for the command. Virtual. Must be overriden
   virtual CDbDataReader *CreateReader() { return NULL; }

   // events
   virtual void      OnObjectCreated();

public:
   /// \brief  \~russian êîíñòðóêòîð êëàññà
   ///         \~english constructor
                     CDbCommand() { MqlTypeName("CDbCommand"); }
   /// \brief  \~russian äåñòðóêòîð êëàññà
   ///         \~english destructor
                    ~CDbCommand();

   // properties
   /// \brief  \~russian Âîçâðàùàåò òåêñò êîìàíäû
   ///         \~english Gets command text
   const string      CommandText();
   /// \brief  \~russian Çàäàåò òåêñò êîìàíäû
   ///         \~english Sets command text
   void              CommandText(const string value);

   /// \brief  \~russian Âîçâðàùàåò ìàêñèìàëüíîå âðåìÿ, â òå÷åíèè êîòîðîãî êîìàíäà äîëæíà âûïîëíèòüñÿ
   ///         \~english Gets command timeout
   const int         CommandTimeout();
   /// \brief  \~russian Çàäàåò ìàêñèìàëüíîå âðåìÿ, â òå÷åíèè êîòîðîãî êîìàíäà äîëæíà âûïîëíèòüñÿ
   ///         \~english Sets command timeout
   void              CommandTimeout(const int value);

   /// \brief  \~russian Âîçâðàùàåò òèï êîìàíäû
   ///         \~english Gets command type
   const ENUM_COMMAND_TYPES CommandType();
   /// \brief  \~russian Çàäàåò òèï êîìàíäû
   ///         \~english Sets command type
   void              CommandType(const ENUM_COMMAND_TYPES value);

   /// \brief  \~russian Âîçâðàùàåò îáúåêò ñîåäèíåíèÿ, ÷åðåç êîòîðîå ðàáîòàåò êîìàíäà
   ///         \~english Gets connection used by the command
   CDbConnection *Connection() { return _Connection; }
   /// \brief  \~russian Çàäàåò îáúåêò ñîåäèíåíèÿ, ÷åðåç êîòîðîå áóäåò ðàáîòàòü êîìàíäà
   ///         \~english Sets connection used by the command
   void              Connection(CDbConnection *value);

   /// \brief  \~russian Âîçâðàùàåò òðàíçàêöèþ, â êîòîðîé âûïîëíÿåòñÿ êîìàíäà
   ///         \~english Gets transaction within which this command executes
   CDbTransaction *Transaction() { return _Transaction; }
   /// \brief  \~russian Çàäàåò òðàíçàêöèþ, â êîòîðîé äîëæíà âûïîëíÿòüñÿ êîìàíäà
   ///         \~english Sets transaction within which this command executes
   void              Transaction(CDbTransaction *value);

   /// \brief  \~russian Âîçâðàùàåò ñïèñîê ïàðàìåòðîâ êîìàíäû
   ///         \~english Get command parameter list
   CDbParameterList *Parameters();

   // methods
   /// \brief  \~russian Âûïîëíÿåò êîìàíäó, êîòîðàÿ íå âîçâðàùàåò çíà÷åíèé
   ///         \~english Executes a command against a connection object
   void              ExecuteNonQuery();
   /// \brief  \~russian Âûïîëíÿåò êîìàíäó íà âûáîðêó, è âîçâðàùàåò îáúåêò, ïðîèçâîäíûé îò DbDataReader
   ///         \~english Executes a command against a connection object and returns DbDataReader
   CDbDataReader    *ExecuteReader();
   /// \brief  \~russian Âûïîëíÿåò êîìàíäó, âîçâðàùàþùåå îäíî çíà÷åíèå (ïåðâóþ ÿ÷åéêó ïåðâîé ñòðîêè âûáîðêè, ôóíêöèè èòï)
   ///         \~english Executes the query and returns the first column of the first row in the result set returned by the query
   CAdoValue        *ExecuteScalar();

  };
//--------------------------------------------------------------------
CDbCommand::~CDbCommand(void)
  {
   if(CheckPointer(_Parameters)==POINTER_DYNAMIC)
     {
      delete _Parameters;
      _Parameters=NULL;
     }
  }
//--------------------------------------------------------------------
void CDbCommand::OnObjectCreated(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   long hParameters=GetDbCommandParameterList(ClrHandle(),exType,exMsg);

   if(exType!="")
     {
      OnClrException("OnObjectCreated",exType,exMsg);
      return;
     }

   Parameters().Assign(hParameters);
  }
//--------------------------------------------------------------------
CDbParameterList *CDbCommand::Parameters()
  {
   if(!CheckPointer(_Parameters))
      _Parameters=CreateParameters();

   return _Parameters;
  }
//--------------------------------------------------------------------
string CDbCommand::CommandText(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   string value=GetDbCommandText(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("CommandText(get)",exType,exMsg);

   return value;
  }
//--------------------------------------------------------------------
void CDbCommand::CommandText(const string value)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   SetDbCommandText(ClrHandle(),value,exType,exMsg);

   if(exType!="")
      OnClrException("CommandText(set)",exType,exMsg);
  }
//--------------------------------------------------------------------
int CDbCommand::CommandTimeout()
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   int value=GetDbCommandTimeout(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("CommandTimeout(get)",exType,exMsg);

   return value;
  }
//--------------------------------------------------------------------
void CDbCommand::CommandTimeout(const int value)
  {
   if(value<=0)
     {
      OnClrException("CommandTimeout(set)","ArgumentException","");
      return;
     }

   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   SetDbCommandTimeout(ClrHandle(),value,exType,exMsg);

   if(exType!="")
      OnClrException("CommandTimeout(set)",exType,exMsg);
  }
//--------------------------------------------------------------------
ENUM_COMMAND_TYPES CDbCommand::CommandType()
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   ENUM_COMMAND_TYPES value=(ENUM_COMMAND_TYPES)GetDbCommandType(ClrHandle(),exType,exMsg);

   if(exType!="")
     {
      OnClrException("CommandType(get)",exType,exMsg);
      return -1;
     }

   return value;
  }
//--------------------------------------------------------------------
void CDbCommand::CommandType(const ENUM_COMMAND_TYPES value)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   SetDbCommandType(ClrHandle(),value,exType,exMsg);

   if(exType!="")
      OnClrException("CommandType(set)",exType,exMsg);
  }
//--------------------------------------------------------------------
void CDbCommand::Connection(CDbConnection *value)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   SetDbCommandConnection(ClrHandle(),value.ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("Connection(set)",exType,exMsg);
   else _Connection=value;
  }
//--------------------------------------------------------------------
void CDbCommand::Transaction(CDbTransaction *value)
  {
   if(value==NULL)
     {
      OnClrException("Transaction(set)","ArgumentException","");
      return;
     }

   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   SetDbCommandTransaction(ClrHandle(),value.ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("Transaction(set)",exType,exMsg);
   else _Transaction=value;
  }
//--------------------------------------------------------------------
void CDbCommand::ExecuteNonQuery(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   DbCommandExecuteNonQuery(ClrHandle(),exType,exMsg);

   if(exType!="")
      OnClrException("ExecuteNonQuery(set)",exType,exMsg);
  }
//--------------------------------------------------------------------
CAdoValue *CDbCommand::ExecuteScalar(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   long hObject=0;
   int type=DbCommandExecuteScalar(ClrHandle(),hObject,exType,exMsg);

   if(exType!="")
     {
      OnClrException("ExecuteScalar[execute]",exType,exMsg);
      return NULL;
     }

// db returned DBNull value or unsupported type
   if(type==-1) return NULL;

   CAdoValue *result=new CAdoValue();

   switch(type+ADOTYPE_VALUE)
     {
      case ADOTYPE_BOOL:
         result.SetValue(DbCommandScalarGetBool(hObject,exType,exMsg));
         break;

      case ADOTYPE_LONG:
         result.SetValue(DbCommandScalarGetLong(hObject,exType,exMsg));
         break;

      case ADOTYPE_DOUBLE:
         result.SetValue(DbCommandScalarGetDouble(hObject,exType,exMsg));
         break;

      case ADOTYPE_STRING:
         result.SetValue(DbCommandScalarGetString(hObject,exType,exMsg));
         break;

      case ADOTYPE_DATETIME:
        {
         MqlDateTime mdt;
         DbCommandScalarGetDatetime(hObject,mdt,exType,exMsg);
         result.SetValue(mdt);
        }
      break;
      default:
         exType="UnknownAdoTypeException";
         break;
     }

   if(exType!="")
     {
      OnClrException("ExecuteScalar[get val]",exType,exMsg);
      return NULL;
     }

   return result;
  }
//--------------------------------------------------------------------
CDbDataReader *CDbCommand::ExecuteReader(void)
  {
   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   long hReader=DbCommandExecuteReader(ClrHandle(),exType,exMsg);

   if(exType!="")
     {
      OnClrException("ExecuteReader",exType,exMsg);
      return NULL;
     }

   CDbDataReader *reader=CreateReader();
   reader.Assign(hReader,true);

   return reader;
  }
//+------------------------------------------------------------------+
