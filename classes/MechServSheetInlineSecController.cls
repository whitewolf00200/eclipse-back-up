public class MechServSheetInlineSecController {

    public boolean isEdit{get;set;}
    public boolean isSaved{get;set;}
    public String selectedValue{get;set;}
    public Boolean flag {get;set;}
    public MechServSheetInlineSecController(ApexPages.StandardController controller) 
    {
        flag = false;
        isEdit=false;
        isSaved = true;
    }
    public class SystemLocationWrapper
    {
        public String systemLocation{get;set;}
        public String noOfLocations{get;set;}
        public String capacity{get;set;}
        public String agentFill{get;set;}
        Public String testDate{get;set;}
    }
    Mechanical_Service_Sheet__c mech = [select Id,System_Location__c,No_of_Cycles__c,Capacity__c,Agent_Fill__c,Test_Date__c  from Mechanical_Service_Sheet__c where Id=:ApexPages.currentPage().getParameters().get('id')];
    List<SystemLocationWrapper> liSystemLocation = new List<SystemLocationWrapper>();
    public List<SystemLocationWrapper> getSystemLocation()
    {
        if(liSystemLocation.isEmpty())
        {
          if(mech.System_Location__c!=null)
            {
                List<String> sysLoc,noCyls,capcity,agntfl,tstdt;
                sysLoc=mech.System_Location__c.split(';',-1);
                for(Integer iterator=0;iterator<sysLoc.size()-1;iterator++)
                {
                    SystemLocationWrapper instance = new SystemLocationWrapper();
                    instance.systemLocation = sysLoc[iterator]; 
                    if(mech.No_of_Cycles__c!=null)
                    {
                        noCyls= mech.No_of_Cycles__c.split(';',-1);
                        instance.noOfLocations = noCyls[iterator];
                    }
                    else
                    {
                        instance.noOfLocations=''; 
                    }
                    if(mech.Capacity__c!=null)
                    {
                        capcity= mech.Capacity__c.split(';',-1);
                        instance.capacity= capcity[iterator];
                    }
                    else
                    {
                        instance.capacity=''; 
                    }
                    if(mech.Agent_Fill__c!=null)
                    {
                        agntfl= mech.Agent_Fill__c.split(';',-1);
                        instance.agentFill= agntfl[iterator];
                    }
                    else
                    {
                        instance.agentFill=''; 
                    }
                    if(mech.Test_Date__c!=null)
                    {
                        tstdt= mech.Test_Date__c.split(';',-1);
                        instance.testDate= tstdt[iterator];
                    }
                    else
                    {
                        instance.testDate=''; 
                    }
                    liSystemLocation.add(instance);
                }
                
                
            }
        }
        return liSystemLocation;
    }
    public PageReference addSystemLocations()
    {
        SystemLocationWrapper instance = new SystemLocationWrapper();
        liSystemLocation.add(instance);
        return null;
    }
    
    public PageReference saveSystemLocations()
    {    
        system.debug(flag + '>>>>>>>>>>>>>>>>>>>>> FLAg');
        system.debug(liSystemLocation+ '>>>>>>>>>>>>>>>>>>>>> LIST');
        if(flag)
        {
            liSystemLocation=new List<SystemLocationWrapper>();
        }
        String systlo='',cyls='',cap='',agnfil='',tstDate='';
        Boolean isError=false;
        Boolean isError2=false;
        Set<String> avoidDuplicate =  new Set<String>();
        for(SystemLocationWrapper iterator:liSystemLocation)
        {
            avoidDuplicate.add(iterator.systemLocation);
            if(systlo=='')
            {
                if(iterator.systemLocation=='')
                {
                    isError2 = true;
                }
                systlo = iterator.systemLocation;
                cyls = iterator.noOfLocations;
                cap = iterator.capacity;
                agnfil = iterator.agentFill;
                tstDate = iterator.testDate;
            }
            else
            {
                if(iterator.systemLocation=='')
                {
                    isError2 = true;
                }
                systlo = systlo + ';' + iterator.systemLocation;
                cyls = cyls + ';' + iterator.noOfLocations;
                cap = cap + ';' + iterator.capacity;
                agnfil = agnfil + ';' + iterator.agentFill;
                tstDate = tstDate + ';' + iterator.testDate;
            }
        }
        if(liSystemLocation.size()!=avoidDuplicate.size())
        {
            isError = true;
        }
        if(isError)
        {
            ApexPages.Message myMsg=new ApexPages.Message(ApexPages.Severity.Error, 'Please do not repeat same Names for Outlet Locations');
            ApexPages.addMessage(myMsg);
        }
        else if(isError2)
        {
            ApexPages.Message myMsg=new ApexPages.Message(ApexPages.Severity.Error, 'Cannot save without System Location. Please enter a name for System Location or remove the row.');
            ApexPages.addMessage(myMsg);
        }
        else
        {
            mech.System_Location__c= systlo+';'; 
            mech.No_of_Cycles__c= cyls+';';
            mech.Capacity__c= cap+';';
            mech.Agent_Fill__c= agnfil+';';
            mech.Test_Date__c= tstDate+';';
            database.update(mech);
            isEdit=false;
            isSaved = true;
        }
        return null;
    }
    public PageReference editSystemLocations()
    {
        isEdit=true;
        isSaved = false;
        return null;
    }
    public PageReference remove()
    {    
        Integer listSize = liSystemLocation.size();
        system.debug(listSize + '>>>>>>>>>>>>>>>>>>>>> SIZE');
        selectedValue=ApexPages.currentPage().getParameters().get('removeRow');
        system.debug(selectedValue + '>>>>>>>>>>>>>>>>>>>>> ONE');
        Integer rowIndex;
        for(Integer i=0;i<liSystemLocation.size();i++)
        {
            if(liSystemLocation[i].systemLocation==selectedValue)
            {
                rowIndex=i;
            }
        }
        system.debug(rowIndex + '>>>>>>>>>>>>>>>>>>>>> INDEX');
        liSystemLocation.remove(rowIndex);
        if(liSystemLocation.size()==0){
            liSystemLocation.clear();
            flag = true;
         }else{
             flag = false;
         }
            
       
        
      
         //system.debug(liSystemLocation+ '>>>>>>>>>>>>>>>>>>>>> LIST');
        return null;
    }
}