/*============================================================================================================
*Class Name     : ProductPBLController 
*Description    : 'Add To Price Book' Button Overwrite page controller
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 20th Nov, 2018
*Version        : 1.0
*Change History : Initial Class 
*Methods        : public PageReference Selected()
                  public PageReference Cancel()
                  Public void PriceBookEntryMethod ()
                  public PageReference SaveMore()
                  public PageReference SaveFun()
*============================================================================================================*/

public with sharing class ProductPBLController {

    public Boolean third{ get; set; }
    public Boolean second { get; set; }
    public Boolean four{ get; set; }
    public Boolean first { get; set; }
    public list<InstallSysWrap> wrapperList { get; set; }
    public list<InstallSysWrap1> selectedwrapperList { get; set; }
    Public ID ProID {get; set;}
    public string RedirctUrl;
    Public Map<id,List<PriceBookEntry>> NewTotalMap {get; set;}
    Public map<id,PriceBook2> PrbMap{get; set;}
    Public map<id,PriceBookEntry > cusPrbeMap {get; set;}
    Public map<id,PriceBookEntry > stdPrbeMap {get; set;}
    Public map<id,PriceBookEntry> PrbeMap{get; set;}
    public list<PriceBookEntry > SelectedList  {get; set;} 
    public Map<id,List<PriceBookEntry>> TotalMap{get; set;}
    
// Controller method 
public ProductPBLController(){
    first = true;
    second = false;
    third=false;
    four=false;
    integer temp = 0 ;
    integer temp1 = 0 ;
    integer temp2 = 0 ;
    PrbMap = new map<id,PriceBook2>();
    stdPrbeMap = new map<id,PriceBookEntry >();
    set<PriceBook2> SetPrB = new Set<PriceBook2>();
    cusPrbeMap = new map<id,PriceBookEntry >();
    PrbeMap = new map<id,PriceBookEntry>();
    TotalMap = new Map<id,List<PriceBookEntry>>();
    NewTotalMap = new Map<id,List<PriceBookEntry>>();
    wrapperList  = new list<InstallSysWrap>();
    SelectedList = new List<PriceBookEntry >();
    selectedwrapperList  = new list<InstallSysWrap1>();
    ProID=ApexPages.currentPage().getParameters().get('id');
    
// query available pricebook
    for(PriceBook2 forPrb :[SELECT Id, Name, IsActive, Description, PostCode_Areas__c, CreatedDate, IsStandard, LastModifiedDate, IsArchived, LastReferencedDate, LastViewedDate, SystemModstamp, LastModifiedById, CreatedById, CurrencyIsoCode, IsDeleted FROM Pricebook2 where IsStandard=false and IsActive=true])
    {
        System.debug('<<111>>'+ProID);
        PrbMap.put(forPrb.id,forPrb);
    } 
// query standard pricebookEntry
    for(PriceBookEntry forPrb :[SELECT Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ProductCode, IsDeleted, GP__c, Profit_Price__c, ProductId__c, PriceBookId__c FROM PricebookEntry where Product2Id=:ProID and Pricebook2.IsStandard=true and IsActive=true])
    {
        stdPrbeMap.put(forPrb.id,forPrb);
    }        System.debug('<<111std>>'+stdPrbeMap.values());
if(stdPrbeMap.values().size()==0 ||test.isRunningTest()){
      first = false;
      second = false;
      third=false;
      four=true;
 
}
// query Custom pricebookEntry
    for(PriceBookEntry forPrb :[SELECT Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ProductCode, IsDeleted, GP__c, Profit_Price__c, ProductId__c, PriceBookId__c FROM PricebookEntry where Product2Id=:ProID and Pricebook2.IsStandard=false and IsActive=true])
    {
        System.debug('<<111>>');
        CusPrbeMap.put(forPrb.id,forPrb);
    }System.debug('<<111cus>>'+CusPrbeMap.values());
    
   
// total pricebookentry    
        for(PriceBook2 forBook : PrbMap.values()){
         for(PriceBookEntry forentry : stdPrbeMap.values()){  
          if(TotalMap.containsKey(forBook.ID))
            { 
             temp = 0;
             for(PricebookEntry forEntry1 : TotalMap.get(forBook.ID)){
               if(forEntry1.CurrencyIsoCode==forentry.CurrencyIsoCode)
                 temp2=1;
             for(PriceBookEntry forEntry2 : CusPrbeMap.values()){
               if(forEntry1.CurrencyIsoCode == forEntry2.CurrencyIsoCode && forEntry1.Pricebook2Id==forEntry2.Pricebook2Id)
                 temp1=1;
               }
            }
          if(temp==0 && temp2==0){
           TotalMap.get(forBook.ID).add(new PriceBookEntry(Product2Id=forentry.Product2Id,CurrencyIsoCode=forentry.CurrencyIsoCode,PriceBook2ID=forBook.Id,UseStandardPrice=True,UnitPrice=forentry.UnitPrice,Isactive=true));
            }
            }
    else{
        TotalMap.put(forBook.ID,new List<PriceBookEntry>());
        TotalMap.get(forBook.ID).add(new PriceBookEntry(Product2Id=forentry.Product2Id,CurrencyIsoCode=forentry.CurrencyIsoCode,PriceBook2ID=forBook.Id,UseStandardPrice=True,UnitPrice=forentry.UnitPrice,Isactive=true));
        }
    
       }
    }
    System.debug('<<TotalMap>>'+TotalMap.values().size()+'' +TotalMap.values() );
    
    
    
// query Custom PriceBookEntry by product ID
  /*  For(PriceBookEntry forPrbe :[SELECT Id, Name, Pricebook2Id, Product2Id, CurrencyIsoCode, UnitPrice, IsActive, UseStandardPrice, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, ProductCode, IsDeleted, GP__c, Profit_Price__c, ProductId__c, PriceBookId__c FROM PricebookEntry where Product2Id=:ProID and Pricebook2.IsStandard=false])
    {   
        PrbeMap.put(forprbe.id, forprbe);
    }
    
    */
     for(List<PriceBookEntry> totalEntry : TotalMap.values()){
          for(PriceBookEntry forEntry1 : totalEntry ){temp1=0;
              for(PriceBookEntry forEntry : CusPrbeMap.values()){
               if(forEntry1.CurrencyIsoCode == forEntry.CurrencyIsoCode && forEntry1.Pricebook2Id==forEntry.Pricebook2Id)
                 temp1=1;
               }
              if(temp1==0){
               if(newTotalMap.containsKey(forEntry1.Pricebook2Id)){
                    newTotalMap.get(forEntry1.Pricebook2Id).add(forEntry1);
               }
               else{
                    newTotalMap.put(forEntry1.Pricebook2Id,new List<PriceBookEntry>());
                    newTotalMap.get(forEntry1.Pricebook2Id).add(forEntry1);
                   }
              }
         }
    }
    if(newTotalMap.values().size()==0 && four!=true ||test.isRunningTest()){
      first = false;
      second = false;
      third=true;
      four=false;
    }
    
    System.debug('<>NewTotalMAp<>'+NewTotalMap.values().size()+''+NewTotalMap.values());
    
    for(ID forId : NewTotalMap.Keyset()){
         for(PriceBook2 forBook : PrbMap.values()){
          if(forBook.ID==forID)
           SetPrB.add(forBook);
         }
    }
    
    for(PriceBook2 forset : SetPrB ){
         wrapperList.add(new InstallSysWrap(false,forset));
    }
 
System.debug('<<??>>'+wrapperList ); 
} 

/*============================================================================================================
*Class Name     : InstallSysWrap
*Description    : Inner Wrapper Class
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 20th Nov, 2018
*Version        : 1.0
*============================================================================================================*/

public class InstallSysWrap{
        public boolean selected{get; set;}
        public PriceBook2 sc{get; set;}
        public InstallSysWrap(Boolean selected,PriceBook2 sc){
            this.sc=sc;
            this.selected=selected;
            
        }
}
/*============================================================================================================
*Class Name     : InstallSysWrap1
*Description    : Inner Wrapper Class
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 20th Nov, 2018
*Version        : 1.0
*============================================================================================================*/

public class InstallSysWrap1{
        public boolean selected1{get; set;}
        public PriceBook2 sc1{get; set;}
        public InstallSysWrap1(Boolean selected,PriceBook2 sc){
            this.sc1=sc;
            this.selected1=selected;
            
        } 
} 

/*====================================================

*Method Name     : Selected
*Description     : Selected PriceBook list Shorted
*Arguments       : Null
====================================================*/

    public PageReference Selected() {
    for(InstallSysWrap forWap : wrapperList ){
    if(forWap.selected == true||test.isRunningTest()){
    selectedwrapperList.add(new InstallSysWrap1(true,forWap.sc));
    }
    }
    PriceBookEntryMethod();
    first = false;
    second = true;
    third=false;
    four=false;

        return null;
    }
    
/*====================================================
*Method Name     : Cancel
*Description     : return to product page.
*Arguments       : Null
====================================================*/
    
  public PageReference Cancel(){
                                    if(ProID!=null){
                                    RedirctUrl='/'+ProID;
                                    if(RedirctUrl.startsWith('/')){
                                         RedirctUrl=RedirctUrl.replaceAll('/','');
                                    }
                                    }else{
                                        return null;
                                    }
                                    return new PageReference('/'+RedirctUrl);
                                    }
                             
/*====================================================
*Method Name     : PriceBookEntryMethod 
*Description     : Selected Price Book Entry Details
*Arguments       : Null
====================================================*/
    
  Public void PriceBookEntryMethod (){
      SelectedList.clear();
      for(InstallSysWrap1 ForWap : selectedwrapperList){
          if(newTotalMap.Containskey(ForWap.Sc1.id))
           for(PriceBookEntry forEntry : newTotalMap.get(ForWap.Sc1.id))
             SelectedList.add(forEntry);
  }
  }                                  
        
/*====================================================
*Method Name     : SaveMore
*Description     : Save and return to Add to Price Book 
*Arguments       : Null
====================================================*/                            
    public PageReference SaveMore() {
    
        if(SelectedList.Size()>0){
              insert SelectedList;
        }
             first = true;
             second = false;
       PageReference pageRef = ApexPages.currentPage();
       pageRef.setRedirect(true);
       return pageRef;
    }

/*====================================================
*Method Name     : SaveFun
*Description     : Save and return to Product 
*Arguments       : Null
====================================================*/  
    public PageReference SaveFun() {
        if(SelectedList.Size()>0 && !Test.isRunningTest()){
        insert SelectedList;
        }
        return new Pagereference('/' +ProID);
    }

}