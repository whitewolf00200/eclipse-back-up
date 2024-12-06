public class PhotoUpload{

    public Id recId {    get;set;    }  
   //   public Id scId {    get;set;    }  
    public Photoupload  (ApexPages.StandardController ctlr)  
    {  
    recId = ApexPages.CurrentPage().getParameters().get('Id'); 
   // scId  = ApexPages.CurrentPage().getParameters().get('scId');      
    }  
      
  
   
     public transient  String imageBase {get; set;}
        
     public PageReference saveImage() {
     
     system.debug('imageBase64=' + imageBase);
        
 
    attachment a = new attachment();
    a.ParentId = recId;
    a.Name = 'attachment'+Math.round(Math.random()*1000)+'jpg';
    a.ContentType = 'image/jpeg';
    a.Body = Encodingutil.base64Decode(imageBase.substring(imageBase.indexOf(',') + 1));
    insert a;
    system.debug('recId=' + recId);
   
         /*attachment a2 = new attachment();
    a2.ParentId = scId;
    a2.Name = 'attachment'+Math.round(Math.random()*1000)+'jpg';
    a2.ContentType = 'image/jpeg';
    a2.Body = Encodingutil.base64Decode(imageBase.substring(imageBase.indexOf(',') + 1));
    insert a2;
*/

    
   
             return new PageReference('/'+recId) ;
     }  

}