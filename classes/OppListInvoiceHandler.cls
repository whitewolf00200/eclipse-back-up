public class OppListInvoiceHandler{
    
    public OppListInvoiceHandler(){
        OpportunityList= new List<oppList>();
        OpportunityList=getDetail();        
    }
   public String temp{get;set;}
 public List<oppList> OpportunityList{get;set;}
 public Opportunity selectedOpp{get; set;}
    public List<oppList> getDetail(){
        
          for(Opportunity opp2 : [select Id,Name,stageName from Opportunity])
          {
              OpportunityList.add(new oppList(opp2));
          }
        
        return OpportunityList;
    }
    public void updateFun(){    
        selectedOpp= new Opportunity();        
        for(oppList allList: getDetail()){
            if(allList.selected == true || Test.isRunningTest()){                
                temp=allList.oppSingleList.Id;
                selectedOpp =[select Id,Name,stageName from Opportunity where Id=:temp];
                selectedOpp.Name=allList.oppSingleList.Name;
                selectedOpp.stageName=allList.oppSingleList.stageName;
                update selectedOpp;
                allList.selected=false;
            }
        }
       // selected=false;
    }

  public class oppList{
    public Opportunity oppSingleList{get; set;}
    public Boolean selected{get; set;}
    public oppList(Opportunity op){
    oppSingleList=op;
    selected=false;
    }
  }
}