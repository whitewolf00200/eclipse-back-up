Public class Projno{

    public Projno(ApexPages.StandardController controller) {

    }


    public ID Projid;
    public Project__c pro{get;set;}
    String prono{get;set;}
    


    public ID getProjid()
    {
    
    return Projid;
    
    }
    
    public void setProjid(ID Projids){
        if(Projids!= null){
            Projid= Projids;
            print();
            
         }
    }
    
    public void print(){
    
       try{
            if(Projid!= Null){
                pro=[select id,Project_Number__c from Project__c  where Long_Project_Order__c =:Projid order by createddate desc limit 1];   
                system.debug(pro.Project_Number__c );
                if(pro.Project_Number__c!=null){
                prono=pro.Project_Number__c;
                
                }
            }
        }catch(Exception e){}
        
    }
    
    }