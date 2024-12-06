/*============================================================================================================
*Class Name     : ComplaintTriggerHandler
*Description    : To send a mail to the Passed To field Value
*Company        : Puthuvannam Technology Solutions
*Date           : 25th Jul, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*Methods        : public void OnAfterUpdate(Map<id,Complaint> complaintNewMap)
                  
                 
*============================================================================================================*/
public class ComplaintTriggerHandler{

public list<Complaints__c> newList;
/*====================================================

*Method Name     : OnBeforeInsert
*Description     : Handle the Before Insert operation
*Arguments       : new map list
====================================================*/

    public void onBeforeInsert(List<Complaints__c > complaintNewList){
    
        passComplaints(complaintNewList);
    
    }
/*====================================================

*Method Name     : OnBeforeUpdate
*Description     : Handle the Before Update operation
*Arguments       : new map list
====================================================*/    
    public void onBeforeUpdate(List<Complaints__c > complaintNewList){
        if(RecursiveHandler.runCTH_UPCOnce()){
        	this.passComplaints(complaintNewList);
        }    
    
    }
/*====================================================

*Method Name     : passComplaints
*Description     : Insert or Update Passed To Complaints Email Field
*Arguments       : new map list
====================================================*/
    private void passComplaints(List<Complaints__c > complaintNewList){
        String Name;
        for(Complaints__c c:complaintNewList){
            //Name= complaintNewMap.get(c.id).Passed_To__c;
            if(c.Passed_To__c!=NULL){
            
            
            Name=c.Passed_To__c;
            Name = Name.replaceAll( '\\s+', '.');
            Name=Name+'@hentland.com';
            System.Debug('======Name'+Name);
            c.Passed_To_Email__c=Name;
            System.Debug('======'+c.Passed_To_Email__c);
            //Insert c;
            }
        }
         
    }
}