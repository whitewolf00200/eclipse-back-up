@istest
class XeroInvoiceTest{
static testMethod void mymethod(){
test.starttest();
XeroInvoice xe=new XeroInvoice();
XeroInvoice.LineItem li=new XeroInvoice.LineItem('A123','test',20.0,40.0);
test.stoptest();

}
}