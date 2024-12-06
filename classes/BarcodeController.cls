public class BarcodeController {

    public transient  String imageBase {get; set;}
    public Id recId;
    
    public BarcodeController(){
        recId=ApexPages.CurrentPage().getParameters().get('Id');
    }
    
    public void saveImage() {     
        if(recId != null){
            system.debug('imageBase64=' + imageBase);               
            attachment a = new attachment();
            a.ParentId = recId;
            a.Name = 'attachment'+Math.round(Math.random()*1000)+'jpg';
            a.ContentType = 'image/jpeg';
            a.Body = Encodingutil.base64Decode(imageBase.substring(imageBase.indexOf(',') + 1));
            insert a;
        }
     }

}