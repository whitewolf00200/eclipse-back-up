public class ServiceReportPreviosSheet  
{
public id Sheetid;
public List<Next_Visit_Product__c> NextVisPrd{get;set;}
public List<Required_Parts__c> ReqPrd{get;set;}
public integer Mapsize;
public List<wrapPrds> ResPrd{get;set;}
public Service_Sheet_STD__c rs {get;set;}
Public Boolean sign{get;set;}
Public String TechSign {get;set;}
    public ID getSheetid(){return Sheetid;}
    Public Boolean hcopy{get;set;} // this is used for hard copy
    
    public void setSheetid(ID SheetsIds){
        if(SheetsIds != null){
            Sheetid = SheetsIds;
            ResData();
            
        }
   }
  
   
   public void ResData(){
    hcopy=true;
    system.debug('initial mapsize===='+Mapsize);
    ResPrd=new List<wrapPrds>();
    NextVisPrd=new List<Next_Visit_Product__c>([select id,Product_Code__c,Product__r.Sales_Description__c,Quantity__c,Product__r.Name from Next_Visit_Product__c where Maintenance_Reactive_Sheet__c=:Sheetid]);
    ReqPrd=new List<Required_Parts__c>([select id,Product_Code__c,Quantity__c,Parts_Used_Description__c,Product_Name__r.Name,Product_Name__r.Sales_Description__c from Required_Parts__c where Maintenance_Reactive_Sheet__c=:Sheetid]);
          
    if(NextVisPrd.size()>0){
       if(NextVisPrd.size()==ReqPrd.size()){
         system.debug('system.debug 1st===='+NextVisPrd);
         Mapsize=NextVisPrd.size()-1;
      }else{
            if(NextVisPrd.size()<ReqPrd.size()){
                system.debug('system.debug 2nd===='+NextVisPrd);
                Mapsize=ReqPrd.size()-1;
                for(Integer i=0;i<=ReqPrd.size();i++){
                    NextVisPrd.add(new Next_Visit_Product__c());
                }
            }
            else{
                  Mapsize=NextVisPrd.size()-1;
                  for(Integer i=0;i<=NextVisPrd.size();i++){
                       ReqPrd.add(new Required_Parts__c());
                   }
                }
           }
     }
    system.debug('%%%%%%%%%%%%%'+Mapsize);
    
    for(integer i=0;i<=Mapsize;i++){
       
        ResPrd.add(new wrapPrds(ReqPrd[i].Product_Code__c,ReqPrd[i].Quantity__c,ReqPrd[i].Parts_Used_Description__c,NextVisPrd[i].Product__r.Sales_Description__c,NextVisPrd[i].Quantity__c,ReqPrd[i].Product_Name__r.Name,ReqPrd[i].Product_Name__r.Sales_Description__c,NextVisPrd[i].Product__r.Name));
        hcopy=false;
        system.debug('inside======'+ResPrd);
    }
    system.debug('>>>>>>>>'+ResPrd);
    
    if(NextVisPrd.size()==0 && ReqPrd.size()>0){
    
    system.debug('ReqPrd.size()===='+ReqPrd.size());
    Mapsize=ReqPrd.size()-1;
    system.debug('Mapsize==='+Mapsize);
    for(integer i=0;i<=Mapsize;i++){
    ResPrd.add(new wrapPrds(ReqPrd[i].Product_Code__c,ReqPrd[i].Quantity__c,ReqPrd[i].Parts_Used_Description__c,'',null,ReqPrd[i].Product_Name__r.Name,ReqPrd[i].Product_Name__r.Sales_Description__c,''));
    hcopy=false;
    system.debug('ResPrd===='+ResPrd);
    }
    Mapsize=null;
    system.debug('final map size==='+Mapsize);
    }
   try{
       rs=[Select id,name,Technician__r.Signature__c from Service_Sheet_STD__c where id=:sheetid ];
               if(rs.Technician__r.Signature__c!=null){
                  TechSign=rs.Technician__r.Signature__c.subStringBetween(rs.Technician__r.Signature__c.contains('src') ? 'src="' : 'href="','"').replaceAll('&amp;','&');
                  sign=true;
                  system.debug('TechSign======'+TechSign+'>>>>sign====='+sign);         
               }
               else{ 
                 sign=false;
                 system.debug('sign====='+sign);
                }
   }
   Catch(Exception e){
    system.debug('Exception occured==========');
   }
   }
   
   public class wrapPrds{
       public string prdCode{get;set;}
       public Decimal qty{get;set;}
       public string Descrip{get;set;}
       public string NextPrd{get;set;}
       public Decimal NextQty{get;set;}
       public string Name{get;set;}
       public string PrdDesc{get;set;}
       public string NxtName{get;set;}
       
       public wrapPrds(String prdCode,Decimal qty,String Descrip,String NextPrd,Decimal NextQty,String Name,String PrdDesc,String NxtName){
           this.prdCode=prdCode;
           this.qty=qty;
           this.Descrip=Descrip;
           this.NextPrd=NextPrd;
           this.NextQty=NextQty;
           this.Name=Name;
           this.PrdDesc=PrdDesc;
           this.NxtName=NxtName;
       }
   }
   
   
}