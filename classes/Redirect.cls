public class Redirect {

    public Redirect(ApexPages.StandardController controller) {
    RedirectCuurentPage();
    }
    
    public pageReference RedirectCuurentPage(){
        return new PageReference('/'+apexpages.currentpage().getparameters().get('id'));
    }

}